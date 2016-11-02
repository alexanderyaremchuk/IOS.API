import Foundation

typealias QueueServiceSuccess = (data: NSData) -> Void
typealias QueueServiceFailure = (error: NSError, errorMessage: String) -> Void

public class QueueService {
    
    static let sharedInstance = QueueService()
    
    func enqueue(customerId: String, eventId: String, userId: String, userAgent: String, sdkVersion: String, layoutName: String?, language: String?,
            success: (status: QueueStatus) -> Void,
            failure: QueueServiceFailure) -> String {
        var body: [String : String] = ["userId" : userId, "userAgent" : userAgent, "sdkVersion" : sdkVersion]
        if layoutName != nil {
            body["layoutName"] = layoutName
        }
        if language != nil {
            body["language"] = language
        }
        
        let enqueueUrl = "http:\(customerId).test-q.queue-it.net/api/queue/\(eventId)/appenqueue"
        
        let path = self.submitPUTPath(enqueueUrl, bodyDict: body,
            success: { (data) -> Void in
                var error:NSError? = nil
                if let dictData = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error:&error) as? NSDictionary {
                    
                }
            })
            { (error, errorMessage) -> Void in
            
            }
            
        return path;
    }
    
    func submitRequestWithURL(url: NSURL, httpMethod: String, bodyDict: NSDictionary, expectedStatus: Int, success: QueueServiceSuccess, failure: QueueServiceFailure) -> String {
            return "";
    }
    
    func submitPUTPath(path: String, bodyDict: NSDictionary, success: QueueServiceSuccess, failure: QueueServiceFailure) -> String
    {
        var url = NSURL(string: path)
        return self.submitRequestWithURL(url!, httpMethod: "PUT", bodyDict: bodyDict, expectedStatus: 200, success: success, failure: failure)
        
    }
    
}