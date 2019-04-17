//
//  SwiftFunctionBodyLine.swift
//  InterfaceCoderCore
//
//  Created by Morten Bjerg Gregersen on 06/11/2018.
//  Copyright © 2018 MoGee. All rights reserved.
//

import Foundation

public protocol SwiftFunctionBodyLine: Decodable {
	static var kindId: String { get }
}

public class SwiftFunctionBodyLocalVarAssignment: SwiftFunctionBodyLine {
	public static let kindId = "source.lang.swift.decl.var.local"
	public let name: String
	public var expressionCall: SwiftFunctionBodyExpressionCall!

	enum CodingKeys: String, CodingKey {
		case kind = "key.kind"
		case name = "key.name"
	}

	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		guard try values.decode(String.self, forKey: .kind) == SwiftFunctionBodyLocalVarAssignment.kindId else {
			throw CustomDecodingError.wrongKind
		}
		self.name = try values.decode(String.self, forKey: .name)
	}
}

public class SwiftFunctionBodyExpressionCall: SwiftFunctionBodyLine, SwiftFunctionBodyExpressionArgumentValue {
	public static let kindId = "source.lang.swift.expr.call"
	public let name: String
	public var arguments = [SwiftFunctionBodyExpressionArgument]()

	enum CodingKeys: String, CodingKey {
		case kind = "key.kind"
		case name = "key.name"
		case bodyLength = "key.bodylength"
		case bodyOffset = "key.bodyoffset"
		case substructures = "key.substructure"
	}

	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		guard try values.decode(String.self, forKey: .kind) == SwiftFunctionBodyExpressionCall.kindId else {
			throw CustomDecodingError.wrongKind
		}
		self.name = try values.decode(String.self, forKey: .name)

		if var substructuresContainer = try? values.nestedUnkeyedContainer(forKey: .substructures) {
			while !substructuresContainer.isAtEnd {
				if let expressionArgument = try? substructuresContainer.decode(SwiftFunctionBodyExpressionArgument.self) {
					arguments.append(expressionArgument)
				} else if let arrayArgument = try? substructuresContainer.decode(SwiftArray.self) {
					arguments.append(SwiftFunctionBodyExpressionArgument(name: nil, value: arrayArgument))
				} else {
					throw CustomDecodingError.unknownExpressionCallSubstructure
				}
			}
		} else if let swiftString = decoder.userInfo[RawSwiftDecodingInfo.key] as? String,
			let valueLength = try values.decodeIfPresent(Int.self, forKey: .bodyLength),
			valueLength > 0 {
			let valueOffset = try values.decode(Int.self, forKey: .bodyOffset)
			let startIndex = swiftString.index(swiftString.startIndex, offsetBy: valueOffset)
			let endIndex = swiftString.index(swiftString.startIndex, offsetBy: valueOffset + valueLength)
			let stringValue = String(swiftString[startIndex..<endIndex])
			arguments.append(SwiftFunctionBodyExpressionArgument(value: stringValue))
		}
	}
}

public protocol SwiftFunctionBodyExpressionArgumentValue { }

extension String: SwiftFunctionBodyExpressionArgumentValue { }

public struct SwiftFunctionBodyExpressionArgument: SwiftFunctionBodyLine {
	public static let kindId = "source.lang.swift.expr.argument"
	public let name: String?
	public var value: SwiftFunctionBodyExpressionArgumentValue!

	enum CodingKeys: String, CodingKey {
		case kind = "key.kind"
		case name = "key.name"
		case bodyLength = "key.bodylength"
		case bodyOffset = "key.bodyoffset"
		case substructures = "key.substructure"
	}

	init(name: String? = nil, value: SwiftFunctionBodyExpressionArgumentValue) {
		self.name = name
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		guard try values.decode(String.self, forKey: .kind) == SwiftFunctionBodyExpressionArgument.kindId else {
			throw CustomDecodingError.wrongKind
		}
		self.name = try values.decode(String.self, forKey: .name)

		if var substructuresContainer = try? values.nestedUnkeyedContainer(forKey: .substructures) {
			while !substructuresContainer.isAtEnd {
				do {
					if let expressionCall = try? substructuresContainer.decode(SwiftFunctionBodyExpressionCall.self) {
						value = expressionCall
					} else {
						throw CustomDecodingError.unknownExpressionArgumentSubstructure
					}
				}
			}
		} else {
			guard let swiftString = decoder.userInfo[RawSwiftDecodingInfo.key] as? String else {
				throw CustomDecodingError.missingRawSwift
			}
			let valueOffset = try values.decode(Int.self, forKey: .bodyOffset)
			let valueLength = try values.decode(Int.self, forKey: .bodyLength)
			let startIndex = swiftString.index(swiftString.startIndex, offsetBy: valueOffset)
			let endIndex = swiftString.index(swiftString.startIndex, offsetBy: valueOffset + valueLength)
			let stringValue = String(swiftString[startIndex..<endIndex])
			value = stringValue
		}
	}
}
