//
// Pretty.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

#if canImport(os)
    import os.log
#endif

#if canImport(Foundation)
    import Foundation
#endif

public class Pretty {
    /// Global format option
    public static var sharedOption: Option = .init()

    static var plainLogStream = LogOutputStream(url: URL(fileURLWithPath: "/tmp/SwiftPrettyPrint/output.log"))
    static var coloredLogStream = LogOutputStream(url: URL(fileURLWithPath: "/tmp/SwiftPrettyPrint/output-colored.log"))

    private init() {}
}

// MARK: Standard API

extension Pretty {
    /// Output `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - colored: whether to apply the color theme in `option`.
    /// - Warning: Xcode doesn't support console coloring since Xcode 8
    public static func print(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Pretty.sharedOption
    ) {
        splatPrint(label: label, targets: targets, separator: separator, option: option)
    }

    /// Output `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    public static func splatPrint(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option
    ) {
        _output(printer: _print, label: label, targets, separator: separator, option: option)
    }

    /// Output `targets` to `output`.
    /// - Parameters:
    ///   - label: label
    ///   - target: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - colored: whether to apply the color theme in `option`.
    ///   - output: output
    public static func print<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Pretty.sharedOption,
        to output: inout Target
    ) {
        splatPrint(label: label, targets: targets, separator: separator, option: option, to: &output)
    }

    /// Output `targets` to `output`.
    /// - Parameters:
    ///   - label: label
    ///   - target: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - colored: whether to apply the color theme in `option`.
    ///   - output: output
    public static func splatPrint<Target: TextOutputStream>(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option,
        to output: inout Target
    ) {
        let plain = _print(label: label, targets, separator: separator, option: option)
        Swift.print(plain, to: &output)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - colored: whether to apply the color theme in `option`.
    /// - Warning: Xcode doesn't support console coloring since Xcode 8
    public static func prettyPrint(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Pretty.sharedOption
    ) {
        splatPrettyPrint(label: label, targets: targets, separator: separator, option: option)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    public static func splatPrettyPrint(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option
    ) {
        _output(printer: _prettyPrint, label: label, targets, separator: separator, option: option)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - output: output
    public static func prettyPrint<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Pretty.sharedOption,
        to output: inout Target
    ) {
        splatPrettyPrint(label: label, targets: targets, separator: separator, option: option, to: &output)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - output: output
    public static func splatPrettyPrint<Target: TextOutputStream>(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option,
        to output: inout Target
    ) {
        let plain = _prettyPrint(label: label, targets, separator: separator, option: option)
        Swift.print(plain, to: &output)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - colored: whether to apply the color theme in `option`.
    /// - Warning: Xcode doesn't support console coloring since Xcode 8
    public static func printDebug(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Pretty.sharedOption
    ) {
        splatPrintDebug(label: label, targets: targets, separator: separator, option: option)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    public static func splatPrintDebug(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option
    ) {
        _output(printer: _printDebug, label: label, targets, separator: separator, option: option)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - output: output
    public static func printDebug<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Pretty.sharedOption,
        to output: inout Target
    ) {
        splatPrintDebug(label: label, targets: targets, separator: separator, option: option, to: &output)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - output: output
    public static func splatPrintDebug<Target: TextOutputStream>(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option,
        to output: inout Target
    ) {
        let plain = _printDebug(label: label, targets, separator: separator, option: option)
        Swift.print(plain, to: &output)
    }

    /// Output debuggable and pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - colored: whether to apply the color theme in `option`.
    /// - Warning: Xcode doesn't support console coloring since Xcode 8
    public static func prettyPrintDebug(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Pretty.sharedOption
    ) {
        splatPrettyPrintDebug(label: label, targets: targets, separator: separator, option: option)
    }

    /// Output debuggable and pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    public static func splatPrettyPrintDebug(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option
    ) {
        _output(printer: _prettyPrintDebug, label: label, targets, separator: separator, option: option)
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - output: output
    public static func prettyPrintDebug<Target: TextOutputStream>(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Pretty.sharedOption,
        to output: inout Target
    ) {
        splatPrettyPrintDebug(label: label, targets: targets, separator: separator, option: option, to: &output)
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    ///   - output: output
    public static func splatPrettyPrintDebug<Target: TextOutputStream>(
        label: String?,
        targets: [Any],
        separator: String,
        option: Option,
        to output: inout Target
    ) {
        let plain = _prettyPrintDebug(label: label, targets, separator: separator, option: option)
        Swift.print(plain, to: &output)
    }

    // MARK: - private

    private typealias Printer = (String?, [Any], String, Option) -> String

    private static func _output(
        printer: Printer,
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) {
        let plainString = printer(label, targets, separator, option)

        var coloredOption = option
        coloredOption.colored = true
        let coloredString = printer(label, targets, separator, coloredOption)

        // Console
        Swift.print(option.colored ? coloredString : plainString)

        // OS Log
        #if canImport(os)
            if option.outputStrategy == .osLog, #available(OSX 10.14, iOS 12.0, *) {
                os_log(.default, "%@", plainString)
                return
            }
        #endif

        // Log files
        #if targetEnvironment(simulator) || os(macOS)
            Swift.print(plainString + "\n", to: &plainLogStream)
            Swift.print(coloredString + "\n", to: &coloredLogStream)
        #endif
    }

    private static func _print(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) -> String {
        prefixLabel(option.prefix, label) +
            targets.map {
                PrettyDescriber.singleline(option: option).string($0, debug: false)
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
                PrettyDescriber.multiline(option: option).string($0, debug: false)
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
                PrettyDescriber.singleline(option: option).string($0, debug: true)
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
                PrettyDescriber.multiline(option: option).string($0, debug: true)
            }.joined(separator: separator)
    }
}

extension PrettyDescriber {
    static func singleline(option: Pretty.Option) -> PrettyDescriber {
        let theme = option.colored ? option.theme : .plain
        return PrettyDescriber(formatter: SinglelineFormatter(theme: theme), theme: theme)
    }

    static func multiline(option: Pretty.Option) -> PrettyDescriber {
        let theme = option.colored ? option.theme : .plain
        return PrettyDescriber(formatter: MultilineFormatter(indentSize: option.indentSize, theme: theme), theme: theme)
    }
}
