@testable import GitHubAPI
import XCTest

final class GitHubAPISessionTests: XCTestCase {
    private var sut: GitHubAPISession!
    private var session: URLSession!
    
    private var accessToken = UUID().uuidString
    private let repository = "octocat/Hello-World"
    
    override func setUp() {
        super.setUp()
        
        sut = GitHubAPISession(sessionConfiguration: .mock,
                               repository: repository,
                               apiToken: accessToken)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
        
        super.tearDown()
    }
}

extension GitHubAPISessionTests {
    func testLatestRelease() async throws {
        let file = try XCTUnwrap(
            Bundle.module.url(forResource: "LatestRelease", withExtension: "json")
        )
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "GET")
            self.verifyHeaders(request: request)
            
            return try (
                HTTPURLResponse.success(url: XCTUnwrap(request.url)),
                Data(contentsOf: file)
            )
            
        }
        
        let release = try await sut.latestRelease()
        XCTAssertEqual(release.tagName, "v1.0.0")
    }
    
    func testCreateReference() async throws {
        let version = UUID().uuidString
        let sha = UUID().uuidString
        
        let file = try XCTUnwrap(
            Bundle.module.url(forResource: "LatestRelease", withExtension: "json")
        )
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            
            return try (
                HTTPURLResponse.success(url: XCTUnwrap(request.url)),
                Data(contentsOf: file)
            )
            
        }
        
        try await sut.createReference(version: version, sha: sha)
    }
    
    func testCreateRelease() async throws {
        let version = UUID().uuidString
        
        let file = try XCTUnwrap(
            Bundle.module.url(forResource: "LatestRelease", withExtension: "json")
        )
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.httpMethod, "POST")
            
            return try (
                HTTPURLResponse.success(url: XCTUnwrap(request.url)),
                Data(contentsOf: file)
            )
            
        }
        
        try await sut.createRelease(version: version)
    }
    
    func verifyHeaders(request: URLRequest,
                       file: StaticString = #filePath,
                       line: UInt = #line) {
        XCTAssertEqual(
            request.allHTTPHeaderFields?["Accept"],
            "application/vnd.github+json",
            file: file,
            line: line
        )
        
        XCTAssertNotNil(
            request.allHTTPHeaderFields?["Bearer"],
            accessToken,
            file: file,
            line: line
        )
    }
}

