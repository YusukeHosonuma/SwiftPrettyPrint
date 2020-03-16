//
// Pretty.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import Foundation

struct Pretty {
    let formatter: PrettyFormatter

    func string<T: Any>(_ target: T, debug: Bool) -> String {
        func _string(_ target: Any) -> String {
            string(target, debug: debug)
        }

        func _value(_ target: Any) -> String {
            handleError { try valueString(target, debug: debug) }
        }

        let mirror = Mirror(reflecting: target)
        let typeName = String(describing: mirror.subjectType)

        if let displayStyle = mirror.displayStyle {
            switch displayStyle {
            case .optional:
                return _value(target)

            case .collection:
                let elements = mirror.children.map { _string($0.value) }
                return formatter.collectionString(elements: elements)

            case .dictionary:
                return handleError {
                    let keysAndValues: [(String, String)] = try extractKeyValues(from: target).map { key, value in
                        (_value(key), _string(value))
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
                    return "Set(" + content + ")"
                } else {
                    return content
                }

            case .struct, .class: fallthrough
            @unknown default:
                break
            }
        }

        // Empty
        if mirror.children.count == 0 {
            return _value(target)
        }

        // ValueObject
        if !debug, mirror.children.count == 1, let value = mirror.children.first?.value {
            return _value(value)
        }

        // Swift.URL
        if typeName == "URL" {
            return handleError {
                guard
                    let field = mirror.children.first?.value as? NSURL,
                    let urlString = field.absoluteString else {
                    throw PrettyError.unknownError(target: target)
                }

                return #"URL("\#(urlString)")"#
            }
        }

        // Object
        let fields: [(String, String)] = mirror.children.map {
            ($0.label ?? "-", _string($0.value))
        }
        return formatter.objectString(typeName: typeName, fields: fields)
    }

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
                throw PrettyError.unknownError(target: target)
            }

            let valueName = "\(target)"[..<index]

            let prefix: String
            if debug {
                prefix = "\(typeName).\(valueName)"
            } else {
                prefix = ".\(valueName)"
            }

            guard let childValue = mirror.children.first?.value else {
                throw PrettyError.unknownError(target: target)
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
