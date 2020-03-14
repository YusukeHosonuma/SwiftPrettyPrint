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

    func tupleString(elements: [(String?, String)]) -> String {
        // if the labels of tuples are not specificated, they are like ".1" (not nil).
        // Using "." as the first charactor of the label of tuple is prohibited.
        let labelValuePairs: [String] = elements.map { label, value in
            if let label = label, label.first != "." {
                return label + ": " + value
            } else {
                return value
            }
        }

        return "(\(labelValuePairs.joined(separator: ", ")))"
    }

    func objectString(typeName: String, fields: [(String, String)]) -> String {
        let contents = fields.map { "\($0): \($1)" }.joined(separator: ", ")
        return "\(typeName)(" + contents + ")"
    }
}
