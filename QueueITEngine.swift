import Foundation

open class QueueITEngine {
    open var customerId: String;
    open var eventId: String;
    open var layoutName: String;
    open var language: String;
    
    public init(customerId: String, eventId: String, layoutName: String, language: String) {
        self.customerId = customerId;
        self.eventId = eventId;
        self.layoutName = layoutName;
        self.language = language;
    }
    
    func tryEnqueue() {
        QueueService.sharedInstance.enqueue(self.customerId, self.eventId, layoutName: nil, language: nil,
            success: { (status) -> Void in
                //QueueCache.sharedInstatnce.setQueueId(status.queueId)
                //let queueId = QueueCache.sharedInstatnce.getQueueId()
                
            }) { (error, errorMessage) -> Void in
                _ = errorMessage
            }
    }
}
