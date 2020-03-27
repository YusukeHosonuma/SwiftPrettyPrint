//
//  OperatorTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/25.
//

import XCTest
import SwiftPrettyPrint

// Note:
// This test is validate can compile only.
// (not include any assertions)

class OperatorTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testExample() {        
        p   >>> 42
        pd  >>> 42
        pp  >>> 42
        ppd >>> 42
        
        p("label") >>> 42
        pd("label") >>> 42
        pp("label") >>> 42
        ppd("label") >>> 42
    }
}
