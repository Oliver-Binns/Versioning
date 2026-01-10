import ArgumentParser
import Versioning

struct Validate: ParsableCommand {
    @Option(name: .shortAndLong, help: "A commit message to validate")
    private var message: String

    @Option(name: .shortAndLong, help: "Whether the commit contains a breaking change in the public facing API")
    private var containsBreakingChange: Bool = false

    mutating func run() throws {
        let commit = try Commit(string: message)
        if containsBreakingChange && !commit.isBreakingChange {
            throw ValidationError.breakingChangeNotFlagged
        }
        print("Validated commit message (\(message)) successfully")
    }
}
