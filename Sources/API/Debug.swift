public class Debug {
    /// Default format option
    public static let defaultOption = Option(indent: 4)

    /// Global format option
    public static var sharedOption: Option = Debug.defaultOption

    private init() {}
}

// MARK: Standard API

extension Debug {
    /// Output `target` to console.
    /// - Parameters:
    ///   - target: target
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func print(_ target: Any) -> String {
        let string = Pretty(formatter: SimpleFormatter()).string(target, debug: false)
        Swift.print(string)
        return string
    }

    /// Output pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func prettyPrint(_ target: Any, option: Option = Debug.sharedOption) -> String {
        let string = Pretty(formatter: PrettyFormatter(option: option)).string(target, debug: false)
        Swift.print(string)
        return string
    }

    /// Output debuggable `target` to console.
    /// - Parameters:
    ///   - target: target
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func debugPrint(_ target: Any) -> String {
        let string = Pretty(formatter: SimpleFormatter()).string(target, debug: true)
        Swift.print(string)
        return string
    }

    /// Output debuggable and pretty-formatted `target` to console.
    /// - Parameters:
    ///   - target: target
    ///   - option: option (default: `Debug.sharedOption`)
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func debugPrettyPrint(_ target: Any, option: Option = Debug.sharedOption) -> String {
        let string = Pretty(formatter: PrettyFormatter(option: option)).string(target, debug: true)
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
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func p<T>(_ target: T, debug: Bool = false) -> String {
        // Note: `option` is meaningless in `not-pretty` print currently.
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
    ///   - option: option (default: `Debug.sharedOption)`
    /// - Returns: String that is the same as output console.
    @discardableResult
    public static func pp<T>(_ target: T, debug: Bool = false, option: Option = Debug.sharedOption) -> String {
        if debug {
            return debugPrettyPrint(target, option: option)
        } else {
            return prettyPrint(target, option: option)
        }
    }
}
