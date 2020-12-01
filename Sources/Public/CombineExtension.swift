//
//  CombineExtension.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

// Linux is not supported to Combine framework.
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    import Combine

    private struct StandardOutput: TextOutputStream {
        func write(_ string: String) {
            print(string, terminator: "")
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6, tvOS 13, *)
    extension Publisher {
        /// Output events as single-line.
        public func p(
            _ prefix: String = "",
            when: [CombineOperatorOption.Event] = CombineOperatorOption.Event.allCases
        ) -> Publishers.HandleEvents<Self> {
            prettyPrint(prefix, when: when, format: .singleline)
        }

        /// Output events as multiine.
        public func pp(
            _ prefix: String = "",
            when: [CombineOperatorOption.Event] = CombineOperatorOption.Event.allCases
        ) -> Publishers.HandleEvents<Self> {
            prettyPrint(prefix, when: when, format: .multiline)
        }

        /// Output events to standard output.
        public func prettyPrint(
            _ prefix: String = "",
            when: [CombineOperatorOption.Event] = CombineOperatorOption.Event.allCases,
            format: CombineOperatorOption.Format = .multiline
        ) -> Publishers.HandleEvents<Self> {
            prettyPrint(prefix, when: when, format: format, to: StandardOutput())
        }

        /// Output events to specified output stream.
        public func prettyPrint<Output: TextOutputStream>(
            _ prefix: String = "",
            when: [CombineOperatorOption.Event] = CombineOperatorOption.Event.allCases,
            format: CombineOperatorOption.Format = .multiline,
            to: Output
        ) -> Publishers.HandleEvents<Self> {
            // Use local function for capture arguments.
            func _print(_ value: Any, type: CombineOperatorOption.Event, terminator: String = "\n") {
                guard when.contains(type) else { return }

                let message = prefix.isEmpty
                    ? "\(value)"
                    : "\(prefix): \(value)"

                var out = to
                Swift.print(message, terminator: terminator, to: &out)
            }

            var option = Pretty.sharedOption
            option.prefix = nil // Prepend duplicat output.

            return handleEvents(receiveSubscription: {
                _print("receive subscription: \($0)", type: .subscription)
            }, receiveOutput: {
                switch format {
                case .singleline:
                    var s: String = ""
                    Swift.print("receive value: ", terminator: "", to: &s)
                    Pretty.print($0, option: option, to: &s)
                    _print(s, type: .output, terminator: "")

                case .multiline:
                    var s: String = ""
                    Swift.print("receive value:", to: &s)
                    Pretty.prettyPrint($0, option: option, to: &s)
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
