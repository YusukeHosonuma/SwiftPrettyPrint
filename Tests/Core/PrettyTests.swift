//
//  PrettyTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/02/19.
//

@testable import SwiftPrettyPrint
import XCTest

class PrettyTests: XCTestCase {
    let pretty = Pretty(formatter: SinglelineFormatter())

    override func setUp() {}

    override func tearDown() {}

    ///
    /// Basic type
    ///
    func testString_BasicType() {
        //
        // String
        //

        XCTAssertEqual(pretty.string("Hello", debug: false), #""Hello""#)
        XCTAssertEqual(pretty.string("Hello", debug: true), #""Hello""#)

        //
        // Int
        //

        XCTAssertEqual(pretty.string(42, debug: false), "42")
        XCTAssertEqual(pretty.string(42, debug: true), "42")

        //
        // Optional.some
        //

        XCTAssertEqual(pretty.string(Optional.some("Hello"), debug: false), #""Hello""#)
        XCTAssertEqual(pretty.string(Optional.some("Hello"), debug: true), #"Optional("Hello")"#)

        //
        // Optional.none
        //

        XCTAssertEqual(pretty.string(nil as String?, debug: false), "nil")
        XCTAssertEqual(pretty.string(nil as String?, debug: true), "nil")

        //
        // URL
        //

        XCTAssertEqual(pretty.string(URL(string: "https://www.google.com/")!, debug: false),
                       "https://www.google.com/")
        XCTAssertEqual(pretty.string(URL(string: "https://www.google.com/")!, debug: true),
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

        XCTAssertEqual(pretty.string(owner, debug: false),
                       #"Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")"#)

        XCTAssertEqual(pretty.string(owner, debug: true),
                       #"Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss"))"#)

        //
        // Nested Struct
        //

        XCTAssertEqual(pretty.string(dog, debug: false),
                       #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#)

        XCTAssertEqual(pretty.string(dog, debug: true),
                       #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#)
    }

    ///
    /// Array
    ///
    func testString_Array() {
        let array: [String?] = ["Hello", "World"]

        XCTAssertEqual(pretty.string(array, debug: false),
                       #"["Hello", "World"]"#)

        XCTAssertEqual(pretty.string(array, debug: true),
                       #"[Optional("Hello"), Optional("World")]"#)

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

        XCTAssertEqual(pretty.string(dictionary, debug: false),
                       #"[1: "One", 2: "Two"]"#)

        XCTAssertEqual(pretty.string(dictionary, debug: true),
                       #"[1: Optional("One"), 2: Optional("Two")]"#)

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
                       #"["mike": Cat(id: "mike", name: "ポチ"), "tama": Cat(id: "tama", name: "タマ")]"#)

        XCTAssertEqual(pretty.string(dictionaryInStruct, debug: true),
                       #"["mike": Cat(id: "mike", name: Optional("ポチ")), "tama": Cat(id: "tama", name: Optional("タマ"))]"#)
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
