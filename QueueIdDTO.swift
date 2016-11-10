import Foundation

open class QueueIdDTO {
    var queueId: String
    var ttl: Int
    var issueMode: String
    
    init(_ queueId: String, _ ttl: Int, _ issueMode: String) {
        self.queueId = queueId
        self.ttl = ttl
        self.issueMode = issueMode
    }
}
