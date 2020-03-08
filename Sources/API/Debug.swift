//
// Debug.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

public class Debug {
    /// Default format option
    public static let defaultOption = Option(indent: 4)

    /// Global format option
    public static var sharedOption: Option = Debug.defaultOption

    private init() {}
}

private func withPrint(f: () -> String) -> String {
    let string = f()
    Swift.print(string)
    return string
}

// MARK: Standard API

extension Debug {
    /// Output `target` to console.
    /// - Parameters:
    ///   - target: target
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func print(_ target: Any) -> String {
        withPrint {
            Pretty(formatter: SinglelineFormatter()).string(target, debug: false)
        }
    }

    /// Output pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func prettyPrint(_ target: Any, option: Option = Debug.sharedOption) -> String {
        withPrint {
            Pretty(formatter: MultilineFormatter(option: option)).string(target, debug: false)
        }
    }

    /// Output debuggable `target` to console.
    /// - Parameters:
    ///   - target: target
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func debugPrint(_ target: Any) -> String {
        withPrint {
            Pretty(formatter: SinglelineFormatter()).string(target, debug: true)
        }
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func debugPrettyPrint(_ target: Any, option: Option = Debug.sharedOption) -> String {
        withPrint {
            Pretty(formatter: MultilineFormatter(option: option)).string(target, debug: true)
        }
    }
}
