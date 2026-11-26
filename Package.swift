// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "VCVerifier",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "VCVerifier",
            targets: ["VCVerifier"]),
    ],
    targets: [
        .target(
            name: "VCVerifier"
        ),
        .testTarget(
            name: "VCVerifierTests",
            dependencies: ["VCVerifier"]
        )
    ]
)
