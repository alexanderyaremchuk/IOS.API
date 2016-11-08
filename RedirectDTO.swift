import Foundation

open class RedirectDTO {
    var redirectType: String
    var ttl: Int
    var extendTtl: Bool
    var redirectId: String
    
    init(_ redirectType: String, _ ttl: Int, _ extendTtl: Bool, _ redirectId: String) {
        self.redirectType = redirectType
        self.ttl = ttl
        self.extendTtl = extendTtl
        self.redirectId = redirectId
    }
}
