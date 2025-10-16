@testable import Run
import Versioning
import XCTest

final class ReleaserTests: XCTestCase {
    func testReleaseWhenNoPreviousRelease() async throws {
        let session = MockAPISession()
        
        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha)
        
        XCTAssertEqual(session.didCallCompare?.0, "HEAD^")
        XCTAssertEqual(session.didCallCompare?.1, sha)
        
        XCTAssertEqual(session.didCallCreateReference?.0, "0.2.1")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertEqual(session.didCallCreateRelease, "0.2.1")
        
        XCTAssertEqual(version, Version(0, 2, 1))
    }
    
    func testReleaseWhenNoPreviousRelease_withSuffix() async throws {
        let session = MockAPISession()
        
        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha, suffix: "alpha")
        
        XCTAssertEqual(session.didCallCompare?.0, "HEAD^")
        XCTAssertEqual(session.didCallCompare?.1, sha)
        
        XCTAssertEqual(session.didCallCreateReference?.0, "0.2.1-alpha")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertEqual(session.didCallCreateRelease, "0.2.1-alpha")
        
        XCTAssertEqual(version, Version(0, 2, 1))
    }
    
    func testReleaseWhenNoPreviousRelease_withSuffix_numerical() async throws {
        let session = MockAPISession()
        
        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha, suffix: "123")
        
        XCTAssertEqual(session.didCallCompare?.0, "HEAD^")
        XCTAssertEqual(session.didCallCompare?.1, sha)
        
        XCTAssertEqual(session.didCallCreateReference?.0, "0.2.1-123")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertEqual(session.didCallCreateRelease, "0.2.1-123")
        
        XCTAssertEqual(version, Version(0, 2, 1))
    }
    
    func testReleaseWhenRelease() async throws {
        let session = MockAPISession()
        session.previousReleaseExists = true
        
        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha)
        
        XCTAssertEqual(session.didCallCompare?.0, "1.0.0")
        XCTAssertEqual(session.didCallCompare?.1, sha)
        
        XCTAssertEqual(session.didCallCreateReference?.0, "1.2.1")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertEqual(session.didCallCreateRelease, "1.2.1")
        
        XCTAssertEqual(version, Version(1, 2, 1))
    }
    
    func testReleaseWhenRelease_withSuffix() async throws {
        let session = MockAPISession()
        session.previousReleaseExists = true
        
        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha, suffix: "beta")
        
        XCTAssertEqual(session.didCallCompare?.0, "1.0.0")
        XCTAssertEqual(session.didCallCompare?.1, sha)
        
        XCTAssertEqual(session.didCallCreateReference?.0, "1.2.1-beta")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertEqual(session.didCallCreateRelease, "1.2.1-beta")
        
        XCTAssertEqual(version, Version(1, 2, 1))
    }

    func testReleaseWhenTagOnly() async throws {
        let session = MockAPISession()
        session.previousReleaseExists = true

        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha, tagOnly: true)

        XCTAssertEqual(session.didCallCompare?.0, "1.0.0")
        XCTAssertEqual(session.didCallCompare?.1, sha)

        XCTAssertEqual(session.didCallCreateReference?.0, "1.2.1")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertNil(session.didCallCreateRelease)

        XCTAssertEqual(version, Version(1, 2, 1))
    }
    
    func testReleaseWhenTagOnly_withSuffix() async throws {
        let session = MockAPISession()
        session.previousReleaseExists = true

        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha, tagOnly: true, suffix: "beta")

        XCTAssertEqual(session.didCallCompare?.0, "1.0.0")
        XCTAssertEqual(session.didCallCompare?.1, sha)

        XCTAssertEqual(session.didCallCreateReference?.0, "1.2.1-beta")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertNil(session.didCallCreateRelease)

        XCTAssertEqual(version, Version(1, 2, 1))
    }

    func testReleaseOfSquashedCommits() async throws {
        let session = MockAPISession()
        session.previousReleaseExists = true
        session.useMultiCommit = true
        
        let sha = UUID().uuidString
        let sut = Releaser(session: session)
        let version = try await sut.makeRelease(sha: sha)
        
        XCTAssertEqual(session.didCallCompare?.0, "1.0.0")
        XCTAssertEqual(session.didCallCompare?.1, sha)
        
        XCTAssertEqual(session.didCallCreateReference?.0, "1.3.1")
        XCTAssertEqual(session.didCallCreateReference?.1, sha)
        XCTAssertEqual(session.didCallCreateRelease, "1.3.1")
        
        XCTAssertEqual(version, Version(1, 3, 1))
    }
}
