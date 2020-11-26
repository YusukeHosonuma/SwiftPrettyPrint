//
//  CombineExtensionTests.swift
//  SwiftPrettyPrintTests
//
//  Created by Yusuke Hosonuma on 2020/11/26.
//

import XCTest
import Combine
@testable import SwiftPrettyPrint

// Note:
// Original `print` operator output is:
//
// ```
// receive subscription: ([[1, 2], [3, 4]])
// request unlimited
// receive value: ([1, 2])
// receive value: ([3, 4])
// receive finished
// ```

final class CombineExtensionInternalTests: XCTestCase {
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
        
        assertEqualLines(recorder.string, """
            receive subscription: [[1, 2], [3, 4]]
            request unlimited
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
        
        assertEqualLines(recorder.string, """
            receive subscription: [[1, 2], [3, 4]]
            request unlimited
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
