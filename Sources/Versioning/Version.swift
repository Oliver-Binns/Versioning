import Foundation

/// Version
///
/// A type for storing the app version in a structured object. Used to assemble the `UserAgent` HTTP header and for checking the app version.
public struct Version: CustomStringConvertible {
    let major: Int
    let minor: Int
    let increment: Int
    
    /// Failable initialiser for `Version` which accepts a single String argument. Because it is failable, it returns an optional `Version`.
    public init?(string: String) {
        let values = string.split(separator: ".").compactMap {
            Int($0)
        }
        guard values.count == 3 else {
            return nil
        }
        major = values[0]
        minor = values[1]
        increment = values[2]
    }
    
    /// Initialiser for `Version` with integer parameters for major, minor and increment.
    public init(_ major: Int, _ minor: Int, _ increment: Int) {
        self.major = major
        self.minor = minor
        self.increment = increment
    }
    
    public var description: String {
        "\(major).\(minor).\(increment)"
    }
    
    public func apply(increment: VersionIncrement) -> Version {
        switch increment {
        case .major:
            Version(major + 1, 0, 0)
        case .minor:
            Version(major, minor + 1, 0)
        case .patch:
            Version(major, minor, self.increment + 1)
        }
    }
}

/// Extension for protocol conformance to `Decodable`
extension Version: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        guard let version = Version(string: string) else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Incorrect Version Format"))
        }
        self = version
    }
}

/// Extension for protocol conformance to `Comparable`
extension Version: Comparable {
    public static func < (lhs: Version, rhs: Version) -> Bool {
        guard lhs.major == rhs.major else {
            return lhs.major < rhs.major
        }
        guard lhs.minor == rhs.minor else {
            return lhs.minor < rhs.minor
        }
        return lhs.increment < rhs.increment
    }
}

extension Version {
    public static var one = Version(1, 0, 0)
}
