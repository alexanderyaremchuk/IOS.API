import Foundation

open class QueueRejectedDetails {
    var reasonCode: String;
    var event: EventDetails;
    
    init(reasonCode: String, event: EventDetails) {
        self.reasonCode = reasonCode;
        self.event = event;
    }
}
