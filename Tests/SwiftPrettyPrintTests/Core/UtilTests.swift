//
//  UtilTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/18.
//

import XCTest
import SwiftParamTest
@testable import SwiftPrettyPrint

class UtilTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testPrefixLabel() {
        // Note:
        // can't type inference in Function Builders API.
        assert(to: prefixLabel,
               header: ["prefix", "label"],
               expect:
        [
            args("[DEBUG]", "x", expect: "[DEBUG] x: "),
            args("[DEBUG]", nil, expect: "[DEBUG] "),
            args(nil,       "x", expect: "x: "),
            args(nil,       nil, expect: ""),
        ] as [Row2<String?, String?, String>])
    }
    
    func testPrefixLabelPretty() {
        // Note:
        // can't type inference in Function Builders API.
        assert(to: prefixLabelPretty,
               header: ["prefix", "label"],
               expect:
        [
            args("[DEBUG]", "x", expect: "[DEBUG] x:\n"),
            args("[DEBUG]", nil, expect: "[DEBUG]\n"),
            args(nil,       "x", expect: "x:\n"),
            args(nil,       nil, expect: ""),
        ] as [Row2<String?, String?, String>])
    }
}
