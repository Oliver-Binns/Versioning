import ArgumentParser
import Versioning

struct Increment: ParsableCommand {
    @Option(name: .shortAndLong, help: "The initial version to be incremented")
    private var initialVersion: String
    
    //@Option(name: .shortAndLong, help: "A commit message to validate")
    //private var messages: [String]
    
    mutating func run() throws -> String {
        /*try messages
            .map(Commit.init)
            .compactMap(\.versionIncrement)
            .reduce(initialVersion) { version, increment in
                version.apply(increment: increment)
            }*/
        Version.one.description
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
