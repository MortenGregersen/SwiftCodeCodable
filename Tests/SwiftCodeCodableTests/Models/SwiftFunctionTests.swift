//
//  SwiftFunctionTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 03/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import Basic
import SwiftSyntax
import SwiftCodeCodable

class SwiftFunctionTests: XCTestCase {

	func testInitializinInternalOverride() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = """
internal override func setupViews(frame: CGRect) -> UIView {
	let subview = UIView(frame: frame)
	subview.setProperties(alpha: 0.5, isHidden: true)
	return subview
}
"""
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let funcDeclSyntax = codeBlockItemList[0].item as! FunctionDeclSyntax
			let function = SwiftFunction(from: funcDeclSyntax)
			XCTAssertEqual(function.name, "setupViews")
			XCTAssertEqual(function.accessibility, .internal)
			XCTAssertEqual(function.kind, .instance)
			XCTAssertEqual(function.attributes, [.internal, .override])
			XCTAssertEqual(function.parameters, [SwiftFunctionParameter(name: "frame", type: "CGRect")])
			XCTAssertEqual(function.returnType, "UIView")
			XCTAssertEqual(function.bodyLines.count, 2)
			// swiftlint:disable:next force_cast
			let varAssignment = function.bodyLines[0] as! SwiftFunctionBodyLocalVarAssignment
			XCTAssertEqual(varAssignment.name, "subview")
			XCTAssertEqual(varAssignment.expressionCall.name, "UIView")
			XCTAssertEqual(varAssignment.expressionCall.arguments[0].name, "frame")
			XCTAssertEqual(varAssignment.expressionCall.arguments[0].value as? String, "frame")
			// swiftlint:disable:next force_cast
			let expressionCall = function.bodyLines[1] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(expressionCall.name, "subview.setProperties")
			XCTAssertEqual(expressionCall.arguments[0].name, "alpha")
			XCTAssertEqual(expressionCall.arguments[0].value as? String, "0.5")
			XCTAssertEqual(expressionCall.arguments[1].name, "isHidden")
			XCTAssertEqual(expressionCall.arguments[1].value as? String, "true")
		} catch let error {
			XCTFail(String(describing: error))
		}
	}
	
	func testInitializinNoReturnNoBody() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = """
func doNothing() {
}
"""
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let funcDeclSyntax = codeBlockItemList[0].item as! FunctionDeclSyntax
			let function = SwiftFunction(from: funcDeclSyntax)
			XCTAssertEqual(function.name, "doNothing")
			XCTAssertEqual(function.accessibility, .internal)
			XCTAssertEqual(function.kind, .instance)
			XCTAssertEqual(function.attributes, [])
			XCTAssertEqual(function.parameters, [])
			XCTAssertNil(function.returnType)
			XCTAssertEqual(function.bodyLines.count, 0)
		} catch let error {
			XCTFail(String(describing: error))
		}
	}

	func testInitializingOverrideInit() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = """
override init(frame: CGRect) {
	super.init(frame: frame)
	var backgroundColor = UIColor.black()
	setProperties(backgroundColor: backgroundColor)
	tintColor = UIColor.blueColor()
}
"""
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let initDeclSyntax = codeBlockItemList[0].item as! InitializerDeclSyntax
			let function = SwiftFunction(from: initDeclSyntax)
			XCTAssertEqual(function.name, "init")
			XCTAssertEqual(function.accessibility, .internal)
			XCTAssertEqual(function.kind, .instance)
			XCTAssertEqual(function.attributes, [.override])
			XCTAssertEqual(function.parameters, [SwiftFunctionParameter(name: "frame", type: "CGRect")])
			XCTAssertNil(function.returnType)
			XCTAssertEqual(function.bodyLines.count, 3)
		} catch let error {
			XCTFail(String(describing: error))
		}
	}

	func testInitializingRequiredOptionalInit() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = """
required init?(coder aDecoder: NSCoder) {
	fatalError("init(coder:) has not been implemented")
}
"""
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let initDeclSyntax = codeBlockItemList[0].item as! InitializerDeclSyntax
			let function = SwiftFunction(from: initDeclSyntax)
			XCTAssertEqual(function.name, "init?")
			XCTAssertEqual(function.accessibility, .internal)
			XCTAssertEqual(function.kind, .instance)
			XCTAssertEqual(function.attributes, [.required])
			XCTAssertEqual(function.parameters, [SwiftFunctionParameter(name: "coder", type: "NSCoder")])
			XCTAssertNil(function.returnType)
			XCTAssertEqual(function.bodyLines.count, 1)
		} catch let error {
			XCTFail(String(describing: error))
		}
	}
	
	func testInitializingInvalidAttribute() {
		XCTAssertNil(SwiftFunctionAttribute(from: DeclModifierSyntax { builder in
			builder.useName(SyntaxFactory.makeIdentifier("Something invalid"))
		}))
	}
}

extension SwiftFunctionParameter: Equatable {
	public static func == (lhs: SwiftFunctionParameter, rhs: SwiftFunctionParameter) -> Bool {
		return lhs.name == rhs.name && lhs.type == rhs.type
	}
}
