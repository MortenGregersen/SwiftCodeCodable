// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftCodeCodable",
    products: [
        .library(
            name: "SwiftCodeCodable",
            targets: ["SwiftCodeCodable"]),
    ],
    dependencies: [
		.package(url: "https://github.com/jpsim/SourceKitten", from: "0.23.0"),
    ],
    targets: [
        .target(
            name: "SwiftCodeCodable",
            dependencies: ["SourceKittenFramework"]),
        .testTarget(
            name: "SwiftCodeCodableTests",
            dependencies: ["SwiftCodeCodable"]),
    ]
)
