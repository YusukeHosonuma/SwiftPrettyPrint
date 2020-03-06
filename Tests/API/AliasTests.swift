//
//  AliasTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/06.
//

import SwiftPrettyPrint
import XCTest

class AliasTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testExample() {
        let array: [String?] = ["Hello", "World"]

        XCTAssertEqual(Debug.p >> array, #"["Hello", "World"]"#)
        XCTAssertEqual(Debug.pd >> array, #"[Optional("Hello"), Optional("World")]"#)
        XCTAssertEqual(Debug.pp >> array, """
        [
            "Hello",
            "World"
        ]
        """)
        XCTAssertEqual(Debug.ppd >> array, """
        [
            Optional("Hello"),
            Optional("World")
        ]
        """)
    }
}
