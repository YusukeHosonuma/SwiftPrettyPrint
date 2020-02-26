//
//  PrettyFormatterTests.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/26.
//

@testable import SwiftPrettyPrint
import XCTest

// TODO: This tests should organize because it is only moved from PrettyTests.

class PrettyFormatterTests: XCTestCase {
    let pretty = Pretty(formatter: PrettyFormatter(option: Debug.defaultOption))

    override func setUp() {}

    override func tearDown() {}

    func testObjectString() {
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

        let owner = Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")
        let dog = Dog(name: "Pochi", owner: owner, age: nil)

        //
        // Struct
        //

        XCTAssertEqual(pretty.string(owner, debug: false),
                       """
                       Owner(name: "Nanachi",
                             age: 20,
                             address: "4th layer in Abyss")
                       """)

        XCTAssertEqual(pretty.string(owner, debug: true),
                       """
                       Owner(name: "Nanachi",
                             age: 20,
                             address: Optional("4th layer in Abyss"))
                       """)

        //
        // Nested Struct
        //

        //
        // TODO: https://github.com/YusukeHosonuma/SwiftPrettyPrint/issues/25
        //
        // XCTAssertEqual(pretty.string(dog, debug: false, pretty: true),
        //                """
        //                Dog(name: "Pochi",
        //                    owner: Owner(name: "Nanachi",
        //                                 age: 20,
        //                                 address: "4th layer Abyss"),
        //                    age: 4)
        //                """)
    }

    func testArrayString() {
        let array: [String?] = ["Hello", "World"]

        XCTAssertEqual(pretty.string(array, debug: false),
                       """
                       [
                           "Hello",
                           "World"
                       ]
                       """)

        XCTAssertEqual(pretty.string(array, debug: true),
                       """
                       [
                           Optional("Hello"),
                           Optional("World")
                       ]
                       """)
    }

    func testDictionaryString() {
        let dictionary: [Int: String?] = [
            2: "Two",
            1: "One",
        ]

        XCTAssertEqual(pretty.string(dictionary, debug: false),
                       """
                       [
                           1: "One",
                           2: "Two"
                       ]
                       """)

        XCTAssertEqual(pretty.string(dictionary, debug: true),
                       """
                       [
                           1: Optional("One"),
                           2: Optional("Two")
                       ]
                       """)

        //
        // Dictionary in Struct
        //

        struct Cat {
            var id: String
            var name: String?
        }

        let dictionaryInStruct: [String: Cat] = [
            "mike": Cat(id: "mike", name: "ポチ"),
            "tama": Cat(id: "tama", name: "タマ"),
        ]

        XCTAssertEqual(pretty.string(dictionaryInStruct, debug: false),
                       """
                       [
                           "mike": Cat(id: "mike",
                                       name: "ポチ"),
                           "tama": Cat(id: "tama",
                                       name: "タマ")
                       ]
                       """)

        XCTAssertEqual(pretty.string(dictionaryInStruct, debug: true),
                       """
                       [
                           "mike": Cat(id: "mike",
                                       name: Optional("ポチ")),
                           "tama": Cat(id: "tama",
                                       name: Optional("タマ"))
                       ]
                       """)
    }
}
