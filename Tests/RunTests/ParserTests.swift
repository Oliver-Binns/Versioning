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
}
