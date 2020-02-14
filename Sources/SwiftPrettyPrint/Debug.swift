public class Debug {
    
    // MARK: - Print to console
    
    public static func p<T: Any>(_ x: T, debug: Bool = false) {
        print(pString(x, debug: debug))
    }

    public static func p<T: Any>(_ x: [T], debug: Bool = false) {
        print(pString(x, debug: debug))
    }
    
    public static func pp<T: Any>(_ x: T, debug: Bool = false) {
        print(ppString(x, debug: debug))
    }

    public static func pp<T: Any>(_ xs: [T], debug: Bool = false) {
        print(ppString(xs, debug: debug))
    }

    // MARK: - Get as string

    public static func pString<T: Any>(_ x: T, debug: Bool = false) -> String {
        return elementString(x, debug: debug, pretty: false)
    }
    
    public static func pString<T: Any>(_ xs: [T], debug: Bool = false) -> String {
        return arrayString(xs, debug: debug, pretty: false)
    }

    public static func ppString<T: Any>(_ x: T, debug: Bool = false) -> String {
        return prettyElementString(x, debug: debug)
    }

    public static func ppString<T: Any>(_ xs: [T], debug: Bool = false) -> String {
        return prettyArrayString(xs, debug: debug)
    }
}
