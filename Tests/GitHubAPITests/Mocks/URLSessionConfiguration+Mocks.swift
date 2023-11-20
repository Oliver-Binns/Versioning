import Foundation

extension URLSessionConfiguration {
    static var mock: URLSessionConfiguration {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return configuration
    }
}
