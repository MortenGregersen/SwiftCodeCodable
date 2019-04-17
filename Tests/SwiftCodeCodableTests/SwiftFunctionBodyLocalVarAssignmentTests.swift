//
//  SwiftFunctionBodyLocalVarAssignmentTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import SourceKittenFramework
import SwiftCodeCodable

class SwiftFunctionBodyLocalVarAssignmentTests: XCTestCase {

	func testSuccessfulDecoding() throws {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: validLocalVarAssignmentResponse)
		let localVarAssignment = try decoder.decode(SwiftFunctionBodyLocalVarAssignment.self, from: structure)
		XCTAssertEqual(localVarAssignment.name, "subview2")
	}

    func testInvalidLocalVarAssignment() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: invalidLocalVarAssignmentResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftFunctionBodyLocalVarAssignment.self, from: structure))
    }

	let validLocalVarAssignmentResponse: [String: SourceKitRepresentable] = [
		"key.kind": "source.lang.swift.decl.var.local",
		"key.length": Int64(81),
		"key.name": "subview2",
		"key.namelength": Int64(8),
		"key.nameoffset": Int64(627),
		"key.offset": Int64(623)
	]

	let invalidLocalVarAssignmentResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(5),
		"key.bodyoffset": Int64(189),
		"key.kind": "source.lang.swift.expr.argument",
		"key.length": Int64(13),
		"key.name": "height",
		"key.namelength": Int64(6),
		"key.nameoffset": Int64(181),
		"key.offset": Int64(181)
	]
}
