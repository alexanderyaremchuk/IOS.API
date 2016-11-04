import Foundation



open class QueueCache {
    fileprivate static var KEY_CACHE = ""
    fileprivate static let KEY_QUEUE_ID = "queueId"
    
    static let sharedInstatnce  = QueueCache()
    
    func initialize(_ customerId: String, eventId: String) {
        QueueCache.KEY_CACHE = "\(customerId)-\(eventId)"
    }
    
    func isEmpty() -> Bool {
        let defaults = UserDefaults.standard
        if let res = defaults.dictionary(forKey: QueueCache.KEY_CACHE) {
            return false;
        }
        return true;
    }
    
    func getQueueId() {
        if isEmpty() {
            
        }
        
    }
    
}
