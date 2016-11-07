import Foundation

open class Widget {
    var state: String
    var version: Int
    
    init(_ state: String, _ version: Int) {
        self.state = state
        self.version = version
    }
}
