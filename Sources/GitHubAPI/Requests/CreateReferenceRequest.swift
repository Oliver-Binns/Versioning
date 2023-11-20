import Foundation

struct CreateReferenceRequest: Encodable {
    let ref: String
    let sha: String
}
