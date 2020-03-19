//
//  Util.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/18.
//

func prefixLabel(_ prefix: String?, _ label: String?) -> String {
    switch (prefix, label) {
    case let (.some(prefix), .some(label)):
        return "\(prefix) \(label): "

    case let (.some(prefix), .none):
        return "\(prefix) "

    case let (.none, .some(label)):
        return "\(label): "

    case (_, _):
        return ""
    }
}

func prefixLabelPretty(_ prefix: String?, _ label: String?) -> String {
    switch (prefix, label) {
    case let (.some(prefix), .some(label)):
        return "\(prefix) \(label):\n"

    case let (.some(prefix), .none):
        return "\(prefix)\n"

    case let (.none, .some(label)):
        return "\(label):\n"

    case (_, _):
        return ""
    }
}
