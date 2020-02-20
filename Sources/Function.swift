// MARK: - print

func elementString<T: Any>(_ x: T, debug: Bool, pretty: Bool) -> String {
    let mirror = Mirror(reflecting: x)

    let typeName = String(describing: mirror.subjectType)

    // Optional / Collection / Dictionary
    switch mirror.displayStyle {
    case .optional:
        return valueString(x, debug: debug)

    case .collection:
        if pretty {
            let contents = mirror.children
                .map { elementString($0.value, debug: debug, pretty: pretty) }
                .joined(separator: ",\n")
            return "[\n\(contents.indent(size: 4))\n]"
        } else {
            let contents = mirror.children
                .map { elementString($0.value, debug: debug, pretty: pretty) }
                .joined(separator: ", ")
            return "[\(contents)]"
        }

    case .dictionary:
        if pretty {
            let contents = extractKeyValues(from: x).map { key, val in
                let label = valueString(key, debug: debug)
                var value = elementString(val, debug: debug, pretty: pretty)
                if let head = value.lines.first {
                    value = head + "\n" + value.lines.dropFirst().joined(separator: "\n").indent(size: "\(label): ".count)
                }
                return "\(label): \(value)"
            }.sorted().joined(separator: ",\n")

            return "[\n\(contents.indent(size: 4))\n]"
        } else {
            let contents = extractKeyValues(from: x).map { key, val in
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
        return valueString(x, debug: debug)
    }

    // ValueObject
    if mirror.children.count == 1, !debug {
        let value = mirror.children.first!.value // TODO: change to safe-api when official release
        return valueString(value, debug: debug)
    }

    // Other
    let prefix = "\(typeName)("
    let fields = mirror.children.map {
        "\($0.label ?? "-"): " + elementString($0.value, debug: debug, pretty: pretty) // recursive call
    }

    if pretty, fields.count > 1 {
        let tailFields = fields.dropFirst()
            .map { $0.indent(size: prefix.count) }
            .joined(separator: ",\n")

        return "\(prefix)\(fields.first!),\n\(tailFields))"
    } else {
        return "\(prefix)\(fields.joined(separator: ", ")))"
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
        let key = Mirror(reflecting: $0.value).children.first!.value
        let value = Mirror(reflecting: $0.value).children.dropFirst().first!.value
        return (key, value)
    }
}
