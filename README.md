# SwiftPrettyPrint

![Test](https://github.com/YusukeHosonuma/SwiftPrettyPrint/workflows/Test/badge.svg)
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftPrettyPrint.svg)](https://cocoapods.org/pods/SwiftPrettyPrint)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)
[![License](https://img.shields.io/github/license/YusukeHosonuma/SwiftPrettyPrint)](https://github.com/YusukeHosonuma/SwiftPrettyPrint/blob/master/LICENSE)
[![Twitter](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Ftwitter.com%2Ftobi462)](https://twitter.com/tobi462)

![Logo](https://raw.githubusercontent.com/YusukeHosonuma/SwiftPrettyPrint/master/Image/logo.png)

SwiftPrettyPrint gives **Human-readable output** than `print()`, `debugPrint()` and `dump()` in Swift standard library.

![Screenshot](https://raw.githubusercontent.com/YusukeHosonuma/SwiftPrettyPrint/master/Image/screenshot.png)

## Motivation 💪

The `print()`, `debugPrint()` and `dump()` are implemented in standard library of Swift.
But these functions output are not readable sometime.

For example, if you have the following types and value:

```swift
enum Enum {
    case foo(Int)
}

struct ID {
    let id: Int
}

struct Struct {
    var array: [Int?]
    var dictionary: [String: Int]
    var tuple: (Int, string: String)
    var `enum`: Enum
    var id: ID
}

let value = Struct(array: [1, 2, nil],
                   dictionary: ["one": 1, "two": 2],
                   tuple: (1, string: "string"),
                   enum: .foo(42),
                   id: ID(id: 7))
```

### Use Standard library of Swift

If you use the standard library, you get the following results.

```swift
print(value)
// Struct(array: [Optional(1), Optional(2), nil], dictionary: ["one": 1, "two": 2], tuple: (1, string: "string"), enum: SwiftPrettyPrintExample.Enum.foo(42), id: SwiftPrettyPrintExample.ID(id: 7))

debugPrint(value)
// SwiftPrettyPrintExample.Struct(array: [Optional(1), Optional(2), nil], dictionary: ["one": 1, "two": 2], tuple: (1, string: "string"), enum: SwiftPrettyPrintExample.Enum.foo(42), id: SwiftPrettyPrintExample.ID(id: 7))

dump(value)
// ▿ SwiftPrettyPrintExample.Struct
//   ▿ array: 3 elements
//     ▿ Optional(1)
//       - some: 1
//     ▿ Optional(2)
//       - some: 2
//     - nil
//   ▿ dictionary: 2 key/value pairs
//     ▿ (2 elements)
//       - key: "one"
//       - value: 1
//     ▿ (2 elements)
//       - key: "two"
//       - value: 2
//   ▿ tuple: (2 elements)
//     - .0: 1
//     - string: "string"
//   ▿ enum: SwiftPrettyPrintExample.Enum.foo
//     - foo: 42
//   ▿ id: SwiftPrettyPrintExample.ID
//     - id: 7
```

This output is enough information for debug, but **not human-readable**.

### Use SwiftPrettyPrint

With SwiftPrittyPrint it looks like this:

```swift
Pretty.print(value)
// Struct(array: [1, 2, nil], dictionary: ["one": 1, "two": 2], tuple: (1, string: "string"), enum: .foo(42), id: 7)

Pretty.prettyPrint(value)
// Struct(
//     array: [
//         1,
//         2,
//         nil
//     ],
//     dictionary: [
//         "one": 1,
//         "two": 2
//     ],
//     tuple: (
//         1,
//         string: "string"
//     ),
//     enum: .foo(42),
//     id: 7
// )
```

Of cource, it can also be used with **LLDB**.

```text
(lldb) e Pretty.prettyPrint(value)
Struct(
    array: [
        1,
        2,
        nil
    ],
    dictionary: [
        "one": 1,
        "two": 2
    ],
    tuple: (
        1,
        string: "string"
    ),
    enum: .foo(42),
    id: 7
)
```

## API

SwiftPrettyPrint has four basic functions as follows:

- `print(label: String?, _ targets: Any..., separator: String, option: Pretty.Option)`
  - print in **one-line**.
- `prettyPrint(label: String?, _ targets: Any..., separator: String, option: Pretty.Option)`
  - print in **multiline**.
- `printDebug(label: String?, _ targets: Any..., separator: String, option: Pretty.Option)`
  - print in **one-line** with **type-information**.
- `prettyPrintDebug(label: String?, _ targets: Any..., separator: String, option: Pretty.Option)`
  - print in **multiline** with **type-information**.

The only required argument is `targets`, it can usually be described as follows.

```swift
let array: [URL?] = [
    URL(string: "https://github.com/YusukeHosonuma/SwiftPrettyPrint"),
    nil
]

Pretty.print(array)
// => [https://github.com/YusukeHosonuma/SwiftPrettyPrint, nil]

Pretty.prettyPrint(array)
// =>
// [
//     https://github.com/YusukeHosonuma/SwiftPrettyPrint,
//     nil
// ]

Pretty.printDebug(array)
// => [Optional(URL("https://github.com/YusukeHosonuma/SwiftPrettyPrint")), nil]

Pretty.prettyPrintDebug(array)
// =>
// [
//     Optional(URL("https://github.com/YusukeHosonuma/SwiftPrettyPrint")),
//     nil
// ]
```

## Operator-based API

You can use operator based alias API that like Ruby.

This is no need to enclose in parenthese that convenient to long expression.

```swift
p >>> 42
// => 42

p >>> 42 + 2 * 4 // It can also be applied to expression
// => 50

p >>> String(string.reversed()).hasSuffix("eH")
// => true

pp >>> ["Hello", "World"]
// =>
// [
//     "Hello",
//     "World"
// ]
```

| Operator syntax | Equatable to                 |
|-----------------|------------------------------|
| `p >>> 42`      | `Pretty.print(42)`            |
| `pp >>> 42`     | `Pretty.prettyPrint(42)`      |
| `pd >>> 42`     | `Pretty.printDebug(42)`       |
| `ppd >>> 42`    | `Pretty.prettyPrintDebug(42)` |

## Format options

You can configure format option, shared or passed by arguments.

### Indent size

You can specify indent size in pretty-print as like following:

```swift
// Global option
Pretty.sharedOption = Pretty.Option(indentSize: 4)

let value = (bool: true, array: ["Hello", "World"])

// Use `sharedOption`
Pretty.prettyPrint(value)
// =>
// (
//     bool: true,
//     array: [
//         "Hello",
//         "World"
//     ]
// )

// Use option that is passed by argument
Pretty.prettyPrint(value, option: Pretty.Option(prefix: nil, indentSize: 2))
// =>
// (
//   bool: true,
//   array: [
//     "Hello",
//     "World"
//   ]
// )
```

### Prefix and Label

You can specify global prefix and label (e.g. variable name) as like following:

```swift
Pretty.sharedOption = Pretty.Option(prefix: "[DEBUG]")

let array = ["Hello", "World"]

Pretty.print(label: "array", array)
// => [DEBUG] array: ["Hello", "World"]

Pretty.p("array") >>> array
// => [DEBUG] array: ["Hello", "World"]
```

### Outputting in Console.app

Applying `.consoleApp` to `Option.outputDestination` makes the output be shown in `Console.app`

> ![Console.app Image](https://user-images.githubusercontent.com/14083051/77843347-376cb580-71d7-11ea-8d70-3318b91c2e89.png)

The output in xcode-debug-console will be the following.  

```swift
Debug.sharedOption = Debug.Option(outputDestination: .consoleApp)

let dog = Dog(id: DogId(rawValue: "pochi"), price: Price(rawValue: 10.0), name: "ポチ")

Debug.print(dog)
// => 2020-04-02 11:51:10.766231+0900 SwiftPrettyPrintExample[41397:2843004] Dog(id: "pochi", price: 10.0, name: "ポチ")
```

## Installation

### CocoaPods (Recommended)

```ruby
pod "SwiftPrettyPrint", "~> 1.0.0", :configuration => "Debug" # enabled on `Debug` build only
```

Example app is in [Example](./Example).

### Carthage

```text
github "YusukeHosonuma/SwiftPrettyPrint"
```

### Swift Package Manager

```swift
.package(url: "https://github.com/YusukeHosonuma/SwiftPrettyPrint.git", .upToNextMajor(from: "1.0.0"))
```

or add from Xcode 10+.

## Recommend Settings 📝

You don't want to write an `import` statement when debagging.

We recommend to create `Debug.swift` and declaration any type as `typealias` like following:

```swift
// Debug.swift
#if canImport(SwiftPrettyPrint)
    import SwiftPrettyPrint
    typealias Debug = SwiftPrettyPrint.Pretty // You can use short alias such as `D` too.
#endif
```

This can be not need to write `import` in each sources.

```swift
// AnySource.swift
Debug.print(42)
Debug.prettyPrint(label: "array", array)
```

Note:
This is can't use to the operator-based API such as `p >>>`. (This is a Swift language's limitation)

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

## Author

Developed by **Penginmura**.

- [Yusuke Hosonuma](https://github.com/YusukeHosonuma)
- [sahara-ooga](https://github.com/sahara-ooga)
- [Kazutoshi Miyasaka](https://github.com/po-miyasaka)
