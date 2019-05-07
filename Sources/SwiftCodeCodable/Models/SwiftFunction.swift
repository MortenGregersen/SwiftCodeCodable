//
//  SwiftFunction.swift
//  SwiftCodeCodable
//
//  Created by Morten Bjerg Gregersen on 21/10/2018.
//

import Foundation
import SwiftSyntax

public struct SwiftFunction {
	public let name: String
	public let accessibility: SwiftFunctionAccessibility
	public let kind: SwiftFunctionKind
	public let attributes: [SwiftFunctionAttribute]?
	public let parameters: [SwiftFunctionParameter]
	public let returnType: String?
	public let bodyLines: [SwiftFunctionBodyLine]
	
	public init(from funcDeclSyntax: FunctionDeclSyntax) {
		name = funcDeclSyntax.identifier.text
		var attributes: [SwiftFunctionAttribute] = []
		funcDeclSyntax.modifiers?.forEach {
			if let attribute = SwiftFunctionAttribute(from: $0) {
				attributes.append(attribute)
			}
		}
		accessibility = .internal
		kind = attributes.contains(.class) ? .class : .instance
		self.attributes = attributes
		parameters = funcDeclSyntax.signature.input.parameterList.map {
			SwiftFunctionParameter(name: $0.firstName!.text, type: ($0.type as! SimpleTypeIdentifierSyntax).name.text)
		}
		returnType = (funcDeclSyntax.signature.output?.returnType as? SimpleTypeIdentifierSyntax)?.name.text ?? nil
		bodyLines = funcDeclSyntax.body!.statements.compactMap {
			if let varDeclSyntax = $0.item as? VariableDeclSyntax {
				return SwiftFunctionBodyLocalVarAssignment(from: varDeclSyntax)
			} else if let callExprSyntax = $0.item as? FunctionCallExprSyntax {
				return SwiftFunctionBodyExpressionCall(from: callExprSyntax)
			}
			return nil
		}
	}
	
	public init(from initDeclSyntax: InitializerDeclSyntax) {
		var name = initDeclSyntax.initKeyword.text
		if let optionalMark = initDeclSyntax.optionalMark {
			name += optionalMark.text
		}
		self.name = name
		var attributes: [SwiftFunctionAttribute] = []
		initDeclSyntax.modifiers?.forEach {
			if let attribute = SwiftFunctionAttribute(from: $0) {
				attributes.append(attribute)
			}
		}
		accessibility = .internal
		kind = .instance
		self.attributes = attributes
		parameters = initDeclSyntax.parameters.parameterList.map {
			SwiftFunctionParameter(name: $0.firstName!.text, type: ($0.type as! SimpleTypeIdentifierSyntax).name.text)
		}
		returnType = nil
		bodyLines = initDeclSyntax.body!.statements.compactMap {
			if let varDeclSyntax = $0.item as? VariableDeclSyntax {
				return SwiftFunctionBodyLocalVarAssignment(from: varDeclSyntax)
			} else if let callExprSyntax = $0.item as? FunctionCallExprSyntax {
				return SwiftFunctionBodyExpressionCall(from: callExprSyntax)
			}
			return nil
		}
	}
}

public enum SwiftFunctionAccessibility: String, Decodable {
	case `internal` = "source.lang.swift.accessibility.internal"
}

public enum SwiftFunctionKind: String, Decodable {
	case `class` = "source.lang.swift.decl.function.method.class"
	case instance = "source.lang.swift.decl.function.method.instance"
}

public enum SwiftFunctionAttribute: String {
	case override
	case required
	case `internal`
	case `class`
	
	public init?(from declModifierSyntax: DeclModifierSyntax) {
		let rawValue = declModifierSyntax.name.text
		guard let attribute = SwiftFunctionAttribute(rawValue: rawValue) else {
			return nil
		}
		self = attribute
	}
}

public struct SwiftFunctionParameter {
	public let name: String
	public let type: String
	
	public init(name: String, type: String) {
		self.name = name
		self.type = type
	}
}
