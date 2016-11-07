import Foundation

open class QueueITEngine {
    open var customerId: String;
    open var eventId: String;
    open var layoutName: String;
    open var language: String;
    
    
    
    var queuePassed: (String) -> Void
    
    public init(customerId: String, eventId: String, layoutName: String, language: String, queuePassed: @escaping (_ queueId: String) -> Void) {
        self.customerId = customerId;
        self.eventId = eventId;
        self.layoutName = layoutName;
        self.language = language;
        self.queuePassed = queuePassed
    }
    
    func run() {
        let cache = QueueCache.sharedInstatnce
        let queueId = cache.getQueueId()
        let sessionTtl = cache.getSessionTtl()
        if sessionTtl != nil {
            let isExtendSession = cache.getExtendSession()
            if isExtendSession != nil {
                cache.setSessionTtl(sessionTtl! * 2)
            }
            queuePassed(queueId!)
        } else {
            if queueId == nil {
                enqueue()
            }
        }
    }
    
    func enqueue() {
        QueueService.sharedInstance.enqueue(self.customerId, self.eventId, layoutName: nil, language: nil,
            success: { (enqueueDto) -> Void in
                
                
            }) { (error, errorMessage) -> Void in
                _ = errorMessage
            }
    }
}
