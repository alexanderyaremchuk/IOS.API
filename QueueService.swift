import Foundation

typealias QueueServiceSuccess = (_ data: Data) -> Void
typealias QueueServiceFailure = (_ error: ErrorInfo?, _ errorStatusCode: Int) -> Void

open class QueueService {
    
    static let sharedInstance = QueueService()
    
    let httpProtocl = "http://"
    let hostName = "test.queue-it.net"
    var customerId = ""
    
    func getHostName() -> String {
        return "\(httpProtocl)\(customerId).\(hostName)"
    }
    
    func enqueue(_ customerId:String, _ eventId:String, _ configId:String, layoutName:String?, language:String?, success:@escaping (_ status: EnqueueDTO) -> Void, failure:@escaping QueueServiceFailure) {
        self.customerId = customerId
        let userId = iOSUtils.getUserId()
        let userAgent = "myUserAgent"
        let sdkVersion = "v1.0"
        var body: [String : String] = ["userId" : userId, "userAgent" : userAgent, "sdkVersion" : sdkVersion, "configurationId" : configId]
        if layoutName != nil {
            body["layoutName"] = layoutName
        }
        if language != nil {
            body["language"] = language
        }
        let enqueueUrl = "\(getHostName())/api/nativeapp/\(customerId)/\(eventId)/queue/enqueue"
        self.submitPOSTPath(enqueueUrl, bodyDict: body as NSDictionary,
            success: { (data) -> Void in
                let dictData = self.dataToDict(data)
                let queueIdDto = self.extractQueueIdDetails(dictData!)
                let eventDetails = self.extractEventDetails(dictData!)
                let redirectDto = self.extractRedirectDetails(dictData!)
                success(EnqueueDTO(queueIdDto, eventDetails!, redirectDto))
        })
        { (error, errorStatusCode) -> Void in
            failure(error, errorStatusCode)
        }
    }
    
    func getStatus(_ customerId:String, _ eventId:String, _ queueId:String, _ configId:String, _ widgets:[Widget], onGetStatus:@escaping (_ status: StatusDTO) -> Void) {
        self.customerId = customerId
        var body: [String : Any] = ["configurationId" : configId]
        var widgetArr = [Any]()
        var widgetItemDict = [String : Any]()
        for w in widgets {
            widgetItemDict["name"] = w.name
            widgetItemDict["version"] = w.version
            widgetArr.append(widgetItemDict)
        }
        body["widgets"] = widgetArr
        let statusUrl = "\(self.getHostName())/api/nativeapp/\(customerId)/\(eventId)/queue/\(queueId)/status"
        self.submitPUTPath(statusUrl, body: body as NSDictionary,
            success: { (data) -> Void in
                let dictData = self.dataToDict(data)
                let eventDetails = self.extractEventDetails(dictData!)
                let redirectDto = self.extractRedirectDetails(dictData!)
                let widgetsResult = self.extractWidgetDetails(dictData!)
                let rejectDto = self.extractRejectDetails(dictData!)
                let nextCallMSec = dictData!.value(forKey: "ttl") as? Int
                let statusDto = StatusDTO(eventDetails, redirectDto, widgetsResult, nextCallMSec!, rejectDto)
                onGetStatus(statusDto)
            })
            { (error, errorStatusCode) -> Void in
                
            }
    }
    
    func submitPOSTPath(_ path: String, bodyDict: NSDictionary, success: @escaping QueueServiceSuccess, failure: @escaping QueueServiceFailure)
    {
        submitRequestWithURL(path, httpMethod: "POST", bodyDict: bodyDict, expectedStatus: 200, success: success, failure: failure)
    }
    
    func submitPUTPath(_ path: String, body: NSDictionary, success: @escaping QueueServiceSuccess, failure: @escaping QueueServiceFailure)
    {
        submitRequestWithURL(path, httpMethod: "PUT", bodyDict: body, expectedStatus: 200, success: success, failure: failure)
    }
    
    func submitRequestWithURL(_ path: String, httpMethod: String, bodyDict: NSDictionary, expectedStatus: Int, success: @escaping QueueServiceSuccess, failure: @escaping QueueServiceFailure) {
        do {
            let url = URL(string: path)!
            let jsonData: Data = try JSONSerialization.data(withJSONObject: bodyDict, options: .prettyPrinted)
            let request = NSMutableURLRequest(url: url)
            request.httpMethod = httpMethod
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            _ = QueueService_NSURLConnectionRequest(request: request as URLRequest, expectedStatusCode: expectedStatus, successCallback: success, failureCallback: failure)
        } catch {
            
        }
    }
    
