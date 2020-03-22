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

        public init(prefix: String?, indentSize: Int) {
            self.prefix = prefix
            self.indentSize = indentSize
        }
    }
}
