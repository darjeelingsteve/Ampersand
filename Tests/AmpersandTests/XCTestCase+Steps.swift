//
//  File.swift
//  
//
//  Created by Stephen Anthony on 17/10/2019.
//

import Foundation
import XCTest

extension XCTestCase {
    func given(_ description: String, file: StaticString = #file, line: UInt = #line, closure: (XCTActivity) throws -> Void) {
        run(description, closure: closure)
    }
    
    func when(_ description: String, file: StaticString = #file, line: UInt = #line, closure: (XCTActivity) throws -> Void) {
        run(description, closure: closure)
    }
    
    func then(_ description: String, file: StaticString = #file, line: UInt = #line, closure: (XCTActivity) throws -> Void) {
        run(description, closure: closure)
    }
    
    private func run(_ description: String, closure: (XCTActivity) throws -> Void, file: StaticString = #file, line: UInt = #line) {
        do {
            try XCTContext.runActivity(named: description, block: closure)
        } catch let error {
            XCTFail("\(description) failed with error \(error)", file: file, line: line)
        }
    }
}
