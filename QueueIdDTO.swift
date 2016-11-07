import Foundation

open class QueueIdDTO {
    var queueId: String
    var ttl: CLongLong
    
    init(_ queueId: String, _ ttl: CLongLong) {
        self.queueId = queueId
        self.ttl = ttl
    }
}
