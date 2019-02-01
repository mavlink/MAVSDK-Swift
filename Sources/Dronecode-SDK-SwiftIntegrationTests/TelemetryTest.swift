@testable import Dronecode_SDK_Swift
import RxBlocking
import RxTest
import XCTest

class TelemetryTest: XCTestCase {

    func testPositionEmitsValues() throws {
        let expectedCount = 5

        let drone = Drone()
        _ = try drone.startMavlink()
                     .andThen(drone.telemetry.position)
                     .take(expectedCount)
                     .toBlocking(timeout: 2)
                     .toArray()
    }
}
