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
Debug.print(value)
// Struct(array: [1, 2, nil], dictionary: ["one": 1, "two": 2], tuple: (1, string: "string"), enum: .foo(42), id: 7)

Debug.printDebug(value)
// Struct(array: [Optional(1), Optional(2), nil], dictionary: ["one": 1, "two": 2], tuple: (1, string: "string"), enum: Enum.foo(42), id: ID(id: 7))

Debug.prettyPrint(value)
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

Debug.prettyPrintDebug(value)
// Struct(
//     array: [
//         Optional(1),
//         Optional(2),
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
//     enum: Enum.foo(42),
//     id: ID(id: 7)
// )
```

Of cource, it can also be used with **LLDB**.

```text
(lldb) e Debug.prettyPrint(value)
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

## Operator-based API

You can use operator based alias API that like Ruby.

This is no need to enclose in parenthese that convenient to long expression.

```swift
p >>> 42
// => 42

p >>> 42 + 1 // It can also be applied to expression
// => 43

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
| `p >>> 42`      | `Debug.print(42)`            |
| `pp >>> 42`     | `Debug.prettyPrint(42)`      |
| `pd >>> 42`     | `Debug.printDebug(42)`       |
| `ppd >>> 42`    | `Debug.prettyPrintDebug(42)` |

## Format options

You can configure format option, shared or passed by arguments.

### Indent size

You can specify indent size in pretty-print as like following:

```swift
// Global option
Debug.sharedOption = Debug.Option(prefix: nil, indentSize: 4)

// Use `sharedOption`
Debug.prettyPrint(["Hello", "World"])
// =>
// [
//     "Hello",
//     "World"
// ]

// Use option that is passed by argument
Debug.prettyPrint(["Hello", "World"], option: Debug.Option(prefix: nil, indentSize: 2))
// =>
// [
//   "Hello",
//   "World"
// ]
```

### Prefix and Label

You can specify global prefix and label (e.g. variable name) as like following:

```swift
Debug.sharedOption = Debug.Option(prefix: "[DEBUG]", indentSize: 4)

let array = ["Hello", "World"]

Debug.print(label: "array", array)
// => [DEBUG] array: ["Hello", "World"]

Debug.prettyPrint(label: "array", array)
// =>
// [DEBUG] array:
// [
//     "Hello",
//     "World"
// ]

Debug.p("array") >>> array
// => [DEBUG] array: ["Hello", "World"]
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

You don't want to write an `import` statement when debagging.

We recommend to create `Debug.swift` and write as following:

```swift
#if canImport(SwiftPrettyPrint)
    import SwiftPrettyPrint
    typealias Debug = SwiftPrettyPrint.Debug // You can use short alias such as `D` too.
#endif
```

or

```swift
#if canImport(SwiftPrettyPrint)
    @_exported import SwiftPrettyPrint // Note: `@_exported` is not official
#endif
```

This can be not need to write `import` in each sources.

## Xcode Code Snippets

![Xcode Code Snippets](https://raw.githubusercontent.com/YusukeHosonuma/SwiftPrettyPrint/master/Image/xcode-snippet.gif)

Copy `.codesnippet` files to the following directory from [.xcode](.xcode) directory:

```text
~/Library/Developer/Xcode/UserData/CodeSnippets/
```

and restart Xcode.

Or run the following command from the root of the repository:

```text
$ make snippets
```

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
