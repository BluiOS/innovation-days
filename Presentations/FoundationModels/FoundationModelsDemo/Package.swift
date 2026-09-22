// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "FoundationModelsDemo",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "FoundationModelsDemo",
            targets: ["FoundationModelsDemo"]
        )
    ],
    targets: [
        .target(name: "FoundationModelsDemo")
    ]
)
