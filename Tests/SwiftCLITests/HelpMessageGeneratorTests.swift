//
//  CommandMessageGeneratorTests.swift
//  SwiftCLI
//
//  Created by Jake Heiser on 6/13/15.
//  Copyright © 2015 jakeheis. All rights reserved.
//

import XCTest
@testable import SwiftCLI

class HelpMessageGeneratorTests: XCTestCase {
    
    static var allTests : [(String, (HelpMessageGeneratorTests) -> () throws -> Void)] {
        return [
            ("testCommandListGeneration", testCommandListGeneration),
            ("testUsageStatementGeneration", testUsageStatementGeneration),
            ("testMisusedOptionsStatementGeneration", testMisusedOptionsStatementGeneration)
        ]
    }
    
    let command = TestCommand()

    override func setUp() {
        super.setUp()
        
        CLI.setup(name: "tester")
    }
    
    func testCommandListGeneration() {
        let message = DefaultHelpMessageGenerator().generateCommandList(prefix: "tester", description: "A tester for SwiftCLI", routables: [
            alphaCmd,
            betaCmd
        ])
        
        let exepectedMessage = ([
            "",
            "Usage: tester <command> [options]",
            "",
            "A tester for SwiftCLI",
            "",
            "Commands:",
            "  alpha               The alpha command",
            "  beta                A beta command",
            ""
            ]).joined(separator: "\n")
        
        XCTAssertEqual(message, exepectedMessage)
    }

    func testUsageStatementGeneration() {
        let message = DefaultHelpMessageGenerator().generateUsageStatement(for: command)
        
        let expectedMessage = ([
            "Usage: tester test <testName> [<testerName>] [options]",
            "",
            "-h, --help                              Show help information for this command",
            "-s, --silent                            Silence all test output",
            "-t, --times <value>                     Number of times to run the test",
            ""
        ]).joined(separator: "\n")
        
        XCTAssertEqual(message, expectedMessage, "Should generate the correct usage statement")
    }
    
    func testMisusedOptionsStatementGeneration() {
        let arguments = ArgumentList(argumentString: "tester test -s -a --times")
        arguments.remove(node: arguments.head!)
        arguments.remove(node: arguments.head!)
        
        do {
            try DefaultOptionRecognizer().recognizeOptions(of: command, in: arguments)
            XCTFail("Option parser should fail on incorrectly used options")
        } catch let error as OptionRecognizerError {
            let message = DefaultHelpMessageGenerator().generateMisusedOptionsStatement(for: command, error: error)
            
            let expectedMessage = ([
                "Usage: tester test <testName> [<testerName>] [options]",
                "",
                "-h, --help                              Show help information for this command",
                "-s, --silent                            Silence all test output",
                "-t, --times <value>                     Number of times to run the test",
                "",
                "Unrecognized option: -a\n"
                ]).joined(separator: "\n")
            
            XCTAssertEqual(message, expectedMessage, "Should generate the correct misused options statement")
        } catch {}
    }

}