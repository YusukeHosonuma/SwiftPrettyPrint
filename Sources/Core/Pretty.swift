struct Pretty {
    let option: Option

    private var indent: Int { option.indent }

    /// Get pretty string for `target`.
    /// - Parameters:
    ///   - target: target
    ///   - debug: Enable debug-level output if `true` (like `debugPrint`)
    ///   - pretty: Enable pretty output if `true`
    func string<T: Any>(_ target: T, debug: Bool, pretty: Bool) -> String {
        func _string(_ target: Any) -> String {
            string(target, debug: debug, pretty: pretty) // fixed `debug` and `pretty`
        }

        func _value(_ target: Any) -> String {
            valueString(target, debug: debug) // fixed `debug`
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
            if pretty {
                let contents = extractKeyValues(from: target).map { key, val in
                    let label = _value(key)
                    let value = _string(val).indentTail(size: "\(label): ".count)
                    return "\(label): \(value)"
                }.sorted().joined(separator: ",\n")

                return "[\n\(contents.indent(size: indent))\n]"
            } else {
                let contents = extractKeyValues(from: target).map { key, val in
                    let label = _value(key)
                    let value = _string(val)
                    return "\(label): \(value)"
                }.sorted().joined(separator: ", ")

                return "[\(contents)]"
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

        // Other
        let typeName = String(describing: mirror.subjectType)

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

    func valueString<T>(_ target: T, debug: Bool) -> String {
        let mirror = Mirror(reflecting: target)

        // Note: this function currently supports Optional type that includes a child.
        guard mirror.children.count <= 1 else {
            // TODO: change to safe-api when official release
            preconditionFailure("valueString() is must value that not has members")
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
            preconditionFailure("Not supported type")
        }
    }

    func extractKeyValues(from dictionary: Any) -> [(Any, Any)] {
        Mirror(reflecting: dictionary).children.map {
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
                preconditionFailure("Extract key or value is failed.")
            }

            return (key, value)
        }
    }
}
