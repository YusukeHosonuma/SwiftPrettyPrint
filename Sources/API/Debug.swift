public class Debug {
    public static let defaultOption = Option(indent: 4)
    public static var option: Option = Debug.defaultOption

    private init() {}
}

private let pretty = Pretty()

// MARK: Standard API

extension Debug {
    /// Output `target` to console.
    /// - Parameter target: target
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func print(_ target: Any) -> String {
        let string = pretty.string(target, debug: false, pretty: false)
        Swift.print(string)
        return string
    }

    /// Output pretty-formatted `target` to console.
    /// - Parameter target: target
    /// - Returns: String that same of output console.
    @discardableResult
    public static func prettyPrint(_ target: Any) -> String {
        let string = pretty.string(target, debug: false, pretty: true)
        Swift.print(string)
        return string
    }

    /// Output debuggable `target` to console.
    /// - Parameter target: target
    /// - Returns: String that same of output console.
    @discardableResult
    public static func debugPrint(_ target: Any) -> String {
        let string = pretty.string(target, debug: true, pretty: false)
        Swift.print(string)
        return string
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameter target: target
    /// - Returns: String that same of output console.
    @discardableResult
    public static func debugPrettyPrint(_ target: Any) -> String {
        let string = pretty.string(target, debug: true, pretty: true)
        Swift.print(string)
        return string
    }
}

// MARK: Alias API

extension Debug {
    /// Alias to `print()` and `debugPrint()`
    /// - Parameters:
    ///   - target: target
    ///   - debug: debuggable output if `true` (default: `false`)
    /// - Returns: String that same of output console.
    @discardableResult
    public static func p<T>(_ target: T, debug: Bool = false) -> String {
        if debug {
            return debugPrint(target)
        } else {
            return print(target)
        }
    }

    /// Alias to `prettyPrint()` and `debugPrettyPrint()`
    /// - Parameters:
    ///   - target: target
    ///   - debug: debuggable output if `true` (default: `false`)
    /// - Returns: String that same of output console.
    @discardableResult
    public static func pp<T>(_ target: T, debug: Bool = false) -> String {
        if debug {
            return debugPrettyPrint(target)
        } else {
            return prettyPrint(target)
        }
    }
}
