import SwiftPrettyPrint // Note: don't use `@testable`, because test to public API
import XCTest

private struct Dog {
    var id: DogId
    var name: String?
    var nickname: String?
    var age: Int
    var homepage: URL?
}

private struct DogId {
    var rawValue: String
}

class DebugTests: XCTestCase {
    fileprivate let dog = Dog(id: DogId(rawValue: "pochi"),
                              name: "ポチ",
                              nickname: nil,
                              age: 3,
                              homepage: URL(string: "https://www.google.com/"))

    override func setUp() {}

    override func tearDown() {}

    func test_pString() {
        //
        // Basic type
        //

        XCTAssertEqual(Debug.pString("Hello", debug: false), #""Hello""#)
        XCTAssertEqual(Debug.pString("Hello", debug: true), #""Hello""#)

        XCTAssertEqual(Debug.pString(42, debug: false), "42")
        XCTAssertEqual(Debug.pString(42, debug: true), "42")

        // TODO: support URL type - https://github.com/YusukeHosonuma/SwiftPrettyPrint/issues/23
        // XCTAssertEqual(Debug.pString(URL(string: "https://www.google.com/")!, debug: false), "https://www.google.com/")
        // XCTAssertEqual(Debug.pString(URL(string: "https://www.google.com/")!, debug: true), #"URL("https://www.google.com/")"#) // this is best?
        // print(URL(string: "https://www.google.com/")!)
        // debugPrint(URL(string: "https://www.google.com/")!)
        // => https://www.google.com/
        // => https://www.google.com/

        //
        // Struct
        //

        let expectString =
            #"Dog(id: "pochi", name: "ポチ", nickname: nil, age: 3, homepage: https://www.google.com/)"#

        let expectDebugString =
            #"Dog(id: DogId(rawValue: "pochi"), name: Optional("ポチ"), nickname: nil, age: 3, homepage: Optional(https://www.google.com/))"#

        XCTAssertEqual(Debug.pString(dog, debug: false),
                       expectString)

        XCTAssertEqual(Debug.pString(dog, debug: true),
                       expectDebugString)

        //
        // Array
        //

        XCTAssertEqual(Debug.pString([dog, dog], debug: false),
                       "[\(expectString), \(expectString)]")

        XCTAssertEqual(Debug.pString([dog, dog], debug: true),
                       "[\(expectDebugString), \(expectDebugString)]")

        //
        // Dictionary
        //

        let dictionary: [String: Dog] = [
            "dog-1": dog,
            "dog-2": dog,
        ]

        print(dictionary)
        // => ["dog-1": SwiftPrettyPrint.Dog(id: DogId("pochi"), name: Optional("ポチ"), nickname: nil, age: 3, homepage: Optional(https://www.google.com/)), "dog-2": SwiftPrettyPrint.Dog(id: DogId("pochi"), name: Optional("ポチ"), nickname: nil, age: 3, homepage: Optional(https://www.google.com/))]

        XCTAssertEqual(Debug.pString(dictionary),
                       #"["dog-1": \#(expectString), "dog-2": \#(expectString)]"#)

        XCTAssertEqual(Debug.pString(dictionary, debug: true),
                       #"["dog-1": \#(expectDebugString), "dog-2": \#(expectDebugString)]"#)
    }

    func test_ppString() {
        //
        // Basic type
        //

        XCTAssertEqual(Debug.ppString("Hello", debug: false), #""Hello""#)
        XCTAssertEqual(Debug.ppString("Hello", debug: true), #""Hello""#)

        XCTAssertEqual(Debug.ppString(42, debug: false), "42")
        XCTAssertEqual(Debug.ppString(42, debug: true), "42")

        //
        // Struct
        //

        XCTAssertEqual(Debug.ppString(dog, debug: false),
                       """
                       Dog(id: "pochi",
                           name: "ポチ",
                           nickname: nil,
                           age: 3,
                           homepage: https://www.google.com/)
                       """)

        XCTAssertEqual(Debug.ppString(dog, debug: true),
                       """
                       Dog(id: DogId(rawValue: "pochi"),
                           name: Optional("ポチ"),
                           nickname: nil,
                           age: 3,
                           homepage: Optional(https://www.google.com/))
                       """)

        XCTAssertEqual(Debug.ppString([dog, dog], debug: false),
                       """
                       [
                           Dog(id: "pochi",
                               name: "ポチ",
                               nickname: nil,
                               age: 3,
                               homepage: https://www.google.com/),
                           Dog(id: "pochi",
                               name: "ポチ",
                               nickname: nil,
                               age: 3,
                               homepage: https://www.google.com/)
                       ]
                       """)

        XCTAssertEqual(Debug.ppString([dog, dog], debug: true),
                       """
                       [
                           Dog(id: DogId(rawValue: "pochi"),
                               name: Optional("ポチ"),
                               nickname: nil,
                               age: 3,
                               homepage: Optional(https://www.google.com/)),
                           Dog(id: DogId(rawValue: "pochi"),
                               name: Optional("ポチ"),
                               nickname: nil,
                               age: 3,
                               homepage: Optional(https://www.google.com/))
                       ]
                       """)

        let dictionary: [String: Dog] = [
            "dog-1": dog,
            "dog-2": dog,
        ]

        Debug.pp(dictionary)

        XCTAssertEqual(Debug.ppString(dictionary, debug: false),
                       """
                       [
                           "dog-1": Dog(id: "pochi",
                                        name: "ポチ",
                                        nickname: nil,
                                        age: 3,
                                        homepage: https://www.google.com/),
                           "dog-2": Dog(id: "pochi",
                                        name: "ポチ",
                                        nickname: nil,
                                        age: 3,
                                        homepage: https://www.google.com/)
                       ]
                       """)

        XCTAssertEqual(Debug.ppString(dictionary, debug: true),
                       """
                       [
                           "dog-1": Dog(id: DogId(rawValue: "pochi"),
                                        name: Optional("ポチ"),
                                        nickname: nil,
                                        age: 3,
                                        homepage: Optional(https://www.google.com/)),
                           "dog-2": Dog(id: DogId(rawValue: "pochi"),
                                        name: Optional("ポチ"),
                                        nickname: nil,
                                        age: 3,
                                        homepage: Optional(https://www.google.com/))
                       ]
                       """)
    }
}
