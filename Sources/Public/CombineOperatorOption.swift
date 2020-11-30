//
//  CombineOperatorOption.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

// Namespace
public enum CombineOperatorOption {}

extension CombineOperatorOption {
    public enum Format {
        case singleline
        case multiline
    }

    public enum Event: CaseIterable {
        case subscription
        case output
        case completion
        case cancel
        case request
    }
}
