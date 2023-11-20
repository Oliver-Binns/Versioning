import Foundation

public struct GitHubCompareResponse: Decodable {
    let commits: [GitHubCommitDetails]
}

public struct GitHubCommitDetails: Decodable {
    let commit: GitHubCommit
    let url: URL
}

public struct GitHubCommit: Decodable {
    let message: String
}
