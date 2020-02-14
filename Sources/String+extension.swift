//
//  String+extension.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/15.
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
}
