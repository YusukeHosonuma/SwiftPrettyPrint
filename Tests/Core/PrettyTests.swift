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
        assert(to: pretty.string) {
            args(("Hello", false), expect: #""Hello""#)
            args(("Hello", true),  expect: #""Hello""#)
        }

        // Int
        assert(to: pretty.string) {
            args((42, false), expect: "42")
            args((42, true),  expect: "42")
        }

        // Optional
        assert(to: pretty.string) {
            // .some
            args(("Hello" as String?, false), expect: #""Hello""#)
            args(("Hello" as String?, true),  expect: #"Optional("Hello")"#)
            
            // .none
            args((nil as String?, false), expect: "nil")
            args((nil as String?, true),  expect: "nil")
        }
        
        // URL
        let url = URL(string: "https://www.google.com/")!
        assert(to: pretty.string) {
            args((url, false), expect: "https://www.google.com/")
            args((url, true),  expect: #"URL("https://www.google.com/")"#)
        }
    }

    ///
    /// Struct
    ///
    func testString_Struct() {
        
        struct Owner {
            var name: String
            var age: Int
            var address: String?
        }

        struct Dog {
            var name: String
            var owner: Owner
            var age: Int?
        }

        let owner = Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")
        let dog = Dog(name: "Pochi", owner: owner, age: nil)

        // single
        assert(to: pretty.string) {
            args((owner, false), expect: #"Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")"#)
            args((owner, true),  expect: #"Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss"))"#)
        }
        
        // nested
        assert(to: pretty.string) {
            args((dog, false), expect: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#)
            args((dog, true),  expect: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#)
        }
    }

    ///
    /// Class
    ///
    func testString_Class() {
        
        // Note:
        // data structure and expected behavior is same to Struct.
        
        class Owner {
            var name: String
            var age: Int
            var address: String?
            init(name: String, age: Int, address: String?) {
                self.name = name
                self.age = age
                self.address = address
            }
        }
        
        class Dog {
            var name: String
            var owner: Owner
            var age: Int?
            init(name: String, owner: Owner, age: Int?) {
                self.name = name
                self.owner = owner
                self.age = age
            }
        }

        let owner = Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")
        let dog = Dog(name: "Pochi", owner: owner, age: nil)
        
        // single
        assert(to: pretty.string) {
            args((owner, false), expect: #"Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")"#)
            args((owner, true),  expect: #"Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss"))"#)
        }
        
        // nested
        assert(to: pretty.string) {
            args((dog, false), expect: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: nil)"#)
            args((dog, true),  expect: #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: Optional("4th layer in Abyss")), age: nil)"#)
        }
    }

    ///
    /// Set
    ///
    func testString_Set() {
        let set: Set<Int?> = [7, 42]

        // Note:
        // sorted by string ascending
        assert(to: pretty.string) {
            args((set, false), expect: #"[42, 7]"#)
            args((set, true),  expect: #"Set([Optional(42), Optional(7)])"#)
        }
    }
    
    ///
    /// Collection
    ///
    func testString_Collection() {
        let array: [Int?] = [7, 42]
        
        // Note:
        // not sorted unlike `Set`
        assert(to: pretty.string) {
            args((array, false), expect: #"[7, 42]"#)
            args((array, true),  expect: #"[Optional(7), Optional(42)]"#)
        }
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
        assert(to: pretty.string) {
            args((dictionary, false), expect: #"[1: "One", 2: "Two"]"#)
            args((dictionary, true),  expect: #"[1: Optional("One"), 2: Optional("Two")]"#)
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
        assert(to: pretty.string) {
            args((dictionaryInStruct, false), expect: #"["mike": Cat(id: "mike", name: "ポチ"), "tama": Cat(id: "tama", name: "タマ")]"#)
            args((dictionaryInStruct, true),  expect: #"["mike": Cat(id: "mike", name: Optional("ポチ")), "tama": Cat(id: "tama", name: Optional("タマ"))]"#)
        }
    }
    
    ///
    /// Tuple
    ///
    func testString_Tuple() {
        let tuple = (1, ("one", URL(string: "https://www.example.com/")!))
        
        assert(to: pretty.string) {
            args((tuple, false), expect: #"(1, ("one", https://www.example.com/))"#)
            args((tuple, true),  expect: #"(1, ("one", URL("https://www.example.com/")))"#)
        }
        
        let labeledTuple = (2019, region: "Chili", variety: Optional("Chardonnay"), taste: ["round", "smooth", "young"])

        assert(to: pretty.string) {
            args((labeledTuple, false), expect: #"(2019, region: "Chili", variety: "Chardonnay", taste: ["round", "smooth", "young"])"#)
            args((labeledTuple, true),  expect: #"(2019, region: "Chili", variety: Optional("Chardonnay"), taste: ["round", "smooth", "young"])"#)
        }
    }
    
    ///
    /// Enum
    ///
    func testString_Enum() {
        // has raw-value
        do {
            enum Fruit: Int {
                case apple = 0
            }
            
            assert(to: pretty.string) {
                args((Fruit.apple, false), expect: ".apple")
                args((Fruit.apple, true),  expect: "Fruit.apple")
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
                args((Fruit.apple("りんご"), false), expect: #".apple("りんご")"#)
                args((Fruit.apple("りんご"), true),  expect: #"Fruit.apple("りんご")"#)

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
                args((Fruit.apple(.sweet), false), expect: ".apple(.sweet)")
                args((Fruit.apple(.sweet), true),  expect: "Fruit.apple(Taste.sweet)")
                
                // nested two
                args((Fruit.apple(.sour(.high)), false), expect: ".apple(.sour(.high))")
                args((Fruit.apple(.sour(.high)), true),  expect: "Fruit.apple(Taste.sour(Level.high))")

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
