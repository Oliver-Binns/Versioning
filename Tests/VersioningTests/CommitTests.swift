@testable import Versioning
import XCTest

final class CommitTests: XCTestCase {
    func testInitialisation() throws {
        let commit = try Commit(string: "feat: adding-optional-initialiser-for-icon")
        XCTAssertEqual(commit.type, .feature)
        XCTAssertFalse(commit.isBreakingChange)
        XCTAssertEqual(commit.message, "adding-optional-initialiser-for-icon")
    }
    
    func testCommitTypesWithoutDeps() throws {
        try CommitType.allCases.forEach {
            let message = "\($0.rawValue): commit message here"
            let commit = try Commit(string: message)
            XCTAssertEqual($0, commit.type)
        }
    }

    func testCommitTypesWithDeps() throws {
        try CommitType.allCases.forEach {
            let message = "\($0.rawValue)(dep): commit message here"
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
    
    func testSquashedCommits() throws {
        let commit = try Commit(string: """
feat: DCMAW-7932 Automate Versioning (#50)
* chore: added a new step on pull request.yml to validate PR names

* chore: update quality report.yml to include increment version job

* chore: moved validate job to before build and test action
""")
        XCTAssertEqual(commit.type, .feature)
        XCTAssertFalse(commit.isBreakingChange)
        XCTAssertEqual(commit.message, """
DCMAW-7932 Automate Versioning (#50)
* chore: added a new step on pull request.yml to validate PR names

* chore: update quality report.yml to include increment version job

* chore: moved validate job to before build and test action
""")
    }
    
    func testThrowsInvalidPrefixError() throws {
        do {
            _ = try Commit(string: "invalid: adding-optional-initialiser-for-icon")
            XCTFail("Expected error to be thrown")
        } catch CommitFormatError.invalidPrefix(let string) {
            XCTAssertEqual(string, "invalid")
        }
    }   
    
    func testThrowsInvalidPrefixErrorDescription() throws {
        do {
            _ = try Commit(string: "invalid: adding-optional-initialiser-for-icon")
            XCTFail("Expected error to be thrown")
        } catch let error as CommitFormatError {
            XCTAssertTrue(error.description.contains("\"invalid\" is not an allowed commit prefix."))
        }
    }
    
    func testThrowsInvalidStructureError() throws {
        do {
            _ = try Commit(string: "feat with no colon / message")
            XCTFail("Expected error to be thrown")
        } catch CommitFormatError.invalid(let string) {
            XCTAssertEqual(string, "feat with no colon / message")
        }
    }   
    
    func testThrowsInvalidStructureErrorDescription() throws {
        do {
            _ = try Commit(string: "feat with no colon / message")
            XCTFail("Expected error to be thrown")
        } catch let error as CommitFormatError {
            XCTAssertTrue(error.description.contains("Invalid commit message format: feat with no colon / message"))
        }
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
