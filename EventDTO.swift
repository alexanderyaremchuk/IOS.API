import Foundation

open class EventDTO {
    var postQueueStartTime: Int64
    var preQueueStartTime: Int64
    var queueStartTime: Int64
    var state: String
    
    init(_ postQueueStartTime: Int64, _ preQueueStartTime: Int64, _ queueStartTime: Int64, _ state: String) {
        self.postQueueStartTime = postQueueStartTime
        self.preQueueStartTime = preQueueStartTime
        self.queueStartTime = queueStartTime
        self.state = state
    }
}
