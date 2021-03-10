// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "today-rewards",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "today-rewards",
            dependencies: []),
        .testTarget(
            name: "today-rewardsTests",
            dependencies: ["today-rewards"]),
    ]
)
