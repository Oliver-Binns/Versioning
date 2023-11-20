import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class GitHubAPISession {
    private let session: URLSession
    private let repository: String
    
    init(sessionConfiguration: URLSessionConfiguration,
         repository: String,
         apiToken: String) {
        sessionConfiguration.httpAdditionalHeaders = [
            "Accept" : "application/vnd.github+json",
            "Bearer" : apiToken
        ]
        
        self.session = URLSession(configuration: sessionConfiguration)
        self.repository = repository
    }
    
    public convenience init(repository: String, apiToken: String) {
        self.init(sessionConfiguration: .ephemeral,
                  repository: repository, apiToken: apiToken)
    }
    
    public func latestRelease() async throws -> GitHubRelease {
        let (data, _) = try await session
            .data(from: .latestRelease(repository: repository))
        return try JSONDecoder()
            .decode(GitHubRelease.self, from: data)
    }
    
    public func createTag(version: String, sha: String) async throws {
        let reference = "refs/tags/\(version)"
        let requestObject = CreateReferenceRequest(ref: reference,
                                                   sha: sha)
        
        var request = URLRequest(url: .tags(repository: repository))
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(requestObject)
        
        _ = try await session.data(for: request)
    }
    
    public func createRelease(version: String) async throws {
        let name = "v\(version)"
        let requestObject = CreateReleaseRequest(
            name: name,
            tagName: version.description,
            draft: false,
            prerelease: false,
            generateReleaseNotes: true
        )
        
        var request = URLRequest(url: .releases(repository: repository))
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(requestObject)
        
        _ = try await session.data(for: request)
    }
}

