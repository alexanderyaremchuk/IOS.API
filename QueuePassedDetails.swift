import Foundation

public enum QueuePassedType {
    case SafetyNet, Queue, Disabled, DirectLink, AfterEvent
}

public class QueuePassedDetails {
    var passedType: QueuePassedType;
    var event: EventDetails;
    
    init(passedType: QueuePassedType, event: EventDetails) {
        self.passedType = passedType;
        self.event = event;
    }
}