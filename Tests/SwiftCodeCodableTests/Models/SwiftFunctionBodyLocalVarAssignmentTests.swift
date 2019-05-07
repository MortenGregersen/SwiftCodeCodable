//
//  SwiftFunctionBodyLocalVarAssignmentTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import Basic
import SwiftSyntax
import SwiftCodeCodable

class SwiftFunctionBodyLocalVarAssignmentTests: XCTestCase {

	func testInitializing() throws {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = "let subview = UIView(frame: frame)"
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let varDeclSyntax = codeBlockItemList[0].item as! VariableDeclSyntax
			let localVarAssignment = SwiftFunctionBodyLocalVarAssignment(from: varDeclSyntax)
			XCTAssertEqual(localVarAssignment.name, "subview")
			XCTAssertEqual(localVarAssignment.expressionCall.name, "UIView")
			XCTAssertEqual(localVarAssignment.expressionCall.arguments.count, 1)
			let argument = localVarAssignment.expressionCall.arguments[0]
			XCTAssertEqual(argument.name, "frame")
			XCTAssertEqual(argument.value as! String, "frame")
		} catch let error {
			XCTFail(error.localizedDescription)
		}
	}
}
