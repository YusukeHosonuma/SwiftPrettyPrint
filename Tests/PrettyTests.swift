//
//  PrettyTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/02/19.
//

@testable import SwiftPrettyPrint
import XCTest

class PrettyTests: XCTestCase {
    let pretty = Pretty()

    override func setUp() {}

    override func tearDown() {}

    func test_elementString_struct_in_struct() {
        struct Dog {
            var name: String
            var owner: Owner
            var age: Int?
        }

        struct Owner {
            var name: String
            var age: Int
            var address: String?
        }

        //
        // struct in struct
        //

        let owner = Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")
        let dog = Dog(name: "Pochi", owner: owner, age: nil)

        XCTAssertEqual(pretty.elementString(dog, debug: false, pretty: false),
                       #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#)

        XCTAssertEqual(pretty.elementString(dog, debug: true, pretty: false),
                       #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#)

        //
        // TODO: https://github.com/YusukeHosonuma/SwiftPrettyPrint/issues/25
        //
        // XCTAssertEqual(elementString(dog, debug: false, pretty: true),
        //                """
        //                Dog(name: "Pochi",
        //                    owner: Owner(name: "Nanachi",
        //                                 age: 20,
        //                                 address: "4th layer Abyss"),
        //                    age: 4)
        //                """)
    }

    func test_extractKeyValues() throws {
        let dictionary: [String: Int] = [
            "One": 1,
            "Two": 2,
        ]

        let result = pretty.extractKeyValues(from: dictionary) as? [(String, Int)]

        // Note:
        // XCTUnwrap is not supported Swift Package Manager currently.
        var actual = result!
        // var actual = try XCTUnwrap(result)

        actual = actual.sorted { $0.1 < $1.1 } // sorted by value

        XCTAssertEqual(actual.count, 2)
        XCTAssertEqual(actual[0].0, "One")
        XCTAssertEqual(actual[0].1, 1)
        XCTAssertEqual(actual[1].0, "Two")
        XCTAssertEqual(actual[1].1, 2)
    }
}
