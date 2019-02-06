import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class MissionTest: XCTestCase {

    let missionResultsArary: [DronecodeSdk_Rpc_Mission_MissionResult.Result] = [.unknown, .error, .tooManyMissionItems, .busy, .timeout, .invalidArgument, .unsupported, .noMissionAvailable, .failedToOpenQgcPlan, .failedToParseQgcPlan, .unsupportedMissionCmd]
    
    func testUploadsOneItem() {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)

        let missionItem = Mission.MissionItem(latitudeDeg: 46, longitudeDeg: 6, relativeAltitudeM: 50, speedMS: 3.4, isFlyThrough: true, gimbalPitchDeg: 90, gimbalYawDeg: 23, cameraAction: Mission.MissionItem.CameraAction.none, loiterTimeS: 2, cameraPhotoIntervalS: 1)

        _ = mission.uploadMission(missionItems: [missionItem])
    }
    
    func testDownloadMissionSucceedsOnSuccess() {
        let expectedResult = [Mission.MissionItem(latitudeDeg: 46.0, longitudeDeg: 6.0, relativeAltitudeM: Float(50), speedMS: Float(3.4), isFlyThrough: true, gimbalPitchDeg: Float(90), gimbalYawDeg: Float(23), cameraAction: Mission.MissionItem.CameraAction.none, loiterTimeS: Float(2), cameraPhotoIntervalS: 1).rpcMissionItem]
        
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_DownloadMissionResponse()
        response.missionResult.result = DronecodeSdk_Rpc_Mission_MissionResult.Result.success
        response.missionItems = expectedResult
        
        fakeService.downloadMissionResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Mission(service: fakeService, scheduler: scheduler)

        _ = client.downloadMission()
                  .do(onError: { error in XCTFail("\(error)") })
                  .subscribe()
    }

    func testStartSucceedsOnSuccess() throws {
        _ = try startWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result.success)
    }

    func startWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result) throws {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_StartMissionResponse()
        response.missionResult.result = result
        fakeService.startMissionResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)

        _ = mission.startMission().toBlocking().materialize()
    }

    func testStartFailsOnFailure() throws {
        try missionResultsArary.forEach { result in
            try startWithFakeResult(result: result)
        }
    }
    
    func testPauseSucceedsOnSuccess() throws {
        try pauseWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result.success)
    }
    
    func pauseWithFakeResult(result: DronecodeSdk_Rpc_Mission_MissionResult.Result) throws {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_PauseMissionResponse()
        response.missionResult.result = result
        fakeService.pauseMissionResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        _ = mission.pauseMission()
                   .toBlocking()
                   .materialize()

        scheduler.start()
    }
    
    func testPauseFailsOnFailure() throws {
        try missionResultsArary.forEach { result in
            try pauseWithFakeResult(result: result)
        }
    }
    
    func testSetReturnToLaunchAfterMissionOnSuccess() throws {
        _ = try setReturnToLaunchAfterMissionWithFakeResults()
    }
    
    func setReturnToLaunchAfterMissionWithFakeResults() throws {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let response = DronecodeSdk_Rpc_Mission_SetReturnToLaunchAfterMissionResponse()
        fakeService.setReturnToLaunchAfterMissionResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        
        _ = mission.setReturnToLaunchAfterMission(enable: true).toBlocking().materialize()
    }
    
    func testGetReturnToLaunchAfterMissionOnSuccess() {
        let expectedValue = true
        
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_GetReturnToLaunchAfterMissionResponse()
        response.enable = expectedValue
        fakeService.getReturnToLaunchAfterMissionResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        
        _ = mission.getReturnToLaunchAfterMission().subscribe { event in
            switch event {
            case .success(let index):
                XCTAssert(index == expectedValue)
                break
            case .error(let error):
                XCTFail("Expecting success, got failure: getReturnToLaunchAfterMission() \(error)")
            }
        }
    }

    func testSetCurrentMissionItemIndexOnSuccess() throws {
        _ = try setCurrentMissionItemIndexWithFakeResults()
    }
    
    func setCurrentMissionItemIndexWithFakeResults() throws {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let response = DronecodeSdk_Rpc_Mission_SetCurrentMissionItemIndexResponse()
        fakeService.setCurrentMissionItemIndexResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        
        _ = mission.setCurrentMissionItemIndex(index: 2).toBlocking().materialize()
    }
    
    func testIsMissionFinishedSucceedsOnSuccess() {
        let expectedResult = true
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Mission_IsMissionFinishedResponse()
        response.isFinished = expectedResult
        fakeService.isMissionFinishedResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        
        _ = mission.isMissionFinished().subscribe { event in
            switch event {
            case .success(let isFinished):
                XCTAssert(isFinished == expectedResult)
                break
            case .error(let error):
                XCTFail("Expecting success, got failure: isMissionFinished() \(error) ")
            }
        }
    }

    func testMissionProgressObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Mission_MissionServiceSubscribeMissionProgressCallTestStub()
        fakeService.subscribeMissionProgressCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Mission.MissionProgress.self)

        let _ = mission.missionProgress.subscribe(observer)
        scheduler.start()

        XCTAssertEqual(0, observer.events.count)
    }

    func testMissionProgressObservableReceivesOneEvent() {
        let missionProgress = createRPCMissionProgress(currentItemIndex: 5, missionCount: 10)
        let missionProgressArray = [missionProgress]
        
        checkMissionProgressObservableReceivesEvents(missionProgressArray: missionProgressArray)
    }

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

    func checkMissionProgressObservableReceivesEvents(missionProgressArray: [DronecodeSdk_Rpc_Mission_MissionProgressResponse]) {
        let fakeService = DronecodeSdk_Rpc_Mission_MissionServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Mission_MissionServiceSubscribeMissionProgressCallTestStub()
        
        for missionProgress in missionProgressArray {
            fakeCall.outputs.append(missionProgress)
        }
        fakeService.subscribeMissionProgressCalls.append(fakeCall)
        
        let scheduler = TestScheduler(initialClock: 0)
        let mission = Mission(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Mission.MissionProgress.self)
        
        let _ = mission.missionProgress.subscribe(observer)
        scheduler.start()

        var expectedEvents = [Recorded<Event<Mission.MissionProgress>>]()
        for missionProgress in missionProgressArray {
            expectedEvents.append(next(0, Mission.MissionProgress.translateFromRpc(missionProgress.missionProgress)))
        }

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
            observed.value == expected.value
        }))
    }
    
    func createRPCMissionProgress(currentItemIndex: Int32, missionCount: Int32) -> DronecodeSdk_Rpc_Mission_MissionProgressResponse {
        var response = DronecodeSdk_Rpc_Mission_MissionProgressResponse()
        response.missionProgress.currentItemIndex = currentItemIndex
        response.missionProgress.missionCount = missionCount
        
        return response
    }
}
