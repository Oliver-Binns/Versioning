import ArgumentParser
import Versioning

struct Validate: ParsableCommand {
    @Option(name: .shortAndLong, help: "A commit message to validate")
    private var message: String
    
    @Option(name: .shortAndLong, help: "Require breaking change")
    private var requireBreakingChange: Bool = false
    
    mutating func run() throws {
        let commit = try Commit(string: message)
        if requireBreakingChange && !commit.isBreakingChange {
            throw ValidationError.breakingChangeNotFlagged
        }
        print("Validated commit message (\(message)) successfully")
    }
}
