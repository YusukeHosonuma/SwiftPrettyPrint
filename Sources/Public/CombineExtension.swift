//
//  CombineExtension.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

// Linux is not supported to Combine framework.
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    import Combine

    @available(iOS 13.0, *)
    @available(OSX 10.15, *)
    extension Publisher {
        public func prettyPrint<Output: TextOutputStream>(
            format: Format = .multiline,
            to out: Output? = nil
        ) -> Publishers.HandleEvents<Self> {
            func _print(_ value: Any, terminator: String = "\n") {
                if var out = out {
                    Swift.print(value, terminator: terminator, to: &out)
                } else {
                    Swift.print(value, terminator: terminator)
                }
            }

            return handleEvents(receiveSubscription: {
                _print("receive subscription: \($0)")
            }, receiveOutput: {
                switch format {
                case .singleline:
                    _print("receive value: ", terminator: "")
                    if var out = out {
                        Pretty.print($0, to: &out)
                    } else {
                        Pretty.print($0)
                    }

                case .multiline:
                    _print("receive value:")
                    if var out = out {
                        Pretty.prettyPrint($0, to: &out)
                    } else {
                        Pretty.prettyPrint($0)
                    }
                }
            }, receiveCompletion: {
                _print("receive \($0)")
            }, receiveCancel: {
                _print("cancel")
            }, receiveRequest: {
                _print("request \($0)")
            })
        }
    }

#endif
