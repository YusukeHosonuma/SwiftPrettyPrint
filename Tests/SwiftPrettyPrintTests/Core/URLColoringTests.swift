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
    /// URL Coloring with Custom Color Theme
    ///
    func testWithCustomColorTheme() {
        let theme: ColorTheme = {
            var t = ColorTheme.plain
            t.url = { #"<a href="\#($0)">\#($0)</a>"# } 
            return t
        }()
        
        let describer = PrettyDescriber(formatter: SinglelineFormatter(), theme: theme)
        
        assert(to: describer.string) {
            args(exampleURL, false, expect: #"<a href="\#(exampleURL.absoluteString)">\#(exampleURL.absoluteString)</a>"#)
            args(exampleURL, true, expect: #"URL("<a href="\#(exampleURL.absoluteString)">\#(exampleURL.absoluteString)</a>")"#)
        }
    }
}
