//
//  SwiftFunctionBodyExpressionCallTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import SourceKittenFramework
import SwiftCodeCodable

// swiftlint:disable line_length

class SwiftFunctionBodyExpressionCallTests: XCTestCase {

    func testSuccessfulDecoding() {
		do {
			let decoder = SourceKittenStructureDecoder()
			decoder.userInfo[RawSwiftDecodingInfo.key] = "rootView.setProperties(alpha: 0.5, isHidden: false"
			let structure = Structure(sourceKitResponse: validCallResponse)
			let call = try decoder.decode(SwiftFunctionBodyExpressionCall.self, from: structure)
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

	func testSuccessfulDecodingWithArraySubstructure() {
		do {
			let decoder = SourceKittenStructureDecoder()
			decoder.userInfo[RawSwiftDecodingInfo.key] = "subview1.addConstraints([subview1.widthAnchor.constraint(equalToConstant: 60.0), subview1.heightAnchor.constraint(equalToConstant: 90.0)])"
			let structure = Structure(sourceKitResponse: validCallWithArrayResponse)
			let call = try decoder.decode(SwiftFunctionBodyExpressionCall.self, from: structure)
			XCTAssertEqual(call.name, "subview1.addConstraints")
			XCTAssertEqual(call.arguments.count, 1)
			let argument = call.arguments[0]
			XCTAssertNil(argument.name)
			// swiftlint:disable:next force_cast
			let arrayArgument = argument.value as! SwiftArray
			XCTAssertEqual(arrayArgument.elements.count, 2)
		} catch let error {
			XCTFail(String(describing: error))
		}
	}

	func testSuccessfulDecodingWithoutSubstructure() {
		do {
			let decoder = SourceKittenStructureDecoder()
			decoder.userInfo[RawSwiftDecodingInfo.key] = "rootView.addSubview(subview1)"
			let structure = Structure(sourceKitResponse: validCallWithoutSubstructureResponse)
			let call = try decoder.decode(SwiftFunctionBodyExpressionCall.self, from: structure)
			XCTAssertEqual(call.name, "rootView.addSubview")
			XCTAssertEqual(call.arguments.count, 1)
			let argument = call.arguments[0]
			XCTAssertNil(argument.name)
			// swiftlint:disable:next force_cast
			let value = argument.value as! String
			XCTAssertEqual(value, "subview1")
		} catch let error {
			XCTFail(String(describing: error))
		}
	}

	func testInvalidExpressionCall() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: invalidCallResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftFunctionBodyExpressionCall.self, from: structure))
	}

	let validCallResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(27),
		"key.bodyoffset": Int64(23),
		"key.kind": "source.lang.swift.expr.call",
		"key.length": Int64(51),
		"key.name": "rootView.setProperties",
		"key.namelength": Int64(22),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(0),
		"key.substructure": [
			[
				"key.bodylength": Int64(3),
				"key.bodyoffset": Int64(30),
				"key.kind": "source.lang.swift.expr.argument",
				"key.length": Int64(10),
				"key.name": "alpha",
				"key.namelength": Int64(5),
				"key.nameoffset": Int64(23),
				"key.offset": Int64(23)
			],
			[
				"key.bodylength": Int64(5),
				"key.bodyoffset": Int64(45),
				"key.kind": "source.lang.swift.expr.argument",
				"key.length": Int64(15),
				"key.name": "isHidden",
				"key.namelength": Int64(8),
				"key.nameoffset": Int64(35),
				"key.offset": Int64(35)
			]
		]
	]

	let validCallWithArrayResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(122),
		"key.bodyoffset": Int64(24),
		"key.kind": "source.lang.swift.expr.call",
		"key.length": Int64(147),
		"key.name": "subview1.addConstraints",
		"key.namelength": Int64(23),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(0),
		"key.substructure": [
			[
				"key.bodylength": Int64(120),
				"key.bodyoffset": Int64(25),
				"key.elements": [
					[
						"key.kind": "source.lang.swift.structure.elem.expr",
						"key.length": Int64(54),
						"key.offset": Int64(25)
					],
					[
						"key.kind": "source.lang.swift.structure.elem.expr",
						"key.length": Int64(55),
						"key.offset": Int64(90)
					]
				],
				"key.kind": "source.lang.swift.expr.array",
				"key.length": Int64(122),
				"key.namelength": Int64(0),
				"key.nameoffset": Int64(0),
				"key.offset": Int64(24),
				"key.substructure": [
					[
						"key.bodylength": Int64(21),
						"key.bodyoffset": Int64(57),
						"key.kind": "source.lang.swift.expr.call",
						"key.length": Int64(54),
						"key.name": "subview1.widthAnchor.constraint",
						"key.namelength": Int64(31),
						"key.nameoffset": Int64(25),
						"key.offset": Int64(25),
						"key.substructure": [
							[
								"key.bodylength": Int64(4),
								"key.bodyoffset": Int64(74),
								"key.kind": "source.lang.swift.expr.argument",
								"key.length": Int64(21),
								"key.name": "equalToConstant",
								"key.namelength": Int64(15),
								"key.nameoffset": Int64(57),
								"key.offset": Int64(57)
							]
						]
					],
					[
						"key.bodylength": Int64(21),
						"key.bodyoffset": Int64(115),
						"key.kind": "source.lang.swift.expr.call",
						"key.length": Int64(55),
						"key.name": "subview1.heightAnchor.constraint",
						"key.namelength": Int64(32),
						"key.nameoffset": Int64(82),
						"key.offset": Int64(82),
						"key.substructure": [
							[
								"key.bodylength": Int64(4),
								"key.bodyoffset": Int64(124),
								"key.kind": "source.lang.swift.expr.argument",
								"key.length": Int64(21),
								"key.name": "equalToConstant",
								"key.namelength": Int64(15),
								"key.nameoffset": Int64(115),
								"key.offset": Int64(115)
							]
						]
					]
				]
			]
		]
	]

	let validCallWithoutSubstructureResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(8),
		"key.bodyoffset": Int64(20),
		"key.kind": "source.lang.swift.expr.call",
		"key.length": Int64(29),
		"key.name": "rootView.addSubview",
		"key.namelength": Int64(19),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(0)
	]

	let invalidCallResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(3),
		"key.bodyoffset": Int64(30),
		"key.kind": "source.lang.swift.expr.argument",
		"key.length": Int64(10),
		"key.name": "alpha",
		"key.namelength": Int64(5),
		"key.nameoffset": Int64(23),
		"key.offset": Int64(23)
	]
}
