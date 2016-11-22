import Foundation

open class StatusDTO {
    var redirectDto: RedirectDTO?
    var widgetsDto: [String]?
    
    init(_ redirectDto: RedirectDTO?, _ widgetsDto: [String]?) {
        self.redirectDto = redirectDto
        self.widgetsDto = widgetsDto
    }
}
