import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(takeoff_and_landTests.allTests),
    ]
}
#endif
