//
//  SimpleFormatter.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/26.
//

class SinglelineFormatter: PrettyFormatter {
    func collectionString(elements: [String]) -> String {
        "[\(elements.joined(separator: ", "))]"
    }

    func dictionaryString(keysAndValues: [(String, String)]) -> String {
        let contents = keysAndValues.map { "\($0): \($1)" }.sorted().joined(separator: ", ")
        return "[\(contents)]"
    }

    func tupleString(elements: [(String?, String)]) -> String {
        let labelValuePairs: [String] = elements.map { label, value in
            if let label = label {
                return label + ": " + value
            } else {
                return value
            }
        }

        return "(" + labelValuePairs.joined(separator: ", ") + ")"
    }

    func objectString(typeName: String, fields: [(String, String)]) -> String {
        let contents = fields.map { "\($0): \($1)" }.joined(separator: ", ")
        return "\(typeName)(" + contents + ")"
    }
}
