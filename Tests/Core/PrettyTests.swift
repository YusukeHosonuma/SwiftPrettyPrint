//
// PrettyTests.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

@testable import SwiftPrettyPrint
import XCTest
import SwiftParamTest

class PrettyTests: XCTestCase {
    let pretty = Pretty(formatter: SinglelineFormatter())

    override func setUp() {}

    override func tearDown() {}

    ///
    /// Basic type
    ///
    func testString_BasicType() {
        
        // String
        assert(to: pretty.string).expect([
            when(("Hello", false), then: #""Hello""#),
            when(("Hello", true),  then: #""Hello""#),
        ])

        // Int
        assert(to: pretty.string).expect([
            when((42, false), then: "42"),
            when((42, true),  then: "42"),
        ])

        // Optional.some
        assert(to: pretty.string).expect([
            when((Optional.some("Hello"), false), then: #""Hello""#),
            when((Optional.some("Hello"), true),  then: #"Optional("Hello")"#),
        ])

        // Optional.none
        assert(to: pretty.string).expect([
            when((nil as String?, false), then: "nil"),
            when((nil as String?, true),  then: "nil"),
        ])
        
        // URL
        assert(to: pretty.string).expect([
            when((URL(string: "https://www.google.com/")!, false), then: "https://www.google.com/"),
            when((URL(string: "https://www.google.com/")!, true),  then: #"URL("https://www.google.com/")"#),
        ])
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

        // struct
        assert(to: pretty.string).expect([
            when((owner, false), then: #"Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")"#),
            when((owner, true),  then: #"Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss"))"#),
        ])
        
        // nested struct
        assert(to: pretty.string).expect([
            when((dog, false), then: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#),
            when((dog, true),  then: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#),
        ])
    }

    ///
    /// Array
    ///
    func testString_Array() {
        let array: [String?] = ["Hello", "World"]
        
        assert(to: pretty.string).expect([
            when((array, false), then: #"["Hello", "World"]"#),
            when((array, true),  then: #"[Optional("Hello"), Optional("World")]"#),
        ])

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

        // Dictinary
        assert(to: pretty.string).expect([
            when((dictionary, false), then: #"[1: "One", 2: "Two"]"#),
            when((dictionary, true),  then: #"[1: Optional("One"), 2: Optional("Two")]"#),
        ])


        struct Cat {
            var id: String
            var name: String?
        }

        let dictionaryInStruct: [String: Cat] = [
            "mike": Cat(id: "mike", name: "ポチ"),
            "tama": Cat(id: "tama", name: "タマ"),
        ]

        // Dictionary in Struct
        assert(to: pretty.string).expect([
            when((dictionaryInStruct, false), then: #"["mike": Cat(id: "mike", name: "ポチ"), "tama": Cat(id: "tama", name: "タマ")]"#),
            when((dictionaryInStruct, true),  then: #"["mike": Cat(id: "mike", name: Optional("ポチ")), "tama": Cat(id: "tama", name: Optional("タマ"))]"#),
        ])
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
