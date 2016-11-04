import Foundation

public enum QueuePassedType {
    case safetyNet, queue, disabled, directLink, afterEvent
}

open class QueuePassedDetails {
    var passedType: QueuePassedType;
    var event: EventDetails;
    
    init(passedType: QueuePassedType, event: EventDetails) {
        self.passedType = passedType;
        self.event = event;
    }
}
