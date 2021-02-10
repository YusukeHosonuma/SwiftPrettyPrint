//
//  ColoredElementVisitor.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2021/01/14.
//

import ColorizeSwift
import Foundation

public struct ColorTheme {
    public static let plain = ColorTheme(
        typeName: { $0 },
        nilLiteral: { $0 },
        boolLiteral: { $0 },
        stringLiteral: { $0 },
        numberLiteral: { $0 },
        url: { $0 }
    )
    public static let `default` = ColorTheme(
        typeName: { $0.green().bold() },
        nilLiteral: { $0.red() },
        boolLiteral: { $0.red() },
        stringLiteral: { $0.yellow() },
        numberLiteral: { $0.cyan() },
        url: { $0.blue().underline() }
    )

    public var typeName: (String) -> String
    public var nilLiteral: (String) -> String
    public var boolLiteral: (String) -> String
    public var stringLiteral: (String) -> String
    public var numberLiteral: (String) -> String
    public var url: (String) -> String

    public init(
        typeName: @escaping (String) -> String,
        nilLiteral: @escaping (String) -> String,
        boolLiteral: @escaping (String) -> String,
        stringLiteral: @escaping (String) -> String,
        numberLiteral: @escaping (String) -> String,
        url: @escaping (String) -> String
    ) {
        self.typeName = typeName
        self.nilLiteral = nilLiteral
        self.boolLiteral = boolLiteral
        self.stringLiteral = stringLiteral
        self.numberLiteral = numberLiteral
        self.url = url
    }
}
