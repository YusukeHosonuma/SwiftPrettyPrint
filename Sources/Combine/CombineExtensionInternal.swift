//
//  File.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

// Linux is not supported to Combine framework.
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    import Combine

    // Note:
    // This source is internal for testable.
    // For public implementation is `CombineExtension.swift`.

    internal class StringRecorder {
        internal var string: String = ""
        internal init() {}
    }

    @available(iOS 13.0, *)
    @available(OSX 10.15, *)
    extension Publisher {
        internal func prettyPrint(format: Format = .multiline, to: StringRecorder) -> Publishers.HandleEvents<Self> {
            handleEvents {
                Swift.print("receive subscription: \($0)", to: &to.string)
            } receiveOutput: {
                switch format {
                case .singleline:
                    Swift.print("receive value: ", terminator: "", to: &to.string)
                    Pretty.print($0, to: &to.string)

                case .multiline:
                    Swift.print("receive value:", to: &to.string)
                    Pretty.prettyPrint($0, to: &to.string)
                }
            } receiveCompletion: {
                Swift.print("receive \($0)", to: &to.string)
            } receiveCancel: {
                Swift.print("cancel", to: &to.string)
            } receiveRequest: {
                Swift.print("request \($0)", to: &to.string)
            }
        }
    }

#endif
