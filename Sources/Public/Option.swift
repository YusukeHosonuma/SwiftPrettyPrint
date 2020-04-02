//
// Option.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

extension Pretty {
    public struct Option {
        public var prefix: String?
        public var indentSize: Int
        public var outputStrategy: OutputStrategy

        public init(prefix: String? = nil, indentSize: Int = 4, outputStrategy: OutputStrategy = .print) {
            self.prefix = prefix
            self.indentSize = indentSize
            self.outputStrategy = outputStrategy
        }

        public enum OutputStrategy {
            /// using os.log
            case osLog

            /// using print
            case print
        }
    }
}
