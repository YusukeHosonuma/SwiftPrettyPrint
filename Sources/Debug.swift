public class Debug {
    private init() {}
}

// MARK: Print to console

extension Debug {
    // MARK: - print

    public static func p<T>(_ x: T, debug: Bool = false) {
        print(pString(x, debug: debug))
    }

    public static func p<K, V>(_ d: [K: V], debug: Bool = false) {
        print(pString(d, debug: debug))
    }

    // MARK: - pretty-print

    public static func pp<T>(_ x: T, debug: Bool = false) {
        print(ppString(x, debug: debug))
    }

    public static func pp<K, V>(_ d: [K: V], debug: Bool = false) {
        print(ppString(d, debug: debug))
    }
}

// MARK: Get as string

extension Debug {
    // MARK: - print

    public static func pString<T>(_ x: T, debug: Bool = false) -> String {
        elementString(x, debug: debug, pretty: false)
    }

    public static func pString<K, V>(_ d: [K: V], debug: Bool = false) -> String {
        dictionaryString(d, debug: debug, pretty: false)
    }

    // MARK: - pretty-print

    public static func ppString<T>(_ x: T, debug: Bool = false) -> String {
        prettyElementString(x, debug: debug)
    }

    public static func ppString<K, V>(_ d: [K: V], debug: Bool = false) -> String {
        prettyDictionaryString(d, debug: debug)
    }
}
