import Foundation

class QueueItemDetails {
    var queueId: String
    var eventDetails: EventDetails
    
    init(_ queueId: String, _ eventDetails: EventDetails) {
        self.queueId = queueId
        self.eventDetails = eventDetails
    }
}
