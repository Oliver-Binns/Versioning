import Foundation

struct CreateReleaseRequest: Encodable {
    let name: String
    let tagName: String
    let draft: Bool
    let prerelease: Bool
    let generateReleaseNotes: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case tagName = "tag_name"
        case draft
        case prerelease
        case generateReleaseNotes = "generate_release_notes"
    }
}
