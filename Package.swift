// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPrettyPrint",
    products: [
        .library(name: "SwiftPrettyPrint", targets: ["SwiftPrettyPrint"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "SwiftPrettyPrint", dependencies: [], path: "Sources"),
        .testTarget(name: "SwiftPrettyPrintTests", dependencies: ["SwiftPrettyPrint"], path: "Tests"),
    ]
)
