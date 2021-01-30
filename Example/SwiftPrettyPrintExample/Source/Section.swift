//
//  Section.swift
//  SwiftPrettyPrintExample
//
//  Created by ogasawara on 2021/01/28.
//  Copyright © 2021 Yusuke Hosonuma. All rights reserved.
//
import ColorizeSwift
import SwiftPrettyPrint

/// Output a section heading to console and log files.
/// - Parameter heading: a section heading
/// - Note: heading strings are displayed in bold on colored log files.
/// - Tag: section
func printSection(_ heading: String) {
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
