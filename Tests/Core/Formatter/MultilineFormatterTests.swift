//
//  MultilineFormatterTests.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/26.
//

@testable import SwiftPrettyPrint
import XCTest

class MultilineFormatterTests: XCTestCase {
    var formatter: MultilineFormatter!

    override func setUp() {}

    override func tearDown() {}

    func testArrayString() {
        let array: [String] = [#""Hello""#, #""World""#]

        formatter = MultilineFormatter(option: Debug.Option(indent: 2))
        assertEqualLines(formatter.arrayString(elements: array),
                         """
                         [
                           "Hello",
                           "World"
                         ]
                         """)

        formatter = MultilineFormatter(option: Debug.Option(indent: 4))
        assertEqualLines(formatter.arrayString(elements: array),
                         """
                         [
                             "Hello",
                             "World"
                         ]
                         """)
    }

    func testDictionaryString() {
        let keysAndValues: [(String, String)] = [
            ("2", #""Two""#),
            ("1", """
            One(value: 1,
                first: true)
            """),
        ]

        formatter = MultilineFormatter(option: Debug.Option(indent: 2))
        assertEqualLines(formatter.dictionaryString(keysAndValues: keysAndValues),
                         """
                         [
                           1: One(value: 1,
                                  first: true),
                           2: "Two"
                         ]
                         """)

        formatter = MultilineFormatter(option: Debug.Option(indent: 4))
        assertEqualLines(formatter.dictionaryString(keysAndValues: keysAndValues),
                         """
                         [
                             1: One(value: 1,
                                    first: true),
                             2: "Two"
                         ]
                         """)
    }
    
    func testTupleString() {
        let tupleElements: [(String?, String)] = [
            (
                Optional(nil),
                "\"first\""
            ),
            (
                "label",
                """
                One(value: 1,
                    first: true)
                """
            )
        ]

        formatter = MultilineFormatter(option: Debug.Option(indent: 2))
        assertEqualLines(formatter.tupleString(elements: tupleElements),
                         """
                         (
                           "first",
                           label: One(value: 1,
                                      first: true)
                         )
                         """)

        formatter = MultilineFormatter(option: Debug.Option(indent: 4))
        assertEqualLines(formatter.tupleString(elements: tupleElements),
                         """
                         (
                             "first",
                             label: One(value: 1,
                                        first: true)
                         )
                         """)
    }

    func testObjectString() {
        let fields: [(String, String)] = [
            ("name", #""pochi""#),
            ("owner", """
            Owner(name: "Nanachi",
                  age: 4)
            """),
        ]

        formatter = MultilineFormatter(option: Debug.Option(indent: 2))
         assertEqualLines(formatter.objectString(typeName: "Dog", fields: fields),
                         """
                         Dog(name: "pochi",
                             owner: Owner(name: "Nanachi",
                                          age: 4))
                         """)
    }
}
