import XCTest
@testable import SwiftyGameController

final class SwiftyGameControllerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftyGameController().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
