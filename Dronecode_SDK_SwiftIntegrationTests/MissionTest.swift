import Dronecode_SDK_Swift
import RxSwift
import XCTest

class MissionTest: XCTestCase {
    func testUploadEmptyMissionSucceeds() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let mission = Mission(address: "localhost", port: 50051)

        mission.uploadMission(missionItems: [])
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }

    func testUploadOneItemSucceeds() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let mission = Mission(address: "localhost", port: 50051)

        let missionItem = MissionItem(latitudeDeg: 47.3977121, longitudeDeg: 8.5456788, relativeAltitudeM: 42, speedMPS: 8.4, isFlyThrough: false, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: CameraAction.none)

        mission.uploadMission(missionItems: [missionItem])
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }

    func testStartMissionSucceeds() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let mission = Mission(address: "localhost", port: 50051)

        mission.startMission().do(onError: { error in XCTFail("\(error)") }).subscribe()
    }
    
    func testPauseMissionSucceeds() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let mission = Mission(address: "localhost", port: 50051)
        
        mission.pauseMission().do(onError: { error in XCTFail("\(error)") }).subscribe()
    }
    
    func testIsMissionFinishedSucceeds() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let mission = Mission(address: "localhost", port: 50051)
        
        mission.isMissionFinished()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testMissionProgressEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let mission = Mission(address: "localhost", port: 50051)
        
        do {
            let missionProgressEvents = try mission.missionProgressObservable.take(1).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("MissionProgressObservable is expected to receive 1 events in 5 seconds, but it did not!")
        }
    }
}
