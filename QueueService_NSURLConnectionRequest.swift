import Foundation

public class QueueService_NSURLConnectionRequest : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate
{
    var request: NSURLRequest
    var response: NSURLResponse?
    var conn: NSURLConnection?
    var expectedStatusCode: Int
    var actualStatusCode: Int?
    var data: NSMutableData?
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
        self.data = NSMutableData()
        self.actualStatusCode = NSNotFound
        self.conn = NSURLConnection(request: self.request, delegate: self)
    }
    
    public func connectionDidFinishLoading(conn:NSURLConnection)
    {
        if hasExpectedStatusCode() {
            var data = self.data!
            self.successCallback(data: data)
        }
    }
    
    public func connection(conn:NSURLConnection, didReceiveResponse response:NSURLResponse)
    {
        self.response = response
        var httpResponse = response as! NSHTTPURLResponse
        var statusCode = httpResponse.statusCode;
        self.actualStatusCode = statusCode
    }
    
    public func connection(conn:NSURLConnection, didReceiveData data:NSData)
    {
        appendData(data)
    }
    
    public func connection(conn:NSURLConnection, didFailWithError error:NSError)
    {

    }
    
    func hasExpectedStatusCode() -> Bool {
        if self.expectedStatusCode != NSNotFound {
            var actualStatusCode = self.actualStatusCode
            var expectedStatusCode = self.expectedStatusCode
            return self.expectedStatusCode == self.actualStatusCode
        }
        return false
    }
    
    func appendData(data: NSData)
    {
        self.data?.appendData(data)
    }
}
