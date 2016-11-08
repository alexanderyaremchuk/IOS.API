import Foundation

open class StatusDTO {
    var eventDto: EventDTO?
    var redirectDto: RedirectDTO?
    var widgetsJson: String
    
    init(_ eventDto: EventDTO?, _ redirectDto: RedirectDTO?, _ widgetsJson: String) {
        self.eventDto = eventDto
        self.redirectDto = redirectDto
        self.widgetsJson = widgetsJson
    }
}
