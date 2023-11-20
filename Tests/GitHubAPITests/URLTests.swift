@testable import GitHubAPI
import XCTest

final class URLTests: XCTestCase {
    let repository = "octocat/Hello-World"
    
    func testCommitURL() {
        XCTAssertEqual(
            URL.commits(repository: repository).absoluteString,
            "https://api.github.com/repos/octocat/Hello-World/commits"
        )
    }
    
    func testReleasesURL() {
        XCTAssertEqual(
            URL.releases(repository: repository).absoluteString,
            "https://api.github.com/repos/octocat/Hello-World/releases"
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
            URL.tags(repository: repository).absoluteString,
            "https://api.github.com/repos/octocat/Hello-World/git/tags"
        )
    }
}
