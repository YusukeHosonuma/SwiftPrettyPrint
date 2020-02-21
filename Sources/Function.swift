// MARK: - print

func elementString<T: Any>(_ target: T, debug: Bool, pretty: Bool) -> String {
    let mirror = Mirror(reflecting: target)

    // Optional / Collection / Dictionary
    switch mirror.displayStyle {
    case .optional:
        return valueString(target, debug: debug)

    case .collection:
        let elements = mirror.children.map { elementString($0.value, debug: debug, pretty: pretty) }
        if pretty {
            return """
            [
            \(elements.joined(separator: ",\n").indent(size: 4))
            ]
            """
        } else {
            return "[\(elements.joined(separator: ", "))]"
        }

    case .dictionary:
        if pretty {
            let contents = extractKeyValues(from: target).map { key, val in
                let label = valueString(key, debug: debug)
                let value = elementString(val, debug: debug, pretty: pretty).indentTail(size: "\(label): ".count)
                return "\(label): \(value)"
            }.sorted().joined(separator: ",\n")

            return "[\n\(contents.indent(size: 4))\n]"
        } else {
            let contents = extractKeyValues(from: target).map { key, val in
                let label = valueString(key, debug: debug)
                let value = elementString(val, debug: debug, pretty: pretty)
                return "\(label): \(value)"
            }.sorted().joined(separator: ", ")

            return "[\(contents)]"
        }

    default:
        break
    }

    // Empty
    if mirror.children.count == 0 {
        return valueString(target, debug: debug)
    }

    // ValueObject
    if !debug, mirror.children.count == 1, let value = mirror.children.first?.value {
        return valueString(value, debug: debug)
    }

    // Other
    let typeName = String(describing: mirror.subjectType)

    let prefix = "\(typeName)("
    let fields = mirror.children.map {
        "\($0.label ?? "-"): " + elementString($0.value, debug: debug, pretty: pretty) // recursive call
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
