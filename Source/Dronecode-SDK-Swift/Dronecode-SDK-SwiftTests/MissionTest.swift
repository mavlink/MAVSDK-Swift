import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class MissionTest: XCTestCase {
    func testUploadsOneItem() {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        let mission = Mission(service: fakeService)

        let missionItem = MissionItem(latitudeDeg: 46, longitudeDeg: 6, relativeAltitudeM: 50, speedMPS: 3.4, isFlyThrough: true, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: CameraAction.NONE)

        mission.uploadMission(missionItems: [missionItem])
    }

    func testStartSucceedsOnSuccess() {
        assertSuccess(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.success))
    }

    func startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        var response = Dronecore_Rpc_Mission_StartMissionResponse()
        response.missionResult.result = result
        fakeService.startmissionResponses.append(response)
        let mission = Mission(service: fakeService)

        return mission.startMission().toBlocking().materialize()
    }

    func assertSuccess(result: MaterializedSequenceResult<Never>) {
        switch result {
        case .completed:
            break
        case .failed:
            XCTFail("Expecting success, got failure")
        }
    }

    func testStartFailsOnFailure() {
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.unknown))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.error))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.tooManyMissionItems))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.busy))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.timeout))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.invalidArgument))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.unsupported))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.noMissionAvailable))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.failedToOpenQgcPlan))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.failedToParseQgcPlan))
        assertFailure(result: startWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.unsupportedMissionCmd))
    }

    func assertFailure(result: MaterializedSequenceResult<Never>) {
        switch result {
        case .completed:
            XCTFail("Expecting failure, got success")
        case .failed:
            break
        }
    }
}
