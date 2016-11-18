import Foundation

open class QueueService_NSURLConnectionRequest : NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate
{
    var request: URLRequest
    var response: URLResponse?
    var conn: NSURLConnection?
    var expectedStatusCode: Int
    var actualStatusCode: Int?
    var data: Data?
    var successCallback: QueueServiceSuccess
    var failureCallback: QueueServiceFailure
    
    init(request: URLRequest, expectedStatusCode: Int, successCallback: @escaping QueueServiceSuccess, failureCallback: @escaping QueueServiceFailure) {
        self.request = request
        self.expectedStatusCode = expectedStatusCode
        self.successCallback = successCallback
        self.failureCallback = failureCallback
        super.init()
        self.initiateRequest()
    }
    
    func initiateRequest() {
        self.data = NSMutableData() as Data
        self.actualStatusCode = NSNotFound
        self.conn = NSURLConnection(request: self.request, delegate: self)
    }
    
    open func connectionDidFinishLoading(_ conn:NSURLConnection)
    {
        if hasExpectedStatusCode() {
            let data = self.data!
            self.successCallback(data as Data)
        } else {
            self.failureCallback(nil, self.actualStatusCode!)
        }
    }
    
    open func connection(_ conn:NSURLConnection, didReceive response:URLResponse)
    {
        self.response = response
        let httpResponse = response as! HTTPURLResponse
        let statusCode = httpResponse.statusCode;
        self.actualStatusCode = statusCode
    }
    
    open func connection(_ conn:NSURLConnection, didReceive data:Data)
    {
        appendData(data)
    }
    
    open func connection(_ conn:NSURLConnection, didFailWithError error:Error)
    {
    }
    
    func hasExpectedStatusCode() -> Bool {
        if self.expectedStatusCode != NSNotFound {
            return self.expectedStatusCode == self.actualStatusCode
        }
        return false
    }
    
    func appendData(_ data: Data)
    {
        self.data?.append(data)
    }
}
