//
//  Assertions.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/04.
//

import XCTest

private extension String {
    var lines: [String] {
        split(separator: "\n").map(String.init)
    }
}

func assertEqualLines(_ actual: String, _ expected: String, file: StaticString = #file, line: UInt = #line) {
    let diff: String

    if expected.lines.count != actual.lines.count {
        diff = "Line counts are not equal \(expected.lines.count) and \(actual.lines.count)."
    } else {
        diff = zip(expected.lines, actual.lines).map {
            if $0 == $1 {
                return "  \($0)"
            } else {
                return """
                + \($0)
                - \($1)
                """
            }
        }.joined(separator: "\n")
    }

    let maxLength = (expected.lines + actual.lines + diff.lines).max { $0.count < $1.count }?.count ?? 4
    let __separator__ = String(repeating: "-", count: maxLength)

    let message = """
    
    
    Expected:
    \(__separator__)
    \(expected)
    \(__separator__)

    Actual:
    \(__separator__)
    \(actual)
    \(__separator__)

    Diff:
    \(__separator__)
    \(diff)
    \(__separator__)
    
    """
    XCTAssertTrue(actual == expected, message, file: file, line: line)
}
