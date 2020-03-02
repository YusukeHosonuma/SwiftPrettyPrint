//
// Pretty.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import Foundation

struct Pretty {
    let option: Debug.Option

    private var indent: Int { option.indent }

    /// Get pretty string for `target`.
    /// - Parameters:
    ///   - target: target
    ///   - debug: Enable debug-level output if `true` (like `debugPrint`)
    ///   - pretty: Enable pretty output if `true`
    func string<T: Any>(_ target: T, debug: Bool, pretty: Bool) -> String {
        func _handleError(_ f: () throws -> String) -> String {
            do {
                return try f()
            } catch {
                dumpError(error: error)
                return "\(error)"
            }
        }

        func _string(_ target: Any) -> String {
            string(target, debug: debug, pretty: pretty)
        }

        func _value(_ target: Any) -> String {
            _handleError { try valueString(target, debug: debug) }
        }

        let mirror = Mirror(reflecting: target)

        // Optional / Collection / Dictionary
        switch mirror.displayStyle {
        case .optional:
            return _value(target)

        case .collection:
            let elements = mirror.children.map { _string($0.value) }
            if pretty {
                return """
                [
                \(elements.joined(separator: ",\n").indent(size: indent))
                ]
                """
            } else {
                return "[\(elements.joined(separator: ", "))]"
            }

        case .dictionary:
            return _handleError {
                if pretty {
                    let contents = try extractKeyValues(from: target).map { key, val in
                        let label = _value(key)
                        let value = _string(val).indentTail(size: "\(label): ".count)
                        return "\(label): \(value)"
                    }.sorted().joined(separator: ",\n")

                    return "[\n\(contents.indent(size: indent))\n]"
                } else {
                    let contents = try extractKeyValues(from: target).map { key, val in
                        let label = _value(key)
                        let value = _string(val)
                        return "\(label): \(value)"
                    }.sorted().joined(separator: ", ")

                    return "[\(contents)]"
                }
            }

        default:
            break
        }

        // Empty
        if mirror.children.count == 0 {
            return _value(target)
        }

        // ValueObject
        if !debug, mirror.children.count == 1, let value = mirror.children.first?.value {
            return _value(value)
        }

        let typeName = String(describing: mirror.subjectType)

        // Swift.URL
        if typeName == "URL" {
            return _handleError {
                guard
                    let field = mirror.children.first?.value as? NSURL,
                    let urlString = field.absoluteString else {
                    throw PrettyError.unknownError(target: target)
                }

                return #"URL("\#(urlString)")"#
            }
        }

        let prefix = "\(typeName)("

        let fields = mirror.children.map {
            "\($0.label ?? "-"): " + _string($0.value)
        }

        if pretty, fields.count > 1 {
            let contents = prefix + fields.joined(separator: ",\n") + ")"
            return contents.indentTail(size: prefix.count)
        } else {
            return prefix + fields.joined(separator: ", ") + ")"
        }
    }

    // MARK: - util

    func valueString<T>(_ target: T, debug: Bool) throws -> String {
        let mirror = Mirror(reflecting: target)

        // Note: this function currently supports Optional type that includes a child.
        guard mirror.children.count <= 1 else {
            throw PrettyError.unknownError(target: target)
        }

        switch target {
        case let value as CustomDebugStringConvertible where debug:
            return value.debugDescription

        case let value as CustomStringConvertible:
            if let string = value as? String {
                return "\"\(string)\""
            } else {
                return value.description
            }

        case let value as T?:
            if let value = value {
                if let string = value as? String {
                    return "\"\(string)\""
                } else {
                    return "\(value)"
                }
            } else {
                return "nil"
            }

        default:
            throw PrettyError.notSupported(target: target)
        }
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
                let value = root.children.dropFirst().first?.value else {
                throw PrettyError.failedExtractKeyValue(dictionary: dictionary)
            }

            return (key, value)
        }
    }

    func dumpError(error: Error) {
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
