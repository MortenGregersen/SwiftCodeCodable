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
		.package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50000.0")),
		.package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "SwiftCodeCodable",
            dependencies: ["SwiftSyntax"]),
        .testTarget(
            name: "SwiftCodeCodableTests",
            dependencies: ["SwiftCodeCodable", "SwiftPM"]),
    ]
)
