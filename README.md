# SwiftPrettyPrint

![Test](https://github.com/YusukeHosonuma/SwiftPrettyPrint/workflows/Test/badge.svg)
[![Release](https://img.shields.io/github/v/release/YusukeHosonuma/SwiftPrettyPrint?include_prereleases)](https://github.com/YusukeHosonuma/SwiftPrettyPrint/releases)
[![License](https://img.shields.io/github/license/YusukeHosonuma/SwiftPrettyPrint)](https://github.com/YusukeHosonuma/SwiftPrettyPrint/blob/master/LICENSE)

Pretty print for debug that readable output than `print()` and `debugPrint()`.

```swift
let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")

print(dog)
// => Dog(id: SwiftPrettyPrint.DogId(rawValue: "pochi"), price: SwiftPrettyPrint.Price(rawValue: 10.0), name: Optional("ポチ"))

debugPrint(dog)
// => SwiftPrettyPrint.Dog(id: SwiftPrettyPrint.DogId(rawValue: "pochi"), price: SwiftPrettyPrint.Price(rawValue: 10.0), name: Optional("ポチ"))

Debug.p(dog)
// => Dog(id: "pochi", price: 10.0, name: "ポチ")

Debug.pp([dog, dog], debug: true) // pretty and more debug information
// =>
// [
//     Dog(id: DogId("pochi"),
//         price: Price(10.0),
//         name: Optional("ポチ")),
//     Dog(id: DogId("pochi"),
//         price: Price(10.0),
//         name: Optional("ポチ"))
// ]
```

## Motivation 💪

`print` and `debugPrint` is implemented by standard library of Swift.
But both function is not readable output string to console sometime.
This is especially when using struct as ValueObject.

For example:

```swift
struct Dog {
    var id: DogId
    var price: Price
    var name: String?
}

struct DogId {
    var rawValue: String
}

struct Price {
    var rawValue: Double
}

let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")

print(dog)
// => Dog(id: SwiftPrettyPrint.DogId(rawValue: "pochi"), price: SwiftPrettyPrint.Price(rawValue: 10.0), name: Optional("ポチ"))

debugPrint(dog)
// => SwiftPrettyPrint.Dog(id: SwiftPrettyPrint.DogId(rawValue: "pochi"), price: SwiftPrettyPrint.Price(rawValue: 10.0), name: Optional("ポチ"))
```

This output is enough information for debug,
but not human-readable for when forcusing on the values.

With SwiftPrittyPrint it looks like this:

```swift
// Adopt `DebuggableValue` protocol to ValueObject.
extension DogId: DebuggableValue {}
extension Price: DebuggableValue {}

Debug.p(dog)
// => Dog(id: "pochi", price: 10.0, name: "ポチ")

Debug.p(dog, debug: true)
// => Dog(id: DogId("pochi"), price: Price(10.0), name: Optional("ポチ"))
```

## Installation

### CocoaPods

Note: Not register official Cocoapods currently.

```ruby
pod 'SwiftPrettyPrint', :git => 'https://github.com/YusukeHosonuma/SwiftPrettyPrint.git', :tag => '0.0.1'
```

### Carthage

T.B.D

### Swift Package Manager

T.B.D

## Recommend Setting 📝

When you need debug, you don't want to write `import` statement.

I recomend create `Debug.swift` in each target.

```swift
import SwiftPrettyPrint

typealias Debug = SwiftPrettyPrint.Debug
```

This can be not need to `import` as follows:

```swift
let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")

Debug.p(dog)
Debug.p(dog, debug: true)

Debug.pp(dog)
Debug.pp(dog, debug: true)
```

## Develoopment

Require:

- Xcode 11.3
- [pre-commit](https://github.com/pre-commit/pre-commit-hooks)

### Setup

```sh
pre-commit install
```
