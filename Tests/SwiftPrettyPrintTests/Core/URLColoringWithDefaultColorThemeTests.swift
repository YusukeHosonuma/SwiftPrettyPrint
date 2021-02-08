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
/// - Note: The escape sequences used for the expected values of the test is as follows:
///     - `\u{1B}`: escape characters starting all the escape sequences
///     - `[0m`: Reset or normal. All attributes off
///     - `[4m`: underline
///     - `[33m`: make forground color yellow
///     - `[34m`: make foreground color blue
/// - SeeAlso:
/// [ANSI escape code - Wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code)
class URLColoringWithDefaultColorThemeTests: XCTestCase {
    let describerWithDefaultColorTheme = PrettyDescriber(formatter: SinglelineFormatter(), theme: .default)

    override func setUp() {}

    override func tearDown() {}

    func testURLColoring() throws {
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        assert(to: describerWithDefaultColorTheme.string) {
            args(
                url, false, expect: "\u{1B}[4m\u{1B}[34m\(url)\u{1B}[0m\u{1B}[4m\u{1B}[0m"
            )
            args(
                url, true, expect: "\u{1B}[33mURL\u{1B}[0m(\"\u{1B}[4m\u{1B}[34m\(url)\u{1B}[0m\u{1B}[4m\u{1B}[0m\")"
            )
        }
    }
}
