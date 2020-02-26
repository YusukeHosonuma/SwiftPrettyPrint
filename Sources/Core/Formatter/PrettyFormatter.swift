//
//  PrettyFormatter.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/02/26.
//

class PrettyFormatter: Formatter {
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

        if fields.count == 1, let field = fields.first {
            return prefix + "\(field.0): \(field.1)" + ")"
        } else {
            let contents = fields.map { "\($0): \($1)" }.joined(separator: ",\n")
            return prefix + contents.indentTail(size: prefix.count) + ")"
        }
    }
}
