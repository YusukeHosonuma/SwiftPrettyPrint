// MARK: - p()

func elementString<T: Any>(_ x: T, debug: Bool, pretty: Bool) -> String {
    let mirror = Mirror(reflecting: x)

    let typeName = type(of: x)

    if mirror.children.count == 0 {
        return "\(typeName)()"
    } else {
        let prefix = "\(typeName)("
        let fields = mirror.children.map {
            "\($0.label ?? "-"): " + valueString($0.value, debug: debug)
        }

        if pretty && fields.count > 1 {
            let tailFields = fields.dropFirst()
                .map { indent($0, size: prefix.count) }
                .joined(separator: ",\n")

            return "\(prefix)\(fields.first!),\n\(tailFields))"
        } else {
            return "\(prefix)\(fields.joined(separator: ", ")))"
        }
    }
}

func arrayString<T: Any>(_ xs: [T], debug: Bool, pretty: Bool) -> String {
    let contents = xs.map { elementString($0, debug: debug, pretty: pretty) }.joined(separator: ", ")
    return "[\(contents)]"
}

func dictionaryString<K: Any, V: Any>(_ d: [K: V], debug: Bool, pretty: Bool) -> String {
    let contents = d.map {
        let key = valueString($0.key, debug: debug)
        let value = elementString($0.value, debug: debug, pretty: pretty)
        return "\(key): \(value)"
    }.sorted().joined(separator: ", ")
    
    return "[\(contents)]"
}

// MARK: - pp()

func prettyElementString<T: Any>(_ x: T, debug: Bool = false) -> String {
    return elementString(x, debug: debug, pretty: true)
}

func prettyArrayString<T: Any>(_ xs: [T], debug: Bool = false) -> String {
    let contents = xs.map { prettyElementString($0, debug: debug) }.joined(separator: ",\n")
    return "[\n\(indent(contents, size: 4))\n]"
}

// MARK: - util

func valueString(_ target: Any, debug: Bool) -> String {
    switch target {
    case let value as CustomDebugStringConvertible where debug:
        return value.debugDescription
    case let value as CustomStringConvertible:
        if let string = value as? String {
            return "\"\(string)\""
        } else {
            return value.description
        }
    case let value as Any?:
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
        if let string = target as? String {
            return "\"\(string)\""
        } else {
            return String(describing: target)
        }
    }
}

func indent(_ string: String, size: Int) -> String {
    return string
        .split(separator: "\n")
        .map { String(repeating: " ", count: size) + $0 }
        .joined(separator: "\n")
}
