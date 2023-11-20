import Foundation

public struct GitHubRelease: Decodable {
    public let tagName: String
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
    }
}
