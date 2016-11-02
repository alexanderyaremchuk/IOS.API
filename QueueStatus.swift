import Foundation

public class QueueStatus {
    static let KEY_QUEUE_ID = "QueueId"
    static let KEY_QUEUE_URL = "QueueUrl"
    static let KEY_EVENT_TARGET_URL = "EventTargetUrl"
    
    public var queueId: String
    public var queueUrl: String
    public var targetUrl: String
    
    public init(queueId: String, queueUrl: String, targetUrl: String) {
        self.queueId = queueId
        self.queueUrl = queueUrl
        self.targetUrl = targetUrl
    }
    
}
