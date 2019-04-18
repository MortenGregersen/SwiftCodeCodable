//
//  SwiftFunctionAttributeTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 03/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import SourceKittenFramework
@testable import SwiftCodeCodable

class SwiftFunctionTests: XCTestCase {

	func testSuccessfulDecoding() {
		do {
			let decoder = SourceKittenStructureDecoder()
			decoder.userInfo[RawSwiftDecodingInfo.key] = """
internal override func setupViews(frame: CGRect) -> UIView {
	let subview = UIView(frame: frame)
	subview.setProperties(alpha: 0.5, isHidden: true)
	return subview
}
"""
			let structure = Structure(sourceKitResponse: validFunctionResponse)
			let function = try decoder.decode(SwiftFunction.self, from: structure)
			XCTAssertEqual(function.name, "createView(frame:)")
			XCTAssertEqual(function.accessibility, .internal)
			XCTAssertEqual(function.kind, .instance)
			XCTAssertEqual(function.attributes, [.override, .internal])
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

	func testValidSwiftFunctionAttributes() {
		let decoder = SourceKittenStructureDecoder()
		do {
			let overrideStructure = Structure(sourceKitResponse: ["key.attribute": "source.decl.attribute.override"])
			let overrideAttribute = try decoder.decode(SwiftFunctionAttribute.self, from: overrideStructure)
			XCTAssertEqual(overrideAttribute, .override)

			let requiredStructure = Structure(sourceKitResponse: ["key.attribute": "source.decl.attribute.required"])
			let requiredAttribute = try decoder.decode(SwiftFunctionAttribute.self, from: requiredStructure)
			XCTAssertEqual(requiredAttribute, .required)

			let internalStructure = Structure(sourceKitResponse: ["key.attribute": "source.decl.attribute.internal"])
			let internalAttribute = try decoder.decode(SwiftFunctionAttribute.self, from: internalStructure)
			XCTAssertEqual(internalAttribute, .internal)
		} catch let error {
			XCTFail(String(describing: error))
		}
	}

    func testSwiftFunctionAttributeUnknown() {
		let structure = Structure(sourceKitResponse: ["key.attribute": "some.invalid.attribute"])
		let decoder = SourceKittenStructureDecoder()
		XCTAssertThrowsError(try decoder.decode(SwiftFunctionAttribute.self, from: structure))
    }

	let validFunctionResponse: [String: SourceKitRepresentable] = [
		"key.accessibility": "source.lang.swift.accessibility.internal",
		"key.attributes": [
			[
				"key.attribute": "source.decl.attribute.override",
				"key.length": Int64(8),
				"key.offset": Int64(9)
			],
			[
				"key.attribute": "source.decl.attribute.internal",
				"key.length": Int64(8),
				"key.offset": Int64(0)
			]
		],
		"key.bodylength": Int64(108),
		"key.bodyoffset": Int64(58),
		"key.kind": "source.lang.swift.decl.function.method.instance",
		"key.length": Int64(151),
		"key.name": "createView(frame:)",
		"key.namelength": Int64(25),
		"key.nameoffset": Int64(21),
		"key.offset": Int64(16),
		"key.substructure": [
			[
				"key.kind": "source.lang.swift.decl.var.parameter",
				"key.length": Int64(13),
				"key.name": "frame",
				"key.namelength": Int64(5),
				"key.nameoffset": Int64(32),
				"key.offset": Int64(32),
				"key.typename": "CGRect"
			],
			[
				"key.kind": "source.lang.swift.decl.var.local",
				"key.length": Int64(34),
				"key.name": "subview",
				"key.namelength": Int64(7),
				"key.nameoffset": Int64(65),
				"key.offset": Int64(61)
			],
			[
				"key.bodylength": Int64(12),
				"key.bodyoffset": Int64(82),
				"key.kind": "source.lang.swift.expr.call",
				"key.length": Int64(20),
				"key.name": "UIView",
				"key.namelength": Int64(6),
				"key.nameoffset": Int64(75),
				"key.offset": Int64(75),
				"key.substructure": [
					[
						"key.bodylength": Int64(5),
						"key.bodyoffset": Int64(90),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(12),
						"key.name": "frame",
						"key.namelength": Int64(5),
						"key.nameoffset": Int64(82),
						"key.offset": Int64(82)
					]
				]
			],
			[
				"key.bodylength": Int64(26),
				"key.bodyoffset": Int64(120),
				"key.kind": "source.lang.swift.expr.call",
				"key.length": Int64(49),
				"key.name": "subview.setProperties",
				"key.namelength": Int64(21),
				"key.nameoffset": Int64(98),
				"key.offset": Int64(98),
				"key.substructure": [
					[
						"key.bodylength": Int64(3),
						"key.bodyoffset": Int64(127),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(10),
						"key.name": "alpha",
						"key.namelength": Int64(5),
						"key.nameoffset": Int64(120),
						"key.offset": Int64(120)
					],
					[
						"key.bodylength": Int64(4),
						"key.bodyoffset": Int64(142),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(14),
						"key.name": "isHidden",
						"key.namelength": Int64(8),
						"key.nameoffset": Int64(132),
						"key.offset": Int64(132)
					]
				]
			]
		],
		"key.typename": "UIView"
	]
}

extension SwiftFunctionParameter: Equatable {
	public static func == (lhs: SwiftFunctionParameter, rhs: SwiftFunctionParameter) -> Bool {
		return lhs.name == rhs.name && lhs.type == rhs.type
	}
}
