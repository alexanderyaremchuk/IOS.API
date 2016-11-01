import Foundation

public class QueueServiceFailureData {
    public var error: NSError;
    public var errorMessage: String;
        public init(error: NSError, errorMessage: String) {
        self.error = error;
        self.errorMessage = errorMessage;
    }
}

public class QueueService {
    
    static let sharedInstance = QueueService()
    
    static let API_ROOT = "http://%@.test-q.queue-it.net/api/queue"
    
    public func enqueue(customerId: String, eventId: String, userId: String, sdkVersion: String, layoutName: String, language: String,
        success: (status: QueueStatus) -> Void,
        failure: (failureData: QueueServiceFailureData ) -> Void) {
        
        
    }
    
    public func submitRequestWithURL(url: NSURL, httpMethod: String, bodyDict: NSDictionary, expectedStatus: Int,
        success: (data: NSData) -> Void,
        failure: (failureData: QueueServiceFailureData ) -> Void) -> String {
            return "";
    }
    
    public func submitPUTPath(path: String, bodyDict: NSDictionary, success: (data: NSData) -> Void, failure: (failureData: QueueServiceFailureData ) -> Void) -> String {
        var url = NSURL(fileURLWithPath: path)
        return self.submitRequestWithURL(url, "PUT", bodyDict, 200, success, failure)
        
    }
    
}