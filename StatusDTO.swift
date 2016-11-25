import Foundation

open class StatusDTO {
    var eventDetails: EventDetails?
    var redirectDto: RedirectDTO?
    var widgets: [WidgetDTO]?
    var nextCallMSec: Int
    
    init(_ eventDetails: EventDetails?, _ redirectDto: RedirectDTO?, _ widgets: [WidgetDTO]?, _ nextCallMSec: Int) {
        self.eventDetails = eventDetails
        self.redirectDto = redirectDto
        self.widgets = widgets
        self.nextCallMSec = nextCallMSec
    }
}
