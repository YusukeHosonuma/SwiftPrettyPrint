// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPrettyPrint",
    products: [
        .library(name: "SwiftPrettyPrint", targets: ["SwiftPrettyPrint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/SwiftParamTest.git", from: "1.1.0"),
    ],
    targets: [
        .target(name: "SwiftPrettyPrint", dependencies: [], path: "Sources"),
        .testTarget(name: "SwiftPrettyPrintTests", dependencies: ["SwiftPrettyPrint", "SwiftParamTest"], path: "Tests"),
    ]
)
