import Foundation

public enum QueueIssueMode {
    case Queue, SafetyNet
}

public class QueueItemDetails {
    public var queueId: String;
    public var queueIssueMode: QueueIssueMode;
    public var event: EventDetails;
    public var queueUrl: String;
    
    public init(queueId: String, queueIssueMode: QueueIssueMode, event: EventDetails, queueUrl: String) {
        self.queueId = queueId;
        self.queueIssueMode = queueIssueMode;
        self.event = event;
        self.queueUrl = queueUrl;
    }
}