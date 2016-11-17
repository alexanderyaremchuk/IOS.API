import Foundation

open class QueueITEngine {
    let CHECK_STATUS_DELAY_SEC = 1
    
    open var customerId: String
    open var eventId: String
    open var configId: String
    open var layoutName: String
    open var language: String
    open var widgets = [Widget]()
    
    var onQueueItemAssigned: (QueueItemDetails) -> Void
    var onQueuePassed: (QueuePassedDetails) -> Void
    var onPostQueue: () -> Void
    
    init(customerId: String, eventId: String, configId: String, widgets:Widget ..., layoutName: String, language: String,
                onQueueItemAssigned: @escaping (_ queueItemDetails: QueueItemDetails) -> Void,
                onQueuePassed: @escaping (_ queuePassedDetails: QueuePassedDetails) -> Void,
                onPostQueue: @escaping () -> Void) {
        self.customerId = customerId
        self.eventId = eventId
        self.configId = configId
        self.layoutName = layoutName
        self.language = language
        self.onQueueItemAssigned = onQueueItemAssigned
        self.onQueuePassed = onQueuePassed
        self.onPostQueue = onPostQueue
        for w in widgets {
            self.widgets.append(w)
        }
        QueueCache.sharedInstatnce.initialize(customerId, eventId)
    }
    
    func run() {
        if isInSession(tryExtendSession: true) {
            onQueuePassed(QueuePassedDetails(nil))//TODO: should not be nill, figure out what
        } else {
            enqueue()
        }
    }
    
    func isInSession(tryExtendSession: Bool) -> Bool {
        let cache = QueueCache.sharedInstatnce
        let redirectId = cache.getRedirectId()
        if redirectId != nil {
            let sessionTtl = cache.getSessionTtl()
            if currentTimeUnixUtil() < sessionTtl! {
                if tryExtendSession {
                    let isExtendSession = cache.getExtendSession()
                    if isExtendSession != nil {
                        let ttlDelta = cache.getSessionTtlDelta()
                        cache.setSessionTtl(sessionTtl! + ttlDelta!)
                    }
                }
                return true
            }
        }
        return false
    }
    
    func enqueue() {
        QueueService.sharedInstance.enqueue(self.customerId, self.eventId, self.configId, layoutName: nil, language: nil,
            success: { (enqueueDto) -> Void in
                let redirectInfo = enqueueDto.redirectDto
                if redirectInfo != nil {
                    self.handleQueuePassed(redirectInfo!)
                } else {
                    let eventState = enqueueDto.eventDetails.state
                    if eventState == .queue {
                        self.handleQueueIdAssigned(enqueueDto.queueIdDto!, enqueueDto.eventDetails)
                        self.checkStatus()
                    }
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
        } else if statusDto.eventDetails?.state == .postqueue {
            self.onPostQueue()
        } else {
            print("requesting status...")
            self.executeWithDelay(CHECK_STATUS_DELAY_SEC, self.checkStatus)
        }
    }
    
    func handleQueuePassed(_ redirectInfo: RedirectDTO) {
        let cache = QueueCache.sharedInstatnce
        cache.setRedirectId((redirectInfo.redirectId))
        cache.setSessionTtlDelta(redirectInfo.ttl)
        cache.setSessionTtl(redirectInfo.ttl + currentTimeUnixUtil())
        cache.setExtendSession((redirectInfo.extendTtl))
        
        self.onQueuePassed(QueuePassedDetails(redirectInfo.passedType))
    }
    
    func currentTimeUnixUtil() -> Int64 {
        let val = Int64(NSDate().timeIntervalSince1970)
        return val
    }
    
    func executeWithDelay(_ delaySec: Int, _ action: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delaySec), execute: {
            action()
        })
    }
}
