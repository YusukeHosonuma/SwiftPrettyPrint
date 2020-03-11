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
    public static func print(_ target: Any) {
        Swift.print(_print(target))
    }

    /// Output `target` to `output`.
    /// - Parameters:
    ///   - target: target
    ///   - output: output
    public static func print<Target: TextOutputStream>(_ target: Any, to output: inout Target) {
        Swift.print(_print(target), to: &output)
    }

    /// Output pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    public static func prettyPrint(_ target: Any, option: Option = Debug.sharedOption) {
        Swift.print(_prettyPrint(target, option: option))
    }

    /// Output pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func prettyPrint<Target: TextOutputStream>(_ target: Any, option: Option = Debug.sharedOption, to output: inout Target) {
        Swift.print(_prettyPrint(target, option: option), to: &output)
    }

    /// Output debuggable `target` to console.
    /// - Parameters:
    ///   - target: target
    public static func debugPrint(_ target: Any) {
        Swift.print(_debugPrint(target))
    }

    /// Output debuggable `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - output: output
    public static func debugPrint<Target: TextOutputStream>(_ target: Any, to output: inout Target) {
        Swift.print(_debugPrint(target), to: &output)
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    public static func debugPrettyPrint(_ target: Any, option: Option = Debug.sharedOption) {
        Swift.print(_debugPrettyPrint(target, option: option))
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func debugPrettyPrint<Target: TextOutputStream>(_ target: Any, option: Option = Debug.sharedOption, to output: inout Target) {
        Swift.print(_debugPrettyPrint(target, option: option), to: &output)
    }

    // MARK: - private

    private static func _print(_ target: Any) -> String {
        Pretty(formatter: SinglelineFormatter()).string(target, debug: false)
    }

    private static func _prettyPrint(_ target: Any, option: Option) -> String {
        Pretty(formatter: MultilineFormatter(option: option)).string(target, debug: false)
    }

    private static func _debugPrint(_ target: Any) -> String {
        Pretty(formatter: SinglelineFormatter()).string(target, debug: true)
    }

    private static func _debugPrettyPrint(_ target: Any, option: Option) -> String {
        Pretty(formatter: MultilineFormatter(option: option)).string(target, debug: true)
    }
}
