//
//  CombineExtensionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

// Linux is not supported to Combine framework.
#if canImport(Combine)

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
        
        subscribeAndWait(
            array
                .publisher
                .setFailureType(to: TestError.self)
                .prettyPrint("🍎", format: .singleline, to: recorder)
                .eraseToAnyPublisher()
        )
        
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
        
        subscribeAndWait(
            Fail<[Int], TestError>(error: TestError())
                .prettyPrint("🍎", when: [.completion], format: .singleline, to: recorder)
                .eraseToAnyPublisher()
        )
        
        XCTAssert(recorder.contents.contains("🍎: receive failure: TestError(code: 1, message: \"This is the error\")"))
        
        
        
    }
    
    func testWhenForFinished() throws {
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
            
            subscribeAndWait(
                array.publisher
                    .setFailureType(to: TestError.self)
                    .prettyPrint(when: test.when, format: .singleline, to: recorder)
                    .eraseToAnyPublisher()
            )

            assertEqualLines(recorder.contents, test.expected, line: test.line)
        }
    }
    
    func testWhenForFailure() throws {
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
                  receive failure: TestError(code: 1, message: \"This is the error\")

                  """
            ),
            (
                line: #line,
                when: [.output, .completion],
                expected: """
                  receive value: [1, 2]
                  receive value: [3, 4]
                  receive failure: TestError(code: 1, message: \"This is the error\")

                  """
            )
        ]
        
        for test in tests {
            let subject: PassthroughSubject<[Int], TestError> = .init()
            let recorder = StringRecorder()
            subscribeAndWait(
                subject
                    .prettyPrint(when: test.when, format: .singleline, to: recorder)
                    .eraseToAnyPublisher(),
                sendHandler: { [array] in
                    subject.send(array[0])
                    subject.send(array[1])
                    subject.send(completion: .failure(TestError()))
                }
            )
            
            assertEqualLines(recorder.contents, test.expected, line: test.line)
        }
    }
    
    func testSingleline() throws {
        do {
            let recorder = StringRecorder()
            
            subscribeAndWait(
                array.publisher
                    .setFailureType(to: TestError.self)
                    .prettyPrint(format: .singleline, to: recorder)
                    .eraseToAnyPublisher()
            )
            
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
        
        do {
            let recorder = StringRecorder()
            subscribeAndWait(
                Fail<[Int], TestError>(error: TestError())
                    .prettyPrint(format: .singleline, to: recorder)
                    .eraseToAnyPublisher()
            )
            
            XCTAssert(recorder.contents.contains("receive failure: TestError(code: 1, message: \"This is the error\")"))
        }
    }

    func testMultiline() throws {
        do {
            let recorder = StringRecorder()
            
            subscribeAndWait(
                array.publisher.setFailureType(to: TestError.self)
                    .prettyPrint(to: recorder)
                    .eraseToAnyPublisher()
            )
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
        
        do {
            let recorder = StringRecorder()
            
            subscribeAndWait(
                Fail<[Int], TestError>(error: TestError())
                    .prettyPrint(to: recorder)
                    .eraseToAnyPublisher()
            )
            
            assertEqualLines(recorder.contents.split(separator: "\n")[2...].joined(separator: "\n"),
                             """
            receive failure:
            TestError(
                code: 1,
                message: "This is the error"
            )
            """)
        }
    }
    
    private func subscribeAndWait(_ publisher: AnyPublisher<[Int], TestError>, sendHandler: (() -> Void)? = nil) {
        let exp = expectation(description: "")
        publisher
            .handleEvents(receiveCompletion: { _ in
                exp.fulfill()
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        sendHandler?()
        wait(for: [exp], timeout: 3)
    }
}

#endif
