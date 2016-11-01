import Foundation

public enum QueueState {
    case Idle, Prequeue, Queue, PostQueue
}


public class EventDetails
{
    public var customerId: String;
    public var eventId: String;
    public var absolutePreQueueStartTime: Int;
    public var relativePreQueueStartTime: Int;
    public var absoluteQueueStartTime: Int;
    public var relativeQueueStartTime: Int;
    public var absolutePostQueueStartTime: Int;
    public var relativePostQueueStartTime: Int;
    
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