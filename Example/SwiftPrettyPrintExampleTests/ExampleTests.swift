//
// ExampleTests.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import SwiftPrettyPrint
@testable import SwiftPrettyPrintExample
import XCTest

enum License {
    case mit
    case other(String)
}

struct Developer {
    var name: String
    var twitterID: String
}

struct Software {
    var name: String
    var description: String?
    var website: URL?
    var repository: URL?
    var packageManagerSupport: (cocoaPods: Bool, carthage: Bool, swiftPackageManager: Bool)
    var developers: [String: Developer]
    var license: License
}

class SwiftPrettyPrintExampleTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testReadmeExample() {
        let swiftPrettyPrint = Software(
            name: "SwiftPrettyPrint",
            description: "Pretty print for Swift.",
            website: nil,
            repository: URL(string: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git"),
            packageManagerSupport: (cocoaPods: true, carthage: true, swiftPackageManager: true),
            developers: [
                "YusukeHosonuma": Developer(name: "Yusuke Hosonuma", twitterID: "tobi462"),
                "sahara-ooga": Developer(name: "sahara-ooga", twitterID: "it_the_hayh"),
                "po-miyasaka": Developer(name: "Kazutoshi Miyasaka", twitterID: "po_miyasaka"),
            ],
            license: .mit
        )

        pp >>> swiftPrettyPrint
    }

    func testExample() {}
}
