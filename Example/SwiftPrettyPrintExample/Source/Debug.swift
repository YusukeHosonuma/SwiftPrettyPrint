//
// Debug.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

// Note:
// Enabled on `debug` configuration only.
// Therefore compile error in `release` build when remaining `Debug` in sources.

#if canImport(SwiftPrettyPrint)
    import SwiftPrettyPrint
    typealias Debug = SwiftPrettyPrint.Pretty
#endif
