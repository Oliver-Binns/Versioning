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
    
    @Option(name: .shortAndLong, help: "A commit message to validate")
    private var messages: [String]
    
    mutating func run() async throws {
        let session = GitHubAPISession(repository: repository, apiToken: token)
        let initialVersion = try await fetchVersion(session: session)
        let newVersion = try incrementVersion(initialVersion).description
        
        try await session.createTag(version: newVersion, sha: sha)
        try await session.createRelease(version: newVersion)
    }
 
    private func fetchVersion(session: GitHubAPISession) async throws -> Version {
        let release = try await session.latestRelease()
        return Version(string: release.tagName) ?? Version(0, 0, 0)
    }
    
    private func incrementVersion(_ initialVersion: Version) throws -> Version {
        try messages
            .map(Commit.init)
            .compactMap(\.versionIncrement)
            .reduce(initialVersion) { version, increment in
                version.apply(increment: increment)
            }
    }
}
