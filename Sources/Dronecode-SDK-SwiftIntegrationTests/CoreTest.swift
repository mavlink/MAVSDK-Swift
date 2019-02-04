import Dronecode_SDK_Swift
import RxBlocking
import XCTest

class CoreTest: XCTestCase {

    func testDiscoverEmitsWhenConnecting() throws {
        let expectedCount = 1

        let drone = Drone()
        _ = try drone.startMavlink
            .andThen(drone.core.discover.take(expectedCount))
            .toBlocking(timeout: 2)
            .toArray()
    }

    func testPluginsAreRunning() throws {
        let expectedPlugins = ["action", "mission", "telemetry", "info"]

        let drone = Drone()
        let pluginNames = try drone.startMavlink
                           .andThen(drone.core.listRunningPlugins())
                           .toBlocking()
                           .first()!.map({ pluginInfo in pluginInfo.name })

        _ = pluginNames.map({ name in XCTAssertTrue(expectedPlugins.contains(name)) })
    }
}
