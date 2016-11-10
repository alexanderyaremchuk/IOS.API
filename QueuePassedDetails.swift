import Foundation

enum PassedType {
    case safetyNet, queue, directLink, afterEvent
}

class QueuePassedDetails {
    var passedType: PassedType
    var eventDetails: EventDetails
    
    init(_ passedType: PassedType, _ eventDetails: EventDetails) {
        self.passedType = passedType
        self.eventDetails = eventDetails
    }
}
