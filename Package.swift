// swift-tools-version: 5.8.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Versioning",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.3"))
    ],
    targets: [
        .executableTarget(name: "Run", dependencies: [
            "Versioning",
            "GitHubAPI",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        
        .target(name: "Versioning"),
        .testTarget(name: "VersioningTests", dependencies: ["Versioning"]),
        
        .target(name: "GitHubAPI"),
        .testTarget(name: "GitHubAPITests",
                    dependencies: ["GitHubAPI"],
                    resources: [.process("Responses")])
    ]
)
