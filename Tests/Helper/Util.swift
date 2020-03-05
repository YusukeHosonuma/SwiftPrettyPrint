//
//  Util.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/03/05.
//

func uncurry<T1, T2, R>(_ f: @escaping (T1) -> (T2) -> R) -> (T1, T2) -> R {
    { (t1, t2) -> R in
        f(t1)(t2)
    }
}
