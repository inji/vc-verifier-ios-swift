// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "vcverifier",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "vcverifier",
            targets: ["vcverifier"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/1024jp/GzipSwift.git",
            from: "5.2.0"
        )
    ],
    targets: [
        .target(
            name: "vcverifier",
            dependencies: [
                .product(name: "Gzip", package: "GzipSwift")
            ]
        ),
        .testTarget(
            name: "vcverifierTests",
            dependencies: ["vcverifier"],
            resources: [
                .process("Resources")
                ]
        )
    ]
)
