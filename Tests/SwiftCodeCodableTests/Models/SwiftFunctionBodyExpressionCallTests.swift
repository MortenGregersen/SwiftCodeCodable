//
//  SwiftFunctionBodyExpressionCallTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import Basic
import SwiftSyntax
import SwiftCodeCodable

class SwiftFunctionBodyExpressionCallTests: XCTestCase {

    func testInitializing() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = "rootView.setProperties(alpha: 0.5, isHidden: false)"
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let callExprSyntax = codeBlockItemList[0].item as! FunctionCallExprSyntax
			let call = SwiftFunctionBodyExpressionCall(from: callExprSyntax)
			XCTAssertEqual(call.name, "rootView.setProperties")
			XCTAssertEqual(call.arguments.count, 2)
			let argument1 = call.arguments[0]
			XCTAssertEqual(argument1.name, "alpha")
			XCTAssertEqual(argument1.value as? String, "0.5")
			let argument2 = call.arguments[1]
			XCTAssertEqual(argument2.name, "isHidden")
			XCTAssertEqual(argument2.value as? String, "false")
		} catch let error {
			XCTFail(String(describing: error))
		}
    }
	
	func testInitializingWithChildExpression() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = "rootView.setProperties(frame: CGRect(x: 60.0, y: 20.0, width: 40.0, height: 60.0))"
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let callExprSyntax = codeBlockItemList[0].item as! FunctionCallExprSyntax
			let call = SwiftFunctionBodyExpressionCall(from: callExprSyntax)
			XCTAssertEqual(call.name, "rootView.setProperties")
			XCTAssertEqual(call.arguments.count, 1)
			let argument = call.arguments[0]
			XCTAssertEqual(argument.name, "frame")
			// swiftlint:disable:next force_cast
			let value = argument.value as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(value.name, "CGRect")
			XCTAssertEqual(value.arguments[0].name, "x")
			XCTAssertEqual(value.arguments[1].name, "y")
			XCTAssertEqual(value.arguments[2].name, "width")
			XCTAssertEqual(value.arguments[3].name, "height")
		} catch let error {
			XCTFail(String(describing: error))
		}
	}
}
