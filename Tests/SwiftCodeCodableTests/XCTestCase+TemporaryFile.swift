//
//  XCTestCase+TemporaryFile.swift
//  SwiftCodeCodableTests
//
//  Created by Morten Bjerg Gregersen on 04/05/2019.
//

import XCTest
import Basic

extension XCTestCase {
	
	func fileURL(for temporaryFile: TemporaryFile, with content: String) -> URL {
		let data = Data(content.utf8)
		temporaryFile.fileHandle.write(data)
		return URL(fileURLWithPath: temporaryFile.path.asString)
	}
}
