//
//  SimpleFormatter.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/26.
//

class SinglelineFormatter: PrettyFormatter {
    func arrayString(elements: [String]) -> String {
        "[\(elements.joined(separator: ", "))]"
    }

    func dictionaryString(keysAndValues: [(String, String)]) -> String {
        let contents = keysAndValues.map { "\($0): \($1)" }.sorted().joined(separator: ", ")
        return "[\(contents)]"
    }

    func tupleString(elements: [String]) -> String {
        "(\(elements.joined(separator: ", ")))"
    }

    func objectString(typeName: String, fields: [(String, String)]) -> String {
        let contents = fields.map { "\($0): \($1)" }.joined(separator: ", ")
        return "\(typeName)(" + contents + ")"
    }
}
