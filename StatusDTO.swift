import Foundation

open class StatusDTO {
    var redirectDto: RedirectDTO?
    var widgetsDto: [WidgetDTO]?
    var nextCallMSec: Int
    
    init(_ redirectDto: RedirectDTO?, _ widgetsDto: [WidgetDTO]?, _ nextCallMSec: Int) {
        self.redirectDto = redirectDto
        self.widgetsDto = widgetsDto
        self.nextCallMSec = nextCallMSec
    }
}
