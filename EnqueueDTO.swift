import Foundation

open class EnqueueDTO {
    var queueIdDto: QueueIdDTO
    var eventDetails: EventDetails
    var redirectDto: RedirectDTO?
    
    init(_ queueIdDto: QueueIdDTO, _ eventDetails: EventDetails, _ redirectDto: RedirectDTO?) {
        self.queueIdDto = queueIdDto
        self.eventDetails = eventDetails
        self.redirectDto = redirectDto
    }
}
