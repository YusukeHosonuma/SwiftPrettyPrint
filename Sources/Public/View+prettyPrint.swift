//
//  View+prettyPrint.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/15.
//

#if canImport(SwiftUI)
    import SwiftUI

    @available(iOS 13, macOS 10.15, *)
    public extension View {
        func prettyPrint(label: String? = nil) -> Self {
            let view = self
            Pretty.prettyPrint(label: label, view)
            return self
        }

        func prettyPrintDebug(label: String? = nil) -> Self {
            let view = self
            Pretty.prettyPrintDebug(label: label, view)
            return self
        }
    }
#endif
