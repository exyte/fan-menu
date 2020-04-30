// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FanMenu",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "FanMenu",
            targets: ["FanMenu"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/exyte/Macaw",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "FanMenu",
            dependencies: ["Macaw"],
            path: "Sources"
        )
    ],
    swiftLanguageVersions: [.v5]
)
