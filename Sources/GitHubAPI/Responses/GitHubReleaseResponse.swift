import Foundation

public struct GitHubReleaseResponse: Decodable {
    public let tagName: String
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
    }
}
