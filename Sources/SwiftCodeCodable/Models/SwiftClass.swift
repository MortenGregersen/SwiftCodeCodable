//
//  SwiftClass.swift
//  SwiftCodeCodable
//
//  Created by Morten Bjerg Gregersen on 19/10/2018.
//

import Foundation
import SwiftSyntax

public struct SwiftClass {
	public let name: String
	public let accessibility: SwiftClassAccessibility
	public let functions: [SwiftFunction]
	
	public init(from classDeclSyntax: ClassDeclSyntax) {
		name = classDeclSyntax.identifier.text
		accessibility = .internal
		print(classDeclSyntax.members.members)
		functions =	classDeclSyntax.members.members.compactMap { memberDeclListItemSyntax -> SwiftFunction? in
			guard let funcDeclSyntax = memberDeclListItemSyntax.decl as? FunctionDeclSyntax else { return nil }
			return SwiftFunction(from: funcDeclSyntax)
		}
	}
}

public enum SwiftClassAccessibility: String {
	case `internal`
}
