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

public let p: (String) -> P = { label in P(label: label) }
public let pp: (String) -> PP = { label in PP(label: label) }
public let pd: (String) -> PD = { label in PD(label: label) }
public let ppd: (String) -> PPD = { label in PPD(label: label) }

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

// MARK: Operator

precedencegroup PrintPrecedence {
    lowerThan: FunctionArrowPrecedence
}

infix operator >>>: PrintPrecedence

// MARK: `Debug.p >>>`

public func >>> (_: (String) -> P, target: Any) {
    Debug.print(target)
}

public func >>> (_: (String) -> PD, target: Any) {
    Debug.debugPrint(target)
}

public func >>> (_: (String) -> PP, target: Any) {
    Debug.prettyPrint(target)
}

public func >>> (_: (String) -> PPD, target: Any) {
    Debug.debugPrettyPrint(target)
}

// MARK: `Debug.p("xxx") >>>`

public func >>> (receiver: P, target: Any) {
    Debug.print(label: receiver.label, target)
}

public func >>> (receiver: PD, target: Any) {
    Debug.debugPrint(label: receiver.label, target)
}

public func >>> (receiver: PP, target: Any) {
    Debug.prettyPrint(label: receiver.label, target)
}

public func >>> (receiver: PPD, target: Any) {
    Debug.debugPrettyPrint(label: receiver.label, target)
}
