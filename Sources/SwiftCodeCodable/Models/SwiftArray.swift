//
//  SwiftArray.swift
//  SwiftCodeCodable
//
//  Created by Morten Bjerg Gregersen on 02/02/2019.
//

import Foundation
import SwiftSyntax

public struct SwiftArray: SwiftFunctionBodyExpressionArgumentValue {
	public var elements = [SwiftFunctionBodyExpressionArgumentValue]()

	public init(from arrayExprSyntax: ArrayExprSyntax) {
		elements = arrayExprSyntax.elements.map {
			if let callExprSyntax = $0.expression as? FunctionCallExprSyntax {
				return SwiftFunctionBodyExpressionCall(from: callExprSyntax)
			}
			return ($0.expression as! IdentifierExprSyntax).identifier.text
		}
	}
}
