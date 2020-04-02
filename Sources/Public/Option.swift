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
        public var outputDestination: OutputStrategy

        public init(prefix: String? = nil, indentSize: Int = 4, outputDestination: OutputStrategy = .print) {
            self.prefix = prefix
            self.indentSize = indentSize
            self.outputDestination = outputDestination
        }

        public enum OutputStrategy {
            /// using os.log
            case osLog

            /// using print
            case print
        }
    }
}
