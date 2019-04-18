//
//  SwiftFunctionBodyExpressionArgumentTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import SourceKittenFramework
@testable import SwiftCodeCodable

class SwiftFunctionBodyExpressionArgumentTests: XCTestCase {

    func testManualInitialization() {
		let argumentWithName = SwiftFunctionBodyExpressionArgument(name: "parent", value: "rootView")
		XCTAssertEqual(argumentWithName.name, "parent")
		XCTAssertEqual(argumentWithName.value as? String, "rootView")

		let argument = SwiftFunctionBodyExpressionArgument(value: "presenter")
		XCTAssertNil(argument.name)
		XCTAssertEqual(argument.value as? String, "presenter")
    }

	func testSuccessfulDecoding() {
		let decoder = SourceKittenStructureDecoder()
		decoder.userInfo[RawSwiftDecodingInfo.key] = "isHidden: true"
		let structure = Structure(sourceKitResponse: validArgumentResponse)
		do {
			let argument = try decoder.decode(SwiftFunctionBodyExpressionArgument.self, from: structure)
			XCTAssertEqual(argument.name, "isHidden")
			XCTAssertEqual(argument.value as? String, "true")
		} catch let error {
			XCTFail(String(describing: error))
		}
	}

	func testSuccessfulDecodingWithSubstructure() {
		let decoder = SourceKittenStructureDecoder()
		decoder.userInfo[RawSwiftDecodingInfo.key] = "frame: CGRect(x: 60.0, y: 20.0, width: 40.0, height: 60.0)"
		let structure = Structure(sourceKitResponse: validArgumentWithSubStructureResponse)
		do {
			let argument = try decoder.decode(SwiftFunctionBodyExpressionArgument.self, from: structure)
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

	func testInvalidArgument() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: invalidArgumentResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftFunctionBodyExpressionArgument.self, from: structure))
	}

	func testUnknownSubstructure() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: unknownSubstructureResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftFunctionBodyExpressionArgument.self, from: structure))
	}

	func testMissingRawSwift() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: validArgumentResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftFunctionBodyExpressionArgument.self, from: structure))
	}

	let validArgumentResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(4),
		"key.bodyoffset": Int64(10),
		"key.kind": "source.lang.swift.expr.argument",
		"key.length": Int64(15),
		"key.name": "isHidden",
		"key.namelength": Int64(8),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(0)
	]

	let validArgumentWithSubStructureResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(50),
		"key.bodyoffset": Int64(7),
		"key.kind": "source.lang.swift.expr.argument",
		"key.length": Int64(57),
		"key.name": "frame",
		"key.namelength": Int64(5),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(0),
		"key.substructure": [
			[
				"key.bodylength": Int64(42),
				"key.bodyoffset": Int64(14),
				"key.kind": "source.lang.swift.expr.call",
				"key.length": Int64(50),
				"key.name": "CGRect",
				"key.namelength": Int64(6),
				"key.nameoffset": Int64(7),
				"key.offset": Int64(7),
				"key.substructure": [
					[
						"key.bodylength": Int64(3),
						"key.bodyoffset": Int64(17),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(6),
						"key.name": "x",
						"key.namelength": Int64(1),
						"key.nameoffset": Int64(14),
						"key.offset": Int64(14)
					],
					[
						"key.bodylength": Int64(4),
						"key.bodyoffset": Int64(25),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(7),
						"key.name": "y",
						"key.namelength": Int64(1),
						"key.nameoffset": Int64(22),
						"key.offset": Int64(22)
					],
					[
						"key.bodylength": Int64(4),
						"key.bodyoffset": Int64(38),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(11),
						"key.name": "width",
						"key.namelength": Int64(5),
						"key.nameoffset": Int64(31),
						"key.offset": Int64(31)
					],
					[
						"key.bodylength": Int64(4),
						"key.bodyoffset": Int64(52),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(12),
						"key.name": "height",
						"key.namelength": Int64(6),
						"key.nameoffset": Int64(44),
						"key.offset": Int64(44)
					]
				]
			]
		]
	]

	let invalidArgumentResponse: [String: SourceKitRepresentable] = [
		"key.kind": "source.lang.swift.decl.var.local",
		"key.length": Int64(81),
		"key.name": "subview2",
		"key.namelength": Int64(8),
		"key.nameoffset": Int64(627),
		"key.offset": Int64(623)
	]

	let unknownSubstructureResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(50),
		"key.bodyoffset": Int64(7),
		"key.kind": "source.lang.swift.expr.argument",
		"key.length": Int64(57),
		"key.name": "frame",
		"key.namelength": Int64(5),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(0),
		"key.substructure": [[
			"key.kind": "some.invalid.kind"
		]]
	]
}
