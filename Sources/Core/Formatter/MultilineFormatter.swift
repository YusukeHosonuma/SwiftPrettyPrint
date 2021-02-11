//
// MultilineFormatter.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

class MultilineFormatter: PrettyFormatter {
    private let indentSize: Int
    private let theme: ColorTheme

    init(indentSize: Int, theme: ColorTheme = .plain) {
        self.indentSize = indentSize
        self.theme = theme
    }

    func collectionString(elements: [String]) -> String {
        let contents = elements.joined(separator: ",\n")

        return """
        [
        \(contents.indent(size: indentSize))
        ]
        """
    }

    func dictionaryString(keysAndValues: [(String, String)]) -> String {
        let lines = keysAndValues.map { key, value in
            "\(key): \(value)"
        }.sorted()

        let contents = lines.joined(separator: ",\n")

        return """
        [
        \(contents.indent(size: indentSize))
        ]
        """
    }

    func tupleString(elements: [(String?, String)]) -> String {
        let lines: [String] = elements.map { label, value in
            if let label = label {
                return "\(label): \(value)"
            } else {
                return value
            }
        }

        let contents = lines.joined(separator: ",\n")

        return """
        (
        \(contents.indent(size: indentSize))
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
    /// owner: Owner(
    ///            name: "Nanachi",
    ///            age: 4)
    ///        )
    ///
    func objectString(
        typeName: String, fields: [(String, String)]
    ) -> String {
        if fields.count == 1, let field = fields.first {
            return theme.type(typeName) + "(" + "\(field.0): \(field.1)" + ")"
        } else {
            let body = fields
                .map { label, value in "\(label): \(value)" }
                .joined(separator: ",\n")
                .indent(size: indentSize)

            return """
            \(theme.type(typeName))(
            \(body)
            )
            """
        }
    }
}
