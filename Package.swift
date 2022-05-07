// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "today-rewards",
    platforms: [
        .macOS(.v12),
    ],
    dependencies: [
        .package(url: "https://github.com/hewigovens/enum-http", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "today-rewards",
            dependencies: [
                .productItem(name: "EnumHttp", package: "enum-http", condition: nil)
            ]
        ),
        .testTarget(
            name: "today-rewardsTests",
            dependencies: ["today-rewards"]
        ),
    ]
)
