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
                .map { prettyElementString($0.value, debug: debug) }
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
            let contents = mirror.children.map {
                let keyObject = Mirror(reflecting: $0.value).children.first!.value
                let valueObject = Mirror(reflecting: $0.value).children.dropFirst().first!.value

                let label = valueString(keyObject, debug: debug)
                var value = elementString(valueObject, debug: debug, pretty: pretty)

                if let head = value.lines.first {
                    value = head + "\n" + value.lines.dropFirst().joined(separator: "\n").indent(size: 9)
                }
                return "\(label): \(value)"
            }.sorted().joined(separator: ",\n")

            return "[\n\(contents.indent(size: 4))\n]"
        } else {
            let contents = mirror.children.map {
                let keyObject = Mirror(reflecting: $0.value).children.first!.value
                let valueObject = Mirror(reflecting: $0.value).children.dropFirst().first!.value

                let label = valueString(keyObject, debug: debug)
                let value = elementString(valueObject, debug: debug, pretty: pretty)
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

// MARK: - pretty-print

func prettyElementString<T>(_ x: T, debug: Bool = false) -> String {
    elementString(x, debug: debug, pretty: true)
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
