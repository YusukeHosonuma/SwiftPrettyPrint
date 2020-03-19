//
//  SinglelineFormatterTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/03.
//

@testable import SwiftPrettyPrint
import XCTest
import SwiftParamTest

class SinglelineFormatterTests: XCTestCase {
    let formatter = SinglelineFormatter()

    override func setUp() {}

    override func tearDown() {}

    func testCollectionString() {
        let array: [String] = [#""Hello""#, #""World""#]

        XCTAssertEqual(formatter.collectionString(elements: array),
                       #"["Hello", "World"]"#)
    }

    func testDictionaryString() {
        let keysAndValues: [(String, String)] = [
            ("2", #""Two""#),
            ("1", #""One""#),
        ]

        XCTAssertEqual(formatter.dictionaryString(keysAndValues: keysAndValues),
                       #"[1: "One", 2: "Two"]"#) // sorted
    }
    
    func testTupleString() {
        typealias T = [(String?, String)]
        
        assert(to: formatter.tupleString) {
            args([]                                 as T, expect: #"()"#)
            args([(nil, #""one""#)]                 as T, expect: #"("one")"#)
            args([("first", #""one""#), (nil, "2")] as T, expect: #"(first: "one", 2)"#)
        }
    }
    
    func testObjectString() {
        let fields: [(String, String)] = [
            ("name", #""pochi""#),
            ("age", "4"),
        ]

        XCTAssertEqual(formatter.objectString(typeName: "Dog", fields: fields),
                       #"Dog(name: "pochi", age: 4)"#)
    }
}
