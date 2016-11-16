import Foundation

enum EventStateError : Error {
    case invalidEventState
}

enum EventState {
    case idle, prequeue, queue, postqueue
}

open class EventDetails {
    var postQueueStartTime: Int64
    var preQueueStartTime: Int64
    var queueStartTime: Int64
    var state: EventState
    
    init(_ postQueueStartTime: Int64, _ preQueueStartTime: Int64, _ queueStartTime: Int64, _ state: EventState) {
        self.postQueueStartTime = postQueueStartTime
        self.preQueueStartTime = preQueueStartTime
        self.queueStartTime = queueStartTime
        self.state = state
    }
}
