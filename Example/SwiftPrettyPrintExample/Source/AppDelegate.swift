//
// AppDelegate.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

import SwiftPrettyPrint
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // -------------------------
        // Configure format-options
        // -------------------------
        Debug.sharedOption = Debug.Option(indent: 4)

        // --------
        // Example
        // --------
        let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")

        Debug.print(dog)
        // => Dog(id: "pochi", price: 10.0, name: "ポチ")

        Debug.prettyPrint([dog, dog])
        // =>
        // [
        //     Dog(id: "pochi",
        //         price: 10.0,
        //         name: "ポチ"),
        //     Dog(id: "pochi",
        //         price: 10.0,
        //         name: "ポチ")
        // ]

        Debug.prettyPrint(["one": dog, "two": dog], option: Debug.Option(indent: 2))
        // =>
        // [
        //   "one": Dog(id: "pochi",
        //              price: 10.0,
        //              name: "ポチ"),
        //   "two": Dog(id: "pochi",
        //              price: 10.0,
        //              name: "ポチ")
        // ]

        Debug.debugPrint(dog)
        // => Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: Optional("ポチ"))

        Debug.debugPrettyPrint(dog)
        // =>
        // Dog(id: DogId(rawValue: "pochi"),
        //     price: Price(rawValue: 10.0),
        //     name: Optional("ポチ"))

        // -------------------
        // Swift standard API
        // -------------------
        print(dog)
        // => Dog(id: SwiftPrettyPrintExample.DogId(rawValue: "pochi"), price: SwiftPrettyPrintExample.Price(rawValue: 10.0), name: Optional("ポチ"))

        print([dog, dog])
        // => [SwiftPrettyPrintExample.Dog(id: SwiftPrettyPrintExample.DogId(rawValue: "pochi"), price: SwiftPrettyPrintExample.Price(rawValue: 10.0), name: Optional("ポチ")), SwiftPrettyPrintExample.Dog(id: SwiftPrettyPrintExample.DogId(rawValue: "pochi"), price: SwiftPrettyPrintExample.Price(rawValue: 10.0), name: Optional("ポチ"))]

        debugPrint(dog)
        // => SwiftPrettyPrintExample.Dog(id: SwiftPrettyPrintExample.DogId(rawValue: "pochi"), price: SwiftPrettyPrintExample.Price(rawValue: 10.0), name: Optional("ポチ"))

        dump(dog)
        // ▿ SwiftPrettyPrintExample.Dog
        //   ▿ id: SwiftPrettyPrintExample.DogId
        //     - rawValue: "pochi"
        //   ▿ price: SwiftPrettyPrintExample.Price
        //     - rawValue: 10.0
        //   ▿ name: Optional("ポチ")
        //     - some: "ポチ"

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}
}
