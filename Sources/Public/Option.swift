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
        public var outputDestination: OutputDestination

        public init(prefix: String? = nil, indentSize: Int = 4, outputDestination: OutputDestination = .xcodeDebugConsole) {
            self.prefix = prefix
            self.indentSize = indentSize
            self.outputDestination = outputDestination
        }

        public enum OutputDestination {
            /// using os.log
            case consoleApp

            /// using print
            case xcodeDebugConsole
        }
    }
}
