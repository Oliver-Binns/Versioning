import Foundation

extension HTTPURLResponse {
    static func success(url: URL) -> HTTPURLResponse {
        HTTPURLResponse(url: url,
                        statusCode: 200, httpVersion: nil,
                        headerFields: ["Content-Type": "application/json"])!
    }
}
