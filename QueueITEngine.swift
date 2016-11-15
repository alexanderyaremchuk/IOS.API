import Foundation

open class QueueITEngine {
    open var customerId: String
    open var eventId: String
    open var configId: String
    open var layoutName: String
    open var language: String
    open var widgets = [Widget]()
    
    var onQueueItemAssigned: (QueueItemDetails) -> Void
    var onQueuePassed: (QueuePassedDetails) -> Void
    
    init(customerId: String, eventId: String, configId: String, widgets:Widget ..., layoutName: String, language: String,
                onQueueItemAssigned: @escaping (_ queueItemDetails: QueueItemDetails) -> Void,
                onQueuePassed: @escaping (_ queuePassedDetails: QueuePassedDetails) -> Void) {
        self.customerId = customerId
        self.eventId = eventId
        self.configId = configId
        self.layoutName = layoutName
        self.language = language
        self.onQueueItemAssigned = onQueueItemAssigned
        self.onQueuePassed = onQueuePassed
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
            onQueuePassed(QueuePassedDetails(nil))//TODO: should not be nill, figure out what
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
                    self.handleQueueIdAssigned(enqueueDto.queueIdDto, enqueueDto.eventDetails)
                    self.checkStatus()
                }
            }) { (error, errorMessage) -> Void in
                _ = errorMessage
            }
    }
    
    func handleQueueIdAssigned(_ queueIdInfo: QueueIdDTO, _ eventDetails: EventDetails) {
        let cache = QueueCache.sharedInstatnce
        cache.setQueueId(queueIdInfo.queueId)
        cache.setQueueIdTtl(queueIdInfo.ttl)
        
        var queueIssueMode: QueueIssueMode = .queue
        if queueIdInfo.issueMode == "SafetyNet" {
            queueIssueMode = .safetyNet
        }
        self.onQueueItemAssigned(QueueItemDetails(queueIdInfo.queueId, queueIssueMode, eventDetails))
    }
    
    func checkStatus() {
        let queueId = QueueCache.sharedInstatnce.getQueueId()!
        QueueService.sharedInstance.getStatus(self.customerId, self.eventId, queueId, self.configId, self.widgets, onGetStatus: (onGetStatus))
    }
    
    func onGetStatus(statusDto: StatusDTO) {
        let redirectInfo = statusDto.redirectDto
        if redirectInfo != nil {
            self.handleQueuePassed(redirectInfo!)
        }
    }
    
    func handleQueuePassed(_ redirectInfo: RedirectDTO) {
        let cache = QueueCache.sharedInstatnce
        cache.setRedirectId((redirectInfo.redirectId))
        cache.setSessionTtl((redirectInfo.ttl))
        cache.setExtendSession((redirectInfo.extendTtl))
        
        self.onQueuePassed(QueuePassedDetails(redirectInfo.passedType))
    }
}
