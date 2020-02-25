//
//  OptionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/02/21.
//

import SwiftPrettyPrint // Note: don't use `@testable`, because test to public API
import XCTest

class OptionTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {
        Debug.option = Debug.defaultOption
    }

    func testExample() {
        Debug.option = Option(indent: 2)

        XCTAssertEqual(Debug.prettyPrint(["Hello", "World"]),
                       """
                       [
                         "Hello",
                         "World"
                       ]
                       """)

        XCTAssertEqual(Debug.prettyPrint(["One": 1, "Two": 2]),
                       """
                       [
                         "One": 1,
                         "Two": 2
                       ]
                       """)
    }
}
