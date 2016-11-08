import Foundation

open class StatusDTO {
    var eventDto: EventDTO?
    var redirectDto: RedirectDTO?
    
    init(_ eventDto: EventDTO?, _ redirectDto: RedirectDTO?) {
        self.eventDto = eventDto
        self.redirectDto = redirectDto
    }
}
