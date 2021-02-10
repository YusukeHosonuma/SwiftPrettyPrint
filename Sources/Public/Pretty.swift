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
    public static func print(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Pretty.sharedOption
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
        colored: Bool = false,
        to output: inout Target
    ) {
        let plain = _print(label: label, targets, separator: separator, option: option, colored: colored)
        Swift.print(plain, to: &output)
    }

    /// Output pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    public static func prettyPrint(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Pretty.sharedOption
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
        colored: Bool = false,
        to output: inout Target
    ) {
        let plain = _prettyPrint(label: label, targets, separator: separator, option: option, colored: colored)
        Swift.print(plain, to: &output)
    }

    /// Output debuggable `targets` to console.
    /// - Parameters:
    ///   - label: label
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    public static func printDebug(
        label: String? = nil,
        _ targets: Any...,
        separator: String = " ",
        option: Option = Pretty.sharedOption
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
        let plain = _printDebug(label: label, targets, separator: separator, option: option, colored: false)
        Swift.print(plain, to: &output)
    }

    /// Output debuggable and pretty-formatted `targets` to console.
    /// - Parameters:
    ///   - targets: targets
    ///   - separator: A string to print between each item.
    ///   - option: option (default: `Pretty.sharedOption`)
    public static func prettyPrintDebug(
        label: String? = nil,
        _ targets: Any...,
        separator: String = "\n",
        option: Option = Pretty.sharedOption
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
        let plain = _prettyPrintDebug(label: label, targets, separator: separator, option: option, colored: false)
        Swift.print(plain, to: &output)
    }

    // MARK: - private

    private typealias Printer = (String?, [Any], String, Option, Bool) -> String

    private static func _output(
        printer: Printer,
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option
    ) {
        let plain = printer(label, targets, separator, option, false)
        let colored = printer(label, targets, separator, option, true)

        // Console
        Swift.print(plain)

        // OS Log
        #if canImport(os)
            if option.outputStrategy == .osLog, #available(OSX 10.14, iOS 12.0, *) {
                os_log(.default, "%@", plain)
                return
            }
        #endif

        // Log files
        #if targetEnvironment(simulator) || os(macOS)
            Swift.print(plain + "\n", to: &plainLogStream)
            Swift.print(colored + "\n", to: &coloredLogStream)
        #endif
    }

    private static func _print(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option,
        colored: Bool
    ) -> String {
        prefixLabel(option.prefix, label) +
            targets.map {
                PrettyDescriber.singleline(option: option, colored: colored).string($0, debug: false)
            }.joined(separator: separator)
    }

    private static func _prettyPrint(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option,
        colored: Bool
    ) -> String {
        prefixLabelPretty(option.prefix, label) +
            targets.map {
                PrettyDescriber.multiline(option: option, colored: colored).string($0, debug: false)
            }.joined(separator: separator)
    }

    private static func _printDebug(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option,
        colored: Bool
    ) -> String {
        prefixLabel(option.prefix, label) +
            targets.map {
                PrettyDescriber.singleline(option: option, colored: colored).string($0, debug: true)
            }.joined(separator: separator)
    }

    private static func _prettyPrintDebug(
        label: String?,
        _ targets: [Any],
        separator: String,
        option: Option,
        colored: Bool
    ) -> String {
        prefixLabelPretty(option.prefix, label) +
            targets.map {
                PrettyDescriber.multiline(option: option, colored: colored).string($0, debug: true)
            }.joined(separator: separator)
    }
}

extension PrettyDescriber {
    static func singleline(option: Pretty.Option, colored: Bool) -> PrettyDescriber {
        let theme = colored ? option.theme : .plain
        return PrettyDescriber(formatter: SinglelineFormatter(theme: theme), theme: theme)
    }

    static func multiline(option: Pretty.Option, colored: Bool) -> PrettyDescriber {
        let theme = colored ? option.theme : .plain
        return PrettyDescriber(formatter: MultilineFormatter(indentSize: option.indentSize, theme: theme), theme: theme)
    }
}
