//
// Dog.swift
// SwiftPrettyPrint
//
// Created by Yusuke Hosonuma on 2020/02/27.
// Copyright (c) 2020 Yusuke Hosonuma.
//

struct Dog {
    var id: DogId
    var price: Price
    var name: String?
}

struct DogId { var rawValue: String }
struct Price { var rawValue: Double }
