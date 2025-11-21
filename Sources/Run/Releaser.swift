import GitHubAPI
import Versioning

struct Releaser {
    private let session: APISession
    private let verbose: Bool
    
    init(session: APISession, verbose: Bool = false) {
        self.session = session
        self.verbose = verbose
    }
    
    func makeRelease(sha: String, tagOnly: Bool = false, suffix: String? = nil) async throws -> Version? {
        print("made it to make release")
        let (initialVersion, commits) = try await fetchCommits(sha: sha)
        print("made it to initial version")
        let newVersion = try incrementVersion(initialVersion, commits: commits)
        print("made it to new version")
        let newVersionDescription = if let suffix {
            "\(newVersion.description)-\(suffix)"
        } else {
            newVersion.description
        }
        
        // guard newVersion > initialVersion else {
        //     log("Nothing to do: no significant changes made")
        //     return nil
        // }
        
        try await session.createReference(version: newVersionDescription, sha: sha)

        if !tagOnly {
            try await session.createRelease(version: newVersionDescription)
            print("tag only")
        }
        
        log("Released new version: \(newVersion)")
        return newVersion
    }
    
    private func fetchCommits(sha: String) async throws -> (initial: Version, commits: [String]) {
        do {
            let initialVersion = try await fetchVersion()
            let commits = try await session.compare(base: initialVersion.description, head: sha)
            return (initialVersion, commits)
        } catch GitHubAPIError.notFound {
            log("No previous release found, comparing to previous commit")
            let commits = try await session.compare(base: "HEAD^", head: sha)
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
    
    private func log(_ values: String...) {
        // guard verbose else { return }
        print(values)
    }
}
