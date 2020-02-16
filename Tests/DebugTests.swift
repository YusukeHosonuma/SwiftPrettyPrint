@testable import SwiftPrettyPrint
import XCTest

struct Dog {
    var id: DogId
    var name: String?
    var nickname: String?
    var age: Int
    var homepage: URL?
}

struct DogId {
    var rawValue: String
}

class DebugTests: XCTestCase {
    let dog = Dog(id: DogId(rawValue: "pochi"),
                  name: "ポチ",
                  nickname: nil,
                  age: 3,
                  homepage: URL(string: "https://www.google.com/"))

    override func setUp() {}

    override func tearDown() {}

    func test_pString() {
        let expectString =
            #"Dog(id: "pochi", name: "ポチ", nickname: nil, age: 3, homepage: https://www.google.com/)"#

        let expectDebugString =
            #"Dog(id: DogId(rawValue: "pochi"), name: Optional("ポチ"), nickname: nil, age: 3, homepage: Optional(https://www.google.com/))"#

        XCTAssertEqual(Debug.pString(dog, debug: false),
                       expectString)

        XCTAssertEqual(Debug.pString(dog, debug: true),
                       expectDebugString)

        XCTAssertEqual(Debug.pString([dog, dog], debug: false),
                       "[\(expectString), \(expectString)]")

        XCTAssertEqual(Debug.pString([dog, dog], debug: true),
                       "[\(expectDebugString), \(expectDebugString)]")

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
