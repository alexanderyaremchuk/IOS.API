import Foundation

enum CacheErorr : Error {
    case NotFound(String)
}

open class QueueCache {
    fileprivate var KEY_CACHE = ""
    fileprivate let KEY_QUEUE_ID = "queueId"
    fileprivate let KEY_SESSION_TTL = "sessionTtl"
    
    static let sharedInstatnce  = QueueCache()
    
    func initialize(_ customerId: String, eventId: String) {
        KEY_CACHE = "\(customerId)-\(eventId)"
    }
    
    open func getQueueId() throws -> String {
        let cache: [String : Any] = ensureCache()
        let queueId: String = cache[KEY_QUEUE_ID] as! String
        return queueId
    }
    
    open func setQueueId(_ queueId: String) {
        update(key: KEY_QUEUE_ID, value: queueId)
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
    
    func update(key: String, value: String) {
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
