import Foundation

typealias QueueServiceSuccess = (_ data: Data) -> Void
typealias QueueServiceFailure = (_ error: NSError, _ errorMessage: String) -> Void

open class QueueService {
    
    static let sharedInstance = QueueService()
    
    func enqueue(_ customerId:String, _ eventId:String, layoutName:String?, language:String?, success:@escaping (_ status: QueueStatus) -> Void,failure:QueueServiceFailure) {
        let userId = "sashaUnique"
        let userAgent = "myUserAgent"
        let sdkVersion = "v1.0"
        let configurationId = "configId1"
        
        var body: [String : String] = ["userId" : userId, "userAgent" : userAgent, "sdkVersion" : sdkVersion, "configurationId" : configurationId]
        if layoutName != nil {
            body["layoutName"] = layoutName
        }
        if language != nil {
            body["language"] = language
        }
        
        //let enqueueUrl = "http://\(customerId).test-q.queue-it.net/api/queue/\(customerId)/\(eventId)/appenqueue"
        let enqueueUrl = "http://\(customerId).test-q.queue-it.net/api/nativeapp/\(customerId)/\(eventId)/queue/enqueue"
        
        self.submitPUTPath(enqueueUrl, bodyDict: body as NSDictionary,
            success: { (data) -> Void in
                do {
                    let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    let queueId = dictData?[QueueStatus.KEY_QUEUE_ID] as! String
                    let queueUrl = dictData?[QueueStatus.KEY_QUEUE_URL] as! String
                    let targetUrl = dictData?[QueueStatus.KEY_EVENT_TARGET_URL] as! String
                    let status = QueueStatus(queueId: queueId, queueUrl: queueUrl, targetUrl: targetUrl)
                    success(status)
                } catch {
                    
                }
            })
            { (error, errorMessage) -> Void in
            }
    }
    
    func submitPUTPath(_ path: String, bodyDict: NSDictionary, success: @escaping QueueServiceSuccess, failure: @escaping QueueServiceFailure)
    {
        let url = URL(string: path)
        self.submitRequestWithURL(url!, httpMethod: "POST", bodyDict: bodyDict, expectedStatus: 200, success: success, failure: failure)
        
    }
    
    func submitRequestWithURL(_ url: URL, httpMethod: String, bodyDict: NSDictionary, expectedStatus: Int, success: @escaping QueueServiceSuccess, failure: @escaping QueueServiceFailure) {
        do {
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
