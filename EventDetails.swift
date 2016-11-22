import Foundation

enum EventStateError : Error {
    case invalidEventState
}

enum EventState {
    case idle, prequeue, queue, postqueue
}

open class EventDetails {
    var state: EventState
    
    init(_ state: EventState) {
        self.state = state
    }
}
