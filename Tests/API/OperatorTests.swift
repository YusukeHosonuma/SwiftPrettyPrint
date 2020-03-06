//
//  OperatorTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/06.
//

import SwiftPrettyPrint
import XCTest

class OperatorTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testExample() {
        let array: [String?] = ["Hello", "World"]

        XCTAssertEqual(Debug.p >>> array, #"["Hello", "World"]"#)
        XCTAssertEqual(Debug.pd >>> array, #"[Optional("Hello"), Optional("World")]"#)
        XCTAssertEqual(Debug.pp >>> array, """
        [
            "Hello",
            "World"
        ]
        """)
        XCTAssertEqual(Debug.ppd >>> array, """
        [
            Optional("Hello"),
            Optional("World")
        ]
        """)

        // Note:
        // could be a apply to expression because the operator `>>>` has lower precedense than all standard operators in Swift.
        XCTAssertEqual(Debug.p >>> 42 + 1, "43")
    }
}
