//
// Operator.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
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
// Pretty.print(string.hasPrefix("Hello"))
//
// // when use `p` - not needs enclose in parenthese
// Pretty.p >>> string.hasPrefix("Hello")
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

// MARK: `p >>>`

public func >>> (_: (String) -> P, target: Any) {
    Pretty.print(target)
}

public func >>> (_: (String) -> PD, target: Any) {
    Pretty.printDebug(target)
}

public func >>> (_: (String) -> PP, target: Any) {
    Pretty.prettyPrint(target)
}

public func >>> (_: (String) -> PPD, target: Any) {
    Pretty.prettyPrintDebug(target)
}

// MARK: `p("xxx") >>>`

public func >>> (receiver: P, target: Any) {
    Pretty.print(label: receiver.label, target)
}

public func >>> (receiver: PD, target: Any) {
    Pretty.printDebug(label: receiver.label, target)
}

public func >>> (receiver: PP, target: Any) {
    Pretty.prettyPrint(label: receiver.label, target)
}

public func >>> (receiver: PPD, target: Any) {
    Pretty.prettyPrintDebug(label: receiver.label, target)
}
