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
    let exampleURL = "https://example.com"

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    
    /// URL coloring
    /// - Throws: when the URL could not be generated from the string given in the `url` argument
    func testURLColoring_non_debug() throws {
        try _test(
            describerWithDefaultColorTheme,
            url: exampleURL,
            expect: "\u{1B}[4m\u{1B}[34m\(exampleURL)\u{1B}[0m\u{1B}[4m\u{1B}[0m",
            debug: false
        )
    }
    
    /// URL Coloring in detail
    /// - Throws: when the URL could not be generated from the string given in the `url` argument
    func testURLColoring_debug() throws {
        try _test(
            describerWithDefaultColorTheme,
            url: exampleURL,
            expect: "\u{1B}[33mURL\u{1B}[0m(\"\u{1B}[4m\u{1B}[34m\(exampleURL)\u{1B}[0m\u{1B}[4m\u{1B}[0m\")",
            debug: true
        )
    }
}
extension URLColoringWithDefaultColorThemeTests {
    /// Test PrettyDescriber
    /// - Parameters:
    ///   - describer: generates a string for output
    ///   - url: a url string which is the target to generate strings
    ///   - expect: the string that is expected to be generated
    ///   - debug: whether generated string is a detailed version for debugging or not
    /// - Throws: when the URL could not be generated from the string given in the `url` argument
    private func _test(
        _ describer: PrettyDescriber,
        url string: String,
        expect: String,
        debug: Bool) throws {
        let url = try XCTUnwrap(URL(string: string))
        assert(to: describer.string) {
            args(
                url, debug, expect: expect
            )
        }
    }
}
