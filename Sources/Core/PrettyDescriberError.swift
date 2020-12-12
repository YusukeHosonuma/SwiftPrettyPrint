//
// PrettyDescriberError.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import Foundation

enum PrettyDescriberError: Error {
    case notSupported(target: Any)
    case failedExtractKeyValue(dictionary: Any)
    case unknownError(target: Any)
}

extension PrettyDescriberError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .notSupported(target: target):
            return "Not supported:\n\(dumpString(target))"

        case let .failedExtractKeyValue(target):
            return "Extract key or value is failed:\n\(dumpString(target))"

        case let .unknownError(target: target):
            return "Unknown error:\n\(dumpString(target))"
        }
    }

    func dumpString(_ target: Any) -> String {
        var string: String = ""
        dump(target, to: &string)
        return string
    }
}

extension PrettyDescriberError: CustomStringConvertible {
    var description: String {
        switch self {
        case .notSupported:
            return "<< not supported >>"

        case .failedExtractKeyValue, .unknownError:
            return "<< unknown error >>"
        }
    }
}
