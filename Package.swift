// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPrettyPrint",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_12),
        .watchOS(.v3),
        .tvOS(.v10),
    ],
    products: [
        .library(name: "SwiftPrettyPrint", targets: ["SwiftPrettyPrint"]),
    ],
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/SwiftParamTest.git", from: "2.2.1"),
        .package(url: "https://github.com/thoughtbot/Curry.git", from: "4.0.2"),
        .package(url: "https://github.com/mtynior/ColorizeSwift.git", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "SwiftPrettyPrint",
            dependencies: ["ColorizeSwift"],
            path: "Sources",
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "SwiftPrettyPrintTests",
            dependencies: ["SwiftPrettyPrint", "SwiftParamTest", "Curry"]
        ),
    ]
)
