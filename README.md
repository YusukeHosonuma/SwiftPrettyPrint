# SwiftPrettyPrint

![Test](https://github.com/YusukeHosonuma/SwiftPrettyPrint/workflows/Test/badge.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftPrettyPrint.svg)](https://cocoapods.org/pods/SwiftPrettyPrint)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)
[![License](https://img.shields.io/github/license/YusukeHosonuma/SwiftPrettyPrint)](https://github.com/YusukeHosonuma/SwiftPrettyPrint/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Ftobi462)](https://twitter.com/tobi462)

![Logo](https://raw.githubusercontent.com/YusukeHosonuma/SwiftPrettyPrint/master/Image/logo.png)

Pretty print that is **Human-readable output** than `print()` and `debugPrint()` in Swift standard library.

![Screenshot](https://raw.githubusercontent.com/YusukeHosonuma/SwiftPrettyPrint/master/Image/screenshot.png)

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
Debug.print(dog)
// => Dog(id: "pochi", price: 10.0, name: "ポチ")

Debug.debugPrint(dog)
// => Dog(id: DogId(rawValue: "pochi"), price: Price(10.0), name: Optional("ポチ"))
```

## Installation

### CocoaPods (Recommended)

```ruby
pod "SwiftPrettyPrint", :configuration => "Debug" # enabled on `Debug` build only
```

Example app is in [Example](./Example).

### Carthage

```text
github "YusukeHosonuma/SwiftPrettyPrint"
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", from: "0.0.3"),
]
```

or add from Xcode 10+.

## Recommend Settings 📝

If you don't want to write import statement, I recommended to create `Debug.swift` in each targets.

```swift
// Note:
// Enabled on `debug` configuration only.
// Therefore compile error in `release` build when remaining `Debug` in sources.

#if canImport(SwiftPrettyPrint)
    import SwiftPrettyPrint
    typealias Debug = SwiftPrettyPrint.Debug
#endif
```

This can be not need to `import` as follows:

```swift
let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")
Debug.print(dog)
```

## Format options

You can configure format option, shared or passed by arguments:

```swift
// Global option
Debug.sharedOption = Debug.Option(indent: 4)

// Use `sharedOption`
Debug.prettyPrint(["Hello", "World"])
// =>
// [
//     "Hello",
//     "World"
// ]

// Use option that is passed by argument
Debug.prettyPrint(["Hello", "World"], option: Debug.Option(indent: 2))
// =>
// [
//   "Hello",
//   "World"
// ]
```

## Operator-based API

You can use operator based alias API that like Ruby.

This is no need to enclose in parenthese that convenient to long expression.

```swift
Debug.p >> 42
// => 42

Debug.p >> String(string.reversed()).hasSuffix("eH")
// => true

Debug.pp >> ["Hello", "World"]
// =>
// [
//     "Hello",
//     "World"
// ]
```

| Operator syntax   | Equatable to                 |
|-------------------|------------------------------|
| `Debug.p >> 42`   | `Debug.print(42)`            |
| `Debug.pp >> 42`  | `Debug.prettyPrint(42)`      |
| `Debug.pd >> 42`  | `Debug.debugPrint(42)`       |
| `Debug.ppd >> 42` | `Debug.debugPrettyPrint(42)` |

## Develoopment

Require:

- Xcode 11.3
- [pre-commit](https://github.com/pre-commit/pre-commit-hooks)

Execute `make setup` to install development tools to system (not include Xcode 11.3).

```text
$ make help
setup      Install requirement development tools to system and setup (not include Xcode 11.3)
build      swift - build
test       swift - test
xcode      swift - generate xcode project
format     format sources by SwiftFormat
lint       cocoapods - lint podspec
release    cocoapods - release
info       cocoapods - show trunk information
```

## Contributors

- [@sahara-ooga](https://github.com/sahara-ooga)
