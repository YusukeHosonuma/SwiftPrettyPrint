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
import Curry

class PrettyTests: XCTestCase {
    let pretty = Pretty(formatter: SinglelineFormatter())

    override func setUp() {}

    override func tearDown() {}

    ///
    /// Basic type
    ///
    func testString_BasicType() {
        
        // String
        assert(to: curry(pretty.string)("Hello")).expect([
            when(false, then: #""Hello""#),
            when(true,  then: #""Hello""#),
        ])

        // Int
        assert(to: curry(pretty.string)(42)).expect([
            when(false, then: "42"),
            when(true,  then: "42"),
        ])

        // Optional.some
        assert(to: curry(pretty.string)(Optional.some("Hello"))).expect([
            when(false, then: #""Hello""#),
            when(true, then: #"Optional("Hello")"#),
        ])

        // Optional.none
        assert(to: curry(pretty.string)(nil as String?)).expect([
            when(false, then: "nil"),
            when(true,  then: "nil"),
        ])
        
        // URL
        assert(to: curry(pretty.string)(URL(string: "https://www.google.com/")!)).expect([
            when(false, then: "https://www.google.com/"),
            when(true,  then: #"URL("https://www.google.com/")"#),
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
        assert(to: curry(pretty.string)(owner)).expect([
            when(false, then: #"Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")"#),
            when(true,  then: #"Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss"))"#),
        ])
        
        // nested struct
        assert(to: curry(pretty.string)(dog)).expect([
            when(false, then: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#),
            when(true,  then: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#),
        ])
    }

    ///
    /// Array
    ///
    func testString_Array() {
        let array: [String?] = ["Hello", "World"]
        
        assert(to: curry(pretty.string)(array)).expect([
            when(false, then: #"["Hello", "World"]"#),
            when(true,  then: #"[Optional("Hello"), Optional("World")]"#),
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
        assert(to: curry(pretty.string)(dictionary)).expect([
            when(false, then: #"[1: "One", 2: "Two"]"#),
            when(true,  then: #"[1: Optional("One"), 2: Optional("Two")]"#),
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
        assert(to: curry(pretty.string)(dictionaryInStruct)).expect([
            when(false, then: #"["mike": Cat(id: "mike", name: "ポチ"), "tama": Cat(id: "tama", name: "タマ")]"#),
            when(true,  then: #"["mike": Cat(id: "mike", name: Optional("ポチ")), "tama": Cat(id: "tama", name: Optional("タマ"))]"#),
        ])
    }
    
    ///
    /// Tuple
    ///
    func testString_Tuple() {
        let tuple = (1, ("one", URL(string: "https://www.example.com/")!))
        assert(to:
            curry(pretty.string)(tuple))
            .expect([
                when(false, then: #"(1, ("one", https://www.example.com/))"#),
                when(true, then: #"(1, ("one", URL("https://www.example.com/")))"#),
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
