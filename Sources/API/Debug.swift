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
        label: String? = nil,
        _ targets: Any...,
        separator: String = " "
    ) {
        Swift.print(_print(label: label, targets, separator: separator))
    }

    /// Output `targets` to `output`.
    /// - Parameters:
    ///   - target: targets
    ///   - separator: A string to print between each item.
    ///   - output: output
    public static func print<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        to output: inout Target
    ) {
        Swift.print(_print(label: label, targets, separator: separator), to: &output)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func prettyPrint(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption
    ) {
        Swift.print(_prettyPrint(label: label, targets, separator: separator, option: option))
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func prettyPrint<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_prettyPrint(label: label, targets, separator: separator, option: option), to: &output)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    public static func debugPrint(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " "
    ) {
        Swift.print(_debugPrint(label: label, targets, separator: separator))
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - output: output
    public static func debugPrint<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        to output: inout Target
    ) {
        Swift.print(_debugPrint(label: label, targets, separator: separator), to: &output)
    }

    /// Output debuggable and pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func debugPrettyPrint(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption
    ) {
        Swift.print(_debugPrettyPrint(label: label, targets, separator: separator, option: option))
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func debugPrettyPrint<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_debugPrettyPrint(label: label, targets, separator: separator, option: option), to: &output)
    }

    // MARK: - private

    private static func _print(
        label: String?,
        _ targets: [Any],
        separator: String
    ) -> String {
        let prefix = label.map { "\($0): " } ?? ""
        return prefix +
            targets.map {
                Pretty(formatter: SinglelineFormatter()).string($0, debug: false)
            }.joined(separator: separator)
    }

    private static func _prettyPrint(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        let prefix = label.map { "\($0):\n" } ?? ""
        return prefix +
            targets.map {
                Pretty(formatter: MultilineFormatter(option: option)).string($0, debug: false)
            }.joined(separator: separator)
    }

    private static func _debugPrint(
        label: String?,
        _ targets: [Any],
        separator: String
    ) -> String {
        let prefix = label.map { "\($0): " } ?? ""
        return prefix +
            targets.map {
                Pretty(formatter: SinglelineFormatter()).string($0, debug: true)
            }.joined(separator: separator)
    }

    private static func _debugPrettyPrint(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        let prefix = label.map { "\($0):\n" } ?? ""
        return prefix +
            targets.map {
                Pretty(formatter: MultilineFormatter(option: option)).string($0, debug: true)
            }.joined(separator: separator)
    }
}
