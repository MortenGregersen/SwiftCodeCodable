//
//  SwiftWriterTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 03/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
@testable import SwiftCodeCodable

// swiftlint:disable line_length

class SwiftWriterTests: XCTestCase {

    func testGenerateHeaderAndImports() {
		XCTAssertEqual(SwiftWriter.generateHeaderAndImports(), """
//
// Generated by SwiftCodeCodable.
//

import UIKit
\n
""")
    }

	func testGenerateClassDeclaration() {
		let actual1 = SwiftWriter.generateClassDeclaration(name: "MyView", parent: "UITableView", content: "weak var delegate: UITableViewDelegate?")
		let expected1 = """
class MyView: UITableView {

	weak var delegate: UITableViewDelegate?
}
"""
		XCTAssertEqual(actual1, expected1)

		let actual2 = SwiftWriter.generateClassDeclaration(name: "MyView", content: "weak var delegate: UITableViewDelegate?")
		let expected2 = """
class MyView {

	weak var delegate: UITableViewDelegate?
}
"""
		XCTAssertEqual(actual2, expected2)
	}

	func testGenerateFunctionDeclaration() {
		let actual1 = SwiftWriter.generateFunctionDeclaration(type: .plain(name: "dump"), content: "let answer = 42\nprint(answer)")
		let expected1 = """
func dump() {
	let answer = 42
	print(answer)
}
"""
		XCTAssertEqual(actual1, expected1)

		let actual2 = SwiftWriter.generateFunctionDeclaration(type: .class(name: "create"), arguments: ["service": "MyService"], returnType: "MyView", content: "let answer = 42\nprint(answer)")
		let expected2 = """
class func create(service: MyService) -> MyView {
	let answer = 42
	print(answer)
}
"""
		XCTAssertEqual(actual2, expected2)
		
		let actual3 = SwiftWriter.generateFunctionDeclaration(type: .initializer(required: false, override: true, canReturnNil: false), arguments: ["frame": "CGRect"], content: "alpha = 0.5")
		let expected3 = """
override init(frame: CGRect) {
	alpha = 0.5
}
"""
		XCTAssertEqual(actual3, expected3)
		
		let actual4 = SwiftWriter.generateFunctionDeclaration(type: .initializer(required: true, override: false, canReturnNil: true), arguments: ["aDecoder": "NSCoder"], content: #"fatalError("init(coder:) has not been implemented")"#)
		let expected4 = """
required init?(aDecoder: NSCoder) {
	fatalError("init(coder:) has not been implemented")
}
"""
		XCTAssertEqual(actual4, expected4)
	}

	func testGenerateVariableAssignment() {
		let actual = SwiftWriter.generateVariableAssignment(type: .let, destination: "answer", value: "42")
		let expected = "let answer = 42"
		XCTAssertEqual(actual, expected)
	}
}
