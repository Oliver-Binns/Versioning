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
            "Authorization" : "token \(apiToken)",
            "Content-Type": "application/json"
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
    
    public func createReference(version: String, sha: String) async throws {
        let reference = "refs/tags/\(version)"
        let requestObject = CreateReferenceRequest(ref: reference,
                                                   sha: sha)
        
        var request = URLRequest(url: .references(repository: repository))
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(requestObject)
        
        let (data, _) = try await session.data(for: request)
        if let response = String(data: data, encoding: .utf8) {
            print("attempt create tag", response)
        }
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
        
        let (data, _) = try await session.data(for: request)
        if let response = String(data: data, encoding: .utf8) {
            print("attempt create tag", response)
        }
    }
}

