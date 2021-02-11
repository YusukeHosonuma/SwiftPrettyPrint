//
// CombineExtension.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

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
            to output: Output
        ) -> Publishers.HandleEvents<Self> {
            var option = Pretty.sharedOption
            option.prefix = nil // prevent duplicate output.

            // Note:
            // Use local function for capture arguments.

            func _out<Output: TextOutputStream>(_ value: String, terminator: String = "\n", to output: Output) {
                let message = prefix.isEmpty
                    ? "\(value)"
                    : "\(prefix): \(value)"

                var out = output
                Swift.print(message, terminator: terminator, to: &out)
            }

            func _print(_ value: String, type: CombineOperatorOption.Event) {
                guard when.contains(type) else { return }

                // Console
                _out(value, to: output)

                // Log files
                #if targetEnvironment(simulator) || os(macOS)
                    // Do not output to log when specifed `Output`.
                    if output is StandardOutput {
                        _out(value, to: Pretty.plainLogStream)
                        _out(value, to: Pretty.coloredLogStream)
                    }
                #endif
            }

            func _prettyPrint(value: Any, label: String, type: CombineOperatorOption.Event) {
                guard when.contains(type) else { return }

                var plain: String = ""

                // Console
                do {
                    switch format {
                    case .singleline:
                        Swift.print("receive \(label): ", terminator: "", to: &plain)
                        Pretty.print(value, option: option, colored: false, to: &plain)

                    case .multiline:
                        Swift.print("receive \(label):", to: &plain)
                        Pretty.prettyPrint(value, option: option, to: &plain)
                    }

                    _out(plain, terminator: "", to: output)
                }

                // Log files
                #if targetEnvironment(simulator) || os(macOS)
                    // Do not output to log when specifed `Output`.
                    if output is StandardOutput {
                        var colored: String = ""

                        switch format {
                        case .singleline:
                            Swift.print("receive \(label): ", terminator: "", to: &colored)
                            Pretty.print(value, option: option, colored: true, to: &colored)

                        case .multiline:
                            Swift.print("receive \(label):", to: &colored)
                            Pretty.prettyPrint(value, option: option, colored: true, to: &colored)
                        }

                        _out(plain, terminator: "", to: Pretty.plainLogStream)
                        _out(colored, terminator: "", to: Pretty.coloredLogStream)
                    }
                #endif
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
