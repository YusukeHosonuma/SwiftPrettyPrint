//
//  Operator.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/03/06.
//

// ----------------------------------------------------------------------------
//
// Provide a simplicity description for print.
//
// No need to enclose in parenthese unlike `print()` or `debugPrint()`.
//
// For example:
//
// ```
// let string = "Hello, world."
// string.hasPrefix("Hello")
//
// // when use `print()` - needs enclose in parenthese
// Debug.print(string.hasPrefix("Hello"))
//
// // when use `p` - not needs enclose in parenthese
// Debug.p >>> string.hasPrefix("Hello")
// ```
//
// Also the operator `>>>` has lower precedence than all standard operators in Swift,
// Therefore could be a apply to expression too.
//
// ----------------------------------------------------------------------------

extension Debug {
    public struct P {
        var label: String
    }

    public struct PP {
        var label: String
    }

    public struct PD {
        var label: String
    }

    public struct PPD {
        var label: String
    }

    public static var p: (String) -> P { _p }
    public static var pp: (String) -> PP { _pp }
    public static var pd: (String) -> PD { _pd }
    public static var ppd: (String) -> PPD { _ppd }

    // MARK: Internal

    private static func _p(label: String) -> P {
        P(label: label)
    }

    private static func _pp(label: String) -> PP {
        PP(label: label)
    }

    private static func _pd(label: String) -> PD {
        PD(label: label)
    }

    private static func _ppd(label: String) -> PPD {
        PPD(label: label)
    }
}

precedencegroup PrintPrecedence {
    lowerThan: FunctionArrowPrecedence
}

infix operator >>>: PrintPrecedence

// MARK: `Debug.p >>>`

public func >>> (_: (String) -> Debug.P, target: Any) {
    Debug.print(target)
}

public func >>> (_: (String) -> Debug.PD, target: Any) {
    Debug.debugPrint(target)
}

public func >>> (_: (String) -> Debug.PP, target: Any) {
    Debug.prettyPrint(target)
}

public func >>> (_: (String) -> Debug.PPD, target: Any) {
    Debug.debugPrettyPrint(target)
}

// MARK: `Debug.p("xxx") >>>`

public func >>> (receiver: Debug.P, target: Any) {
    Debug.print(label: receiver.label, target)
}

public func >>> (receiver: Debug.PD, target: Any) {
    Debug.debugPrint(label: receiver.label, target)
}

public func >>> (receiver: Debug.PP, target: Any) {
    Debug.prettyPrint(label: receiver.label, target)
}

public func >>> (receiver: Debug.PPD, target: Any) {
    Debug.debugPrettyPrint(label: receiver.label, target)
}
