import Foundation

open class StatusDTO {
    var eventDetails: EventDTO?
    var redirectDto: RedirectDTO?
    var widgets: [WidgetDTO]?
    var nextCallMSec: Int
    
    init(_ eventDetails: EventDTO?, _ redirectDto: RedirectDTO?, _ widgets: [WidgetDTO]?, _ nextCallMSec: Int) {
        self.eventDetails = eventDetails
        self.redirectDto = redirectDto
        self.widgets = widgets
        self.nextCallMSec = nextCallMSec
    }
}
