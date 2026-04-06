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
    
    public func latestRelease(tagPrefix: String = "") async throws -> String {
        if tagPrefix.isEmpty {
            return try await latestReleaseFromLatestEndpoint()
        } else {
            return try await latestRelease(withPrefix: "\(tagPrefix)-")
        }
    }

    private func latestReleaseFromLatestEndpoint() async throws -> String {
        let (data, response) = try await session
            .data(from: .latestRelease(repository: repository))
        
        guard let response = response as? HTTPURLResponse else {
            throw GitHubAPIError.unknown
        }

        switch response.statusCode {
        case _ where response.statusCode.isSuccessful:
            return try JSONDecoder()
                .decode(GitHubReleaseResponse.self, from: data)
                .tagName
        case 404:
            throw GitHubAPIError.notFound
        default:
            throw GitHubAPIError.unknown
        }
    }

    private func latestRelease(withPrefix prefixWithSeparator: String) async throws -> String {
        var page = 1
        while true {
            let (data, response) = try await session
                .data(from: .listReleases(repository: repository, page: page))

            guard let response = response as? HTTPURLResponse else {
                throw GitHubAPIError.unknown
            }

            guard response.statusCode.isSuccessful else {
                throw response.statusCode == 404 ? GitHubAPIError.notFound : GitHubAPIError.unknown
            }

            let releases = try JSONDecoder()
                .decode([GitHubReleaseResponse].self, from: data)

            if let match = releases.first(where: { $0.tagName.hasPrefix(prefixWithSeparator) }) {
                return match.tagName
            }

            // An empty page means there are no more releases to check.
            guard !releases.isEmpty else {
                throw GitHubAPIError.notFound
            }

            page += 1
        }
    }
    
    public func compare(base: String, head: String) async throws -> [String] {
        let (data, _) = try await session
            .data(from: .compare(repository: repository, base: base, head: head))
        return try JSONDecoder()
            .decode(GitHubCompareResponse.self, from: data)
            .commits.map(\.commit).map(\.message)
    }
    
    public func createReference(version: String, sha: String) async throws {
        let reference = "refs/tags/\(version)"
        let requestObject = CreateReferenceRequest(ref: reference,
                                                   sha: sha)
        
        var request = URLRequest(url: .references(repository: repository))
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

