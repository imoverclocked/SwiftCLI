//
//  OptionRegistryTests.swift
//  SwiftCLI
//
//  Created by Jake Heiser on 3/29/17.
//
//

import XCTest
@testable import SwiftCLI

class OptionRegistryTests: XCTestCase {
    
    static var allTests : [(String, (OptionRegistryTests) -> () throws -> Void)] {
        return [
            ("testFlagDetection", testFlagDetection),
            ("testKeyDetection", testKeyDetection)
        ]
    }
    
    func testFlagDetection() {
        let cli = CLI(name: "tester")
        let cmd = FlagCmd()
        let options = OptionRegistry(options: cmd.options(for: cli), optionGroups: cmd.optionGroups)
        XCTAssert(options.flag(for: "-a") != nil, "Options should expect flags after a call to onFlags")
        XCTAssert(options.flag(for: "--alpha") != nil, "Options should expect flags after a call to onFlags")
        XCTAssert(options.key(for: "-a") == nil, "Options should parse no keys from only flags")
    }
    
    func testKeyDetection() {
        let cli = CLI(name: "tester")
        let cmd = KeyCmd()
        let options = OptionRegistry(options: cmd.options(for: cli), optionGroups: cmd.optionGroups)
        XCTAssert(options.key(for: "-a") != nil, "Options should expect keys after a call to onKeys")
        XCTAssert(options.key(for: "--alpha") != nil, "Options should expect keys after a call to onKeys")
        XCTAssert(options.flag(for: "-a") == nil, "Options should parse no flags from only keys")
    }
    
}
