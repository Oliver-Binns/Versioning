@testable import GitHubAPI
import XCTest

final class URLTests: XCTestCase {
    let repository = "octocat/Hello-World"
    
    func testReleasesURL() {
        XCTAssertEqual(
            URL.releases(repository: repository).absoluteString,
            "https://api.github.com/repos/octocat/Hello-World/releases"
        )
    }
    
    func testCompareURL() {
        XCTAssertEqual(
            URL.compare(repository: repository, base: "0.0.3", head: "7474013faffbf094ff0bd198168c7fcacdb2f1f4").absoluteString,
            "https://api.github.com/repos/octocat/Hello-World/compare/0.0.3...7474013faffbf094ff0bd198168c7fcacdb2f1f4"
        )
    }
    
    func testLatestReleaseURL() {
        XCTAssertEqual(
            URL.latestRelease(repository: repository).absoluteString,
            "https://api.github.com/repos/octocat/Hello-World/releases/latest"
        )
    }
    
    func testTagsURL() {
        XCTAssertEqual(
            URL.references(repository: repository).absoluteString,
            "https://api.github.com/repos/octocat/Hello-World/git/refs"
        )
    }
}
