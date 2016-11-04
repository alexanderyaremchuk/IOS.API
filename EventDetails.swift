import Foundation

public enum QueueState {
    case idle, prequeue, queue, postQueue
}


open class EventDetails
{
    open var customerId: String;
    open var eventId: String;
    open var absolutePreQueueStartTime: Int;
    open var relativePreQueueStartTime: Int;
    open var absoluteQueueStartTime: Int;
    open var relativeQueueStartTime: Int;
    open var absolutePostQueueStartTime: Int;
    open var relativePostQueueStartTime: Int;
    
    init(customerId: String, eventId: String, absolutePreQueueStartTime: Int, relativePreQueueStartTime: Int, absoluteQueueStartTime: Int,
            relativeQueueStartTime: Int, absolutePostQueueStartTime: Int, relativePostQueueStartTime: Int) {
        self.customerId = customerId;
        self.eventId = eventId;
        self.absolutePreQueueStartTime = absolutePreQueueStartTime;
        self.relativePreQueueStartTime = relativePreQueueStartTime;
        self.absoluteQueueStartTime = absoluteQueueStartTime;
        self.relativeQueueStartTime = relativeQueueStartTime;
        self.absolutePostQueueStartTime = absolutePostQueueStartTime;
        self.relativePostQueueStartTime = relativePostQueueStartTime;
    }
}
