//
// PrettyDescriber.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

#if canImport(UIKit)
    import UIKit
    typealias UIComponent = UIResponder
#else
    import Foundation
    typealias UIComponent = AnyClass
#endif

#if canImport(SwiftUI)
    import SwiftUI
#endif

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
            let value = _string($0.value)

            if isSwiftUIPropertyWrapperType($0.value), let label = $0.label, label.first == "_" {
                return (String(label.dropFirst()), value) // e.g. `_text` -> `text`
            } else {
                return ($0.label ?? "-", value)
            }
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

    func isSwiftUIPropertyWrapperType(_ target: Any) -> Bool {
        let typeName = String(describing: target.self)
        return [
            "Published",
            "StateObject",
            "ObservedObject",
            "EnvironmentObject",
            "Environment",
            "State",
            "Binding",
            "AppStorage",
            "SceneStorage",
            "GestureState",
            "FocusState",
            "FocusedBinding",
        ].contains { typeName.hasPrefix("\($0)<") }
    }

    private func asValueString<T>(_ target: T, debug: Bool) -> String? {
        guard debug == false else { return nil }

        let children = Mirror(reflecting: target).children

        // Note:
        //
        // The conditions for being a `ValueObject`:
        // - has only one field
        // - that field is `Premitive`
        // - that filed is not property-wrapper of SwiftUI
        //
        if children.count == 1,
            let value = children.first?.value,
            isSwiftUIPropertyWrapperType(value) == false {
            return asPremitiveString(value, debug: debug)
        } else {
            return nil
        }
    }

    private func asPremitiveString<T>(_ target: T, debug: Bool) -> String? {
        //
        // SwiftUI Library
        //
        #if canImport(SwiftUI)
            func __string<T: Any>(_ target: T) -> String {
                string(target, debug: debug) // ☑️ Capture `debug`
            }

            let typeName = String(describing: target.self)

            let propertyWrappers: [(String, String)] = [
                ("Published", "currentValue"),
                ("StateObject", "wrappedValue"),
                ("ObservedObject", "wrappedValue"),
                ("EnvironmentObject", "_store"),
                ("State", "_value"),
                ("Binding", "_value"),
                ("GestureState", "_value"), // Lookup @State's value.
            ]

            for (type, key) in propertyWrappers {
                if typeName.hasPrefix("\(type)<"), let value = lookup(key, from: target) {
                    if debug {
                        // e.g. `@Published(42)`
                        return "@\(type)(\(__string(value)))"
                    } else {
                        return __string(value)
                    }
                }
            }

            //
            // @FocusedBinding
            //
            if typeName.hasPrefix("FocusedBinding<") {
                // Try lookup `_value` of `@Binding`.
                let value = lookup("_value", from: target).map(__string) ?? "nil"
                if debug {
                    return "@FocusedBinding(\(value))"
                } else {
                    return value
                }
            }

            //
            // @FocusState
            //
            // Note: Currently not getting values, but implemented to prevent infinite loops.
            //
            if typeName.hasPrefix("FocusState<") {
                // TODO: I don't know where to get the value of what's inside.
                if debug {
                    return "@FocusState(<can not lookup>)"
                } else {
                    return "<can not lookup>"
                }
            }

            //
            // @Environment
            //
            if typeName.hasPrefix("Environment<"),
                let content = lookup("content", from: target),
                let rawValue = Mirror(reflecting: content).children.first?.value {
                if debug {
                    return "@Environment(\(__string(rawValue)))"
                } else {
                    return __string(rawValue)
                }
            }

            //
            // @AppStorage
            //
            if typeName.hasPrefix("AppStorage<"), let key = lookup("key", from: target) as? String {
                let value = UserDefaults.standard.value(forKey: key) ?? "nil"

                if debug {
                    // e.g. `@AppStorage(key: "Number", userDefaultsValue: 42)`
                    return "@AppStorage(key: \"\(key)\", userDefaultsValue: \(__string(value)))"
                } else {
                    return __string(value)
                }
            }

            //
            // @SceneStorage
            //
            if #available(iOS 14, macOS 11.0,*),
                typeName.hasPrefix("SceneStorage<"),
                let key = lookup("_key", from: target) as? String {
                let value: String

                switch target {
                case let storage as SceneStorage<URL>:
                    value = __string(storage.wrappedValue)

                case let storage as SceneStorage<Int>:
                    value = __string(storage.wrappedValue)

                case let storage as SceneStorage<Double>:
                    value = __string(storage.wrappedValue)

                case let storage as SceneStorage<String>:
                    value = __string(storage.wrappedValue)

                case let storage as SceneStorage<Bool>:
                    value = __string(storage.wrappedValue)

                default:
                    //
                    // Can't lookup value that implemented `RawRepresentable` protocol.
                    //
                    if debug {
                        return "@SceneStorage(key: \"\(key)\", value: <can not lookup>)"
                    } else {
                        return "<can not lookup>"
                    }
                }

                if debug {
                    return "@SceneStorage(key: \"\(key)\", value: \(value))"
                } else {
                    return value
                }
            }
        #endif

        //
        // Swift Standard Library
        //
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
                #if !os(WASI)
                    f.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
                    f.timeZone = timeZone
                #endif
                return theme.type("Date") + #"("\#(f.string(from: date))")"#
            } else {
                let f = DateFormatter()
                #if !os(WASI)
                    f.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    f.timeZone = timeZone
                #endif
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
                    if #available(iOS 10.0, tvOS 10.0, *),
                        let _ = value as? UIComponent {
                        return nil
                    } else {
                        return value.description
                    }

                default:
                    return nil
                }
            } else {
                switch target {
                case let value as CustomStringConvertible:
                    if #available(iOS 10.0, tvOS 10.0, *),
                        let _ = value as? UIComponent {
                        return nil
                    } else {
                        return value.description
                    }

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

    private func lookup(_ key: String, from target: Any) -> Any? {
        for child in Mirror(reflecting: target).children {
            // 💡 Prevent infinite recursive call.
            guard let label = child.label else { continue }

            if label == key {
                return child.value
            } else {
                if let found = lookup(key, from: child.value) { // ☑️ Recursive call.
                    return found
                }
            }
        }
        return nil
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
