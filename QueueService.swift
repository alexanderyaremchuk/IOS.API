import Foundation

typealias QueueServiceSuccess = (data: NSData) -> Void
typealias QueueServiceFailure = (error: NSError, errorMessage: String) -> Void

public class QueueService {
    
    static let sharedInstance = QueueService()
    
    func enqueue(customerId:String, eventId:String, userId:String, userAgent:String, sdkVersion:String, layoutName:String?, language:String?, success:(status: QueueStatus) -> Void,failure:QueueServiceFailure) {
        var body: [String : String] = ["userId" : userId, "userAgent" : userAgent, "sdkVersion" : sdkVersion]
        if layoutName != nil {
            body["layoutName"] = layoutName
        }
        if language != nil {
            body["language"] = language
        }
        
        let enqueueUrl = "http://\(customerId).test-q.queue-it.net/api/queue/\(eventId)/appenqueue"
        
        self.submitPUTPath(enqueueUrl, bodyDict: body,
            success: { (data) -> Void in
                var error:NSError? = nil
                if let dictData = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error:&error) as? NSDictionary {
                    var queueId = dictData[QueueStatus.KEY_QUEUE_ID] as! String
                    var queueUrl = dictData[QueueStatus.KEY_QUEUE_URL] as! String
                    var targetUrl = dictData[QueueStatus.KEY_EVENT_TARGET_URL] as! String
                    var status = QueueStatus(queueId: queueId, queueUrl: queueUrl, targetUrl: targetUrl)
                    success(status: status)
                }
            })
            { (error, errorMessage) -> Void in
            
            }
    }
    
    func submitPUTPath(path: String, bodyDict: NSDictionary, success: QueueServiceSuccess, failure: QueueServiceFailure)
    {
        var url = NSURL(string: path)
        self.submitRequestWithURL(url!, httpMethod: "PUT", bodyDict: bodyDict, expectedStatus: 200, success: success, failure: failure)
        
    }
    
    func submitRequestWithURL(url: NSURL, httpMethod: String, bodyDict: NSDictionary, expectedStatus: Int, success: QueueServiceSuccess, failure: QueueServiceFailure) {
        var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(bodyDict, options: nil, error: nil)!
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = httpMethod
        request.HTTPBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        QueueService_NSURLConnectionRequest(request: request, expectedStatusCode: expectedStatus, successCallback: success, failureCallback: failure)
    }
}