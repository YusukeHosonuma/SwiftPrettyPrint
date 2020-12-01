//
//  CombineExtension.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

// Linux is not supported to Combine framework.
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    import Combine

    @available(macOS 10.15, iOS 13.0, watchOS 6, tvOS 13, *)
    extension Publisher {
        public func prettyPrint<Output: TextOutputStream>(format: Format = .multiline, to out: Output? = nil) -> Publishers.HandleEvents<Self> {
            handleEvents(receiveSubscription: {
                _print("receive subscription: \($0)", to: out)
            }, receiveOutput: {
                switch format {
                case .singleline:
                    _print("receive value: ", terminator: "", to: out)
                    if var out = out {
                        Pretty.print($0, to: &out)
                    } else {
                        Pretty.print($0)
                    }

                case .multiline:
                    _print("receive value:", to: out)
                    if var out = out {
                        Pretty.prettyPrint($0, to: &out)
                    } else {
                        Pretty.prettyPrint($0)
                    }
                }
            }, receiveCompletion: {
                _print("receive \($0)", to: out)
            }, receiveCancel: {
                _print("cancel", to: out)
            }, receiveRequest: {
                _print("request \($0)", to: out)
            })
        }
    }

    private func _print<Output: TextOutputStream>(_ value: Any, terminator: String = "\n", to: Output?) {
        if var to = to {
            Swift.print(value, terminator: terminator, to: &to)
        } else {
            Swift.print(value, terminator: terminator)
        }
    }

#endif
