import Foundation

public class QueueITEngine {
    public var customerId: String;
    public var eventId: String;
    public var layoutName: String;
    public var language: String;
    
    public init(customerId: String, eventId: String, layoutName: String, language: String) {
        self.customerId = customerId;
        self.eventId = eventId;
        self.layoutName = layoutName;
        self.language = language;
    }
    
    func tryEnqueue() {
        var userId = "sashaUnique"
        var userAgent = "myUserAgent"
        var sdkVersion = "v1.0"
        
        var qs = QueueService.sharedInstance
        
        qs.enqueue(self.customerId, eventId: self.eventId, userId: userId, userAgent: userAgent, sdkVersion: sdkVersion, layoutName: nil, language: nil,
            success: { (status) -> Void in
                var qId = status.queueId
                var url = status.queueUrl
                var targetUrl = status.targetUrl
            }) { (error, errorMessage) -> Void in
                var errorText = errorMessage
            }
    }
}