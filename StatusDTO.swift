import Foundation

open class StatusDTO {
    var redirectDto: RedirectDTO?
    var widgets: [WidgetDTO]?
    var nextCallMSec: Int
    
    init(_ redirectDto: RedirectDTO?, _ widgets: [WidgetDTO]?, _ nextCallMSec: Int) {
        self.redirectDto = redirectDto
        self.widgets = widgets
        self.nextCallMSec = nextCallMSec
    }
}
