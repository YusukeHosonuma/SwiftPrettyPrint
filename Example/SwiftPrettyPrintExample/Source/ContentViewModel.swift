//
//  ContentViewModel.swift
//  SwiftPrettyPrintExample
//
//  Created by Yusuke Hosonuma on 2020/12/01.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

import Combine
import Foundation

final class ContentViewModel: ObservableObject {
    var cancellables: [AnyCancellable] = []

    init() {
        let array = [
            Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ"),
            Dog(id: DogId(rawValue: "koro"), price: Price(rawValue: 20.0), name: "コロ"),
        ]

        array
            .publisher
            .prettyPrint("🍌", when: [.output, .completion], format: .multiline)
            .sink { _ in }
            .store(in: &cancellables)

        // =>
        // 🍌: receive value:
        // Dog(
        //     id: "pochi",
        //     price: 10.0,
        //     name: "ポチ"
        // )
        // 🍌: receive value:
        // Dog(
        //     id: "koro",
        //     price: 20.0,
        //     name: "コロ"
        // )
        // 🍌: receive finished
    }
}
