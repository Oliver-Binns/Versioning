import Foundation

struct GitHubCompareResponse: Decodable {
    let commits: [GitHubCommitDetails]
}

struct GitHubCommitDetails: Decodable {
    let commit: GitHubCommit
    let url: URL
}

struct GitHubCommit: Decodable {
    let message: String
}
