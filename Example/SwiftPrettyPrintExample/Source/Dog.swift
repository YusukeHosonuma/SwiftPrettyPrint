//
//  Dog.swift
//  SwiftPrettyPrintExample
//
//  Created by Yusuke Hosonuma on 2020/02/18.
//  Copyright © 2020 Yusuke Hosonuma. All rights reserved.
//

struct Dog {
    var id: DogId
    var price: Price
    var name: String?
}

struct DogId { var rawValue: String }
struct Price { var rawValue: Double }
