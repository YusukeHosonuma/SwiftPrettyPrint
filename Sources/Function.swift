// MARK: - print

func elementString<T: Any>(_ x: T, debug: Bool, pretty: Bool) -> String {
    let mirror = Mirror(reflecting: x)

    let typeName = String(describing: mirror.subjectType)

    // Empty
    if mirror.children.count == 0 {
        return valueString(x, debug: debug)
    }

    // Optional
    if case .optional = mirror.displayStyle {
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

func arrayString<T>(_ xs: [T], debug: Bool, pretty: Bool) -> String {
    let contents = xs.map { elementString($0, debug: debug, pretty: pretty) }.joined(separator: ", ")
    return "[\(contents)]"
}

func dictionaryString<K, V>(_ d: [K: V], debug: Bool, pretty: Bool) -> String {
    let contents = d.map {
        let key = valueString($0.key, debug: debug)
        let value = elementString($0.value, debug: debug, pretty: pretty)
        return "\(key): \(value)"
    }.sorted().joined(separator: ", ")

    return "[\(contents)]"
}

// MARK: - pretty-print

func prettyElementString<T>(_ x: T, debug: Bool = false) -> String {
    elementString(x, debug: debug, pretty: true)
}

func prettyArrayString<T>(_ xs: [T], debug: Bool = false) -> String {
    let contents = xs.map { prettyElementString($0, debug: debug) }.joined(separator: ",\n")
    return "[\n\(contents.indent(size: 4))\n]"
}

func prettyDictionaryString<K, V>(_ d: [K: V], debug: Bool) -> String {
    let contents = d.map {
        let key = valueString($0.key, debug: debug)
        var value = prettyElementString($0.value, debug: debug)

        if let head = value.lines.first {
            value = head + "\n" + value.lines.dropFirst().joined(separator: "\n").indent(size: 9)
        }
        return "\(key): \(value)"
    }.sorted().joined(separator: ",\n")

    return "[\n\(contents.indent(size: 4))\n]"
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
