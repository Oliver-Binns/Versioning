import GitHubAPI
import Versioning

struct Releaser {
    private let session: APISession
    private let verbose: Bool
    
    init(session: APISession, verbose: Bool = false) {
        self.session = session
        self.verbose = verbose
    }
    
    func makeRelease(sha: String, tagOnly: Bool = false, tagPrefix: String = "") async throws -> Version? {
        let (initialVersion, commits) = try await fetchCommits(sha: sha, tagPrefix: tagPrefix)
        let newVersion = try incrementVersion(initialVersion, commits: commits)
        
        guard newVersion > initialVersion else {
            log("Nothing to do: no significant changes made")
            return nil
        }
        
        let tag = fullTag(prefix: tagPrefix, version: newVersion)
        try await session.createReference(version: tag, sha: sha)

        if !tagOnly {
            try await session.createRelease(version: tag)
        }
        
        log("Released new version: \(newVersion)")
        return newVersion
    }
    
    private func fetchCommits(sha: String, tagPrefix: String) async throws -> (initial: Version, commits: [String]) {
        do {
            let initialVersion = try await fetchVersion(tagPrefix: tagPrefix)
            let tag = fullTag(prefix: tagPrefix, version: initialVersion)
            let commits = try await session.compare(base: tag, head: sha)
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
 
    private func fetchVersion(tagPrefix: String) async throws -> Version {
        let release = try await session.latestRelease()
        let prefixWithSeparator = tagPrefix.isEmpty ? "" : "\(tagPrefix)-"
        let versionString = release.hasPrefix(prefixWithSeparator) ? String(release.dropFirst(prefixWithSeparator.count)) : release
        return Version(string: versionString) ?? Version(0, 0, 0)
    }

    private func fullTag(prefix: String, version: Version) -> String {
        prefix.isEmpty ? version.description : "\(prefix)-\(version.description)"
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
        guard verbose else { return }
        print(values)
    }
}
