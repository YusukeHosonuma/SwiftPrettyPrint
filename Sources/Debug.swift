public class Debug {
    public static let defaultOption = Option(indent: 4)
    public static var option: Option = Debug.defaultOption

    private init() {}
}

private let pretty = Pretty()

// MARK: Print to console

extension Debug {
    public static func p<T>(_ target: T, debug: Bool = false) {
        print(pString(target, debug: debug))
    }

    public static func pp<T>(_ target: T, debug: Bool = false) {
        print(ppString(target, debug: debug))
    }
}

// MARK: Get as string

extension Debug {
    public static func pString<T>(_ target: T, debug: Bool = false) -> String {
        pretty.string(target, debug: debug, pretty: false)
    }

    public static func ppString<T>(_ target: T, debug: Bool = false) -> String {
        pretty.string(target, debug: debug, pretty: true)
    }
}
