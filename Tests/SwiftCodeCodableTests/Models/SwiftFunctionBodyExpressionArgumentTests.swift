//
//  SwiftFunctionBodyExpressionArgumentTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import Basic
import SwiftSyntax
import SwiftCodeCodable

class SwiftFunctionBodyExpressionArgumentTests: XCTestCase {

    func testInitializing() {
		let argumentWithName = SwiftFunctionBodyExpressionArgument(name: "parent", value: "rootView")
		XCTAssertEqual(argumentWithName.name, "parent")
		XCTAssertEqual(argumentWithName.value as? String, "rootView")

		let argument = SwiftFunctionBodyExpressionArgument(value: "presenter")
		XCTAssertNil(argument.name)
		XCTAssertEqual(argument.value as? String, "presenter")
    }
}
