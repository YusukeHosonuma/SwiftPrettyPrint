//
//  Alias.swift
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
    public struct P {}
    public struct PP {}
    public struct PD {}
    public struct PPD {}

    public static var p: P { P() }
    public static var pp: PP { PP() }
    public static var pd: PD { PD() }
    public static var ppd: PPD { PPD() }
}

precedencegroup PrintPrecedence {
    lowerThan: FunctionArrowPrecedence
}

infix operator >>>: PrintPrecedence

@discardableResult
public func >>> (_: Debug.P, target: Any) -> String {
    Debug.print(target)
}

@discardableResult
public func >>> (_: Debug.PD, target: Any) -> String {
    Debug.debugPrint(target)
}

@discardableResult
public func >>> (_: Debug.PP, target: Any) -> String {
    Debug.prettyPrint(target)
}

@discardableResult
public func >>> (_: Debug.PPD, target: Any) -> String {
    Debug.debugPrettyPrint(target)
}
