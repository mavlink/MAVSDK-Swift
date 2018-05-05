import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class MissionTest: XCTestCase {
    let scheduler = MainScheduler.instance
    
    func testUploadsOneItem() {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        let mission = Mission(service: fakeService, scheduler: scheduler)

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
        let mission = Mission(service: fakeService, scheduler: scheduler)

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

    func testMissionProgressObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Mission_MissionServiceSubscribeMissionProgressCallTestStub()
        fakeService.subscribemissionprogressCalls.append(fakeCall)

        let mission = Mission(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MissionProgress.self)

        let _ = mission.missionProgressObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testMissionProgressObservableReceivesOneEvent() {
        let missionProgress = createRPCMissionProgress(currentItemIndex: 5, missionCount: 10)
        let missionProgressArray = [missionProgress]
        
        checkMissionProgressObservableReceivesEvents(missionProgressArray: missionProgressArray)
    }

    func createRPCMissionProgress(currentItemIndex: Int32, missionCount: Int32) -> Dronecore_Rpc_Mission_MissionProgressResponse {
        var missionProgress = Dronecore_Rpc_Mission_MissionProgressResponse()
        missionProgress.currentItemIndex = currentItemIndex
        missionProgress.missionCount = missionCount

        return missionProgress
    }

    func checkMissionProgressObservableReceivesEvents(missionProgressArray: [Dronecore_Rpc_Mission_MissionProgressResponse]) {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Mission_MissionServiceSubscribeMissionProgressCallTestStub()

        for missionProgress in missionProgressArray {
            fakeCall.outputs.append(missionProgress)
        }
        fakeService.subscribemissionprogressCalls.append(fakeCall)

        let mission = Mission(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(MissionProgress.self)

        let _ = mission.missionProgressObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<MissionProgress>>]()
        for missionProgress in missionProgressArray {
            expectedEvents.append(next(0, translateRPCMissionProgress(missionProgressRPC: missionProgress)))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testMissionProgressObservableReceivesMultipleEvents() {
        var missionProgressArray = [Dronecore_Rpc_Mission_MissionProgressResponse]()
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 1, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 2, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 3, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 4, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 5, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 6, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 7, missionCount: 10))

        checkMissionProgressObservableReceivesEvents(missionProgressArray: missionProgressArray)
    }

    func translateRPCMissionProgress(missionProgressRPC: Dronecore_Rpc_Mission_MissionProgressResponse) -> MissionProgress {
        return MissionProgress(currentItemIndex: missionProgressRPC.currentItemIndex, missionCount: missionProgressRPC.missionCount)
    }
}
