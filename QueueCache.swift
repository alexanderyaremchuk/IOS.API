import Foundation



public class QueueCache {
    private static var KEY_CACHE = ""
    private static let KEY_QUEUE_ID = "queueId"
    
    static let sharedInstatnce  = QueueCache()
    
    func initialize(customerId: String, eventId: String) {
        QueueCache.KEY_CACHE = "\(customerId)-\(eventId)"
    }
    
    func isEmpty() -> Bool {
        var defaults = NSUserDefaults.standardUserDefaults()
        if let res = defaults.dictionaryForKey(QueueCache.KEY_CACHE) {
            return false;
        }
        return true;
    }
    
    func getQueueId() {
        if isEmpty() {
            
        }
        
    }
    
}
