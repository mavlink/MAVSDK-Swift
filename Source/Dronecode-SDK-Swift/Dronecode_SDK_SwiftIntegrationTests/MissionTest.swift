import Dronecode_SDK_Swift
import RxSwift
import XCTest

class MissionTest: XCTestCase {
    func testUploadEmptyMissionSucceeds() {
        let core = Core()
        core.connect()
        let mission = Mission(address: "localhost", port: 50051)

        mission.uploadMission(missionItems: [])
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }

    func testUploadOneItemSucceeds() {
        let core = Core()
        core.connect()
        let mission = Mission(address: "localhost", port: 50051)

        let missionItem = MissionItem(latitudeDeg: 47.3977121, longitudeDeg: 8.5456788, relativeAltitudeM: 42, speedMPS: 8.4, isFlyThrough: false, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: CameraAction.NONE)

        mission.uploadMission(missionItems: [missionItem])
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }

    func testStartMissionSucceeds() {
        let core = Core()
        core.connect()
        let mission = Mission(address: "localhost", port: 50051)

        mission.startMission().do(onError: { error in XCTFail("\(error)") }).subscribe()
    }
}
