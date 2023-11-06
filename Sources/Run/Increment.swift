import ArgumentParser
import Versioning

struct Increment: ParsableCommand {
    mutating func run() throws {
        print("hi")
    }
    
    
    static func calculateNewVersion(initialVersion: Version,
                                    commits: [Commit]) -> Version {
        commits
            .compactMap(\.versionIncrement)
            .reduce(initialVersion) { version, increment in
                version.apply(increment: increment)
            }
    }
}
