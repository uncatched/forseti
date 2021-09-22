// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "forseti",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .executable(name: "forseti", targets: ["forseti"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(url: "https://github.com/industrialbinaries/CupertinoJWT", from: "0.2.2")
    ],
    targets: [
        .target(
            name: "forseti",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "CupertinoJWT", package: "CupertinoJWT")
            ]),
        .testTarget(
            name: "forsetiTests",
            dependencies: ["forseti"]),
    ]
)
