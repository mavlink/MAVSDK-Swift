import RxSwift
import XCTest
@testable import Mavsdk

class ActionTest: XCTestCase {

    func testArmSucceeds() {
        let drone = Drone()
        _ = drone.startMavlink
                 .andThen(drone.action.arm())
                 .do(onError: { error in XCTFail("\(error)") })
                 .toBlocking()
                 .materialize()
    }

    func testDisarmSucceeds() {
        let drone = Drone()
        _ = drone.startMavlink
            .andThen(drone.action.arm())
            .delay(2, scheduler: MainScheduler.instance)
            .andThen(drone.action.disarm())
            .do(onError: { (error) in XCTFail("\(error)") })
            .toBlocking()
            .materialize()
    }

    func testTakeoffAndLandSucceeds() {
        let drone = Drone()
        _ = drone.startMavlink
            .andThen(drone.action.arm())
            .andThen(drone.action.takeoff())
            .delay(5, scheduler: MainScheduler.instance)
            .andThen(drone.action.land())
            .do(onError: { (error) in XCTFail("\(error)") })
            .toBlocking()
            .materialize()
    }
    
    func testSetAndGetReturnToLaunchAltitude() throws {
        let expectedFirstAltitude: Float = 32
        let expectedSecondAltitude: Float = 5

        let drone = Drone()
        _ = drone.startMavlink.toBlocking().materialize()

        let firstAltitude = try drone.action.setReturnToLaunchAltitude(relativeAltitudeM: expectedFirstAltitude)
                                     .andThen(drone.action.getReturnToLaunchAltitude())
                                     .toBlocking().single()

        XCTAssertEqual(expectedFirstAltitude, firstAltitude)

        let secondAltitude = try drone.action.setReturnToLaunchAltitude(relativeAltitudeM: expectedSecondAltitude)
                                      .andThen(drone.action.getReturnToLaunchAltitude())
                                      .toBlocking().single()

        XCTAssertEqual(expectedSecondAltitude, secondAltitude)
    }
}