    func parseRedirectType(_ redirectType: String) throws -> PassedType {
        var passedType: PassedType
        if redirectType == "Safetynet" {
            passedType = .safetyNet
        } else if redirectType == "Disabled" {
            passedType = .disabled
        } else if redirectType == "DirectLink" {
            passedType = .directLink
        } else if redirectType == "AfterEvent" {
            passedType = .afterEvent
        } else if redirectType == "Queue" {
            passedType = .queue
        } else {
            throw PassedTypeError.invalidPassedType
        }
        return passedType
    }
    
    func parseEventState(_ state: String) throws -> EventState {
        var eventState: EventState
        if state == "PreQueue" {
            eventState = .prequeue
        } else if state == "Queue" {
            eventState = .queue
        } else if state == "Idle" {
            eventState = .idle
        } else if state == "PostQueue" {
            eventState = .postqueue
        } else {
            throw EventStateError.invalidEventState
        }
        return eventState
    }
    
    func dataToDict(_ data: Data) -> NSDictionary? {
        return try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
    }
    
    func extractQueueIdDetails(_ dataDict: NSDictionary) -> QueueIdDTO? {
        var queueIdDto: QueueIdDTO? = nil
        let qIdDict = dataDict.value(forKey: "queueIdDetails") as? NSDictionary
        if qIdDict != nil {
            let qId = qIdDict?["queueId"] as! String
            let ttl = Int(qIdDict?["ttl"] as! CLongLong)
            queueIdDto = QueueIdDTO(qId, ttl)
        }
        return queueIdDto
    }
    
    func extractEventDetails(_ dataDict: NSDictionary) -> EventDTO? {
        var eventDetails: EventDTO? = nil
        let eventDetailsDict = dataDict.value(forKey: "eventDetails") as? NSDictionary
        if eventDetailsDict != nil {
            let stateString = eventDetailsDict?["state"] as! String
            let state: EventState = try! self.parseEventState(stateString)
            eventDetails = EventDTO(state)
        }
        return eventDetails
    }
    
    func extractRejectDetails(_ dataDict: NSDictionary) -> RejectDTO? {
        var rejectDetails: RejectDTO? = nil
        let rejectDetailsDict = dataDict.value(forKey: "rejectDetails") as? NSDictionary
        if rejectDetailsDict != nil {
            let reason = rejectDetailsDict?["reason"] as! String
            rejectDetails = RejectDTO(reason)
        }
        return rejectDetails
    }
    
    func extractRedirectDetails(_ dataDict: NSDictionary) -> RedirectDTO? {
        var redirectDto: RedirectDTO? = nil
        let redirectDetailsDict = dataDict.value(forKey: "redirectDetails") as? NSDictionary
        if redirectDetailsDict != nil {
            let redirectType = redirectDetailsDict?["redirectType"] as! String
            let ttl = Int(redirectDetailsDict?["ttl"] as! CLongLong)
            let extendTtl = redirectDetailsDict?["extendTtl"] as! Bool
            let redirectId = redirectDetailsDict?["redirectId"] as! String
            let passedType = try! self.parseRedirectType(redirectType)
            redirectDto = RedirectDTO(passedType, ttl, extendTtl, redirectId)
        }
        return redirectDto
    }
    
    func extractWidgetDetails(_ dataDict: NSDictionary) -> [WidgetDTO]? {
        var widgetsResutl = [WidgetDTO]()
        let widgetArr = dataDict.value(forKey: "widgets") as? NSArray
        for w in widgetArr! {
            var widgetText = String(describing: w)
            widgetText = widgetText.replacingOccurrences(of: "\n", with: "")
            widgetText = widgetText.replacingOccurrences(of: " ", with: "")
            widgetText = widgetText.replacingOccurrences(of: "{", with: "")
            widgetText = widgetText.replacingOccurrences(of: "}", with: "")
            
            var kvPairs = getAllKeyValues(widgetText)
            let name = kvPairs["type"]
            let checksum = kvPairs["checksum"]
            
            kvPairs.removeValue(forKey: "type")
            kvPairs.removeValue(forKey: "version")
            kvPairs.removeValue(forKey: "checksum")
            
            let widgetDto = WidgetDTO(name!, checksum!, widgetText)
            widgetsResutl.append(widgetDto)
        }
        return widgetsResutl
    }
    
    func getAllKeyValues(_ text: String) -> [String:String] {
        var kvPairs = [String:String]()
        var key = ""; var cand = ""
        for c in text.characters {
            if c == "=" {
                key = cand
                cand = ""
            } else if c == ";" {
                kvPairs[key] = cand
                cand = ""
            }
            else {
                cand = cand + String(c)
            }
        }
        return kvPairs
    }
}
