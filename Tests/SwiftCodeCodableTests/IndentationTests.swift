//
//  IndentationTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 07/11/2018.
//  Copyright © 2018 MoGee. All rights reserved.
//

import XCTest
@testable import SwiftCodeCodable

class IndentationTests: XCTestCase {

	func testTabs() {
		let twoTabsIndentation = Indentation.tabs(2)
		XCTAssertEqual(twoTabsIndentation.stringValue, "\t\t")
		let threeTabsIndentation = twoTabsIndentation.increased
		XCTAssertEqual(threeTabsIndentation.stringValue, "\t\t\t")
		let newTwoTabsIndentation = threeTabsIndentation.decreased
		XCTAssertEqual(newTwoTabsIndentation.stringValue, "\t\t")
    }

	func testSpaceTabs() {
		let oneSpaceTabIndentation = Indentation.spaceTabs(1)
		XCTAssertEqual(oneSpaceTabIndentation.stringValue, "    ")
		let twoSpaceTabIndentation = oneSpaceTabIndentation.increased
		XCTAssertEqual(twoSpaceTabIndentation.stringValue, "        ")
		let newOneSpaceTabIndentation = twoSpaceTabIndentation.decreased
		XCTAssertEqual(newOneSpaceTabIndentation.stringValue, "    ")
	}
}
