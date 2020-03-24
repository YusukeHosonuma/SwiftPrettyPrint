//
//  MultilineFormatterTests.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/26.
//

@testable import SwiftPrettyPrint
import XCTest
import SwiftParamTest

class MultilineFormatterTests: XCTestCase {
    var formatter: MultilineFormatter!

    override func setUp() {}

    override func tearDown() {}

    func testCollectionString() {
        let array: [String] = [#""Hello""#, #""World""#]

        formatter = MultilineFormatter(indentSize: 2)
        assertEqualLines(formatter.collectionString(elements: array),
                         """
                         [
                           "Hello",
                           "World"
                         ]
                         """)

        formatter = MultilineFormatter(indentSize: 4)
        assertEqualLines(formatter.collectionString(elements: array),
                         """
                         [
                             "Hello",
                             "World"
                         ]
                         """)
    }

    func testDictionaryString() {
        func f(indentSize: Int, keysAndValues: [(String, String)]) -> String {
            let formatter = MultilineFormatter(indentSize: indentSize)
            return formatter.dictionaryString(keysAndValues: keysAndValues)
        }
        
        assert(to: f, with: assertEqualLines) {
            // indent = 2
            args((
                indent: 2,
                keysAndValues: [
                    ("2", #""Two""#),
                    ("1", """
                      One(
                        value: 1,
                        first: true
                      )
                      """),
                ]
            ),
            expect: """
            [
              1: One(
                value: 1,
                first: true
              ),
              2: "Two"
            ]
            """)
            
            // indent = 4
            args((
                indent: 4,
                keysAndValues: [
                    ("2", #""Two""#),
                    ("1", """
                      One(
                          value: 1,
                          first: true
                      )
                      """),
                ]
            ),
            expect: """
            [
                1: One(
                    value: 1,
                    first: true
                ),
                2: "Two"
            ]
            """)
        }
    }
    
    func testTupleString() {
        func f(indentSize: Int, tupleElements: [(String?, String)]) -> String {
            let formatter = MultilineFormatter(indentSize: indentSize)
            return formatter.tupleString(elements: tupleElements)
        }
        
        assert(to: f, with: assertEqualLines) {
            // indent = 2
            args((
                indent: 2,
                tupleElements: [
                    (
                        Optional(nil),
                        "\"first\""
                    ),
                    (
                        "label",
                        """
                        One(
                          value: 1,
                          first: true
                        )
                        """
                    )
                ]
            ),
            expect: """
            (
              "first",
              label: One(
                value: 1,
                first: true
              )
            )
            """)
            
            // indent = 4
            args((
                indent: 4,
                tupleElements: [
                    (
                        Optional(nil),
                        "\"first\""
                    ),
                    (
                        "label",
                        """
                        One(
                            value: 1,
                            first: true
                        )
                        """
                    )
                ]
            ),
            expect: """
            (
                "first",
                label: One(
                    value: 1,
                    first: true
                )
            )
            """)
        }
    }

    func testObjectString() {
        var fields: [(String, String)] = [
            ("name", #""pochi""#),
            ("owner", """
            Owner(
              name: "Nanachi",
              age: 4
            )
            """),
        ]

        var expected =
        """
        Dog(
          name: "pochi",
          owner: Owner(
                   name: "Nanachi",
                   age: 4
                 )
        )
        """

        formatter = MultilineFormatter(indentSize: 2)
        assertEqualLines(formatter.objectString(typeName: "Dog", fields: fields), expected)


        fields = [
            ("name", #""pochi""#),
            ("owner", """
            Owner(
                name: "Nanachi",
                age: 4
            )
            """),
        ]

        expected =
        """
        Dog(
            name: "pochi",
            owner: Owner(
                       name: "Nanachi",
                       age: 4
                   )
        )
        """

        formatter = MultilineFormatter(indentSize: 4)
        assertEqualLines(formatter.objectString(typeName: "Dog", fields: fields), expected)
    }
    
    // MARK: - Helper
        
    private func option(indent: Int) -> Debug.Option {
        Debug.Option(prefix: "", indentSize: indent)
    }
}
