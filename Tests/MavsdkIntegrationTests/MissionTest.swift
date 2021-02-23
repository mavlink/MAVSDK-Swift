import RxSwift
import XCTest
@testable import Mavsdk

class MissionTest: XCTestCase {

    func testUploadEmptyMissionSucceeds() {
        let drone = Drone()
        _ = drone.startMavlink
                 .andThen(drone.mission.uploadMission(missionItems: []))
                 .do(onError: { error in XCTFail("\(error)") })
                 .toBlocking()
                 .materialize()
    }

    func testUploadOneItemSucceeds() {
        let drone = Drone()

        let missionItem = Mission.MissionItem(latitudeDeg: 47.3977121, longitudeDeg: 8.5456788, relativeAltitudeM: 42, speedMS: 8.4, isFlyThrough: false, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: Mission.MissionItem.CameraAction.none, loiterTimeS: 3, cameraPhotoIntervalS: 1)

        _ = drone.startMavlink
            .andThen(drone.mission.uploadMission(missionItems: [missionItem]))
            .do(onError: { error in XCTFail("\(error)") })
            .toBlocking()
            .materialize()
    }

    func testStartMissionSucceeds() {
        let drone = Drone()

        _ = drone.startMavlink
                 .andThen(drone.mission.startMission())
                 .do(onError: { error in XCTFail("\(error)") })
                 .toBlocking()
                 .materialize()
    }
}
