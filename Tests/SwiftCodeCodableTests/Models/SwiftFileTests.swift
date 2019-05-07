//
//  SwiftFileTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 06/05/2019.
//

import XCTest
import Basic
import SwiftSyntax
import SwiftCodeCodable

class SwiftFileTests: XCTestCase {

    func testInitializing() {
		do {
			let temporaryFile = try TemporaryFile()
			let swiftCode = """
import UIKit

class MyView: UIView {

}
"""
			let sourceFileSyntax = try SyntaxTreeParser.parse(fileURL(for: temporaryFile, with: swiftCode))
			let file = SwiftFile(from: sourceFileSyntax)
			XCTAssertEqual(file.classes.count, 1)
		} catch let error {
			XCTFail(String(describing: error))
		}
    }
}
