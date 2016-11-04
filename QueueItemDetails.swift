import Foundation

public enum QueueIssueMode {
    case queue, safetyNet
}

open class QueueItemDetails {
    open var queueId: String;
    open var queueIssueMode: QueueIssueMode;
    open var event: EventDetails;
    open var queueUrl: String;
    
    public init(queueId: String, queueIssueMode: QueueIssueMode, event: EventDetails, queueUrl: String) {
        self.queueId = queueId;
        self.queueIssueMode = queueIssueMode;
        self.event = event;
        self.queueUrl = queueUrl;
    }
}
