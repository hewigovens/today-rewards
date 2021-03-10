import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(today_rewardsTests.allTests),
    ]
}
#endif
