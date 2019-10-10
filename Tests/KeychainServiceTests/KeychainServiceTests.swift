import XCTest
@testable import KeychainService

final class KeychainServiceTests: XCTestCase {
    func testSaveInKeychain() {
        let keychainService = KeychainService(forUserAccount: "test")
        XCTAssertTrue(keychainService.saveItem(item: "saveMe", forKey: "masterKey"))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
