//
// Debug.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import Foundation
import os.log

public class Debug {
    /// Global format option
    public static var sharedOption: Option = .init()

    private init() {}
}

// MARK: Standard API

extension Debug {
    /// Output `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func print(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Debug.sharedOption
    ) {
        log(message: _print(label: label, targets, separator: separator, option: option))
    }

    /// Output `targets` to `output`.
    /// - Parameters:
    ///   - label: label
    ///   - target: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func print<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_print(label: label, targets, separator: separator, option: option), to: &output)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func prettyPrint(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption
    ) {
        log(message: _prettyPrint(label: label, targets, separator: separator, option: option))
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - label: label
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
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func printDebug(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Debug.sharedOption
    ) {
        log(message: _printDebug(label: label, targets, separator: separator, option: option))
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func printDebug<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_printDebug(label: label, targets, separator: separator, option: option), to: &output)
    }

    /// Output debuggable and pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    public static func prettyPrintDebug(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption
    ) {
        log(message: _prettyPrintDebug(label: label, targets, separator: separator, option: option))
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Debug.sharedOption`)
    ///   - output: output
    public static func prettyPrintDebug<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Debug.sharedOption,
        to output: inout Target
    ) {
        Swift.print(_prettyPrintDebug(label: label, targets, separator: separator, option: option), to: &output)
    }

    // MARK: - private

    private static func log(message: String) {
        #if canImport(Foundation)
            if sharedOption.isConsoleUsed, #available(OSX 10.12, iOS 10.0, *) {
                os_log("%@", type: .debug, message)
                return
            }
        #endif

        Swift.print(message)
    }

    private static func _print(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        prefixLabel(option.prefix, label) +
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
        prefixLabelPretty(option.prefix, label) +
            targets.map {
                Pretty(formatter: MultilineFormatter(indentSize: option.indentSize)).string($0, debug: false)
            }.joined(separator: separator)
    }

    private static func _printDebug(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        prefixLabel(option.prefix, label) +
            targets.map {
                Pretty(formatter: SinglelineFormatter()).string($0, debug: true)
            }.joined(separator: separator)
    }

    private static func _prettyPrintDebug(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        prefixLabelPretty(option.prefix, label) +
            targets.map {
                Pretty(formatter: MultilineFormatter(indentSize: option.indentSize)).string($0, debug: true)
            }.joined(separator: separator)
    }
}
