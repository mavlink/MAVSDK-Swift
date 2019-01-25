import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class MissionTest: XCTestCase {
    let scheduler = MainScheduler.instance
    let missionResultsArary: [DronecodeSdk_Rpc_Mission_MissionResult.Result] = [.unknown, .error, .tooManyMissionItems, .busy, .timeout, .invalidArgument, .unsupported, .noMissionAvailable, .failedToOpenQgcPlan, .failedToParseQgcPlan, .unsupportedMissionCmd]
    
    // MARK: - Upload Mission
    func testUploadsOneItem() {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let mission = Mission(service: fakeService, scheduler: scheduler)

        let missionItem = Mission.MissionItem(latitudeDeg: 46, longitudeDeg: 6, relativeAltitudeM: 50, speedMS: 3.4, isFlyThrough: true, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: Mission.MissionItem.CameraAction.none, loiterTimeS: 2)

        let missionItems = Mission.MissionItems(missionItems: [missionItem])
        _ = mission.uploadMission(missionItems: missionItems)
    }
    
    // MARK: - Download Mission
    func testDownloadMissionSucceedsOnSuccess() {
        let expectedResult = [Mission.MissionItem(latitudeDeg: 46.0, longitudeDeg: 6.0, relativeAltitudeM: Float(50), speedMS: Float(3.4), isFlyThrough: true, gimbalPitchDeg: Float(90), gimbalYawDeg: Float(23), cameraAction: Mission.MissionItem.CameraAction.none, loiterTimeS: Float(2)).rpcMissionItem]
        
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_DownloadMissionResponse()
        response.missionItems.missionItems = expectedResult
        
        fakeService.downloadMissionResponses.append(response)
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        _ = client.downloadMission().subscribe { event in
            switch event {
            case .success(let mission):
                XCTAssert(mission.missionItems == [Mission.MissionItem.translateFromRpc(expectedResult.first!)])
            case .error(let error):
                XCTFail("Expecting success, got failure: downloadMission() \(error)")
            }
        }
    }

    // MARK: - Start Mission
    func testStartSucceedsOnSuccess() {
        assertSuccess(result: startWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result.success))
    }

    func startWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_StartMissionResponse()
        response.missionResult.result = result
        fakeService.startMissionResponses.append(response)
        let mission = Mission(service: fakeService, scheduler: scheduler)

        return mission.startMission().toBlocking().materialize()
    }

    func testStartFailsOnFailure() {
        missionResultsArary.forEach { result in
            assertFailure(result: startWithFakeResult(result: result))
        }
    }
    
    // MARK: - Pause Mission
    func testPauseSucceedsOnSuccess() {
        assertSuccess(result: pauseWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result.success))
    }
    
    func pauseWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_PauseMissionResponse()
        response.missionResult.result = result
        fakeService.pauseMissionResponses.append(response)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        
        return mission.pauseMission().toBlocking().materialize()
    }
    
    func testPauseFailsOnFailure() {
        missionResultsArary.forEach { result in
            assertFailure(result: pauseWithFakeResult(result: result))
        }
    }
    
    // MARK: - Set Return to Launch After Mission
    func testSetReturnToLaunchAfterMissionOnSuccess() {
        assertSuccess(result: setReturnToLaunchAfterMissionWithFakeResults())
    }
    
    func setReturnToLaunchAfterMissionWithFakeResults() -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let response = DronecodeSdk_Rpc_Mission_SetReturnToLaunchAfterMissionResponse()
        fakeService.setReturnToLaunchAfterMissionResponses.append(response)
        
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        return client.setReturnToLaunchAfterMission(enable: true).toBlocking().materialize()
    }
    
    // MARK: - Get Return to Launch After Mission
    func testGetReturnToLaunchAfterMissionOnSuccess() {
        let expectedValue = true
        
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_GetReturnToLaunchAfterMissionResponse()
        response.enable = expectedValue
        
        fakeService.getReturnToLaunchAfterMissionResponses.append(response)
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        _ = client.getReturnToLaunchAfterMission().subscribe { event in
            switch event {
            case .success(let index):
                XCTAssert(index == expectedValue)
                break
            case .error(let error):
                XCTFail("Expecting success, got failure: getReturnToLaunchAfterMission() \(error)")
            }
        }
    }

    
    // MARK: - Set Current Mission Item Index
    func testSetCurrentMissionItemIndexOnSuccess() {
        assertSuccess(result: setCurrentMissionItemIndexWithFakeResults())
    }
    
    func setCurrentMissionItemIndexWithFakeResults() ->  MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let response = DronecodeSdk_Rpc_Mission_SetCurrentMissionItemIndexResponse()
        fakeService.setCurrentMissionItemIndexResponses.append(response)
        
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        return client.setCurrentMissionItemIndex(index: 2).toBlocking().materialize()
    }
    
    // MARK: - Is Mission Finished
    func testIsMissionFinishedSucceedsOnSuccess() {
        let expectedResult = true
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_IsMissionFinishedResponse()
        response.isFinished = expectedResult
        
        fakeService.isMissionFinishedResponses.append(response)
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        _ = client.isMissionFinished().subscribe { event in
            switch event {
            case .success(let isFinished):
                XCTAssert(isFinished == expectedResult)
                break
            case .error(let error):
                XCTFail("Expecting success, got failure: isMissionFinished() \(error) ")
            }
        }
    }

    // MARK: - Subscribe Mission Progress
    // No event
    func testMissionProgressObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Mission_MissionServiceSubscribeMissionProgressCallTestStub()
        fakeService.subscribeMissionProgressCalls.append(fakeCall)

        let mission = Mission(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Mission.MissionProgress.self)

        let _ = mission.missionProgress.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    // One event
    func testMissionProgressObservableReceivesOneEvent() {
        let missionProgress = createRPCMissionProgress(currentItemIndex: 5, missionCount: 10)
        let missionProgressArray = [missionProgress]
        
        checkMissionProgressObservableReceivesEvents(missionProgressArray: missionProgressArray)
    }

    // Multiple Events
    func testMissionProgressObservableReceivesMultipleEvents() {
        var missionProgressArray = [DronecodeSdk_Rpc_Mission_MissionProgressResponse]()
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 1, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 2, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 3, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 4, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 5, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 6, missionCount: 10))
        missionProgressArray.append(createRPCMissionProgress(currentItemIndex: 7, missionCount: 10))

        checkMissionProgressObservableReceivesEvents(missionProgressArray: missionProgressArray)
    }

    // Generic Methods
    func checkMissionProgressObservableReceivesEvents(missionProgressArray: [DronecodeSdk_Rpc_Mission_MissionProgressResponse]) {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Mission_MissionServiceSubscribeMissionProgressCallTestStub()
        
        for missionProgress in missionProgressArray {
            fakeCall.outputs.append(missionProgress)
        }
        fakeService.subscribeMissionProgressCalls.append(fakeCall)
        
        let mission = Mission(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Mission.MissionProgress.self)
        
        let _ = mission.missionProgress.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<Mission.MissionProgress>>]()
        for missionProgress in missionProgressArray {
            expectedEvents.append(next(0, translateRPCMissionProgress(missionProgressRPC: missionProgress)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func createRPCMissionProgress(currentItemIndex: Int32, missionCount: Int32) -> DronecodeSdk_Rpc_Mission_MissionProgressResponse {
        var response = DronecodeSdk_Rpc_Mission_MissionProgressResponse()
        response.missionProgress.currentItemIndex = currentItemIndex
        response.missionProgress.missionCount = missionCount
        
        return response
    }
    
    func translateRPCMissionProgress(missionProgressRPC: DronecodeSdk_Rpc_Mission_MissionProgressResponse) -> Mission.MissionProgress {
        return Mission.MissionProgress(currentItemIndex: missionProgressRPC.missionProgress.currentItemIndex, missionCount: missionProgressRPC.missionProgress.missionCount)
    }
    
    // MARK: - Utils
    func assertSuccess(result: MaterializedSequenceResult<Never>) {
        switch result {
        case .completed:
            break
        case .failed:
            XCTFail("Expecting success, got failure")
        }
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
