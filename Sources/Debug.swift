public class Debug {
    private init() {}
}

// MARK: Print to console

extension Debug {

    // MARK: - print

    public static func p<T: Any>(_ x: T, debug: Bool = false) {
        print(pString(x, debug: debug))
    }

    public static func p<T: Any>(_ x: [T], debug: Bool = false) {
        print(pString(x, debug: debug))
    }

    public static func p<K: Any, V: Any>(_ d: [K: V], debug: Bool = false) {
        print(pString(d, debug: debug))
    }
    
    // MARK: - pretty-print

    public static func pp<T: Any>(_ x: T, debug: Bool = false) {
        print(ppString(x, debug: debug))
    }

    public static func pp<T: Any>(_ xs: [T], debug: Bool = false) {
        print(ppString(xs, debug: debug))
    }

    public static func pp<K: Any, V: Any>(_ d: [K: V], debug: Bool = false) {
        print(ppString(d, debug: debug))
    }
}

// MARK: Get as string

extension Debug {

    // MARK: - print

    public static func pString<T: Any>(_ x: T, debug: Bool = false) -> String {
        elementString(x, debug: debug, pretty: false)
    }

    public static func pString<T: Any>(_ xs: [T], debug: Bool = false) -> String {
        arrayString(xs, debug: debug, pretty: false)
    }

    public static func pString<K: Any, V: Any>(_ d: [K: V], debug: Bool = false) -> String {
        dictionaryString(d, debug: debug, pretty: false)
    }

    // MARK: - pretty-print

    public static func ppString<T: Any>(_ x: T, debug: Bool = false) -> String {
        prettyElementString(x, debug: debug)
    }

    public static func ppString<T: Any>(_ xs: [T], debug: Bool = false) -> String {
        prettyArrayString(xs, debug: debug)
    }

    public static func ppString<K: Any, V: Any>(_ d: [K: V], debug: Bool = false) -> String {
        prettyDictionaryString(d, debug: debug)
    }
}
