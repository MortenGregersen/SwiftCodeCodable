//
//  SourceKittenStructureDecoderTests.swift
//  InterfaceCoderCoreTests
//
//  Created by Morten Bjerg Gregersen on 22/10/2018.
//  Copyright © 2018 MoGee. All rights reserved.
//

import XCTest
import SourceKittenFramework
@testable import SwiftCodeCodable

class SourceKittenStructureDecoderTests: XCTestCase {
	let testBundle = Bundle(for: SourceKittenStructureDecoderTests.self)

	// swiftlint:disable:next function_body_length
	func testDecoding() {
		do {
			// swiftlint:disable force_cast
			let fileUrl = testBundle.url(forResource: "Example", withExtension: "testswift")!
			let swiftString = try String(contentsOf: fileUrl, encoding: .utf8)
			let structure = try Structure(file: File(contents: swiftString))
			let decoder = SourceKittenStructureDecoder()
			decoder.userInfo = [RawSwiftDecodingInfo.key: swiftString]

			let decodedFile = try decoder.decode(SwiftFile.self, from: structure)
			XCTAssertEqual(decodedFile.classes.count, 2)

			// Root view class

			let rootViewClass = decodedFile.classes[0]
			XCTAssertEqual(rootViewClass.name, "LoginView")
			XCTAssertEqual(rootViewClass.accessibility, .internal)
			XCTAssertEqual(rootViewClass.functions.count, 1)

			let createRootViewFunc = rootViewClass.functions[0]
			XCTAssertEqual(createRootViewFunc.name, "createRootView()")
			XCTAssertEqual(createRootViewFunc.accessibility, .internal)
			XCTAssertNil(createRootViewFunc.attributes)
			XCTAssertEqual(createRootViewFunc.returnType, "UIView")
			XCTAssertEqual(createRootViewFunc.parameters.count, 0)
			XCTAssertEqual(createRootViewFunc.bodyLines.count, 16)

			let rootViewInit = createRootViewFunc.bodyLines[0] as! SwiftFunctionBodyLocalVarAssignment
			XCTAssertEqual(rootViewInit.name, "rootView")
			XCTAssertEqual(rootViewInit.expressionCall.name, "UIView")
			XCTAssertEqual(rootViewInit.expressionCall.arguments.count, 1)
			XCTAssertEqual(rootViewInit.expressionCall.arguments[0].name, "frame")
			let rootViewInitFrame = rootViewInit.expressionCall.arguments[0].value as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(rootViewInitFrame.arguments[0].name, "x")
			XCTAssertEqual(rootViewInitFrame.arguments[0].value as! String, "0.0")
			XCTAssertEqual(rootViewInitFrame.arguments[1].name, "y")
			XCTAssertEqual(rootViewInitFrame.arguments[1].value as! String, "0.0")
			XCTAssertEqual(rootViewInitFrame.arguments[2].name, "width")
			XCTAssertEqual(rootViewInitFrame.arguments[2].value as! String, "100.0")
			XCTAssertEqual(rootViewInitFrame.arguments[3].name, "height")
			XCTAssertEqual(rootViewInitFrame.arguments[3].value as! String, "120.0")

			let rootViewSet = createRootViewFunc.bodyLines[1] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(rootViewSet.name, "rootView.setProperties")
			XCTAssertEqual(rootViewSet.arguments.count, 2)
			XCTAssertEqual(rootViewSet.arguments[0].name, "alpha")
			XCTAssertEqual(rootViewSet.arguments[0].value as! String, "0.5")
			XCTAssertEqual(rootViewSet.arguments[1].name, "isHidden")
			XCTAssertEqual(rootViewSet.arguments[1].value as! String, "false")

			let subview1Init = createRootViewFunc.bodyLines[2] as! SwiftFunctionBodyLocalVarAssignment
			XCTAssertEqual(subview1Init.name, "subview1")
			XCTAssertEqual(subview1Init.expressionCall.name, "MySubview")
			XCTAssertEqual(subview1Init.expressionCall.arguments.count, 1)
			XCTAssertEqual(subview1Init.expressionCall.arguments[0].name, "frame")
			let subview1Frame = subview1Init.expressionCall.arguments[0].value as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview1Frame.name, "CGRect")
			XCTAssertEqual(subview1Frame.arguments.count, 4)
			XCTAssertEqual(subview1Frame.arguments[0].name, "x")
			XCTAssertEqual(subview1Frame.arguments[0].value as! String, "0.0")
			XCTAssertEqual(subview1Frame.arguments[1].name, "y")
			XCTAssertEqual(subview1Frame.arguments[1].value as! String, "30.0")
			XCTAssertEqual(subview1Frame.arguments[2].name, "width")
			XCTAssertEqual(subview1Frame.arguments[2].value as! String, "60.0")
			XCTAssertEqual(subview1Frame.arguments[3].name, "height")
			XCTAssertEqual(subview1Frame.arguments[3].value as! String, "90.0")

			let subview1Set = createRootViewFunc.bodyLines[3] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview1Set.name, "subview1.setProperties")
			XCTAssertEqual(subview1Set.arguments.count, 1)
			XCTAssertEqual(subview1Set.arguments[0].name, "backgroundColor")
			let subview1BackgroundColor = subview1Set.arguments[0].value as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview1BackgroundColor.name, "UIColor")
			XCTAssertEqual(subview1BackgroundColor.arguments.count, 4)
			XCTAssertEqual(subview1BackgroundColor.arguments[0].name, "red")
			XCTAssertEqual(subview1BackgroundColor.arguments[0].value as! String, "1.0")
			XCTAssertEqual(subview1BackgroundColor.arguments[1].name, "green")
			XCTAssertEqual(subview1BackgroundColor.arguments[1].value as! String, "0.0")
			XCTAssertEqual(subview1BackgroundColor.arguments[2].name, "blue")
			XCTAssertEqual(subview1BackgroundColor.arguments[2].value as! String, "0.0")
			XCTAssertEqual(subview1BackgroundColor.arguments[3].name, "alpha")
			XCTAssertEqual(subview1BackgroundColor.arguments[3].value as! String, "1.0")

			let subview1Add = createRootViewFunc.bodyLines[4] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview1Add.name, "rootView.addSubview")
			XCTAssertEqual(subview1Add.arguments.count, 1)
			XCTAssertEqual(subview1Add.arguments[0].value as! String, "subview1")

			let subview1AddConstraints = createRootViewFunc.bodyLines[5] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview1AddConstraints.name, "subview1.addConstraints")
			XCTAssertEqual(subview1AddConstraints.arguments.count, 1)
			let subview1Constraints = subview1AddConstraints.arguments[0].value as! SwiftArray
			XCTAssertEqual(subview1Constraints.elements.count, 2)
			let subview1WidthConstraint = subview1Constraints.elements[0] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview1WidthConstraint.name, "subview1.widthAnchor.constraint")
			XCTAssertEqual(subview1WidthConstraint.arguments.count, 1)
			XCTAssertEqual(subview1WidthConstraint.arguments[0].name, "equalToConstant")
			XCTAssertEqual(subview1WidthConstraint.arguments[0].value as! String, "60.0")
			let subview1HeightConstraint = subview1Constraints.elements[1] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview1HeightConstraint.name, "subview1.heightAnchor.constraint")
			XCTAssertEqual(subview1HeightConstraint.arguments.count, 1)
			XCTAssertEqual(subview1HeightConstraint.arguments[0].name, "equalToConstant")
			XCTAssertEqual(subview1HeightConstraint.arguments[0].value as! String, "90.0")

			let subview2Init = createRootViewFunc.bodyLines[6] as! SwiftFunctionBodyLocalVarAssignment
			XCTAssertEqual(subview2Init.name, "subview2")
			XCTAssertEqual(subview2Init.expressionCall.name, "UIView")
			XCTAssertEqual(subview2Init.expressionCall.arguments.count, 1)
			XCTAssertEqual(subview2Init.expressionCall.arguments[0].name, "frame")
			let subview2Frame = subview2Init.expressionCall.arguments[0].value as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2Frame.name, "CGRect")
			XCTAssertEqual(subview2Frame.arguments.count, 4)
			XCTAssertEqual(subview2Frame.arguments[0].name, "x")
			XCTAssertEqual(subview2Frame.arguments[0].value as! String, "60.0")
			XCTAssertEqual(subview2Frame.arguments[1].name, "y")
			XCTAssertEqual(subview2Frame.arguments[1].value as! String, "20.0")
			XCTAssertEqual(subview2Frame.arguments[2].name, "width")
			XCTAssertEqual(subview2Frame.arguments[2].value as! String, "40.0")
			XCTAssertEqual(subview2Frame.arguments[3].name, "height")
			XCTAssertEqual(subview2Frame.arguments[3].value as! String, "60.0")

			let subview2Set = createRootViewFunc.bodyLines[7] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2Set.name, "subview2.setProperties")
			XCTAssertEqual(subview2Set.arguments.count, 1)
			XCTAssertEqual(subview2Set.arguments[0].name, "alpha")
			XCTAssertEqual(subview2Set.arguments[0].value as! String, "0.9")

			let subview2Add = createRootViewFunc.bodyLines[8] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2Add.name, "rootView.addSubview")
			XCTAssertEqual(subview2Add.arguments.count, 1)
			XCTAssertEqual(subview2Add.arguments[0].value as! String, "subview2")

			let subview2AddConstraints = createRootViewFunc.bodyLines[9] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2AddConstraints.name, "subview2.addConstraints")
			XCTAssertEqual(subview2AddConstraints.arguments.count, 1)

			let subview2n1Init = createRootViewFunc.bodyLines[10] as! SwiftFunctionBodyLocalVarAssignment
			XCTAssertEqual(subview2n1Init.name, "subview2n1")
			XCTAssertEqual(subview2n1Init.expressionCall.name, "MySubview")
			XCTAssertEqual(subview2n1Init.expressionCall.arguments.count, 1)
			XCTAssertEqual(subview2n1Init.expressionCall.arguments[0].name, "frame")
			let subview2n1Frame = subview2n1Init.expressionCall.arguments[0].value as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2n1Frame.name, "CGRect")
			XCTAssertEqual(subview2n1Frame.arguments.count, 4)
			XCTAssertEqual(subview2n1Frame.arguments[0].name, "x")
			XCTAssertEqual(subview2n1Frame.arguments[0].value as! String, "70.0")
			XCTAssertEqual(subview2n1Frame.arguments[1].name, "y")
			XCTAssertEqual(subview2n1Frame.arguments[1].value as! String, "30.0")
			XCTAssertEqual(subview2n1Frame.arguments[2].name, "width")
			XCTAssertEqual(subview2n1Frame.arguments[2].value as! String, "10.0")
			XCTAssertEqual(subview2n1Frame.arguments[3].name, "height")
			XCTAssertEqual(subview2n1Frame.arguments[3].value as! String, "10.0")

			let subview2n1Set = createRootViewFunc.bodyLines[11] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2n1Set.name, "subview2n1.setProperties")
			XCTAssertEqual(subview2n1Set.arguments.count, 1)
			XCTAssertEqual(subview2n1Set.arguments[0].name, "alpha")
			XCTAssertEqual(subview2n1Set.arguments[0].value as! String, "0.3")

			let subview2n1Add = createRootViewFunc.bodyLines[12] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2n1Add.name, "subview2.addSubview")
			XCTAssertEqual(subview2n1Add.arguments.count, 1)
			XCTAssertEqual(subview2n1Add.arguments[0].value as! String, "subview2n1")

			let subview2n1AddConstraints = createRootViewFunc.bodyLines[13] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subview2n1AddConstraints.name, "subview2n1.addConstraints")
			XCTAssertEqual(subview2n1AddConstraints.arguments.count, 1)

			// Subview class

			let subviewClass = decodedFile.classes[1]
			XCTAssertEqual(subviewClass.name, "MySubview")
			XCTAssertEqual(subviewClass.accessibility, .internal)
			XCTAssertEqual(subviewClass.functions.count, 2)

			let subviewInitFunc = subviewClass.functions[0]
			XCTAssertEqual(subviewInitFunc.name, "init(frame:)")
			XCTAssertEqual(subviewInitFunc.accessibility, .internal)
			XCTAssertEqual(subviewInitFunc.kind, .instance)
			XCTAssertEqual(subviewInitFunc.attributes!.count, 1)
			XCTAssertEqual(subviewInitFunc.attributes![0], .override)
			XCTAssertNil(subviewInitFunc.returnType)
			XCTAssertEqual(subviewInitFunc.parameters.count, 1)
			XCTAssertEqual(subviewInitFunc.bodyLines.count, 2)

			let superInit = subviewInitFunc.bodyLines[0] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(superInit.name, "super.init")
			XCTAssertEqual(superInit.arguments.count, 1)
			XCTAssertEqual(superInit.arguments[0].name, "frame")
			XCTAssertEqual(superInit.arguments[0].value as! String, "frame")

			let subviewSet = subviewInitFunc.bodyLines[1] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(subviewSet.name, "setProperties")
			XCTAssertEqual(subviewSet.arguments.count, 1)
			XCTAssertEqual(subviewSet.arguments[0].name, "userInteractionEnabled")
			XCTAssertEqual(subviewSet.arguments[0].value as! String, "false")

			let subviewInitDecoderFunc = subviewClass.functions[1]
			XCTAssertEqual(subviewInitDecoderFunc.name, "init(coder:)")
			XCTAssertEqual(subviewInitDecoderFunc.accessibility, .internal)
			XCTAssertEqual(subviewInitDecoderFunc.kind, .instance)
			XCTAssertEqual(subviewInitDecoderFunc.attributes!.count, 1)
			XCTAssertEqual(subviewInitDecoderFunc.attributes![0], .required)
			XCTAssertNil(subviewInitDecoderFunc.returnType)
			XCTAssertEqual(subviewInitDecoderFunc.parameters.count, 1)
			XCTAssertEqual(subviewInitDecoderFunc.bodyLines.count, 1)

			let notImplemented = subviewInitDecoderFunc.bodyLines[0] as! SwiftFunctionBodyExpressionCall
			XCTAssertEqual(notImplemented.name, "fatalError")
			XCTAssertEqual(notImplemented.arguments.count, 1)
			XCTAssertNil(notImplemented.arguments[0].name)
			XCTAssertEqual(notImplemented.arguments[0].value as! String, "\"init(coder:) has not been implemented\"")
		} catch let error {
			XCTFail(error.localizedDescription)
		}
	}
}
