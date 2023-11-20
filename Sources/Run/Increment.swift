import ArgumentParser
import GitHubAPI
import Versioning

struct Increment: AsyncParsableCommand {
    @Option(name: .shortAndLong, help: "The owner and repository name. For example, octocat/Hello-World.")
    private var repository: String
    
    @Option(name: .shortAndLong, help: "The SHA hash for the commit that we are releasing")
    private var sha: String
    
    @Option(name: .shortAndLong, help: "A token that you can use to authenticate on behalf of GitHub Actions")
    private var token: String
    
    @Flag(name: .shortAndLong)
    private var verbose = false
    
    mutating func run() async throws {
        let session = GitHubAPISession(repository: repository, apiToken: token)
        if let version = try await Releaser(session: session, verbose: verbose)
            .makeRelease(sha: sha) {
            print(version)
        }
    }
}
