//
// DebugTests.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import SwiftPrettyPrint // Note: don't use `@testable`, because test to public API
import XCTest

class DebugTests: XCTestCase {
    let helper = DebugHelper(option: Pretty.Option(prefix: "[DEBUG]", indentSize: 4))

    override func setUp() {}
    override func tearDown() {}

    func testExample() {
        // all premetive types (but not include `Date` because depends on timeZone of system)
        class Class {
            let string: String
            let int: Int
            let float: Float
            let double: Double
            let bool: Bool
            let url: URL
            
            init(
                string: String,
                int: Int,
                float: Float,
                double: Double,
                bool: Bool,
                url: URL
            ) {
                self.string = string
                self.int = int
                self.float = float
                self.double = double
                self.bool = bool
                self.url = url
            }
        }
        
        enum Enum {
            case one
            case two(Int)
            case three(string: String)
        }
        
        struct ValueObject {
            let id: Int
        }
        
        // all `Mirror.DisplayStyle` and `ValueObject`
        struct Struct {
            var optional: String?
            var array: [Int?]
            var dictionary: [String: Int?]
            var tuple: (Int, string: String)
            var enumOne: Enum
            var enumTwo: Enum
            var enumThree: Enum
            var set: Set<Int?>
            var klass: Class
            var valueObject: ValueObject
        }
        
        let target =
        Struct(
            optional: "string",
            array: [1, 2, nil],
            dictionary: ["one": 1, "two": 2],
            tuple: (1, string: "string"),
            enumOne: .one,
            enumTwo: .two(1),
            enumThree: .three(string: "string"),
            set: [1, 2, nil],
            klass: Class(
                string: "string",
                int: 1,
                float: 1.0,
                double: 2.0,
                bool: true,
                url: URL(string: "https://github.com/YusukeHosonuma/SwiftPrettyPrint")!
            ),
            valueObject: ValueObject(id: 1)
        )
        
        assertEqualLines(helper.print(target),
                         #"[DEBUG] Struct(optional: "string", array: [1, 2, nil], dictionary: ["one": 1, "two": 2], tuple: (1, string: "string"), enumOne: .one, enumTwo: .two(1), enumThree: .three(string: "string"), set: [1, 2, nil], klass: Class(string: "string", int: 1, float: 1.0, double: 2.0, bool: true, url: https://github.com/YusukeHosonuma/SwiftPrettyPrint), valueObject: 1)"# + "\n")

        assertEqualLines(helper.printDebug(target),
                         #"[DEBUG] Struct(optional: Optional("string"), array: [Optional(1), Optional(2), nil], dictionary: ["one": Optional(1), "two": Optional(2)], tuple: (1, string: "string"), enumOne: Enum.one, enumTwo: Enum.two(1), enumThree: Enum.three(string: "string"), set: Set([Optional(1), Optional(2), nil]), klass: Class(string: "string", int: 1, float: 1.0, double: 2.0, bool: true, url: URL("https://github.com/YusukeHosonuma/SwiftPrettyPrint")), valueObject: ValueObject(id: 1))"# + "\n")

        assertEqualLines(helper.prettyPrint(target),
        """
        [DEBUG]
        Struct(
            optional: "string",
            array: [
                1,
                2,
                nil
            ],
            dictionary: [
                "one": 1,
                "two": 2
            ],
            tuple: (
                1,
                string: "string"
            ),
            enumOne: .one,
            enumTwo: .two(1),
            enumThree: .three(
                string: "string"
            ),
            set: [
                1,
                2,
                nil
            ],
            klass: Class(
                string: "string",
                int: 1,
                float: 1.0,
                double: 2.0,
                bool: true,
                url: https://github.com/YusukeHosonuma/SwiftPrettyPrint
            ),
            valueObject: 1
        )
        """ + "\n")
        
        assertEqualLines(helper.prettyPrintDebug(target),
        """
        [DEBUG]
        Struct(
            optional: Optional("string"),
            array: [
                Optional(1),
                Optional(2),
                nil
            ],
            dictionary: [
                "one": Optional(1),
                "two": Optional(2)
            ],
            tuple: (
                1,
                string: "string"
            ),
            enumOne: Enum.one,
            enumTwo: Enum.two(1),
            enumThree: Enum.three(
                string: "string"
            ),
            set: Set([
                Optional(1),
                Optional(2),
                nil
            ]),
            klass: Class(
                string: "string",
                int: 1,
                float: 1.0,
                double: 2.0,
                bool: true,
                url: URL("https://github.com/YusukeHosonuma/SwiftPrettyPrint")
            ),
            valueObject: ValueObject(id: 1)
        )
        """ + "\n")
    }
    
    func testLabel() {
        let array = ["Hello", "World"]
        
        assertEqualLines(helper.print(label: "array", array),
                         #"[DEBUG] array: ["Hello", "World"]"# + "\n")
        
        assertEqualLines(helper.printDebug(label: "array", array),
                         #"[DEBUG] array: ["Hello", "World"]"# + "\n")
        
        assertEqualLines(helper.prettyPrint(label: "array", array), """
            [DEBUG] array:
            [
                "Hello",
                "World"
            ]
            """ + "\n")
        
        assertEqualLines(helper.prettyPrintDebug(label: "array", array), """
            [DEBUG] array:
            [
                "Hello",
                "World"
            ]
            """ + "\n")
    }

    func testMultipleValuesAndSeparator() {
        let array = ["Hello", "World"]

        //
        // not specify `separator` (default)
        //

        var result = ""
        Pretty.print(array, 42, to: &result)
        XCTAssertEqual(result, #"["Hello", "World"] 42"# + "\n")

        result = ""
        Pretty.printDebug(array, 42, to: &result)
        XCTAssertEqual(result, #"["Hello", "World"] 42"# + "\n")

        result = ""
        Pretty.prettyPrint(array, 42, to: &result)
        XCTAssertEqual(result, """
            [
                "Hello",
                "World"
            ]
            42
            """ + "\n")

        result = ""
        Pretty.prettyPrintDebug(array, 42, to: &result)
        XCTAssertEqual(result, """
            [
                "Hello",
                "World"
            ]
            42
            """ + "\n")

        //
        // specify `separator`
        //

        result = ""
        Pretty.print(array, 42, separator: "!!", to: &result)
        XCTAssertEqual(result, #"["Hello", "World"]!!42"# + "\n")

        result = ""
        Pretty.printDebug(array, 42, separator: "!!", to: &result)
        XCTAssertEqual(result, #"["Hello", "World"]!!42"# + "\n")

        result = ""
        Pretty.prettyPrint(array, 42, separator: "!!\n", to: &result)
        XCTAssertEqual(result, """
            [
                "Hello",
                "World"
            ]!!
            42
            """ + "\n")

        result = ""
        Pretty.prettyPrintDebug(array, 42, separator: "!!\n", to: &result)
        XCTAssertEqual(result, """
            [
                "Hello",
                "World"
            ]!!
            42
            """ + "\n")
    }
}
