import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CameraTest: XCTestCase {
    
    let scheduler = MainScheduler.instance
    let cameraResultsArray: [Mavsdk_Rpc_Camera_CameraResult.Result] = [.unknown, .error, .busy, .timeout, .inProgress, .denied, .wrongArgument]
    
    func testTakePhoto() throws {
        _ = try takePhotoWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
    }
    
    func takePhotoWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_TakePhotoResponse()
        
        response.cameraResult.result = result
        fakeService.takePhotoResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.takePhoto().toBlocking().materialize()
    }
    
    func testTakePhotoFail() throws {
        try cameraResultsArray.forEach { result in
            try takePhotoWithFakeResult(result: result)
        }
    }
    
    func testStartPhotoInteval() throws {
        _ = try startPhotoIntervalWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
    }
    
    func startPhotoIntervalWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_StartPhotoIntervalResponse()
        
        response.cameraResult.result = result
        fakeService.startPhotoIntervalResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.startPhotoInterval(intervalS: 5).toBlocking().materialize()
    }
    
    func testStartPhotoIntervalFail() throws {
        try cameraResultsArray.forEach { result in
            try startPhotoIntervalWithFakeResult(result: result)
        }
    }
    
    func testStopPhotoInterval() throws {
        _ = try stopPhotoIntervalWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
    }
    
    func stopPhotoIntervalWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_StopPhotoIntervalResponse()
        
        response.cameraResult.result = result
        fakeService.stopPhotoIntervalResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.stopPhotoInterval().toBlocking().materialize()
    }
    
    func testStopPhotoIntervalFail() throws {
        try cameraResultsArray.forEach { result in
            try stopPhotoIntervalWithFakeResult(result: result)
        }
    }
    
    func testStartVideo() throws {
        _ = try startVideoWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
    }
    
    func startVideoWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_StartVideoResponse()
        
        response.cameraResult.result = result
        fakeService.startVideoResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.startVideo().toBlocking().materialize()
    }
    
    func testStartVideoFail() throws {
        try cameraResultsArray.forEach { result in
            try startVideoWithFakeResult(result:result)
        }
    }
    
    func testStopVideo() throws {
        _ = try stopPhotoIntervalWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
    }
    
    func stopVideoWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_StopVideoResponse() // Should fail?
        
        response.cameraResult.result = result
        fakeService.stopVideoResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.stopVideo().toBlocking().materialize()
    }
    
    func testStopVideoFail() throws {
        try cameraResultsArray.forEach { result in
            _ = try stopPhotoIntervalWithFakeResult(result: result)
        }
    }
    
    func testStartVideoStreaming() throws {
        try startVideoWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
    }
    
    func startVideoStreamingWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_StartVideoStreamingResponse()
        
        response.cameraResult.result = result
        fakeService.startVideoStreamingResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.startVideoStreaming().toBlocking().materialize()
    }
    
    func testStartVideoStreamingFail() throws {
        try cameraResultsArray.forEach { result in
            try startVideoStreamingWithFakeResult(result: result)
        }
    }
    
    func testStopVideoStreaming() throws {
        _ = try stopPhotoIntervalWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
    }
    
    func stopVideoStreamingWithFakeResult(result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_StopVideoStreamingResponse()
        
        response.cameraResult.result = result
        fakeService.stopVideoStreamingResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.stopVideoStreaming().toBlocking().materialize()
    }
    
    func testStopVideoStreamingFail() throws {
        try cameraResultsArray.forEach { result in
            try stopVideoStreamingWithFakeResult(result: result)
        }
    }
    
    func testSetMode() throws {
        let cameraModeArray: [Camera.CameraMode] = [.unknown, .photo, .video]
        
        try cameraModeArray.forEach { mode in
            try setModeWithFakeResult(mode: mode, result: Mavsdk_Rpc_Camera_CameraResult.Result.success)
        }
    }
    
    func setModeWithFakeResult(mode: Camera.CameraMode, result: Mavsdk_Rpc_Camera_CameraResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = Mavsdk_Rpc_Camera_SetModeResponse()
        
        response.cameraResult.result = result
        fakeService.setModeResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        _ = client.setMode(cameraMode: mode).toBlocking().materialize()
    }
    
    func testSetModeFail() throws {
        let cameraModeArray: [Camera.CameraMode] = [.unknown, .photo, .video]
        
        try cameraResultsArray.forEach { result in
            try cameraModeArray.forEach { mode in
                try setModeWithFakeResult(mode: mode, result: result)
            }
        }
    }
    
    func testSubscribeModeEmitsNothingWhenNoEvents() {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = Mavsdk_Rpc_Camera_CameraServiceSubscribeModeCallTestStub()
        fakeService.subscribeModeCalls.append(fakeCall)
        
        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Camera.CameraMode.self)
        
        let _ = camera.mode.subscribe(observer)
        scheduler.start()

        XCTAssertEqual(0, observer.events.count)
    }
    
    func testCameraModeObservableReceivesOneEvent() {
        let cameraMode = createRPCCameraMode(status: .photo)
        let cameraModeStates = [cameraMode]
        
        checkSubscribeModeReceivesEvents(cameraModeStates: cameraModeStates)
    }
    
    func testCameraModeObservableReceivesMultipleEvents() {
        var cameraModeStates = [Mavsdk_Rpc_Camera_CameraMode]()
        cameraModeStates.append(createRPCCameraMode(status: .photo))
        cameraModeStates.append(createRPCCameraMode(status: .video))
        cameraModeStates.append(createRPCCameraMode(status: .unknown))
        
        checkSubscribeModeReceivesEvents(cameraModeStates: cameraModeStates)
    }
    
    func checkSubscribeModeReceivesEvents(cameraModeStates: [Mavsdk_Rpc_Camera_CameraMode]) {
        let fakeService = Mavsdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = Mavsdk_Rpc_Camera_CameraServiceSubscribeModeCallTestStub()
        
        cameraModeStates.forEach {
            fakeCall.outputs.append(createCameraModeResponse(cameraMode: $0))
        }
        fakeService.subscribeModeCalls.append(fakeCall)
        
        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Camera.CameraMode.self)
        
        let _ = camera.mode.subscribe(observer)
        scheduler.start()

        var expectedEvents = [Recorded<Event<Camera.CameraMode>>]()
        cameraModeStates.forEach {
            expectedEvents.append(next(0, Camera.CameraMode.translateFromRpc($0)))
        }

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
            observed.value == expected.value
        }))
    }
    
    func createCameraModeResponse(cameraMode: Mavsdk_Rpc_Camera_CameraMode) -> Mavsdk_Rpc_Camera_ModeResponse {
        var response = Mavsdk_Rpc_Camera_ModeResponse()
        response.cameraMode = cameraMode
        
        return response
    }
    
    func createRPCCameraMode(status: Mavsdk_Rpc_Camera_CameraMode) -> Mavsdk_Rpc_Camera_CameraMode {
        var cameraMode = Mavsdk_Rpc_Camera_CameraMode()
        cameraMode = status
        
        return cameraMode
    }
}
