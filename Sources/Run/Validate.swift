import ArgumentParser
import Versioning

struct Validate: ParsableCommand {
    mutating func run() throws {
        print("hi")
        
    }
    
    static func validateCommits(messages: [String]) throws {
        _ = try messages.map(Commit.init)
    }
}
