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

final class CombineExtensionTests: XCTestCase {
    var cancellables: [AnyCancellable] = []
    
    let array = [
        [1, 2],
        [3, 4],
    ]
    
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
