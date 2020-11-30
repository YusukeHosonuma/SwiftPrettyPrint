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
            _ prefix: String = "",
            when: [CombineOperatorOption.Event] = CombineOperatorOption.Event.allCases,
            format: CombineOperatorOption.Format = .multiline,
            to out: Output? = nil
        ) -> Publishers.HandleEvents<Self> {
            // Use local function for capture arguments.
            func _print(_ value: Any, type: CombineOperatorOption.Event, terminator: String = "\n") {
                guard when.contains(type) else { return }

                let message = prefix.isEmpty
                    ? "\(value)"
                    : "\(prefix): \(value)"

                if var out = out {
                    Swift.print(message, terminator: terminator, to: &out)
                } else {
                    Swift.print(message, terminator: terminator)
                }
            }

            return handleEvents(receiveSubscription: {
                _print("receive subscription: \($0)", type: .subscription)
            }, receiveOutput: {
                switch format {
                case .singleline:
                    var s: String = ""
                    Swift.print("receive value: ", terminator: "", to: &s)
                    Pretty.print($0, to: &s)
                    _print(s, type: .output, terminator: "")

                case .multiline:
                    var s: String = ""
                    Swift.print("receive value:", to: &s)
                    Pretty.prettyPrint($0, to: &s)
                    _print(s, type: .output, terminator: "")
                }
            }, receiveCompletion: {
                _print("receive \($0)", type: .completion)
            }, receiveCancel: {
                _print("cancel", type: .cancel)
            }, receiveRequest: {
                _print("request \($0)", type: .request)
            })
        }
    }

#endif
