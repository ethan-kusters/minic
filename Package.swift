// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "minic",
    products: [
        .executable(name: "minic", targets: ["minic"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1"),
        .package(path: "./Antlr4"),
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.5.0"),
        .package(url: "https://github.com/eneko/System.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "minic",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Antlr4", package: "Antlr4"),
                .product(name: "ColorizeSwift", package: "ColorizeSwift")
        ]),
        .testTarget(
            name: "MiniCompilerTests",
            dependencies: ["minic", "System"]),
    ]
)
