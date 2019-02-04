@testable import Dronecode_SDK_Swift
import RxBlocking
import RxTest
import RxSwift
import XCTest

class TelemetryTest: XCTestCase {

    func testPositionEmitsValues() throws {
        let expectedCount = 5

        let drone = Drone()
        _ = try drone.startMavlink
                     .andThen(drone.telemetry.position)
                     .take(expectedCount)
                     .toBlocking(timeout: 2)
                     .toArray()
    }

    func testPositionCanBeSubscribedMultipleTimes() throws {
        let expectedCount = 5
        let drone = Drone()

        let position1 = drone.startMavlink
                             .andThen(drone.telemetry.position)

        let position2 = drone.startMavlink
                             .andThen(drone.telemetry.position)

        _ = try Observable.zip(position1, position2) { return ($0, $1) }
                          .take(expectedCount)
                          .toBlocking(timeout: 2)
                          .toArray()
    }
}
