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
        success: (status: QueueStatus) -> Void, failure: (failureData: QueueServiceFailureData ) -> Void) {
        
        
    }
    
    
    
}