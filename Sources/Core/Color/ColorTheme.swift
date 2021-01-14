//
//  ColoredElementVisitor.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2021/01/14.
//

import ColorizeSwift
import Foundation

public struct ColorTheme {
    public static let plain = ColorTheme()
    public static let `default` = ColorTheme(
        typeName: { $0.yellow() },
        nilLiteral: { $0.red() },
        boolLiteral: { $0.blue() },
        stringLiteral: { $0.cyan() },
        numberLiteral: { $0.green() }
    )

    public var typeName: (String) -> String = { $0 }
    public var nilLiteral: (String) -> String = { $0 }
    public var boolLiteral: (String) -> String = { $0 }
    public var stringLiteral: (String) -> String = { $0 }
    public var numberLiteral: (String) -> String = { $0 }
}
