//
// String+extensionTests.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

@testable import SwiftPrettyPrint
import XCTest
import SwiftParamTest

class String_extensionTests: XCTestCase {
    override func setUp() {}

    override func tearDown() {}

    func testIndentTail() {
        let text = """
        Apple
        Orange
        Banana
        """
        
        assert(to: uncurry(String.indentTail), with: assertEqualLines).expect([
            // Single-line
            when(("Apple", 4), then: "Apple"),
            
            // Multi-line
            when((text,    2), then: """
                                     Apple
                                       Orange
                                       Banana
                                     """),
            when((text,    4), then: """
                                     Apple
                                         Orange
                                         Banana
                                     """),
        ])
    }
}
