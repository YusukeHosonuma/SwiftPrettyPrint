//
// CombineExtension.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

// Linux is not supported to Combine framework.
#if canImport(Combine)

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
            var option = Pretty.sharedOption
            option.prefix = nil // prevent duplicate output.

            // Use local function for capture arguments.
            func _print(_ value: Any, type: CombineOperatorOption.Event, terminator: String = "\n") {
                guard when.contains(type) else { return }

                let message = prefix.isEmpty
                    ? "\(value)"
                    : "\(prefix): \(value)"

                var out = to
                Swift.print(message, terminator: terminator, to: &out)
            }

            func _prettyPrint(value: Any, label: String, type: CombineOperatorOption.Event) {
                var s: String = ""
                switch format {
                case .singleline:
                    Swift.print("receive \(label): ", terminator: "", to: &s)
                    Pretty.print(value, option: option, to: &s)
                    _print(s, type: type, terminator: "")

                case .multiline:
                    Swift.print("receive \(label):", to: &s)
                    Pretty.prettyPrint(value, option: option, to: &s)
                    _print(s, type: type, terminator: "")
                }
            }

            return handleEvents(receiveSubscription: {
                _print("receive subscription: \($0)", type: .subscription)
            }, receiveOutput: {
                _prettyPrint(value: $0, label: "value", type: .output)
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    _print("receive finished", type: .completion)
                case let .failure(error):
                    _prettyPrint(value: error, label: "failure", type: .completion)
                }
            }, receiveCancel: {
                _print("cancel", type: .cancel)
            }, receiveRequest: {
                _print("request \($0)", type: .request)
            })
        }
    }

#endif
