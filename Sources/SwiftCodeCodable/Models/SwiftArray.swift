//
//  SwiftArray.swift
//  SwiftCodeCodable
//
//  Created by Morten Bjerg Gregersen on 02/02/2019.
//  Copyright © 2019 MoGee. All rights reserved.
//

import Foundation

public struct SwiftArray: Decodable, SwiftFunctionBodyExpressionArgumentValue {
	static let kindId = "source.lang.swift.expr.array"
	private var elementDefinitions = [SwiftArrayElementDefinition]()
	public var elements = [SwiftFunctionBodyExpressionArgumentValue]() //TODO: Bad name for the type when used here

	enum CodingKeys: String, CodingKey {
		case kind = "key.kind"
		case elements = "key.elements"

		case substructures = "key.substructure"
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		guard try values.decode(String.self, forKey: .kind) == SwiftArray.kindId else { throw CustomDecodingError.wrongKind }

		if var elementDefinitionsContainer = try? values.nestedUnkeyedContainer(forKey: .elements) {
			while !elementDefinitionsContainer.isAtEnd {
				if let elementDefinition = try? elementDefinitionsContainer.decode(SwiftArrayElementDefinition.self) {
					elementDefinitions.append(elementDefinition)
				} else {
					throw CustomDecodingError.unknownArrayElement
				}
			}
		}

		if var elementsContainer = try? values.nestedUnkeyedContainer(forKey: .substructures) {
			var elementIndex = 0
			while !elementsContainer.isAtEnd {
				if elementDefinitions[elementIndex].kindId == "source.lang.swift.structure.elem.expr",
					let expressionCall = try? elementsContainer.decode(SwiftFunctionBodyExpressionCall.self) {
					elements.append(expressionCall)
				} else {
					throw CustomDecodingError.unknownArrayElement
				}
				elementIndex += 1
			}
		}
	}

}

struct SwiftArrayElementDefinition: Decodable {
	let kindId: String

	enum CodingKeys: String, CodingKey {
		case kindId = "key.kind"
	}
}
