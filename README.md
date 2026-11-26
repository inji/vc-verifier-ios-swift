# vc-verifier-ios-swift

Swift library to validate and verify Verifiable Credentials. It is the iOS counterpart of the Kotlin [vc-verifier](https://github.com/inji/vc-verifier) and exposes the same API shape.

> **Status:** initial setup. Only the package and folder structure are in place; no verification logic is implemented yet.

## Requirements

- iOS 15+
- Swift 6.0+ (Xcode 16+)

## Installation

Add the package with Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/inji/vc-verifier-ios-swift", branch: "develop")
]
```

Then add the `VCVerifier` product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "VCVerifier", package: "vc-verifier-ios-swift")
    ]
)
```

## Project structure

```
Sources/VCVerifier/
├── Constants/            credential formats, error codes
├── CredentialVerifier/   per-format validators and verifiers
├── Data/                 result and status models
├── Exception/            error types
├── KeyResolver/          public key resolution (did, http, jwks)
├── NetworkManager/       network client
├── Proof/                data integrity / LD proof verification
├── Signature/            signature verifiers per algorithm
└── Utils/                shared helpers
Tests/VCVerifierTests/
```

## Build and test

```sh
xcodebuild -scheme VCVerifier -destination 'generic/platform=iOS' build
xcodebuild test -scheme VCVerifier -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Formatting

Code is formatted with [swift-format](https://github.com/swiftlang/swift-format), which ships with Xcode 16 and later. The rules are in `.swift-format`.

```sh
swift format -i -r Sources Tests          # format in place
swift format lint --strict -r Sources Tests   # check only
```

In Xcode, **Editor ▸ Structure ▸ Format File with 'swift-format'** (⌃⇧I) formats the current file.

## License

[Apache License 2.0](LICENSE)
