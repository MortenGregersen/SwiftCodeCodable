//
//  SwiftArrayTests.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/04/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import XCTest
import SourceKittenFramework
import SwiftCodeCodable

// swiftlint:disable line_length

class SwiftArrayTests: XCTestCase {

	func testSuccessfulDecoding() {
		do {
			let decoder = SourceKittenStructureDecoder()
			decoder.userInfo[RawSwiftDecodingInfo.key] = "[subview1.widthAnchor.constraint(equalToConstant: 60.0), subview1.heightAnchor.constraint(equalToConstant: 90.0)]"
			let structure = Structure(sourceKitResponse: validResponse)
			let array = try decoder.decode(SwiftArray.self, from: structure)
			XCTAssertEqual(array.elements.count, 2)
		} catch let error {
			XCTFail(String(describing: error))
		}
	}

	func testUnknownElementDefintion() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: unknownElementDefinitionsResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftArray.self, from: structure))
	}

	func testInvalidElementDefintion() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: invalidElementDefinitionsResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftArray.self, from: structure))
	}

	func testInvalidArray() {
		let decoder = SourceKittenStructureDecoder()
		let structure = Structure(sourceKitResponse: invalidArrayResponse)
		XCTAssertThrowsError(try decoder.decode(SwiftArray.self, from: structure))
	}

	let validResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(120),
		"key.bodyoffset": Int64(1),
		"key.elements": [
			[
				"key.kind": "source.lang.swift.structure.elem.expr",
				"key.length": Int64(54),
				"key.offset": Int64(1)
			],
			[
				"key.kind": "source.lang.swift.structure.elem.expr",
				"key.length": Int64(55),
				"key.offset": Int64(66)
			]
		],
		"key.kind": "source.lang.swift.expr.array",
		"key.length": Int64(122),
		"key.namelength": Int64(0),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(0),
		"key.substructure": [
			[
				"key.bodylength": Int64(21),
				"key.bodyoffset": Int64(33),
				"key.kind": "source.lang.swift.expr.call",
				"key.length": Int64(54),
				"key.name": "subview1.widthAnchor.constraint",
				"key.namelength": Int64(31),
				"key.nameoffset": Int64(1),
				"key.offset": Int64(1),
				"key.substructure": [
					[
						"key.bodylength": Int64(4),
						"key.bodyoffset": Int64(50),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(21),
						"key.name": "equalToConstant",
						"key.namelength": Int64(15),
						"key.nameoffset": Int64(33),
						"key.offset": Int64(33)
					]
				]
			],
			[
				"key.bodylength": Int64(21),
				"key.bodyoffset": Int64(91),
				"key.kind": "source.lang.swift.expr.call",
				"key.length": Int64(55),
				"key.name": "subview1.heightAnchor.constraint",
				"key.namelength": Int64(32),
				"key.nameoffset": Int64(58),
				"key.offset": Int64(58),
				"key.substructure": [
					[
						"key.bodylength": Int64(4),
						"key.bodyoffset": Int64(108),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(21),
						"key.name": "equalToConstant",
						"key.namelength": Int64(15),
						"key.nameoffset": Int64(91),
						"key.offset": Int64(91)
					]
				]
			]
		]
	]

	let unknownElementDefinitionsResponse: [String: SourceKitRepresentable] = [
		"key.bodylength": Int64(120),
		"key.bodyoffset": Int64(495),
		"key.elements": [
			[
				"key.kind": "source.lang.swift.structure.elem.id",
				"key.length": Int64(54),
				"key.offset": Int64(495)
			],
			[
				"key.kind": "source.lang.swift.structure.elem.expr",
				"key.length": Int64(55),
				"key.offset": Int64(560)
			]
		],
		"key.kind": "source.lang.swift.expr.array",
		"key.length": Int64(122),
		"key.namelength": Int64(0),
		"key.nameoffset": Int64(0),
		"key.offset": Int64(494),
		"key.substructure": [
			[
				"key.kind": "source.lang.swift.decl.var.local",
				"key.name": "myConstraint",
				"key.offset": Int64(63),
				"key.length": Int64(8),
				"key.nameoffset": Int64(63),
				"key.namelength": Int64(8)
			],
			[
				"key.bodylength": Int64(21),
				"key.bodyoffset": Int64(593),
				"key.kind": "source.lang.swift.expr.call",
				"key.length": Int64(55),
				"key.name": "subview1.heightAnchor.constraint",
				"key.namelength": Int64(32),
				"key.nameoffset": Int64(560),
				"key.offset": Int64(560),
				"key.substructure": [
					[
						"key.bodylength": Int64(4),
						"key.bodyoffset": Int64(610),
						"key.kind": "source.lang.swift.expr.argument",
						"key.length": Int64(21),
						"key.name": "equalToConstant",
						"key.namelength": Int64(15),
						"key.nameoffset": Int64(593),
						"key.offset": Int64(593)
					]
				]
			]
		]
	]

	let invalidElementDefinitionsResponse: [String: SourceKitRepresentable] = [
		"key.elements": [
			[
				"key.length": Int64(54),
				"key.offset": Int64(495)
			]
		],
		"key.kind": "source.lang.swift.expr.array",
		"key.substructure": [
			[
				"key.kind": "source.lang.swift.decl.var.local",
				"key.name": "myConstraint",
				"key.offset": Int64(63),
				"key.length": Int64(8),
				"key.nameoffset": Int64(63),
				"key.namelength": Int64(8)
			]
		]
	]

	let invalidArrayResponse: [String: SourceKitRepresentable] = [
		"key.kind": "source.lang.swift.decl.var.local",
		"key.length": Int64(81),
		"key.name": "subview2",
		"key.namelength": Int64(8),
		"key.nameoffset": Int64(627),
		"key.offset": Int64(623)
	]
}
