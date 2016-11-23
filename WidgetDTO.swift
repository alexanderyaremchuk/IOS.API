import Foundation

open class WidgetDTO {
    var name: String
    var checksum: String
    var value: String
    
    init(_ name: String, _ checksum: String, _ value: String) {
        self.name = name
        self.checksum = checksum
        self.value = value
    }
}
