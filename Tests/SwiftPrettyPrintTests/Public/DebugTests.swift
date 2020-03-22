//
// DebugTests.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import SwiftPrettyPrint // Note: don't use `@testable`, because test to public API
import XCTest

private struct Dog {
    var id: DogId
    var name: String?
    var nickname: String?
    var age: Int
    var homepage: URL?
}

private struct DogId {
    var rawValue: String
}

// TODO: should reduce test patterns, because exhaustive tests are written by `PrettyTests`

class DebugTests: XCTestCase {
    fileprivate let dog = Dog(id: DogId(rawValue: "pochi"),
                              name: "ポチ",
                              nickname: nil,
                              age: 3,
                              homepage: URL(string: "https://www.google.com/"))

    override func setUp() {}

    override func tearDown() {}

    func testPrint() {
        let expectString =
            #"Dog(id: "pochi", name: "ポチ", nickname: nil, age: 3, homepage: https://www.google.com/)"#

        let expectDebugString =
            #"Dog(id: DogId(rawValue: "pochi"), name: Optional("ポチ"), nickname: nil, age: 3, homepage: Optional(https://www.google.com/))"#

        //
        // Struct
        //
        do {
            var result = ""
            Debug.print(dog, to: &result)
            XCTAssertEqual(result, expectString + "\n")

            result = ""
            Debug.debugPrint(dog, to: &result)
            XCTAssertEqual(result, expectDebugString + "\n")
        }

        //
        // Array
        //
        do {
            var result = ""
            Debug.print([dog, dog], to: &result)
            XCTAssertEqual(result, "[\(expectString), \(expectString)]" + "\n")

            result = ""
            Debug.debugPrint([dog, dog], to: &result)
            XCTAssertEqual(result, "[\(expectDebugString), \(expectDebugString)]" + "\n")
        }

        //
        // Dictionary
        //
        do {
            let dictionary: [String: Dog] = [
                "dog-1": dog,
                "dog-2": dog,
            ]

            var result = ""
            Debug.print(dictionary, to: &result)
            XCTAssertEqual(result, #"["dog-1": \#(expectString), "dog-2": \#(expectString)]"# + "\n")

            result = ""
            Debug.debugPrint(dictionary, to: &result)
            XCTAssertEqual(result,
                           #"["dog-1": \#(expectDebugString), "dog-2": \#(expectDebugString)]"# + "\n")

        }
    }

    func testPretyPrint() {
        //
        // Struct
        //
        var result = ""
        Debug.prettyPrint(dog, to: &result)
        assertEqualLines(result,
                         """
                         Dog(
                             id: "pochi",
                             name: "ポチ",
                             nickname: nil,
                             age: 3,
                             homepage: https://www.google.com/
                         )
                         """ + "\n")

        result = ""
        Debug.debugPrettyPrint(dog, to: &result)
        assertEqualLines(result,
                         """
                         Dog(
                             id: DogId(rawValue: "pochi"),
                             name: Optional("ポチ"),
                             nickname: nil,
                             age: 3,
                             homepage: Optional(https://www.google.com/)
                         )
                         """ + "\n")

        result = ""
        Debug.prettyPrint([dog, dog], to: &result)
        assertEqualLines(result,
                         """
                         [
                             Dog(
                                 id: "pochi",
                                 name: "ポチ",
                                 nickname: nil,
                                 age: 3,
                                 homepage: https://www.google.com/
                             ),
                             Dog(
                                 id: "pochi",
                                 name: "ポチ",
                                 nickname: nil,
                                 age: 3,
                                 homepage: https://www.google.com/
                             )
                         ]
                         """ + "\n")

        result = ""
        Debug.debugPrettyPrint([dog, dog], to: &result)
        assertEqualLines(result,
                         """
                         [
                             Dog(
                                 id: DogId(rawValue: "pochi"),
                                 name: Optional("ポチ"),
                                 nickname: nil,
                                 age: 3,
                                 homepage: Optional(https://www.google.com/)
                             ),
                             Dog(
                                 id: DogId(rawValue: "pochi"),
                                 name: Optional("ポチ"),
                                 nickname: nil,
                                 age: 3,
                                 homepage: Optional(https://www.google.com/)
                             )
                         ]
                         """ + "\n")

        let dictionary: [String: Dog] = [
            "dog-1": dog,
            "dog-2": dog,
        ]

        result = ""
        Debug.prettyPrint(dictionary, to: &result)
        assertEqualLines(result,
                         """
                         [
                             "dog-1": Dog(
                                          id: "pochi",
                                          name: "ポチ",
                                          nickname: nil,
                                          age: 3,
                                          homepage: https://www.google.com/
                                      ),
                             "dog-2": Dog(
                                          id: "pochi",
                                          name: "ポチ",
                                          nickname: nil,
                                          age: 3,
                                          homepage: https://www.google.com/
                                      )
                         ]
                         """ + "\n")

        result = ""
        Debug.debugPrettyPrint(dictionary, to: &result)
        assertEqualLines(result,
                         """
                         [
                             "dog-1": Dog(
                                          id: DogId(rawValue: "pochi"),
                                          name: Optional("ポチ"),
                                          nickname: nil,
                                          age: 3,
                                          homepage: Optional(https://www.google.com/)
                                      ),
                             "dog-2": Dog(
                                          id: DogId(rawValue: "pochi"),
                                          name: Optional("ポチ"),
                                          nickname: nil,
                                          age: 3,
                                          homepage: Optional(https://www.google.com/)
                                      )
                         ]
                         """ + "\n")
    }

    func testLabel() {
        let array = ["Hello", "World"]

        var result = ""
        Debug.print(label: "array", array, to: &result)
        XCTAssertEqual(result, #"array: ["Hello", "World"]"# + "\n")

        result = ""
        Debug.debugPrint(label: "array", array, to: &result)
        XCTAssertEqual(result, #"array: ["Hello", "World"]"# + "\n")

        result = ""
        Debug.prettyPrint(label: "array", array, to: &result)
        XCTAssertEqual(result, """
            array:
            [
                "Hello",
                "World"
            ]
            """ + "\n")

        result = ""
        Debug.debugPrettyPrint(label: "array", array, to: &result)
        XCTAssertEqual(result, """
            array:
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
        Debug.print(array, 42, to: &result)
        XCTAssertEqual(result, #"["Hello", "World"] 42"# + "\n")

        result = ""
        Debug.debugPrint(array, 42, to: &result)
        XCTAssertEqual(result, #"["Hello", "World"] 42"# + "\n")

        result = ""
        Debug.prettyPrint(array, 42, to: &result)
        XCTAssertEqual(result, """
            [
                "Hello",
                "World"
            ]
            42
            """ + "\n")

        result = ""
        Debug.debugPrettyPrint(array, 42, to: &result)
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
        Debug.print(array, 42, separator: "!!", to: &result)
        XCTAssertEqual(result, #"["Hello", "World"]!!42"# + "\n")

        result = ""
        Debug.debugPrint(array, 42, separator: "!!", to: &result)
        XCTAssertEqual(result, #"["Hello", "World"]!!42"# + "\n")

        result = ""
        Debug.prettyPrint(array, 42, separator: "!!\n", to: &result)
        XCTAssertEqual(result, """
            [
                "Hello",
                "World"
            ]!!
            42
            """ + "\n")

        result = ""
        Debug.debugPrettyPrint(array, 42, separator: "!!\n", to: &result)
        XCTAssertEqual(result, """
            [
                "Hello",
                "World"
            ]!!
            42
            """ + "\n")
    }
}
