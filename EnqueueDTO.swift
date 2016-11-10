import Foundation

open class EnqueueDTO {
    var queueIdDto: QueueIdDTO
    var eventDetails: EventDetails
    
    init(_ queueIdDto: QueueIdDTO, _ eventDetails: EventDetails) {
        self.queueIdDto = queueIdDto
        self.eventDetails = eventDetails
    }
}
