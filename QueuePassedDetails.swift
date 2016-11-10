import Foundation

enum PassedTypeError : Error {
    case invalidPassedType
}

enum PassedType {
    case safetyNet, queue, disabled, directLink, afterEvent
}

class QueuePassedDetails {
    var passedType: PassedType
    var eventDetails: EventDetails
    
    init(_ passedType: PassedType, _ eventDetails: EventDetails) {
        self.passedType = passedType
        self.eventDetails = eventDetails
    }
}
