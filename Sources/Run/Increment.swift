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
    
    mutating func run() async throws {
        let session = GitHubAPISession(repository: repository, apiToken: token)
        
        let (initialVersion, commits) = try await fetchCommits(session: session)
        let newVersion = try incrementVersion(initialVersion, commits: commits)
        
        guard newVersion > initialVersion else {
            print("Nothing to do: no significant changes made")
            return
        }
        
        try await session.createReference(version: newVersion.description, sha: sha)
        try await session.createRelease(version: newVersion.description)
        print("Released new version: \(newVersion)")
    }
    
    private func fetchCommits(session: GitHubAPISession) async throws -> (initial: Version, commits: [String]) {
        do {
            let initialVersion = try await fetchVersion(session: session)
            let commits = try await session.compare(base: initialVersion.description, head: sha)
            return (initialVersion, commits)
        } catch GitHubAPIError.notFound {
            print("No previous release found, comparing to HEAD")
            let commits = try await session.compare(base: "HEAD", head: sha)
            return (
                Version(0, 0, 0),
                commits
            )
        }
    }
 
    private func fetchVersion(session: GitHubAPISession) async throws -> Version {
        let release = try await session.latestRelease()
        return Version(string: release.tagName) ?? Version(0, 0, 0)
    }
    
    private func incrementVersion(_ initialVersion: Version, commits: [String]) throws -> Version {
        try commits
            .map(Commit.init)
            .compactMap(\.versionIncrement)
            .reduce(initialVersion) { version, increment in
                version.apply(increment: increment)
            }
    }
}
