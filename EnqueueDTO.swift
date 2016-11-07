import Foundation

open class EnqueueDTO {
    var queueIdDto: QueueIdDTO
    var eventDto: EventDTO
    
    init(_ queueIdDto: QueueIdDTO, _ eventDto: EventDTO) {
        self.queueIdDto = queueIdDto
        self.eventDto = eventDto
    }
}
