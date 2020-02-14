public protocol DebuggableValue: CustomStringConvertible, CustomDebugStringConvertible {
    associatedtype T: Any
    var rawValue: T { get }
}

extension DebuggableValue {
    public var description: String {
        if let string = rawValue as? String {
            return "\"\(string)\""
        } else {
            return "\(rawValue)"
        }
    }

    public var debugDescription: String {
        "\(type(of: self))(\(description))"
    }
}
