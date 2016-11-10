import Foundation

enum QueueIssueMode {
    case queue, safetyNet
}

class QueueItemDetails {
    var queueId: String
    var queueIssueMode: QueueIssueMode
    var eventDetails: EventDetails
    
    init(_ queueId: String, _ queueIssueMode: QueueIssueMode, _ eventDetails: EventDetails) {
        self.queueId = queueId
        self.queueIssueMode = queueIssueMode
        self.eventDetails = eventDetails
    }
}
