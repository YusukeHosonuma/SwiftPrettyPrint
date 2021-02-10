//
// PrettyDescriber.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import Foundation

struct PrettyDescriber {
    var formatter: PrettyFormatter
    var theme: ColorTheme = .plain
    var timeZone: TimeZone = .current

    func string<T: Any>(_ target: T, debug: Bool) -> String {
        func _string(_ target: Any) -> String {
            string(target, debug: debug)
        }

        let mirror = Mirror(reflecting: target)
        let typeName = String(describing: mirror.subjectType)

        if let displayStyle = mirror.displayStyle {
            switch displayStyle {
            case .optional:
                if let value = mirror.children.first?.value {
                    if debug {
                        return theme.type("Optional") + "(" + _string(value) + ")"
                    } else {
                        return _string(value)
                    }
                } else {
                    return theme.nil("nil")
                }

            case .collection:
                let elements = mirror.children.map { _string($0.value) }
                return formatter.collectionString(elements: elements)

            case .dictionary:
                return handleError {
                    let keysAndValues: [(String, String)] = try extractKeyValues(from: target).map { key, value in
                        (_string(key), _string(value))
                    }
                    return formatter.dictionaryString(keysAndValues: keysAndValues)
                }

            case .tuple:
                let elements: [(String?, String)] = mirror.children.map {
                    let label: String?
                    // if the labels of tuples are not specificated, it assigns the label like ".1" (not nil).
                    // Specifing "." as the first charactor of the label of tuple is prohibited.
                    if let nonNilLabel = $0.label, nonNilLabel.first != "." {
                        label = nonNilLabel
                    } else { label = nil }

                    return (label: label, value: _string($0.value))
                }
                return formatter.tupleString(elements: elements)

            case .enum:
                return handleError {
                    try enumString(target, debug: debug)
                }

            case .set:
                let elements = mirror.children.map { _string($0.value) }.sorted()
                let content = formatter.collectionString(elements: elements)

                if debug {
                    return theme.type("Set") + "(" + content + ")"
                } else {
                    return content
                }

            case .struct, .class: fallthrough
            @unknown default:
                break
            }
        }

        // Premitive
        if let value = asPremitiveString(target, debug: debug) {
            return value
        }

        // ValueObject
        if let value = asValueString(target, debug: debug) {
            return value
        }

        // Object
        let fields: [(String, String)] = mirror.children.map {
            ($0.label ?? "-", _string($0.value))
        }
        return formatter.objectString(typeName: typeName, fields: fields)
    }

    func extractKeyValues(from dictionary: Any) throws -> [(Any, Any)] {
        try Mirror(reflecting: dictionary).children.map {
            // Note:
            // Each element $0 structure are like following:
            //
            // ```
            // - label : nil
            // + value :          ->  `root`
            //   - key   : "Two"  ->  `key`
            //   - value : 2      ->  `value`
            // ```

            let root = Mirror(reflecting: $0.value)

            guard
                let key = root.children.first?.value,
                let value = root.children.dropFirst().first?.value
            else {
                throw PrettyDescriberError.failedExtractKeyValue(dictionary: dictionary)
            }

            return (key, value)
        }
    }

    private func asValueString<T>(_ target: T, debug: Bool) -> String? {
        // Note:
        // The conditions for being a `ValueObject`:
        // - has only one field
        // - that field is `Premitive`

        let mirror = Mirror(reflecting: target)

        guard !debug, mirror.children.count == 1 else { return nil }

        return mirror.children.first.flatMap { asPremitiveString($0.value, debug: debug) }
    }

    private func asPremitiveString<T>(_ target: T, debug: Bool) -> String? {
        switch target {
        case let value as String:
            return theme.string(#""\#(value)""#)

        case let url as URL:
            if debug {
                return theme.type("URL") + #"("\#(theme.url(url.absoluteString))")"#
            } else {
                return theme.url(url.absoluteString)
            }

        case let date as Date:
            if debug {
                let f = DateFormatter()
                f.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                f.timeZone = timeZone
                return theme.type("Date") + #"("\#(f.string(from: date))")"#
            } else {
                let f = DateFormatter()
                f.dateFormat = "yyyy-MM-dd HH:mm:ss"
                f.timeZone = timeZone
                return f.string(from: date)
            }

        case let bool as Bool:
            return theme.bool(bool ? "true" : "false")

        case is Int: fallthrough
        case is Float: fallthrough
        case is Double:
            return theme.number("\(target)")

        default:
            if debug {
                switch target {
                case let value as CustomDebugStringConvertible:
                    return value.debugDescription

                case let value as CustomStringConvertible:
                    return value.description

                default:
                    return nil
                }
            } else {
                switch target {
                case let value as CustomStringConvertible:
                    return value.description

                case let value as CustomDebugStringConvertible:
                    return value.debugDescription

                default:
                    return nil
                }
            }
        }
    }

    private func enumString(_ target: Any, debug: Bool) throws -> String {
        let mirror = Mirror(reflecting: target)
        let typeName = String(describing: mirror.subjectType)

        if mirror.children.count == 0 {
            if debug {
                return "\(typeName).\(target)"
            } else {
                return ".\(target)"
            }
        } else {
            guard let index = "\(target)".firstIndex(of: "(") else {
                throw PrettyDescriberError.unknownError(target: target)
            }

            let valueName = "\(target)"[..<index]

            let prefix: String
            if debug {
                prefix = "\(typeName).\(valueName)"
            } else {
                prefix = ".\(valueName)"
            }

            guard let childValue = mirror.children.first?.value else {
                throw PrettyDescriberError.unknownError(target: target)
            }

            let body = string(childValue, debug: debug)

            // Note:
            //
            // Remove enclosed parentheses when `childValue` are tuple.
            // (representation as `tuple` when `enum` has two or more associated-value or labeled)
            //
            // e.g.
            // - `Fruit.orange("みかん", 42)` - `body` is `("みかん", 42)` of tuple
            // - `Fruit.orange(juicy: true)` - `body` is `(juicy: 42)` of tuple
            //

            return "\(prefix)(" + body.removeEnclosedParentheses() + ")"
        }
    }

    private func handleError(_ f: () throws -> String) -> String {
        do {
            return try f()
        } catch {
            dumpError(error: error)
            return "\(error)"
        }
    }

    private func dumpError(error: Error) {
        let message = """

        ---------------------------------------------------------
        Fatal error in SwiftPrettyPrint.
        ---------------------------------------------------------
        \(error.localizedDescription)
        Please report issue from below:
        https://github.com/YusukeHosonuma/SwiftPrettyPrint/issues
        ---------------------------------------------------------

        """
        print(message)
    }
}
