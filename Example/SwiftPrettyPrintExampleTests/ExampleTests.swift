//
// ExampleTests.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

@testable import SwiftPrettyPrintExample
import XCTest

class SwiftPrettyPrintExampleTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testExample() {
        let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")

        var result = ""
        Debug.print(dog, to: &result)
        XCTAssertEqual(result,
                       #"Dog(id: "pochi", price: 10.0, name: "ポチ")"# + "\n")
    }
}
