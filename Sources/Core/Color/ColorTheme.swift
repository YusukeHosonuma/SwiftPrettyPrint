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
        type: { $0 },
        nil: { $0 },
        bool: { $0 },
        string: { $0 },
        number: { $0 },
        url: { $0 }
    )

    public static let `default` = ColorTheme(
        type: { $0.green().bold() },
        nil: { $0.red() },
        bool: { $0.red() },
        string: { $0.yellow() },
        number: { $0.cyan() },
        url: { $0.blue().underline() }
    )

    public var type: (String) -> String
    public var `nil`: (String) -> String
    public var bool: (String) -> String
    public var string: (String) -> String
    public var number: (String) -> String
    public var url: (String) -> String

    public init(
        type: @escaping (String) -> String,
        nil: @escaping (String) -> String,
        bool: @escaping (String) -> String,
        string: @escaping (String) -> String,
        number: @escaping (String) -> String,
        url: @escaping (String) -> String
    ) {
        self.type = type
        self.nil = `nil`
        self.bool = bool
        self.string = string
        self.number = number
        self.url = url
    }
}
