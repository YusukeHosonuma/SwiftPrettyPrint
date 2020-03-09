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

    func objectString(typeName: String, fields: [(String, String)]) -> String {
        let prefix = "\(typeName)("
        let body: String

        if fields.count == 1, let field = fields.first {
            body = "\(field.0): \(field.1)"
        } else {
            body = fields.map(indentInsertedKeyValueString(_:))
                .joined(separator: ",\n")
                .indentTail(size: prefix.count)
        }

        return prefix + body + ")"
    }

    /// transform key value pair to single string inserted indent according to key
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
    /// - Parameter source: key value pair
    private func indentInsertedKeyValueString(_ source: (String, String)) -> String {
        let indentInserted = source.1.indentTail(size: "\(source.0): ".count)
        return "\(source.0): \(indentInserted)"
    }
}
