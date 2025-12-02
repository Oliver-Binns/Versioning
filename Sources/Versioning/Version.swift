import Foundation

/// Version
///
/// A type for storing the app version in a structured object. Used to assemble the `UserAgent` HTTP header and for checking the app version.
public struct Version: CustomStringConvertible {
    let major: Int
    let minor: Int
    let increment: Int
    let suffix: String?
    let buildNumber: Int?
    
    /// Failable initialiser for `Version` which accepts a single String argument. Because it is failable, it returns an optional `Version`.
    /// // 1.2.3-alpha.1
    public init?(string: String) {
        // Split the string in 2 ie "1.2.3" and "alpha.1"
        let values = string.split(separator: "-").compactMap {
            String($0)
        }
        
        // Split the string in 3 ie "1", "2", and "3"
        let fullStopSeparatedValues = values[0].split(separator: ".").compactMap {
            Int($0)
        }
        
        guard fullStopSeparatedValues.count == 3 else {
            return nil
        }
        
        major = fullStopSeparatedValues[0]
        minor = fullStopSeparatedValues[1]
        increment = fullStopSeparatedValues[2]
        
        if values.count == 2 {
            let fullStopSeparatedValuesForSuffix = values[1].split(separator: ".").compactMap {
                String($0)
            }
            
            suffix  = fullStopSeparatedValuesForSuffix[0]
            buildNumber = Int(fullStopSeparatedValuesForSuffix[1])
        } else {
            suffix = nil
            buildNumber = nil
        }
    }
    
    /// Initialiser for `Version` with integer parameters for major, minor and increment.
    public init(_ major: Int, _ minor: Int, _ increment: Int, _ suffix: String? = nil, _ buildNumber: Int? = nil) {
        self.major = major
        self.minor = minor
        self.increment = increment
        self.suffix = suffix
        self.buildNumber = buildNumber
    }
    
    public var description: String {
        if let suffix, let buildNumber {
            "\(major).\(minor).\(increment)-\(suffix).\(buildNumber)"
        } else {
            "\(major).\(minor).\(increment)"
        }
    }
    
    public func apply(increment: VersionIncrement, newSuffix: String? = nil) -> Version {
        var newVersion: Version
        print(increment)
        
        switch increment {
        case .major:
            newVersion = Version(major + 1, 0, 0)
        case .minor:
            newVersion = Version(major, minor + 1, 0)
        case .patch:
            newVersion = Version(major, minor, self.increment + 1)
        }
        
        // if theres previous suffix
            // does that match?
                // if matching, bump build number
                // if not matching, build number set to 1 with new suffix
        // if theres no previous suffix
            // build number set to 1 with new suffix
        
        print(self.suffix)
        print(newSuffix)
        
        if let suffix {
            if let previousSuffix = self.suffix, previousSuffix == newSuffix {
                return Version(newVersion.major, newVersion.minor, newVersion.increment, previousSuffix, (buildNumber ?? 0) + 1)
            } else {
                return Version(newVersion.major, newVersion.minor, newVersion.increment, newSuffix, 1)
            }
        } else {
            return newVersion
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
        //TODO: add check that suffix is less than no suffix?
        
        return lhs.increment < rhs.increment
    }
}

extension Version: Sendable { }
extension Version {
    public static let one = Version(1, 0, 0)
    public static let oneWithSuffix = Version(1, 0, 0, "alpha", 1)

}
