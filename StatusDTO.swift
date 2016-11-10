import Foundation

open class StatusDTO {
    var eventDetails: EventDetails?
    var redirectDto: RedirectDTO?
    var widgetsDto: [String]?
    
    init(_ eventDetails: EventDetails?, _ redirectDto: RedirectDTO?, _ widgetsDto: [String]?) {
        self.eventDetails = eventDetails
        self.redirectDto = redirectDto
        self.widgetsDto = widgetsDto
    }
}
