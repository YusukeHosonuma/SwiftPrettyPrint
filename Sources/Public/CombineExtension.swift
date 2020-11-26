//
//  CombineExtension.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

import Combine

// TODO: Auto generate from `CombineExtension.swift`.

// ❗Important:
// Please copy from `CombineExtensionInternal.swift` and remove all `to:` argument.

@available(iOS 13.0, *)
@available(OSX 10.15, *)
extension Publisher {
    public func prettyPrint(format: Format = .multiline) -> Publishers.HandleEvents<Self> {
        handleEvents {
            Swift.print("receive subscription: \($0)")
        } receiveOutput: {
            switch format {
            case .singleline:
                Swift.print("receive value: ", terminator: "")
                Pretty.print($0)

            case .multiline:
                Swift.print("receive value:")
                Pretty.prettyPrint($0)
            }
        } receiveCompletion: {
            Swift.print("receive \($0)")
        } receiveCancel: {
            Swift.print("cancel")
        } receiveRequest: {
            Swift.print("request \($0)")
        }
    }
}
