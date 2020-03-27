//
// Option.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

extension Debug {
    public struct Option {
        public var prefix: String?
        public var indentSize: Int
        public var isConsoleUsed: Bool

        public init(prefix: String? = nil, indentSize: Int = 4, isConsoleUsed: Bool = false) {
            self.prefix = prefix
            self.indentSize = indentSize
            self.isConsoleUsed = isConsoleUsed
        }
    }
}
