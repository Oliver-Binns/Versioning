import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URL {
    private static var repositories: URL {
        URL(string: "https://api.github.com/repos/")!
    }
    
    private static func repository(repository: String) -> URL {
        repositories
            .appending(path: repository)
    }
    
    static func releases(repository: String) -> URL {
        self.repository(repository: repository)
            .appending(component: "releases")
    }
    
    static func latestRelease(repository: String) ->  URL {
        releases(repository: repository)
            .appending(component: "latest")
    }
    
    static func tags(repository: String) -> URL {
        self.repository(repository: repository)
            .appending(components: "git", "tags")
    }
    
    static func commits(repository: String) -> URL {
        self.repository(repository: repository)
            .appending(component: "commits")
    }
}
