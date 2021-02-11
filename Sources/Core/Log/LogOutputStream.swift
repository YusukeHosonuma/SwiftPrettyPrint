//
//  LogOutputStream.swift
//  SwiftPrettyPrint
//
//  Created by Yusuke Hosonuma on 2021/01/14.
//

#if canImport(Foundation)

    import Foundation

    final class LogOutputStream: TextOutputStream {
        private let url: URL

        init(url: URL) {
            self.url = url
            let directoryPath = url.deletingLastPathComponent()
            if !FileManager().fileExists(atPath: directoryPath.absoluteString) {
                do {
                    try FileManager().createDirectory(at: directoryPath, withIntermediateDirectories: true)
                } catch {
                    print("[SwiftPrettyPrint] Failed to create directory. (\(directoryPath))")
                }
            }
        }

        func write(_ string: String) {
            guard let output = OutputStream(url: url, append: true) else { return }

            output.open()
            defer { output.close() }

            guard let data = string.data(using: .utf8) else { return }
            data.withUnsafeBytes { ptr in
                guard let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    return
                }
                _ = output.write(bytes, maxLength: data.count)
            }
        }
    }

#endif
