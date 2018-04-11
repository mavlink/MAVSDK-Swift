import Dronecode_SDK_Swift
import RxBlocking
import RxSwift
import XCTest

class TelemetryTest: XCTestCase {

    func testPositionEmitsValues() {
        let core = Core()
        core.connect()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let positionEvents = try telemetry.getPositionObservable().take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("PositionObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
}
