@testable import Versioning
import XCTest

final class VersionTests: XCTestCase {
    func testInitializationFromString() {
        let threeZeroOne = Version(string: "3.0.1")
        XCTAssertEqual(threeZeroOne?.major, 3)
        XCTAssertEqual(threeZeroOne?.minor, 0)
        XCTAssertEqual(threeZeroOne?.increment, 1)

        XCTAssertNil(Version(string: "1.2.1.4"))
    }

    func testCompareVersions() {
        XCTAssertEqual(Version(3, 0, 5), Version(3, 0, 5))
        XCTAssertGreaterThan(Version(3, 0, 0), Version(2, 9, 9))
        XCTAssertGreaterThan(Version(4, 0, 0), Version(3, 0, 0))
        XCTAssertGreaterThan(Version(2, 2, 0), Version(2, 1, 9))
        XCTAssertGreaterThan(Version(3, 2, 9), Version(3, 2, 8))
        XCTAssertGreaterThan(Version(1, 5, 5), Version(0, 14, 2))
        XCTAssertGreaterThan(Version(11, 0, 0), Version(10, 17, 1))
    }
    
    func testIncrement() {
        XCTAssertEqual(Version.one.apply(increment: .major), Version(2, 0, 0))
        XCTAssertEqual(Version.one.apply(increment: .minor), Version(1, 1, 0))
        XCTAssertEqual(Version.one.apply(increment: .patch), Version(1, 0, 1))
    }
}
