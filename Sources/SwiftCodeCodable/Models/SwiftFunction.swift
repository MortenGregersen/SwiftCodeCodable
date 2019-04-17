//
//  SwiftFunction.swift
//  InterfaceCoderCore
//
//  Created by Morten Bjerg Gregersen on 21/10/2018.
//  Copyright © 2018 MoGee. All rights reserved.
//

import Foundation
import SourceKittenFramework

public struct SwiftFunction: Decodable {
	public let name: String
	public let accessibility: SwiftFunctionAccessibility
	public let kind: SwiftFunctionKind
	public let attributes: [SwiftFunctionAttribute]?
	public let parameters: [SwiftFunctionParameter]
	public let returnType: String?
	public let bodyLines: [SwiftFunctionBodyLine]

	enum CodingKeys: String, CodingKey {
		case name = "key.name"
		case accessibility = "key.accessibility"
		case kind = "key.kind"
		case attributes = "key.attributes"
		case returnType = "key.typename"

		case substructures = "key.substructure"
	}

	enum BodyLinesCodingKeys: String, CodingKey {
		case kind = "key.kind"
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.name = try values.decode(String.self, forKey: .name)
		self.accessibility = try values.decode(SwiftFunctionAccessibility.self, forKey: .accessibility)
		self.kind = try values.decode(SwiftFunctionKind.self, forKey: .kind)
		self.attributes = try values.decodeIfPresent([SwiftFunctionAttribute].self, forKey: .attributes)
		self.returnType = try values.decodeIfPresent(String.self, forKey: .returnType)

		var substructuresContainer = try values.nestedUnkeyedContainer(forKey: .substructures)
		var parameters = [SwiftFunctionParameter]()
		var bodyLines = [SwiftFunctionBodyLine]()
		var lastLocalVarAssignment: SwiftFunctionBodyLocalVarAssignment?
		while !substructuresContainer.isAtEnd {
			do {
				if let parameter = try? substructuresContainer.decode(SwiftFunctionParameter.self) {
					parameters.append(parameter)
				} else if let localVarAssignment = try? substructuresContainer.decode(SwiftFunctionBodyLocalVarAssignment.self) {
					bodyLines.append(localVarAssignment)
					lastLocalVarAssignment = localVarAssignment
				} else if let expressionCall = try? substructuresContainer.decode(SwiftFunctionBodyExpressionCall.self) {
					if let theLastLocalVarAssignment = lastLocalVarAssignment {
						theLastLocalVarAssignment.expressionCall = expressionCall
						lastLocalVarAssignment = nil
					} else {
						bodyLines.append(expressionCall)
					}
				} else {
					throw CustomDecodingError.unknownBodyLineType
				}
			}
		}
		self.parameters = parameters
		self.bodyLines = bodyLines
	}
}

public enum SwiftFunctionAccessibility: String, Decodable {
	case `internal` = "source.lang.swift.accessibility.internal"
}

public enum SwiftFunctionKind: String, Decodable {
	case `class` = "source.lang.swift.decl.function.method.class"
	case instance = "source.lang.swift.decl.function.method.instance"
}

public enum SwiftFunctionAttribute: String, Decodable {
	case override = "source.decl.attribute.override"
	case required = "source.decl.attribute.required"
	case `internal` = "source.decl.attribute.internal"

	enum CodingKeys: String, CodingKey {
		case attribute = "key.attribute"
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		let rawValue = try values.decode(String.self, forKey: .attribute)
		guard let attribute = SwiftFunctionAttribute(rawValue: rawValue) else {
			let context = DecodingError.Context(codingPath: [CodingKeys.attribute], debugDescription: "Attribute not found")
			throw DecodingError.valueNotFound(SwiftFunctionAttribute.self, context)
		}
		self = attribute
	}
}

public struct SwiftFunctionParameter: Decodable {
	static let kindId = "source.lang.swift.decl.var.parameter"
	let name: String
	let type: String

	enum CodingKeys: String, CodingKey {
		case name = "key.name"
		case type = "key.typename"
	}
}
