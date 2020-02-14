import XCTest
import SwiftPrettyPrint

struct Dog {
    var id: DogId
    var name: String?
    var nickname: String?
    var age: Int
    var homepage: URL?
}

struct DogId: DebuggableValue {
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
            #"Dog(id: DogId("pochi"), name: Optional("ポチ"), nickname: nil, age: 3, homepage: Optional(https://www.google.com/))"#

        XCTAssertEqual(Debug.pString(dog, debug: false),
                       expectString)

        XCTAssertEqual(Debug.pString(dog, debug: true),
                       expectDebugString)

        XCTAssertEqual(Debug.pString([dog, dog], debug: false),
                       "[\(expectString), \(expectString)]")
        
        XCTAssertEqual(Debug.pString([dog, dog], debug: true),
                       "[\(expectDebugString), \(expectDebugString)]")
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
                       Dog(id: DogId("pochi"),
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
                           Dog(id: DogId("pochi"),
                               name: Optional("ポチ"),
                               nickname: nil,
                               age: 3,
                               homepage: Optional(https://www.google.com/)),
                           Dog(id: DogId("pochi"),
                               name: Optional("ポチ"),
                               nickname: nil,
                               age: 3,
                               homepage: Optional(https://www.google.com/))
                       ]
                       """)
    }
}
