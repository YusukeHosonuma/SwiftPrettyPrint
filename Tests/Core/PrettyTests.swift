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
        assert(to: curry(pretty.string)("Hello")) {
            args(false, expect: #""Hello""#)
            args(true,  expect: #""Hello""#)
        }

        // Int
        assert(to: curry(pretty.string)(42)) {
            args(false, expect: "42")
            args(true,  expect: "42")
        }

        // Optional.some
            assert(to: curry(pretty.string)(Optional.some("Hello"))) {
            args(false, expect: #""Hello""#)
            args(true, expect: #"Optional("Hello")"#)
        }

        // Optional.none
        assert(to: curry(pretty.string)(nil as String?)) {
            args(false, expect: "nil")
            args(true,  expect: "nil")
        }
        
        // URL
        assert(to: curry(pretty.string)(URL(string: "https://www.google.com/")!)) {
            args(false, expect: "https://www.google.com/")
            args(true,  expect: #"URL("https://www.google.com/")"#)
        }
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
        assert(to: curry(pretty.string)(owner)) {
            args(false, expect: #"Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")"#)
            args(true,  expect: #"Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss"))"#)
        }
        
        // nested struct
        assert(to: curry(pretty.string)(dog)) {
            args(false, expect: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#)
            args(true,  expect: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#)
        }
    }

    ///
    /// Array
    ///
    func testString_Array() {
        let array: [String?] = ["Hello", "World"]
        
        assert(to: curry(pretty.string)(array)) {
            args(false, expect: #"["Hello", "World"]"#)
            args(true,  expect: #"[Optional("Hello"), Optional("World")]"#)
        }

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
        assert(to: curry(pretty.string)(dictionary)) {
            args(false, expect: #"[1: "One", 2: "Two"]"#)
            args(true,  expect: #"[1: Optional("One"), 2: Optional("Two")]"#)
        }


        struct Cat {
            var id: String
            var name: String?
        }

        let dictionaryInStruct: [String: Cat] = [
            "mike": Cat(id: "mike", name: "ポチ"),
            "tama": Cat(id: "tama", name: "タマ"),
        ]

        // Dictionary in Struct
        assert(to: curry(pretty.string)(dictionaryInStruct)) {
            args(false, expect: #"["mike": Cat(id: "mike", name: "ポチ"), "tama": Cat(id: "tama", name: "タマ")]"#)
            args(true,  expect: #"["mike": Cat(id: "mike", name: Optional("ポチ")), "tama": Cat(id: "tama", name: Optional("タマ"))]"#)
        }
    }
    
    ///
    /// Tuple
    ///
    func testString_Tuple() {
        let tuple = (1, ("one", URL(string: "https://www.example.com/")!))
        
        assert(to: curry(pretty.string)(tuple)) {
            args(false, expect: #"(1, ("one", https://www.example.com/))"#)
            args(true,  expect: #"(1, ("one", URL("https://www.example.com/")))"#)
        }
        
        let labeledTuple = (2019, region: "Chili", variety: Optional("Chardonnay"), taste: ["round", "smooth", "young"])

        assert(to: curry(pretty.string)(labeledTuple)) {
            args(false, expect: #"(2019, region: "Chili", variety: "Chardonnay", taste: ["round", "smooth", "young"])"#)
            args(true,  expect: #"(2019, region: "Chili", variety: Optional("Chardonnay"), taste: ["round", "smooth", "young"])"#)
        }
    }
    
    ///
    /// enum
    ///
    func testString_enum() {
        // simple enum
        do {
            enum Fruit {
                case apple
            }
            
            assert(to: curry(pretty.string)(Fruit.apple)) {
                args(false, expect: ".apple")
                args(true,  expect: "Fruit.apple")
            }
        }
        
        // has raw-value
        do {
            enum Fruit: Int {
                case apple  = 0
            }
            
            assert(to: curry(pretty.string)(Fruit.apple)) {
                args(false, expect: ".apple")
                args(true,  expect: "Fruit.apple")
            }
        }
        
        // has associated-value (with no label)
        do {
            enum Fruit {
                case apple(String)       // has one
                case orange(String, Int) // has many
                case banana(juicy: Bool) // with label
            }

            assert(to: pretty.string) {
                // has one
                args((Fruit.apple("りんご"),      false), expect: #".apple("りんご")"#)
                args((Fruit.apple("りんご"),      true),  expect: #"Fruit.apple("りんご")"#)

                // has many (representation as a tuple)
                args((Fruit.orange("みかん", 42), false), expect: #".orange("みかん", 42)"#)
                args((Fruit.orange("みかん", 42), true),  expect: #"Fruit.orange("みかん", 42)"#)
                
                // with label (representation as a tuple)
                args((Fruit.banana(juicy: true), false), expect: #".banana(juicy: true)"#)
                args((Fruit.banana(juicy: true), true),  expect: #"Fruit.banana(juicy: true)"#)
            }
        }
        
        // nested-enum
        do {
            enum Level {
                case high
                case low
            }
            
            enum Taste {
                case sweet
                case sour(Level)
            }
            
            enum Fruit {
                case apple(Taste)
                case orange(taste: Taste)
            }

            assert(to: pretty.string) {
                // nested one
                args((Fruit.apple(.sweet),              false), expect: ".apple(.sweet)")
                args((Fruit.apple(.sweet),              true),  expect: "Fruit.apple(Taste.sweet)")
                
                // nested two
                args((Fruit.apple(.sour(.high)),        false), expect: ".apple(.sour(.high))")
                args((Fruit.apple(.sour(.high)),        true),  expect: "Fruit.apple(Taste.sour(Level.high))")

                // nested two with label
                args((Fruit.orange(taste: .sour(.low)), false), expect: ".orange(taste: .sour(.low))")
                args((Fruit.orange(taste: .sour(.low)), true),  expect: "Fruit.orange(taste: Taste.sour(Level.low))")
            }
        }
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
