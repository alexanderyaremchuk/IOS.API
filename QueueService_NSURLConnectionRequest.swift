import Foundation

public class QueueService_NSURLConnectionRequest : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate
{
    var request: NSURLRequest
    var response: NSURLResponse?
    var conn: NSURLConnection?
    var expectedStatusCode: Int
    var actualStatusCode: Int?
    var successCallback: QueueServiceSuccess
    var failureCallback: QueueServiceFailure
    
    init(request: NSURLRequest, expectedStatusCode: Int, successCallback: QueueServiceSuccess, failureCallback: QueueServiceFailure) {
        self.request = request
        self.expectedStatusCode = expectedStatusCode
        self.successCallback = successCallback
        self.failureCallback = failureCallback
        super.init()
        self.initiateRequest()
    }
    
    func initiateRequest() {
        var data = NSMutableData()
        self.actualStatusCode = NSNotFound
        self.conn = NSURLConnection(request: self.request, delegate: self)
    }
    
    public func connectionDidFinishLoading(conn:NSURLConnection) {

    }
    
    public func connection(conn:NSURLConnection, didReceiveResponse response:NSURLResponse) {

    }
    
    public func connection(conn:NSURLConnection, didReceiveData data:NSData) {

    }
    
    public func connection(conn:NSURLConnection, didFailWithError error:NSError) {

    }
    
}
