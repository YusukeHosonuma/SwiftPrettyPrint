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

// MARK: Standard API

extension Debug {
    /// Output `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    public static func print(
        _ targets: Any...,
        separator: String = " "
    ) {
        Swift.print(_print(targets, separator: separator))
    }

    /// Output `targets` to `output`.
    /// - Parameters:
    ///   - target: targets
    ///   - separator: A string to print between each item.
    ///   - output: output
    public static func print<Target: TextOutputStream>(
        _ targets: Any...,
        separator: String = " ",
        to output: inout Target
    ) {
        Swift.print(_print(targets, separator: separator), to: &output)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func prettyPrint(
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption
    ) {
        Swift.print(_prettyPrint(targets, separator: separator, option: option))
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func prettyPrint<Target: TextOutputStream>(
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_prettyPrint(targets, separator: separator, option: option), to: &output)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    public static func debugPrint(
        _ targets: Any...,
        separator: String = " "
    ) {
        Swift.print(_debugPrint(targets, separator: separator))
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - output: output
    public static func debugPrint<Target: TextOutputStream>(
        _ targets: Any...,
        separator: String = " ",
        to output: inout Target
    ) {
        Swift.print(_debugPrint(targets, separator: separator), to: &output)
    }

    /// Output debuggable and pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func debugPrettyPrint(
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption
    ) {
        Swift.print(_debugPrettyPrint(targets, separator: separator, option: option))
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func debugPrettyPrint<Target: TextOutputStream>(
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_debugPrettyPrint(targets, separator: separator, option: option), to: &output)
    }

    // MARK: - private

    private static func _print(
        _ targets: [Any],
        separator: String
    ) -> String {
        targets.map {
            Pretty(formatter: SinglelineFormatter()).string($0, debug: false)
        }.joined(separator: separator)
    }

    private static func _prettyPrint(
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        targets.map {
            Pretty(formatter: MultilineFormatter(option: option)).string($0, debug: false)
        }.joined(separator: separator)
    }

    private static func _debugPrint(
        _ targets: [Any],
        separator: String
    ) -> String {
        targets.map {
            Pretty(formatter: SinglelineFormatter()).string($0, debug: true)
        }.joined(separator: separator)
    }

    private static func _debugPrettyPrint(
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        targets.map {
            Pretty(formatter: MultilineFormatter(option: option)).string($0, debug: true)
        }.joined(separator: separator)
    }
}
