//
//  SwiftFile.swift
//  SwiftCodeCodable
//
//  Created by Morten Bjerg Gregersen on 22/10/2018.
//  Copyright © 2018 MoGee. All rights reserved.
//

import Foundation

public struct SwiftFile: Decodable {
	public let classes: [SwiftClass]

	enum CodingKeys: String, CodingKey {
		case classes = "key.substructure"
	}
}
