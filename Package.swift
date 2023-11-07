// swift-tools-version: 5.9
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
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.3")),
        .package(url: "https://github.com/realm/swiftlint.git", .upToNextMinor(from: "0.53.0"))
    ],
    targets: [
        .executableTarget(name: "Run", dependencies: [
            "Versioning",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),

        .target(name: "Versioning", plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(name: "VersioningTests", dependencies: ["Versioning"])
    ]
)
