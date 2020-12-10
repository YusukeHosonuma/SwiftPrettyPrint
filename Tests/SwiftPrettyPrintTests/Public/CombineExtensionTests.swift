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
        
        subscribeAndWait(
            array
                .publisher
                .setFailureType(to: TestError.self)
                .prettyPrint("🍎", format: .singleline, to: recorder).eraseToAnyPublisher(),
            exp: exp
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
        
        let exp2 = expectation(description: "")
        
        subscribeAndWait(
            Fail<[Int], TestError>(error: TestError())
                .prettyPrint("🍎", when: [.completion], format: .singleline, to: recorder).eraseToAnyPublisher(),
            exp: exp2
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
            let exp = expectation(description: "")
            
            subscribeAndWait(
                array.publisher
                    .setFailureType(to: TestError.self)
                    .prettyPrint(when: test.when, format: .singleline, to: recorder).eraseToAnyPublisher(),
                exp: exp
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
            let exp = expectation(description: "")
            
            subscribeAndWait(
                subject.prettyPrint(when: test.when, format: .singleline, to: recorder).eraseToAnyPublisher(),
                exp: exp
            )
            
            subject.send(array[0])
            subject.send(array[1])
            subject.send(completion: .failure(TestError()))
            
            assertEqualLines(recorder.contents, test.expected, line: test.line)
        }
    }
    
    func testSingleline() throws {
        
        let recorder = StringRecorder()
        let exp = expectation(description: "")
        
        
        subscribeAndWait(
            array.publisher
                .setFailureType(to: TestError.self)
                .prettyPrint(format: .singleline, to: recorder)
                .eraseToAnyPublisher(),
            exp: exp
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
        
        let exp2 = expectation(description: "")
        let recorder2 = StringRecorder()
        subscribeAndWait(
            Fail<[Int], TestError>(error: TestError())
                .prettyPrint(format: .singleline, to: recorder2)
                .eraseToAnyPublisher(),
            exp: exp2
        )

        XCTAssert(recorder2.contents.contains("receive failure: TestError(code: 1, message: \"This is the error\")"))
    }

    func testMultiline() throws {
        let recorder = StringRecorder()
        let exp = expectation(description: "")
        
        subscribeAndWait(
            array.publisher.setFailureType(to: TestError.self).prettyPrint(to: recorder).eraseToAnyPublisher(),
            exp: exp
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
        
        let recorder2 = StringRecorder()
        let exp2 = expectation(description: "")
        
        subscribeAndWait(
            Fail<[Int], TestError>(error: TestError()).prettyPrint(to: recorder2).eraseToAnyPublisher(),
            exp: exp2
        )
        
        assertEqualLines(recorder2.contents.split(separator: "\n")[2...].joined(separator: "\n"),
            """
            receive failure:
            TestError(
                code: 1,
                message: "This is the error"
            )
            """)
    }
    
    private func subscribeAndWait(_ publisher: AnyPublisher<[Int], TestError>, exp: XCTestExpectation) {
        publisher
            .handleEvents(receiveCompletion: { _ in
                exp.fulfill()
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        wait(for: [exp], timeout: 3)
    }
}

#endif
