import Foundation

open class QueueITEngine {
    open var customerId: String
    open var eventId: String
    open var configId: String
    open var layoutName: String
    open var language: String
    open var widgets = [Widget]()
    
    var queuePassed: (String) -> Void
    
    public init(customerId: String, eventId: String, configId: String, _ widgets:Widget ..., layoutName: String, language: String, queuePassed: @escaping (_ queueId: String) -> Void) {
        self.customerId = customerId
        self.eventId = eventId
        self.configId = configId
        self.layoutName = layoutName
        self.language = language
        self.queuePassed = queuePassed
        for w in widgets {
            self.widgets.append(w)
        }
    }
    
    func run() {
        let cache = QueueCache.sharedInstatnce
        let redirectId = cache.getRedirectId()
        let sessionTtl = cache.getSessionTtl()
        if sessionTtl != nil {
            let isExtendSession = cache.getExtendSession()
            if isExtendSession != nil {
                cache.setSessionTtl(sessionTtl! * 2)
            }
            queuePassed(redirectId!)
        } else {
            if redirectId == nil {
                enqueue()
            }
        }
    }
    
    func enqueue() {
        QueueService.sharedInstance.enqueue(self.customerId, self.eventId, self.configId, layoutName: nil, language: nil,
            success: { (enqueueDto) -> Void in
                let eventState = enqueueDto.eventDetails.state
                if eventState == "Queue" {
                    let cache = QueueCache.sharedInstatnce
                    cache.setQueueId(enqueueDto.queueIdDto.queueId)
                    cache.setQueueIdTtl(enqueueDto.queueIdDto.ttl)
                    self.checkStatus()
                }
            }) { (error, errorMessage) -> Void in
                _ = errorMessage
            }
    }
    
    func checkStatus() {
        let queueId = QueueCache.sharedInstatnce.getQueueId()!
        QueueService.sharedInstance.getStatus(self.customerId, self.eventId, queueId, self.configId, self.widgets, onGetStatus: (onGetStatus))
    }
    
    func onGetStatus(statusDto: StatusDTO) {
        let redirectInfo = statusDto.redirectDto
        if redirectInfo != nil {
            if redirectInfo?.redirectId != nil {
                let cache = QueueCache.sharedInstatnce
                cache.setRedirectId((redirectInfo?.redirectId)!)
                cache.setSessionTtl((redirectInfo?.ttl)!)
                cache.setExtendSession((redirectInfo?.extendTtl)!)
            }
        }
    }
    
}
