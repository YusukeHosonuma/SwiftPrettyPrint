//
// String+extension.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

extension String {
    var lines: [String] {
        split(separator: "\n").map(String.init)
    }

    func indent(size: Int) -> String {
        lines
            .map { String(repeating: " ", count: size) + $0 }
            .joined(separator: "\n")
    }

    func indentTail(size: Int) -> String {
        guard let head = lines.first else { return self }
        return ([head] + lines.dropFirst().map { $0.indent(size: size) })
            .joined(separator: "\n")
    }

    func removeEnclosedParentheses() -> String {
        var s = self
        if first == "(", last == ")" {
            s.removeFirst()
            s.removeLast()
        }
        return s
    }
}
