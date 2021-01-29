//
// ContentViewModel.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/12/12.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import Combine
import Foundation

final class ContentViewModel: ObservableObject {
    var cancellables: [AnyCancellable] = []

    init() {
        let dog1 = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")
        let dog2 = Dog(id: DogId(rawValue: "koro"), price: Price(rawValue: 20.0), name: "コロ")

        printSection("Combine Example")

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

        subject
            .eraseToAnyPublisher()
            .prettyPrint("🐩", format: .multiline)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)

        subject.send(dog2)
        subject.send(completion: .failure(DogsError()))

        // =>
        // 🐩: request unlimited
        // 🐩: receive subscription: PassthroughSubject
        // 🐩: receive value:
        // Dog(
        //     id: "koro",
        //     price: 20.0,
        //     name: "コロ"
        // )
        // 🐩: receive failure:
        // DogsError(
        //     code: 101,
        //     message: "dogs have run away"
        // )
    }
}
