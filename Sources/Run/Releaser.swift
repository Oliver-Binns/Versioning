import GitHubAPI
import Versioning

struct Releaser {
    let session: APISession
    
    init(session: APISession) {
        self.session = session
    }
    
    func makeRelease(sha: String) async throws {
        let (initialVersion, commits) = try await fetchCommits(sha: sha)
        let newVersion = try incrementVersion(initialVersion, commits: commits)
        
        guard newVersion > initialVersion else {
            print("Nothing to do: no significant changes made")
            return
        }
        
        try await session.createReference(version: newVersion.description, sha: sha)
        try await session.createRelease(version: newVersion.description)
        print("Released new version: \(newVersion)")
    }
    
    private func fetchCommits(sha: String) async throws -> (initial: Version, commits: [String]) {
        do {
            let initialVersion = try await fetchVersion()
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
 
    private func fetchVersion() async throws -> Version {
        let release = try await session.latestRelease()
        return Version(string: release) ?? Version(0, 0, 0)
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
