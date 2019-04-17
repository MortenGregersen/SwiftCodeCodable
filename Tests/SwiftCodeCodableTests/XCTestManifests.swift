#if !canImport(ObjectiveC)
import XCTest

extension IndentationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__IndentationTests = [
        ("testSpaceTabs", testSpaceTabs),
        ("testTabs", testTabs),
    ]
}

extension SourceKittenStructureDecoderTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SourceKittenStructureDecoderTests = [
        ("testDecoding", testDecoding),
    ]
}

extension SwiftArrayTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftArrayTests = [
        ("testInvalidArray", testInvalidArray),
        ("testInvalidElementDefintion", testInvalidElementDefintion),
        ("testSuccessfulDecoding", testSuccessfulDecoding),
        ("testUnknownElementDefintion", testUnknownElementDefintion),
    ]
}

extension SwiftFunctionBodyExpressionArgumentTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftFunctionBodyExpressionArgumentTests = [
        ("testInvalidArgument", testInvalidArgument),
        ("testManualInitialization", testManualInitialization),
        ("testMissingRawSwift", testMissingRawSwift),
        ("testSuccessfulDecoding", testSuccessfulDecoding),
        ("testSuccessfulDecodingWithSubstructure", testSuccessfulDecodingWithSubstructure),
        ("testUnknownSubstructure", testUnknownSubstructure),
    ]
}

extension SwiftFunctionBodyExpressionCallTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftFunctionBodyExpressionCallTests = [
        ("testInvalidExpressionCall", testInvalidExpressionCall),
        ("testSuccessfulDecoding", testSuccessfulDecoding),
        ("testSuccessfulDecodingWithArraySubstructure", testSuccessfulDecodingWithArraySubstructure),
        ("testSuccessfulDecodingWithoutSubstructure", testSuccessfulDecodingWithoutSubstructure),
    ]
}

extension SwiftFunctionBodyLocalVarAssignmentTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftFunctionBodyLocalVarAssignmentTests = [
        ("testInvalidLocalVarAssignment", testInvalidLocalVarAssignment),
        ("testSuccessfulDecoding", testSuccessfulDecoding),
    ]
}

extension SwiftFunctionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftFunctionTests = [
        ("testSuccessfulDecoding", testSuccessfulDecoding),
        ("testSwiftFunctionAttributeUnknown", testSwiftFunctionAttributeUnknown),
        ("testValidSwiftFunctionAttributes", testValidSwiftFunctionAttributes),
    ]
}

extension SwiftWriterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__SwiftWriterTests = [
        ("testGenerateClassDeclaration", testGenerateClassDeclaration),
        ("testGenerateFunctionDeclaration", testGenerateFunctionDeclaration),
        ("testGenerateHeaderAndImports", testGenerateHeaderAndImports),
        ("testGenerateVariableAssignment", testGenerateVariableAssignment),
        ("testInitializerFunctionType", testInitializerFunctionType),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(IndentationTests.__allTests__IndentationTests),
        testCase(SourceKittenStructureDecoderTests.__allTests__SourceKittenStructureDecoderTests),
        testCase(SwiftArrayTests.__allTests__SwiftArrayTests),
        testCase(SwiftFunctionBodyExpressionArgumentTests.__allTests__SwiftFunctionBodyExpressionArgumentTests),
        testCase(SwiftFunctionBodyExpressionCallTests.__allTests__SwiftFunctionBodyExpressionCallTests),
        testCase(SwiftFunctionBodyLocalVarAssignmentTests.__allTests__SwiftFunctionBodyLocalVarAssignmentTests),
        testCase(SwiftFunctionTests.__allTests__SwiftFunctionTests),
        testCase(SwiftWriterTests.__allTests__SwiftWriterTests),
    ]
}
#endif
