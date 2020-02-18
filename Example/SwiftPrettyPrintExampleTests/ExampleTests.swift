//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Yusuke Hosonuma on 2020/02/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

@testable import SwiftPrettyPrintExample
import XCTest

class SwiftPrettyPrintExampleTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testExample() {
        let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")
        XCTAssertEqual(Debug.pString(dog),
                       #"Dog(id: "pochi", price: 10.0, name: "ポチ")"#)
    }
}
