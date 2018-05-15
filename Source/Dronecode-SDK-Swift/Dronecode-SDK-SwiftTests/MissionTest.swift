import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class MissionTest: XCTestCase {
    let scheduler = MainScheduler.instance
    let missionResultsArary: [Dronecore_Rpc_Mission_MissionResult.Result] = [.unknown, .error, .tooManyMissionItems, .busy, .timeout, .invalidArgument, .unsupported, .noMissionAvailable, .failedToOpenQgcPlan, .failedToParseQgcPlan, .unsupportedMissionCmd]
    
    // MARK: - Upload Mission
    func testUploadsOneItem() {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        let mission = Mission(service: fakeService, scheduler: scheduler)

        let missionItem = MissionItem(latitudeDeg: 46, longitudeDeg: 6, relativeAltitudeM: 50, speedMPS: 3.4, isFlyThrough: true, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: CameraAction.none)

        _ = mission.uploadMission(missionItems: [missionItem])
    }
    
    // MARK: - Download Mission
    func testDownloadMissionSucceedsOnSuccess() {
        let expectedResult = [MissionItem.createRPC(MissionItem(latitudeDeg: 46, longitudeDeg: 6, relativeAltitudeM: 50, speedMPS: 3.4, isFlyThrough: true, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: CameraAction.none))]
        
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        var response = Dronecore_Rpc_Mission_DownloadMissionResponse()
        response.mission.missionItem = expectedResult
        
        fakeService.downloadmissionResponses.append(response)
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        _ = client.downloadMission().subscribe { event in
            switch event {
            case .success(let mission):
                XCTAssert(mission == [MissionItem.translateFromRPC(expectedResult.first!)])
            case .error(let error):
                XCTFail("Expecting success, got failure: downloadMission() \(error)")
            }
        }
    }

    // MARK: - Start Mission
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

    func testStartFailsOnFailure() {
        missionResultsArary.forEach { result in
            assertFailure(result: startWithFakeResult(result: result))
        }
    }
    
    // MARK: - Pause Mission
    func testPauseSucceedsOnSuccess() {
        assertSuccess(result: pauseWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result.success))
    }
    
    func pauseWithFakeResult(result: Dronecore_Rpc_Mission_MissionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        var response = Dronecore_Rpc_Mission_PauseMissionResponse()
        response.missionResult.result = result
        fakeService.pausemissionResponses.append(response)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        
        return mission.pauseMission().toBlocking().materialize()
    }
    
    func testPauseFailsOnFailure() {
        missionResultsArary.forEach { result in
            assertFailure(result: pauseWithFakeResult(result: result))
        }
    }
    
    // MARK: - Set Current Mission Item Index
    func testSetCurrentMissionItemIndexOnSuccess() {
        assertSuccess(result: setCurrentMissionItemIndexWithFakeResults())
    }
    
    func setCurrentMissionItemIndexWithFakeResults() ->  MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        let response = Dronecore_Rpc_Mission_SetCurrentMissionItemIndexResponse()
        fakeService.setcurrentmissionitemindexResponses.append(response)
        
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        return client.setCurrentMissionItemIndex(2).toBlocking().materialize()
    }
    
    // MARK: - Get Current Mission Item Index
    func testGetCurrentMissionItemIndexSucceedsOnSuccess() {
        let expectedIndex = 32
        
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        var response = Dronecore_Rpc_Mission_GetCurrentMissionItemIndexResponse()
        response.index = Int32(expectedIndex)
        
        fakeService.getcurrentmissionitemindexResponses.append(response)
        let client = Mission(service: fakeService, scheduler: self.scheduler)
        
        _ = client.getCurrentMissionItemIndex().subscribe { event in
            switch event {
            case .success(let index):
                XCTAssert(index == expectedIndex)
                break
            case .error(let error):
                XCTFail("Expecting success, got failure: getCurrentMissionItemIndex() \(error)")
            }
        }
    }
    
    // MARK: - Get Mission Count
    func testGetMissionCountSucceedsOnSuccess() {
        let expectedMissionCount = 40
        
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        var response = Dronecore_Rpc_Mission_GetMissionCountResponse()
        response.count = Int32(expectedMissionCount)
        
        fakeService.getmissioncountResponses.append(response)
        let client = Mission(service: fakeService, scheduler: self.scheduler)

        _ = client.getMissionCount().subscribe { event in
            switch event {
            case .success(let count):
                XCTAssert(count == expectedMissionCount)
            case .error(let error):
                XCTFail("Expecting success, got failure: getMissionCount() \(error)")
            }
        }
        
    }
    
    // MARK: - Is Mission Finished
    func testIsMissionFinishedSucceedsOnSuccess() {
        let expectedResult = true
        let fakeService = Dronecore_Rpc_Mission_MissionServiceServiceTestStub()
        var response = Dronecore_Rpc_Mission_IsMissionFinishedResponse()
        response.isFinished = expectedResult
        
        fakeService.ismissionfinishedResponses.append(response)
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

    // One event
    func testMissionProgressObservableReceivesOneEvent() {
        let missionProgress = createRPCMissionProgress(currentItemIndex: 5, missionCount: 10)
        let missionProgressArray = [missionProgress]
        
        checkMissionProgressObservableReceivesEvents(missionProgressArray: missionProgressArray)
    }

    // Multiple Events
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

    // Generic Methods
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
    
    func createRPCMissionProgress(currentItemIndex: Int32, missionCount: Int32) -> Dronecore_Rpc_Mission_MissionProgressResponse {
        var missionProgress = Dronecore_Rpc_Mission_MissionProgressResponse()
        missionProgress.currentItemIndex = currentItemIndex
        missionProgress.missionCount = missionCount
        
        return missionProgress
    }
    
    func translateRPCMissionProgress(missionProgressRPC: Dronecore_Rpc_Mission_MissionProgressResponse) -> MissionProgress {
        return MissionProgress(currentItemIndex: missionProgressRPC.currentItemIndex, missionCount: missionProgressRPC.missionCount)
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
