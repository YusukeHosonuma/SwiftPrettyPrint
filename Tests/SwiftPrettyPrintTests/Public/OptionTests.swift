//
//  OptionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/18.
//

import XCTest
import SwiftPrettyPrint

class OptionTests: XCTestCase {
    let helper = DebugHelper(option: Pretty.Option(prefix: "<DEBUG>", indentSize: 2))
    
    override func setUp() {}

    override func tearDown() {}

    func testExample() {
        
        let array = [42, 7]
        
        // with no `label`
                
        assertEqualLines(helper.print(array),
                         "<DEBUG> [42, 7]" + "\n")
        assertEqualLines(helper.printDebug(array),
                         "<DEBUG> [42, 7]" + "\n")
        assertEqualLines(helper.prettyPrint(array),
                         """
                         <DEBUG>
                         [
                           42,
                           7
                         ]
                         """ + "\n")
        assertEqualLines(helper.prettyPrintDebug(array),
                         """
                         <DEBUG>
                         [
                           42,
                           7
                         ]
                         """ + "\n")
        
        // with `label`
                
        assertEqualLines(helper.print(label: "array", array),
                         "<DEBUG> array: [42, 7]" + "\n")
        assertEqualLines(helper.printDebug(label: "array", array),
                         "<DEBUG> array: [42, 7]" + "\n")
        assertEqualLines(helper.prettyPrint(label: "array", array),
                         """
                         <DEBUG> array:
                         [
                           42,
                           7
                         ]
                         """ + "\n")
        assertEqualLines(helper.prettyPrintDebug(label: "array", array),
                         """
                         <DEBUG> array:
                         [
                           42,
                           7
                         ]
                         """ + "\n")
    }
}
