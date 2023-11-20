import GitHubAPI

protocol APISession {
    func latestRelease() async throws -> String
    func compare(base: String, head: String) async throws -> [String]
    
    func createReference(version: String, sha: String) async throws
    func createRelease(version: String) async throws
}

extension GitHubAPISession: APISession { }
