public class Debug {
    private init() {}
}

// MARK: Print to console

extension Debug {
    // MARK: - print

    public static func p<T>(_ x: T, debug: Bool = false) {
        print(pString(x, debug: debug))
    }

    // MARK: - pretty-print

    public static func pp<T>(_ x: T, debug: Bool = false) {
        print(ppString(x, debug: debug))
    }
}

// MARK: Get as string

extension Debug {
    // MARK: - print

    public static func pString<T>(_ x: T, debug: Bool = false) -> String {
        elementString(x, debug: debug, pretty: false)
    }

    // MARK: - pretty-print

    public static func ppString<T>(_ x: T, debug: Bool = false) -> String {
        elementString(x, debug: debug, pretty: true)
    }
}
