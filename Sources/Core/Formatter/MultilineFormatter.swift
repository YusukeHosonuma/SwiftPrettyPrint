//
//  PrettyFormatter.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/26.
//

class MultilineFormatter: PrettyFormatter {
    private let option: Debug.Option

    init(option: Debug.Option) {
        self.option = option
    }

    func arrayString(elements: [String]) -> String {
        """
        [
        \(elements.joined(separator: ",\n").indent(size: option.indent))
        ]
        """
    }

    func dictionaryString(keysAndValues: [(String, String)]) -> String {
        let contents = keysAndValues.map { key, value in
            "\(key): \(value.indentTail(size: "\(key): ".count))"
        }.sorted().joined(separator: ",\n")

        return """
        [
        \(contents.indent(size: option.indent))
        ]
        """
    }

    func tupleString(elements: [(String?, String)]) -> String {
        // if the labels of tuples are not specificated, they are like ".1" (not nil).
        // Using "." as the first charactor of the label of tuple is prohibited.
        let labelValuePairs: [String] = elements.map { label, value in
            if let label = label, label.first != "." {
                return label + ": " + value.indentTail(size: "\(label): ".count)
            } else {
                return value
            }
        }

        return """
        (
        \(labelValuePairs.joined(separator: ",\n").indent(size: option.indent))
        )
        """
    }

    /// NOTE:
    /// transform fields to single string
    /// insert indent according to key
    ///
    /// ex:
    /// ("owner", """
    /// Owner(name: "Nanachi",
    ///       age: 4)
    /// """)
    ///
    /// goes to
    ///
    /// owner: Owner(name: "Nanachi",
    ///              age: 4))
    ///
    func objectString(
        typeName: String, fields: [(String, String)]
    ) -> String {
        let prefix = "\(typeName)("
        let body: String

        if fields.count == 1, let field = fields.first {
            body = "\(field.0): \(field.1)"
        } else {
            body = fields
                .map { label, value in "\(label): \(value.indentTail(size: "\(label): ".count))" }
                .joined(separator: ",\n")
                .indentTail(size: prefix.count)
        }

        return prefix + body + ")"
    }
}
