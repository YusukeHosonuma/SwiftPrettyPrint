//
//  FunctionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/02/19.
//

@testable import SwiftPrettyPrint
import XCTest

class FunctionTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func test_elementString_struct_in_struct() {
        struct Dog {
            var name: String
            var owner: Owner
            var age: Int
        }

        struct Owner {
            var name: String
            var age: Int
            var address: String
        }

        //
        // struct in struct
        //

        let owner = Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss")
        let dog = Dog(name: "Pochi", owner: owner, age: 4)

        XCTAssertEqual(elementString(dog, debug: false, pretty: false),
                       #"Dog(name: "Pochi", owner: Owner(name: "Nanachi", age: 20, address: "4th layer in Abyss"), age: 4)"#)

        // TODO: support
//        XCTAssertEqual(elementString(dog, debug: false, pretty: true),
//                       """
//                       Dog(name: "Pochi",
//                           owner: Owner(name: "Nanachi",
//                                        age: 20,
//                                        address: "4th layer Abyss"),
//                           age: 4)
//                       """)
    }
}