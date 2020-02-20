//
//  String+extensionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/02/20.
//

@testable import SwiftPrettyPrint
import XCTest

class String_extensionTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func test_indentTail() {
        let text = """
        Apple
        Orange
        Banana
        """

        XCTAssertEqual("Single line".indentTail(size: 4), "Single line")

        XCTAssertEqual(text.indentTail(size: 2),
                       """
                       Apple
                         Orange
                         Banana
                       """)

        XCTAssertEqual(text.indentTail(size: 4),
                       """
                       Apple
                           Orange
                           Banana
                       """)
    }
}
