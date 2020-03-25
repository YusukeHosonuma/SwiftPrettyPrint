//
//  OptionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/18.
//

import XCTest
import SwiftPrettyPrint

class OptionTests: XCTestCase {

    override func setUp() {}

    override func tearDown() {}

    func testExample() {
        let option = Debug.Option(prefix: "<DEBUG>", indentSize: 2)
        
        func _print(label: String? = nil, _ target: Any) -> String {
            var s = ""
            Debug.print(label: label, target, option: option, to: &s)
            return s
        }
        
        func _printDebug(label: String? = nil, _ target: Any) -> String {
            var s = ""
            Debug.printDebug(label: label, target, option: option, to: &s)
            return s
        }
        
        func _prettyPrint(label: String? = nil, _ target: Any) -> String {
            var s = ""
            Debug.prettyPrint(label: label, target, option: option, to: &s)
            return s
        }
        
        func _prettyPrintDebug(label: String? = nil, _ target: Any) -> String {
            var s = ""
            Debug.prettyPrintDebug(label: label, target, option: option, to: &s)
            return s
        }

        
        let array = [42, 7]
        
        // with no `label`
                
        assertEqualLines(_print(array),
                         "<DEBUG> [42, 7]" + "\n")
        assertEqualLines(_printDebug(array),
                         "<DEBUG> [42, 7]" + "\n")
        assertEqualLines(_prettyPrint(array),
                         """
                         <DEBUG>
                         [
                           42,
                           7
                         ]
                         """ + "\n")
        assertEqualLines(_prettyPrintDebug(array),
                         """
                         <DEBUG>
                         [
                           42,
                           7
                         ]
                         """ + "\n")
        
        // with `label`
                
        assertEqualLines(_print(label: "array", array),
                         "<DEBUG> array: [42, 7]" + "\n")
        assertEqualLines(_printDebug(label: "array", array),
                         "<DEBUG> array: [42, 7]" + "\n")
        assertEqualLines(_prettyPrint(label: "array", array),
                         """
                         <DEBUG> array:
                         [
                           42,
                           7
                         ]
                         """ + "\n")
        assertEqualLines(_prettyPrintDebug(label: "array", array),
                         """
                         <DEBUG> array:
                         [
                           42,
                           7
                         ]
                         """ + "\n")
    }
}
