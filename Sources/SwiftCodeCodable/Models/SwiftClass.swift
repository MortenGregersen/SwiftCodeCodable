//
//  SwiftClass.swift
//  InterfaceCoderCore
//
//  Created by Morten Bjerg Gregersen on 19/10/2018.
//  Copyright © 2018 MoGee. All rights reserved.
//

import Foundation

public struct SwiftClass: Decodable {
	public let name: String
	public let accessibility: SwiftClassAccessibility
	public let functions: [SwiftFunction]

	enum CodingKeys: String, CodingKey {
		case name = "key.name"
		case accessibility = "key.accessibility"
		case functions = "key.substructure"
	}
}

public enum SwiftClassAccessibility: String, Decodable {
	case `internal` = "source.lang.swift.accessibility.internal"
}
