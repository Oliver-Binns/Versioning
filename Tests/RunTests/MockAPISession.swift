@testable import Run
import GitHubAPI

final class MockAPISession: APISession {
    var previousReleaseExists: Bool = false
    var useMultiCommit: Bool = false
    var didCallCompare: (String, String)?
    
    var didCallCreateReference: (String, String)?
    var didCallCreateRelease: String?
    
    func latestRelease() async throws -> String {
        if previousReleaseExists {
            return "1.0.0"
        }
        throw GitHubAPIError.notFound
    }
    
    func compare(base: String, head: String) async throws -> [String] {
        didCallCompare = (base, head)
        
        var listOfCommit =  [
            "chore: implement pipelines for Cards",
            "chore: fix Fastlane deployment",
            "chore: fixed warnings in latest version of Xcode",
            "fix: game state is reset when pushing a new SoloGame view",
            "chore: split single Swift Package target into six",
            "feat: Added first-class macOS support rather than using Catalyst",
            "feat: use button rather than tap recogniser",
            "fix: fixed compilation issues on Linux"
        ]
        
        if useMultiCommit {
            listOfCommit.insert("""
feat: implement pipelines for Cards
* fix: implement pipelines for Cards
* chore: fix Fastlane deployment
""", at: 0)
        }
        
        return listOfCommit
    }
    
    func createReference(version: String, sha: String) async throws {
        didCallCreateReference = (version, sha)
    }
    
    func createRelease(version: String) async throws {
        didCallCreateRelease = version
    }
    
    
}
