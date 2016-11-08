import Foundation

open class StatusDTO {
    var eventDto: EventDTO?
    var redirectDto: RedirectDTO?
    var widgetsDto: [String]?
    
    init(_ eventDto: EventDTO?, _ redirectDto: RedirectDTO?, _ widgetsDto: [String]?) {
        self.eventDto = eventDto
        self.redirectDto = redirectDto
        self.widgetsDto = widgetsDto
    }
}
