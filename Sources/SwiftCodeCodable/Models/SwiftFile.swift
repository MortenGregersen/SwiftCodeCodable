//
//  SwiftFile.swift
//  SwiftCodeCodable
//
//  Created by Morten Bjerg Gregersen on 22/10/2018.
//

import Foundation
import SwiftSyntax

public struct SwiftFile {
	public let classes: [SwiftClass]
	
	public init(from sourceFileSyntax: SourceFileSyntax) {
		let codeBlockItemListSyntax = sourceFileSyntax.child(at: 0) as! CodeBlockItemListSyntax
		classes = codeBlockItemListSyntax.children.compactMap { childSyntax -> SwiftClass? in
			guard let codeBlockItemSyntax = childSyntax as? CodeBlockItemSyntax,
				let classDeclSyntax = codeBlockItemSyntax.item as? ClassDeclSyntax else { return nil }
			return SwiftClass(from: classDeclSyntax)
		}
	}
}
