//
//  SwiftArrayTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import Basic
import SwiftSyntax
import SwiftCodeCodable

class SwiftArrayTests: XCTestCase {

	func testInitializing() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = """
[subview1.widthAnchor.constraint(equalToConstant: 60.0),
 myConstraint]
"""
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let arrayExprSyntax = codeBlockItemList[0].item as! ArrayExprSyntax
			let array = SwiftArray(from: arrayExprSyntax)
			XCTAssertEqual(array.elements.count, 2)
		} catch let error {
			XCTFail(String(describing: error))
		}
	}
}
