import Foundation

open class QueueCache {
    fileprivate var KEY_CACHE = ""
    fileprivate let KEY_QUEUE_ID = "queueId"
    fileprivate let KEY_QUEUEID_TTL = "sessionTtl"
    fileprivate let KEY_EXTEND_SESSION = "extendSession"
    fileprivate let KEY_REDIRECT_ID = "redirectId"
    fileprivate let KEY_SESSION_TTL = "redirectTtl"
    
    static let sharedInstatnce  = QueueCache()
    
    func initialize(_ customerId: String, eventId: String) {
        KEY_CACHE = "\(customerId)-\(eventId)"
    }
    
    open func getQueueId() -> String? {
        let cache: [String : Any] = ensureCache()
        let queueId: String? = cache[KEY_QUEUE_ID] as? String
        return queueId
    }
    
    open func getQueueIdTtl() -> Int? {
        let cache: [String : Any] = ensureCache()
        let queueIdTtl: Int? = cache[KEY_QUEUEID_TTL] as? Int
        return queueIdTtl
    }
    
    open func getExtendSession() -> Bool? {
        let cache: [String : Any] = ensureCache()
        let extendSession: Bool? = cache[KEY_EXTEND_SESSION] as? Bool
        return extendSession
    }
    
    open func getRedirectId() -> String? {
        let cache: [String : Any] = ensureCache()
        let redirectId: String? = cache[KEY_REDIRECT_ID] as? String
        return redirectId
    }
    
    open func getSessionTtl() -> Int? {
        let cache: [String : Any] = ensureCache()
        let sessionTtl: Int? = cache[KEY_SESSION_TTL] as? Int
        return sessionTtl
    }
    
    open func setQueueId(_ queueId: String) {
        update(key: KEY_QUEUE_ID, value: queueId)
    }
    
    open func setExtendSession(_ extendSession: Bool) {
        update(key: KEY_EXTEND_SESSION, value: extendSession)
    }
    
    open func setRedirectId(_ redirectId: String) {
        update(key: KEY_REDIRECT_ID, value: redirectId)
    }
    
    open func setQueueIdTtl(_ queueIdTtl: Int) {
        update(key: KEY_QUEUEID_TTL, value: queueIdTtl)
    }
    
    open func setSessionTtl(_ redirectTtl: Int) {
        update(key: KEY_SESSION_TTL, value: redirectTtl)
    }
    
    open func clear() {
        var cache: [String : Any] = ensureCache()
        cache.removeAll()
        setCache(cache)
    }
    
    func ensureCache() -> [String : Any] {
        let defaults = UserDefaults.standard
        if defaults.dictionary(forKey: KEY_CACHE) == nil {
            let emptyDict = [String : Any]()
            setCache(emptyDict)
        }
        let cache : [String : Any] = defaults.dictionary(forKey: KEY_CACHE)!
        return cache
    }
    
    func update(key: String, value: Any) {
        var cache : [String : Any] = ensureCache()
        cache.updateValue(value, forKey: key)
        setCache(cache)
    }
    
    func setCache(_ cache: [String : Any]) {
        let defaults = UserDefaults.standard
        defaults.set(cache, forKey: KEY_CACHE)
        defaults.synchronize()
    }
}
