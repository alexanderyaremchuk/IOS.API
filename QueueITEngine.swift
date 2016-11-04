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
        let userId = "sashaUnique"
        let userAgent = "myUserAgent"
        let sdkVersion = "v1.0"
        
        let qs = QueueService.sharedInstance
        
        qs.enqueue(self.customerId, eventId: self.eventId, userId: userId, userAgent: userAgent, sdkVersion: sdkVersion, layoutName: nil, language: nil,
            success: { (status) -> Void in
                //QueueCache.sharedInstatnce.setQueueId(status.queueId)
                let queueId = QueueCache.sharedInstatnce.getQueueId()
                
            }) { (error, errorMessage) -> Void in
                _ = errorMessage
            }
    }
}
