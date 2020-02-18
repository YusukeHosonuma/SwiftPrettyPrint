//
//  Debug.swift
//  SwiftPrettyPrintExample
//
//  Created by Yusuke Hosonuma on 2020/02/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

// Note:
// Enabled on `debug` configuration only.
// Therefore compile error in `release` build when remaining `Debug` in sources.

#if canImport(SwiftPrettyPrint)
    import SwiftPrettyPrint
    typealias Debug = SwiftPrettyPrint.Debug
#endif
