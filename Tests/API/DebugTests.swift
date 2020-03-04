//
// DebugTests.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import SwiftPrettyPrint // Note: don't use `@testable`, because test to public API
import XCTest

private struct Dog {
    var id: DogId
    var name: String?
    var nickname: String?
    var age: Int
    var homepage: URL?
}

private struct DogId {
    var rawValue: String
}

// TODO: organize test to comprehensive

class DebugTests: XCTestCase {
    fileprivate let dog = Dog(id: DogId(rawValue: "pochi"),
                              name: "ポチ",
                              nickname: nil,
                              age: 3,
                              homepage: URL(string: "https://www.google.com/"))

    override func setUp() {}

    override func tearDown() {}

    func testPrint() {
        //
        // Struct
        //

        let expectString =
            #"Dog(id: "pochi", name: "ポチ", nickname: nil, age: 3, homepage: https://www.google.com/)"#

        let expectDebugString =
            #"Dog(id: DogId(rawValue: "pochi"), name: Optional("ポチ"), nickname: nil, age: 3, homepage: Optional(https://www.google.com/))"#

        XCTAssertEqual(Debug.print(dog),
                       expectString)

        XCTAssertEqual(Debug.debugPrint(dog),
                       expectDebugString)

        //
        // Array
        //

        XCTAssertEqual(Debug.print([dog, dog]),
                       "[\(expectString), \(expectString)]")

        XCTAssertEqual(Debug.debugPrint([dog, dog]),
                       "[\(expectDebugString), \(expectDebugString)]")

        //
        // Dictionary
        //

        let dictionary: [String: Dog] = [
            "dog-1": dog,
            "dog-2": dog,
        ]

        XCTAssertEqual(Debug.print(dictionary),
                       #"["dog-1": \#(expectString), "dog-2": \#(expectString)]"#)

        XCTAssertEqual(Debug.debugPrint(dictionary),
                       #"["dog-1": \#(expectDebugString), "dog-2": \#(expectDebugString)]"#)
    }

    func testPretyPrint() {
        //
        // Struct
        //

        assertEqualLines(Debug.prettyPrint(dog),
                         """
                         Dog(id: "pochi",
                             name: "ポチ",
                             nickname: nil,
                             age: 3,
                             homepage: https://www.google.com/)
                         """)

        assertEqualLines(Debug.debugPrettyPrint(dog),
                         """
                         Dog(id: DogId(rawValue: "pochi"),
                             name: Optional("ポチ"),
                             nickname: nil,
                             age: 3,
                             homepage: Optional(https://www.google.com/))
                         """)

        assertEqualLines(Debug.prettyPrint([dog, dog]),
                         """
                         [
                             Dog(id: "pochi",
                                 name: "ポチ",
                                 nickname: nil,
                                 age: 3,
                                 homepage: https://www.google.com/),
                             Dog(id: "pochi",
                                 name: "ポチ",
                                 nickname: nil,
                                 age: 3,
                                 homepage: https://www.google.com/)
                         ]
                         """)

        assertEqualLines(Debug.debugPrettyPrint([dog, dog]),
                         """
                         [
                             Dog(id: DogId(rawValue: "pochi"),
                                 name: Optional("ポチ"),
                                 nickname: nil,
                                 age: 3,
                                 homepage: Optional(https://www.google.com/)),
                             Dog(id: DogId(rawValue: "pochi"),
                                 name: Optional("ポチ"),
                                 nickname: nil,
                                 age: 3,
                                 homepage: Optional(https://www.google.com/))
                         ]
                         """)

        let dictionary: [String: Dog] = [
            "dog-1": dog,
            "dog-2": dog,
        ]

        assertEqualLines(Debug.prettyPrint(dictionary),
                         """
                         [
                             "dog-1": Dog(id: "pochi",
                                          name: "ポチ",
                                          nickname: nil,
                                          age: 3,
                                          homepage: https://www.google.com/),
                             "dog-2": Dog(id: "pochi",
                                          name: "ポチ",
                                          nickname: nil,
                                          age: 3,
                                          homepage: https://www.google.com/)
                         ]
                         """)

        assertEqualLines(Debug.debugPrettyPrint(dictionary),
                         """
                         [
                             "dog-1": Dog(id: DogId(rawValue: "pochi"),
                                          name: Optional("ポチ"),
                                          nickname: nil,
                                          age: 3,
                                          homepage: Optional(https://www.google.com/)),
                             "dog-2": Dog(id: DogId(rawValue: "pochi"),
                                          name: Optional("ポチ"),
                                          nickname: nil,
                                          age: 3,
                                          homepage: Optional(https://www.google.com/))
                         ]
                         """)
    }
}
