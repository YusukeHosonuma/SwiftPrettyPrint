//
//  OptionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/02/21.
//

import SwiftPrettyPrint // Note: don't use `@testable`, because test to public API
import XCTest

class OptionTests: XCTestCase {
    let array: [String?] = ["Hello", "World"]
    let dictionary: [String: Int?] = ["One": 1, "Two": 2]

    override func setUp() {}

    override func tearDown() {
        Debug.sharedOption = Debug.defaultOption
    }

    func testIndent() {
        let option = Option(indent: 2)

        XCTAssertEqual(Debug.prettyPrint(array, option: option),
                       """
                       [
                         "Hello",
                         "World"
                       ]
                       """)

        XCTAssertEqual(Debug.prettyPrint(dictionary, option: option),
                       """
                       [
                         "One": 1,
                         "Two": 2
                       ]
                       """)
    }

    func testSharedOption() {
        Debug.sharedOption = Option(indent: 2)

        var expected: String

        //
        // Use `sharedOption` if `option` arguments are omitted.
        //

        // debug = `false`
        expected = """
        [
          "Hello",
          "World"
        ]
        """
        XCTAssertEqual(Debug.prettyPrint(array), expected)
        XCTAssertEqual(Debug.pp(array, debug: false), expected)

        // debug = `true`
        expected = """
        [
          Optional("Hello"),
          Optional("World")
        ]
        """
        XCTAssertEqual(Debug.debugPrettyPrint(array), expected)
        XCTAssertEqual(Debug.pp(array, debug: true), expected)

        //
        // Use `option` that passed by arguments.
        //

        let option = Option(indent: 4)

        // debug = `false`
        expected = """
        [
            "Hello",
            "World"
        ]
        """
        XCTAssertEqual(Debug.prettyPrint(array, option: option), expected)
        XCTAssertEqual(Debug.pp(array, debug: false, option: option), expected)

        // debug = `true`
        expected = """
        [
            Optional("Hello"),
            Optional("World")
        ]
        """
        XCTAssertEqual(Debug.debugPrettyPrint(array, option: option), expected)
        XCTAssertEqual(Debug.pp(array, debug: true, option: option), expected)
    }
}
