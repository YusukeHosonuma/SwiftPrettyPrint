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
        let dog1 = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")
        let dog2 = Dog(id: DogId(rawValue: "koro"), price: Price(rawValue: 20.0), name: "コロ")

        [dog1]
            .publisher
            .prettyPrint("🐕", when: [.output, .completion], format: .multiline)
            .sink { _ in }
            .store(in: &cancellables)

        // =>
        // 🐕: receive value:
        // Dog(
        //     id: "pochi",
        //     price: 10.0,
        //     name: "ポチ"
        // )
        // 🐕: receive finished

        let subject = PassthroughSubject<Dog, DogsError>()
        let publisher = subject.eraseToAnyPublisher()

        publisher
            .prettyPrint("🐶", when: [.output, .completion], format: .multiline)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)

        subject.send(dog1)
        subject.send(dog2)
        subject.send(completion: .failure(DogsError()))
    }
}
