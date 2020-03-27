//
//  DebugHelper.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/25.
//

import SwiftPrettyPrint

struct DebugHelper {
    var option: Debug.Option

    func print(label: String? = nil, _ target: Any) -> String {
        var s = ""
        Debug.print(label: label, target, option: option, to: &s)
        return s
    }

    func printDebug(label: String? = nil, _ target: Any) -> String {
        var s = ""
        Debug.printDebug(label: label, target, option: option, to: &s)
        return s
    }

    func prettyPrint(label: String? = nil, _ target: Any) -> String {
        var s = ""
        Debug.prettyPrint(label: label, target, option: option, to: &s)
        return s
    }

    func prettyPrintDebug(label: String? = nil, _ target: Any) -> String {
        var s = ""
        Debug.prettyPrintDebug(label: label, target, option: option, to: &s)
        return s
    }
}
