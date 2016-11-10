import Foundation

open class QueueITEngine {
    open var customerId: String
    open var eventId: String
    open var configId: String
    open var layoutName: String
    open var language: String
    open var widgets = [Widget]()
    
    var queuePassed: (String) -> Void
    var onQueueItemAssigned: (QueueItemDetails) -> Void
    var onQueuePassed: (QueuePassedDetails) -> Void
    
    init(customerId: String, eventId: String, configId: String, widgets:Widget ..., layoutName: String, language: String, queuePassed: @escaping (_ queueId: String) -> Void,
                onQueueItemAssigned: @escaping (_ queueItemDetails: QueueItemDetails) -> Void,
                onQueuePassed: @escaping (_ queuePassedDetails: QueuePassedDetails) -> Void) {
        self.customerId = customerId
        self.eventId = eventId
        self.configId = configId
        self.layoutName = layoutName
        self.language = language
        self.queuePassed = queuePassed
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
            self.handleQueuePassed(redirectInfo!, statusDto.eventDetails!)
        }
    }
    
    func handleQueuePassed(_ redirectInfo: RedirectDTO, _ eventDetails: EventDetails) {
        let cache = QueueCache.sharedInstatnce
        cache.setRedirectId((redirectInfo.redirectId))
        cache.setSessionTtl((redirectInfo.ttl))
        cache.setExtendSession((redirectInfo.extendTtl))
        do {
            let passedType = try parseRedirectType(redirectInfo.redirectType)
            self.onQueuePassed(QueuePassedDetails(passedType, eventDetails))
        } catch {
            print("Unknown redirectType: \(redirectInfo.redirectType)")
        }
    }
    
    func parseRedirectType(_ redirectType: String) throws -> PassedType {
        var passedType: PassedType
        if redirectType == "SafetyNet" {
            passedType = .safetyNet
        } else if redirectType == "Disabled" {
            passedType = .disabled
        } else if redirectType == "DirectLink" {
            passedType = .directLink
        } else if redirectType == "AfterEvent" {
            passedType = .afterEvent
        } else if redirectType == "Queue" {
            passedType = .queue
        } else {
            throw PassedTypeError.invalidPassedType
        }
        return passedType
    }
}
