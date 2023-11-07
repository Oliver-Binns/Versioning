@testable import Versioning
import XCTest

final class CommitTests: XCTestCase {
    func testInitialisation() throws {
        let commit = try Commit(string: "feat: adding-optional-initialiser-for-icon")
        XCTAssertEqual(commit.type, .feature)
        XCTAssertFalse(commit.isBreakingChange)
        XCTAssertEqual(commit.message, "adding-optional-initialiser-for-icon")
    }

    func testCommitTypes() throws {
        try CommitType.allCases.forEach {
            let message = "\($0.rawValue): commit message here"
            let commit = try Commit(string: message)
            XCTAssertEqual($0, commit.type)
        }
    }

    func testBreakingChange() throws {
        try CommitType.allCases.forEach {
            let message = "\($0.rawValue)!: commit message here"
            let commit = try Commit(string: message)
            XCTAssertEqual($0, commit.type)
        }
    }

    func testThrowsInvalidPrefixError() throws {
        do {
            _ = try Commit(string: "invalid: adding-optional-initialiser-for-icon")
            XCTFail("Expected error to be thrown")
        } catch CommitFormatError.invalidPrefix { }
    }

    func testThrowsInvalidStructureError() throws {
        do {
            _ = try Commit(string: "feat with no colon / message")
            XCTFail("Expected error to be thrown")
        } catch CommitFormatError.invalid { }
    }

    func testVersionIncrementValues() throws {
        try XCTAssertEqual(
            Commit(string: "feat!: adding-optional-initialiser-for-icon").versionIncrement,
            .major
        )

        try XCTAssertEqual(
            Commit(string: "feat: adding-optional-initialiser-for-icon").versionIncrement,
            .minor
        )

        try XCTAssertEqual(
            Commit(string: "fix: adding-optional-initialiser-for-icon").versionIncrement,
            .patch
        )

        try XCTAssertEqual(
            Commit(string: "ci: adding-optional-initialiser-for-icon").versionIncrement,
            nil
        )
    }
}
