import Foundation

open class StatusDTO {
    var redirectDto: RedirectDTO?
    var widgetsDto: [String]?
    var nextCallMSec: Int
    
    init(_ redirectDto: RedirectDTO?, _ widgetsDto: [String]?, _ nextCallMSec: Int) {
        self.redirectDto = redirectDto
        self.widgetsDto = widgetsDto
        self.nextCallMSec = nextCallMSec
    }
}
