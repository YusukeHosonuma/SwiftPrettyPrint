//
//  Section.swift
//  SwiftPrettyPrintExample
//
//  Created by ogasawara on 2021/01/28.
//  Copyright © 2021 Yusuke Hosonuma. All rights reserved.
//
import ColorizeSwift
import SwiftPrettyPrint

prefix operator *
postfix operator *

extension String {
    /// Output a section heading to console and log files.
    /// - Parameter heading: a section heading
    /// # Reference
    /// [section method](x-source-tag://section)
    static prefix func * (heading: String) {
        section(heading)
    }

    /// Return the previous string as is.
    /// - Parameter heading: a section heading
    /// - Returns: String received as argument
    /// - Note: This postfix operator expresses in the source code that the preceding string is a heading. The prefix operator `*` alone is difficult to distinguish from the operator for multiplication when reading source codes.
    static postfix func * (heading: String) -> String {
        heading
    }
}

/// Output a section heading to console and log files.
/// - Parameter heading: a section heading
/// - Note: heading strings are displayed in bold on colored log files.
/// - Tag: section
func section(_ heading: String) {
    let separator = String(repeating: "-", count: heading.count + 2)
    let theme: ColorTheme = {
        var theme = ColorTheme.plain
        theme.stringLiteral = { $0.bold() }
        return theme
    }()
    let sectionOption = Debug.Option(theme: theme)

    Debug.print(
        """

        \(separator)
         \(heading)
        \(separator)

        """,
        option: sectionOption
    )
}
