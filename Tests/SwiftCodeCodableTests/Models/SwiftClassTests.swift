//
//  SwiftClassTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 06/05/2019.
//

import XCTest
import Basic
import SwiftSyntax
import SwiftCodeCodable

class SwiftClassTests: XCTestCase {

    func testInitializing() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = """
import UIKit

class MyView: UIView {
	
	class func createRootView() -> MyView {
		let view = MyView()
		return view
	}
}
"""
			let syntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let codeBlockItemList = syntax.child(at: 0) as! CodeBlockItemListSyntax
			let classDeclSyntax = codeBlockItemList[1].item as! ClassDeclSyntax
			let aClass = SwiftClass(from: classDeclSyntax)
			XCTAssertEqual(aClass.name, "MyView")
			XCTAssertEqual(aClass.accessibility, .internal)
			XCTAssertEqual(aClass.functions.count, 1)
		} catch let error {
			XCTFail(String(describing: error))
		}
    }
}
