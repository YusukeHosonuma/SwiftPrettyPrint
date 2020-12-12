//
// PrettyFormatter.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

protocol PrettyFormatter {
    func collectionString(elements: [String]) -> String
    func dictionaryString(keysAndValues: [(String, String)]) -> String
    func tupleString(elements: [(String?, String)]) -> String
    func objectString(typeName: String, fields: [(String, String)]) -> String
}
