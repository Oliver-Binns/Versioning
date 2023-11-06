import ArgumentParser
import Versioning

struct Validate: ParsableCommand {
    @Option(name: .shortAndLong, help: "A commit message to validate")
    private var message: String
    
    mutating func run() throws {
        _ = try Commit(string: message)
        print("Validated commit message (\(message)) successfully")
    }
}
