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
    
    func run() {
        let cache = QueueCache.sharedInstatnce
        let sessionTtl = cache.getSessionTtl()
        if sessionTtl != nil {
            let isExtendSession = cache.getExtendSession()
            if isExtendSession != nil {
                cache.setSessionTtl(sessionTtl! * 2)
            }
        }
    }
    
    func tryEnqueue() {
        QueueService.sharedInstance.enqueue(self.customerId, self.eventId, layoutName: nil, language: nil,
            success: { (status) -> Void in
                
            }) { (error, errorMessage) -> Void in
                _ = errorMessage
            }
    }
}
