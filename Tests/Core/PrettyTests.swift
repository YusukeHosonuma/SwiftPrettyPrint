//
//  PrettyTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/02/19.
//

@testable import SwiftPrettyPrint
import XCTest

class PrettyTests: XCTestCase {
    let pretty = Pretty(option: Debug.defaultOption)

    override func setUp() {}

    override func tearDown() {}

    ///
    /// Basic type
    ///
    func testString_BasicType() {
        //
        // String
        //

        XCTAssertEqual(pretty.string("Hello", debug: false, pretty: false), #""Hello""#)
        XCTAssertEqual(pretty.string("Hello", debug: true, pretty: false), #""Hello""#)
        XCTAssertEqual(pretty.string("Hello", debug: false, pretty: true), #""Hello""#)
        XCTAssertEqual(pretty.string("Hello", debug: true, pretty: true), #""Hello""#)

        //
        // Int
        //

        XCTAssertEqual(pretty.string(42, debug: false, pretty: false), "42")
        XCTAssertEqual(pretty.string(42, debug: true, pretty: false), "42")
        XCTAssertEqual(pretty.string(42, debug: false, pretty: true), "42")
        XCTAssertEqual(pretty.string(42, debug: true, pretty: true), "42")

        //
        // Optional.some
        //

        XCTAssertEqual(pretty.string(Optional.some("Hello"), debug: false, pretty: false), #""Hello""#)
        XCTAssertEqual(pretty.string(Optional.some("Hello"), debug: true, pretty: false), #"Optional("Hello")"#)
        XCTAssertEqual(pretty.string(Optional.some("Hello"), debug: false, pretty: true), #""Hello""#)
        XCTAssertEqual(pretty.string(Optional.some("Hello"), debug: true, pretty: true), #"Optional("Hello")"#)

        //
        // Optional.none
        //

        XCTAssertEqual(pretty.string(nil as String?, debug: false, pretty: false), "nil")
        XCTAssertEqual(pretty.string(nil as String?, debug: true, pretty: false), "nil")
        XCTAssertEqual(pretty.string(nil as String?, debug: false, pretty: true), "nil")
        XCTAssertEqual(pretty.string(nil as String?, debug: true, pretty: true), "nil")

        //
        // URL
        //

        XCTAssertEqual(pretty.string(URL(string: "https://www.google.com/")!, debug: false, pretty: false),
                       "https://www.google.com/")
        XCTAssertEqual(pretty.string(URL(string: "https://www.google.com/")!, debug: true, pretty: false),
                       #"URL("https://www.google.com/")"#)

        // TODO: add test pattern
    }

    ///
    /// Struct
    ///
    func testString_Struct() {
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

        XCTAssertEqual(pretty.string(owner, debug: false, pretty: false),
                       #"Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")"#)

        XCTAssertEqual(pretty.string(owner, debug: true, pretty: false),
                       #"Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss"))"#)

        XCTAssertEqual(pretty.string(owner, debug: false, pretty: true),
                       """
                       Owner(name: "Nanachi",
                             age: 20,
                             address: "4th layer in Abyss")
                       """)

        XCTAssertEqual(pretty.string(owner, debug: true, pretty: true),
                       """
                       Owner(name: "Nanachi",
                             age: 20,
                             address: Optional("4th layer in Abyss"))
                       """)

        //
        // Nested Struct
        //

        XCTAssertEqual(pretty.string(dog, debug: false, pretty: false),
                       #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#)

        XCTAssertEqual(pretty.string(dog, debug: true, pretty: false),
                       #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#)

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

    ///
    /// Array
    ///
    func testString_Array() {
        let array: [String?] = ["Hello", "World"]

        XCTAssertEqual(pretty.string(array, debug: false, pretty: false),
                       #"["Hello", "World"]"#)

        XCTAssertEqual(pretty.string(array, debug: true, pretty: false),
                       #"[Optional("Hello"), Optional("World")]"#)

        XCTAssertEqual(pretty.string(array, debug: false, pretty: true),
                       """
                       [
                           "Hello",
                           "World"
                       ]
                       """)

        XCTAssertEqual(pretty.string(array, debug: true, pretty: true),
                       """
                       [
                           Optional("Hello"),
                           Optional("World")
                       ]
                       """)

        // TODO: add tests for nested Array
    }

    ///
    /// Dictionary
    ///
    func testString_Dictionary() {
        let dictionary: [Int: String?] = [
            2: "Two",
            1: "One",
        ]

        XCTAssertEqual(pretty.string(dictionary, debug: false, pretty: false),
                       #"[1: "One", 2: "Two"]"#)

        XCTAssertEqual(pretty.string(dictionary, debug: true, pretty: false),
                       #"[1: Optional("One"), 2: Optional("Two")]"#)

        XCTAssertEqual(pretty.string(dictionary, debug: false, pretty: true),
                       """
                       [
                           1: "One",
                           2: "Two"
                       ]
                       """)

        XCTAssertEqual(pretty.string(dictionary, debug: true, pretty: true),
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

        XCTAssertEqual(pretty.string(dictionaryInStruct, debug: false, pretty: false),
                       #"["mike": Cat(id: "mike", name: "ポチ"), "tama": Cat(id: "tama", name: "タマ")]"#)

        XCTAssertEqual(pretty.string(dictionaryInStruct, debug: true, pretty: false),
                       #"["mike": Cat(id: "mike", name: Optional("ポチ")), "tama": Cat(id: "tama", name: Optional("タマ"))]"#)

        XCTAssertEqual(pretty.string(dictionaryInStruct, debug: false, pretty: true),
                       """
                       [
                           "mike": Cat(id: "mike",
                                       name: "ポチ"),
                           "tama": Cat(id: "tama",
                                       name: "タマ")
                       ]
                       """)

        XCTAssertEqual(pretty.string(dictionaryInStruct, debug: true, pretty: true),
                       """
                       [
                           "mike": Cat(id: "mike",
                                       name: Optional("ポチ")),
                           "tama": Cat(id: "tama",
                                       name: Optional("タマ"))
                       ]
                       """)
    }

    func testExtractKeyValues() throws {
        let dictionary: [String: Int] = [
            "One": 1,
            "Two": 2,
        ]

        let result = try pretty.extractKeyValues(from: dictionary) as? [(String, Int)]

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
