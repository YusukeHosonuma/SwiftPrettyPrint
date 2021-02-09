//
//  URLColoringWithDefaultColorThemeTests.swift
//  SwiftPrettyPrintTests
//
//  Created by ogasawara on 2021/02/08.
//

@testable import SwiftPrettyPrint
import XCTest
import SwiftParamTest
import Curry

/// Test the coloring of URL.
class URLColoringTests: XCTestCase {
    let exampleURL = URL(string: "https://example.com")!

    override func setUp() {}

    override func tearDown() {}

    ///
    /// URL Coloring with Default Color Theme
    ///
    func testWithDefaultColorTheme() {
        let describerWithDefaultColorTheme = PrettyDescriber(formatter: SinglelineFormatter(), theme: .default)
        assert(to: describerWithDefaultColorTheme.string) {
            args(
                exampleURL, false, expect: "\u{1B}[4m\u{1B}[34m\(exampleURL)\u{1B}[0m\u{1B}[4m\u{1B}[0m"
            )
            args(
                exampleURL, true, expect: "\u{1B}[33mURL\u{1B}[0m(\"\u{1B}[4m\u{1B}[34m\(exampleURL)\u{1B}[0m\u{1B}[4m\u{1B}[0m\")"
            )
        }
    }
    
}
