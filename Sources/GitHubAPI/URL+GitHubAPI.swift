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
    
    static func listReleases(repository: String) -> URL {
        var components = URLComponents(url: releases(repository: repository),
                                       resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "per_page", value: "100")]
        return components.url!
    }
    
    static func references(repository: String) -> URL {
        self.repository(repository: repository)
            .appending(components: "git", "refs")
    }
    
    static func compare(repository: String,
                        base: String, head: String) -> URL {
        self.repository(repository: repository)
            .appending(components: "compare", "\(base)...\(head)")
    
    }
}
