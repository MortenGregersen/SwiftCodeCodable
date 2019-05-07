//
//  SwiftFunctionBodyLine.swift
//  SwiftCodeCodable
//
//  Created by Morten Bjerg Gregersen on 06/11/2018.
//

import Foundation
import SwiftSyntax

public protocol SwiftFunctionBodyLine {
	
}

public class SwiftFunctionBodyLocalVarAssignment: SwiftFunctionBodyLine {
	public let name: String
	public var expressionCall: SwiftFunctionBodyExpressionCall!

	public init(from varDeclSyntax: VariableDeclSyntax) {
		name = (varDeclSyntax.bindings[0].pattern as! IdentifierPatternSyntax).identifier.text
		let exprSyntax = varDeclSyntax.bindings[0].initializer!.value as! FunctionCallExprSyntax
		expressionCall = SwiftFunctionBodyExpressionCall(from: exprSyntax)
	}
}

public class SwiftFunctionBodyExpressionCall: SwiftFunctionBodyLine, SwiftFunctionBodyExpressionArgumentValue {
	public let name: String
	public var arguments = [SwiftFunctionBodyExpressionArgument]()

	public init(from exprSyntax: FunctionCallExprSyntax) {
		let memberName: String?
		let expressionName: String
		if let memberAccessExprSytax = exprSyntax.calledExpression as? MemberAccessExprSyntax {
			if let superMemberName = (memberAccessExprSytax.base as? SuperRefExprSyntax)?.superKeyword.text {
				memberName = superMemberName
			} else if let subMemberAccessExprSytax = memberAccessExprSytax.base as? MemberAccessExprSyntax {
				let parentMemberName = (subMemberAccessExprSytax.base as! IdentifierExprSyntax).identifier.text
				memberName = "\(parentMemberName).\(subMemberAccessExprSytax.name.text)"
			} else {
				memberName = (memberAccessExprSytax.base as! IdentifierExprSyntax).identifier.text
			}
			expressionName = memberAccessExprSytax.name.text
		} else {
			memberName = nil
			expressionName = (exprSyntax.calledExpression as! IdentifierExprSyntax).identifier.text
		}
		if let memberName = memberName {
			name = "\(memberName).\(expressionName)"
		} else {
			name = expressionName
		}
		exprSyntax.argumentList.forEach { argumentSyntax in
			arguments.append(SwiftFunctionBodyExpressionArgument(from: argumentSyntax))
		}
	}
}

public protocol SwiftFunctionBodyExpressionArgumentValue { }

extension String: SwiftFunctionBodyExpressionArgumentValue { }

public struct SwiftFunctionBodyExpressionArgument: SwiftFunctionBodyLine {
	public let name: String?
	public var value: SwiftFunctionBodyExpressionArgumentValue!
	
	public init(from argumentSyntax: FunctionCallArgumentSyntax) {
		let name = argumentSyntax.label?.text
		if let boolExprSyntax = argumentSyntax.expression as? BooleanLiteralExprSyntax {
			self.init(name: name, value: boolExprSyntax.booleanLiteral.text)
		} else if let floatExprSyntax = argumentSyntax.expression as? FloatLiteralExprSyntax {
			self.init(name: name, value: floatExprSyntax.floatingDigits.text)
		} else if let stringExprSyntax = argumentSyntax.expression as? StringLiteralExprSyntax {
			self.init(name: name, value: stringExprSyntax.stringLiteral.text)
		} else if let exprCallSyntax = argumentSyntax.expression as? FunctionCallExprSyntax {
			self.init(name: name, value: SwiftFunctionBodyExpressionCall(from: exprCallSyntax))
		} else {
			self.init(name: name, value: (argumentSyntax.expression as! IdentifierExprSyntax).identifier.text)
		}
	}

	public init(name: String? = nil, value: SwiftFunctionBodyExpressionArgumentValue) {
		self.name = name
		self.value = value
	}
}
