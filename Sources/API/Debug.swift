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
    public static func print(
        _ targets: Any...
    ) {
        Swift.print(_print(targets))
    }

    /// Output `targets` to `output`.
    /// - Parameters:
    ///   - target: targets
    ///   - output: output
    public static func print<Target: TextOutputStream>(
        _ targets: Any...,
        to output: inout Target
    ) {
        Swift.print(_print(targets), to: &output)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - option: option (default: `Debug.sharedOption`)
    public static func prettyPrint(
        _ targets: Any...,
        option: Option = Debug.sharedOption
    ) {
        Swift.print(_prettyPrint(targets, option: option))
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func prettyPrint<Target: TextOutputStream>(
        _ targets: Any...,
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_prettyPrint(targets, option: option), to: &output)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    public static func debugPrint(
        _ targets: Any...
    ) {
        Swift.print(_debugPrint(targets))
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - output: output
    public static func debugPrint<Target: TextOutputStream>(
        _ targets: Any...,
        to output: inout Target
    ) {
        Swift.print(_debugPrint(targets), to: &output)
    }

    /// Output debuggable and pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - option: option (default: `Debug.sharedOption`)
    public static func debugPrettyPrint(
        _ targets: Any...,
        option: Option = Debug.sharedOption
    ) {
        Swift.print(_debugPrettyPrint(targets, option: option))
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func debugPrettyPrint<Target: TextOutputStream>(
        _ targets: Any...,
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_debugPrettyPrint(targets, option: option), to: &output)
    }

    // MARK: - private

    private static func _print(
        _ targets: [Any]
    ) -> String {
        targets.map {
            Pretty(formatter: SinglelineFormatter()).string($0, debug: false)
        }.joined(separator: " ")
    }

    private static func _prettyPrint(
        _ targets: [Any],
        option: Option
    ) -> String {
        targets.map {
            Pretty(formatter: MultilineFormatter(option: option)).string($0, debug: false)
        }.joined(separator: ",\n")
    }

    private static func _debugPrint(
        _ targets: [Any]
    ) -> String {
        targets.map {
            Pretty(formatter: SinglelineFormatter()).string($0, debug: true)
        }.joined(separator: " ")
    }

    private static func _debugPrettyPrint(
        _ targets: [Any],
        option: Option
    ) -> String {
        targets.map {
            Pretty(formatter: MultilineFormatter(option: option)).string($0, debug: true)
        }.joined(separator: ",\n")
    }
}
