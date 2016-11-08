import Foundation

typealias QueueServiceSuccess = (_ data: Data) -> Void
typealias QueueServiceFailure = (_ error: NSError, _ errorMessage: String) -> Void

open class QueueService {
    
    static let sharedInstance = QueueService()
    
    func getStatus(_ customerId:String, _ eventId:String, _ queueId:String, _ configId:String, _ widgets:[Widget]) {
        var body: [String : Any] = ["configurationId" : configId]
        
        var widgetArr = [Any]()
        var widgetItemDict = [String : Any]()
        for w in widgets {
            widgetItemDict["name"] = w.name
            widgetItemDict["version"] = w.version
            widgetArr.append(widgetItemDict)
        }
        
        body["widgets"] = widgetArr
        
        let statusUrl = "http://\(customerId).test.queue-it.net/api/nativeapp/\(customerId)/\(eventId)/queue/\(queueId)/status"
        
        self.submitPUTPath(statusUrl, body: body as NSDictionary, success: { (data) -> Void in
            
                                
        })
        { (error, errorMessage) -> Void in
        }

    }
    
    
    func enqueue(_ customerId:String, _ eventId:String, _ configId:String, layoutName:String?, language:String?, success:@escaping (_ status: EnqueueDTO) -> Void,failure:QueueServiceFailure) {
        let userId = "sashaUnique"
        let userAgent = "myUserAgent"
        let sdkVersion = "v1.0"
        
        var body: [String : String] = ["userId" : userId, "userAgent" : userAgent, "sdkVersion" : sdkVersion, "configurationId" : configId]
        if layoutName != nil {
            body["layoutName"] = layoutName
        }
        if language != nil {
            body["language"] = language
        }
        
        let enqueueUrl = "http://\(customerId).test.queue-it.net/api/nativeapp/\(customerId)/\(eventId)/queue/enqueue"
        
        self.submitPOSTPath(enqueueUrl, bodyDict: body as NSDictionary,
            success: { (data) -> Void in
                do {
                    let dictData = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    
                    let qIdDict = dictData.value(forKey: "queueIdDetails") as! NSDictionary
                    let qId = qIdDict["queueId"] as! String
                    let ttl = Int(qIdDict["ttl"] as! CLongLong)
                    let queueIdDto = QueueIdDTO(qId, ttl)
                    
                    let eventDetailsDict = dictData.value(forKey: "eventDetails") as! NSDictionary
                    let postQueueStartTime = eventDetailsDict["postQueueStartTime"] as! Int64
                    let preQueueStartTime = eventDetailsDict["preQueueStartTime"] as! Int64
                    let state = eventDetailsDict["state"] as! String
                    let queueStartTime = eventDetailsDict["queueStartTime"] as! Int64
                    let eventDto = EventDTO(postQueueStartTime, preQueueStartTime, queueStartTime, state)
                    
                    success(EnqueueDTO(queueIdDto, eventDto))
                } catch {
                    
                }
            })
            { (error, errorMessage) -> Void in
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
}
