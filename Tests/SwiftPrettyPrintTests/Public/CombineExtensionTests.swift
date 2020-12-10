//
//  CombineExtensionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

// Linux is not supported to Combine framework.
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

import XCTest
import Combine
@testable import SwiftPrettyPrint

// Note:
// Original `print` operator output is:
// https://developer.apple.com/documentation/combine/publisher/print(_:to:)
//
// ```
// receive subscription: ([[1, 2], [3, 4]])
// request unlimited
// receive value: ([1, 2])
// receive value: ([3, 4])
// receive finished
// ```

final class StringRecorder: TextOutputStream {
    var contents: String = ""
    
    func write(_ string: String) {
        contents.append(string)
    }
}

struct TestError: Error {
    let code = 1
    let message =  "This is the error"
}

final class CombineExtensionTests: XCTestCase {
    var cancellables: [AnyCancellable] = []
    
    let array = [
        [1, 2],
        [3, 4],
    ]
    
    func testPrefix() throws {
        let recorder = StringRecorder()
        let exp = expectation(description: "")
        
        array
            .publisher
            .prettyPrint("🍎", format: .singleline, to: recorder)
            .handleEvents(receiveCompletion: { _ in
                exp.fulfill()
            })
            .sink { value in }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 3)
        
        // Note:
        // Order of first and second line is unstable.
        XCTAssert(recorder.contents.contains("🍎: receive subscription: [[1, 2], [3, 4]]"))
        XCTAssert(recorder.contents.contains("🍎: request unlimited"))
        assertEqualLines(recorder.contents.split(separator: "\n")[2...].joined(separator: "\n"),
            """
            🍎: receive value: [1, 2]
            🍎: receive value: [3, 4]
            🍎: receive finished
            """)
        
        let exp2 = expectation(description: "")
        
        Fail<[Int], TestError>(error: TestError())
            .prettyPrint("🍎", when: [.completion], format: .singleline, to: recorder)
            .handleEvents(receiveCompletion: { _ in
                exp2.fulfill()
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        wait(for: [exp2], timeout: 3)
        
        XCTAssert(recorder.contents.contains("🍎: receive failure: TestError(code: 1, message: \"This is the error\")"))
        
        
        
    }
    
    func testWhen() throws {
        let tests: [(line: UInt, when: [CombineOperatorOption.Event], expected: String)] = [
            (
                line: #line,
                when: [.output],
                expected: """
                receive value: [1, 2]
                receive value: [3, 4]

                """
            ),
            (
                line: #line,
                when: [.completion],
                expected: """
                receive finished

                """
            ),
            (
                line: #line,
                when: [.output, .completion],
                expected: """
                receive value: [1, 2]
                receive value: [3, 4]
                receive finished

                """
            )
        ]
        
        for test in tests {
            let recorder = StringRecorder()
            let exp = expectation(description: "")
            
            array
                .publisher
                .prettyPrint(when: test.when, format: .singleline, to: recorder)
                .handleEvents(receiveCompletion: { _ in
                    exp.fulfill()
                })
                .sink { value in }
                .store(in: &cancellables)
            
            wait(for: [exp], timeout: 3)

            assertEqualLines(recorder.contents, test.expected, line: test.line)
        }
    }
    
    func testSingleline() throws {
        let recorder = StringRecorder()
        let exp = expectation(description: "")
        
        array
            .publisher
            .prettyPrint(format: .singleline, to: recorder)
            .handleEvents(receiveCompletion: { _ in
                exp.fulfill()
            })
            .sink { value in }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 3)
        
        // Note:
        // Order of first and second line is unstable.
        XCTAssert(recorder.contents.contains("receive subscription: [[1, 2], [3, 4]]"))
        XCTAssert(recorder.contents.contains("request unlimited"))
        assertEqualLines(recorder.contents.split(separator: "\n")[2...].joined(separator: "\n"),
            """
            receive value: [1, 2]
            receive value: [3, 4]
            receive finished
            """)
    }

    func testMultiline() throws {
        let recorder = StringRecorder()
        let exp = expectation(description: "")
        
        array
            .publisher
            .prettyPrint(to: recorder)
            .handleEvents(receiveCompletion: { _ in
                exp.fulfill()
            })
            .sink { value in }
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 3)
        
        // Note:
        // Order of first and second line is unstable.
        XCTAssert(recorder.contents.contains("receive subscription: [[1, 2], [3, 4]]"))
        XCTAssert(recorder.contents.contains("request unlimited"))
        assertEqualLines(recorder.contents.split(separator: "\n")[2...].joined(separator: "\n"),
            """
            receive value:
            [
                1,
                2
            ]
            receive value:
            [
                3,
                4
            ]
            receive finished
            """)
    }
}

#endif
