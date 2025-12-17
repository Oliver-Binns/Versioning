import Foundation

final class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        do {
            guard let (response, data) = try Self.requestHandler?(request) else {
                preconditionFailure("Received unexpected request with no handler set")
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }
}

extension URLRequest {
    public func httpBodyData() -> Data? {
        guard let bodyStream = self.httpBodyStream else { return nil }
        
        bodyStream.open()
        
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        var data = Data()
        
        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readData)
        }
        
        buffer.deallocate()
        bodyStream.close()
        return data
    }
}
