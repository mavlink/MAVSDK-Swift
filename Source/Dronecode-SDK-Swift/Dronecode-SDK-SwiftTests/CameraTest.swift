import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CameraTest: XCTestCase {
    let scheduler = MainScheduler.instance
    let cameraResultsArray: [DronecodeSdk_Rpc_Camera_CameraResult.Result] = [.unknown, .error, .busy, .timeout, .inProgress, .denied, .wrongArgument]
    
    // MARK: - Take Photo
    func testTakePhoto() {
        assertSuccess(result: takePhotoWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }
    
    func takePhotoWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_TakePhotoResponse()
        
        response.cameraResult.result = result
        fakeService.takePhotoResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        return client.takePhoto().toBlocking().materialize()
    }
    
    func testTakePhotoFail() {
        cameraResultsArray.forEach { result in
            assertFailure(result: takePhotoWithFakeResult(result: result))
        }
    }
    
    // MARK: - Start Photo Interval
    func testStartPhotoInteval() {
        assertSuccess(result: startPhotoIntervalWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }
    
    func startPhotoIntervalWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_StartPhotoIntervalResponse()
        
        response.cameraResult.result = result
        fakeService.startPhotoIntervalResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        return client.startPhotoInteval(interval: 5).toBlocking().materialize()
    }
    
    func testStartPhotoIntervalFail() {
        cameraResultsArray.forEach { result in
            assertFailure(result: startPhotoIntervalWithFakeResult(result: result))
        }
    }
    
    // MARK: - Stop Photo Interval
    func testStopPhotoInterval() {
        assertSuccess(result: stopPhotoIntervalWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }
    
    func stopPhotoIntervalWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_StopPhotoIntervalResponse()
        
        response.cameraResult.result = result
        fakeService.stopPhotoIntervalResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        return client.stopPhotoInterval().toBlocking().materialize()
    }
    
    func testStopPhotoIntervalFail() {
        cameraResultsArray.forEach { result in
            assertFailure(result: stopPhotoIntervalWithFakeResult(result: result))
        }
    }
    
    // MARK: - Start Video
    func testStartVideo() {
        assertSuccess(result: startVideoWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }
    
    func startVideoWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_StartVideoResponse()
        
        response.cameraResult.result = result
        fakeService.startVideoResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)

        return client.startVideo().toBlocking().materialize()
    }
    
    func testStartVideoFail() {
        cameraResultsArray.forEach { result in
            assertFailure(result: startVideoWithFakeResult(result:result))
        }
    }
    
    // MARK: - Stop Video
    func testStopVideo() {
       assertSuccess(result: stopPhotoIntervalWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }
    
    func stopVideoWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_StopVideoResponse() // Should fail?
        
        response.cameraResult.result = result
        fakeService.stopVideoResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)

        return client.stopVideo().toBlocking().materialize()
    }
    
    func testStopVideoFail() {
        cameraResultsArray.forEach { result in
            assertFailure(result: stopPhotoIntervalWithFakeResult(result: result))
        }
    }
    
    // MARK: - Start Video Streaming
    func testStartVideoStreaming() {
        assertSuccess(result: startVideoWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }
    
    func startVideoStreamingWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_StartVideoStreamingResponse()
        
        response.cameraResult.result = result
        fakeService.startVideoStreamingResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        return client.startVideoStreaming().toBlocking().materialize()
    }
    
    func testStartVideoStreamingFail() {
        cameraResultsArray.forEach { result in
            assertFailure(result: startVideoStreamingWithFakeResult(result: result))
        }
    }
    
    // MARK: - Stop Video Streaming
    func testStopVideoStreaming() {
        assertSuccess(result: stopPhotoIntervalWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }
    
    func stopVideoStreamingWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_StopVideoStreamingResponse()
        
        response.cameraResult.result = result
        fakeService.stopVideoStreamingResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)

        return client.stopVideoStreaming().toBlocking().materialize()
    }
    
    func testStopVideoStreamingFail() {
        cameraResultsArray.forEach { result in
            assertFailure(result: stopVideoStreamingWithFakeResult(result: result))
        }
    }
    
    // MARK: - Set Mode
    func testSetMode() {
        let cameraModeArray: [CameraMode] = [.unknown, .photo, .video]
        
        cameraModeArray.forEach { mode in
            assertSuccess(result: setModeWithFakeResult(mode: mode, result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
        }
    }
    
    func setModeWithFakeResult(mode: CameraMode, result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Camera_SetModeResponse()
        
        response.cameraResult.result = result
        fakeService.setModeResponses.append(response)
        
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        return client.setMode(mode: mode).toBlocking().materialize()
    }
    
    func testSetModeFail() {
        let cameraModeArray: [CameraMode] = [.unknown, .photo, .video]

        cameraResultsArray.forEach { result in
            cameraModeArray.forEach { mode in
                assertFailure(result: setModeWithFakeResult(mode: mode, result: result))
            }
        }
    }
    
    // MARK: - Subscribe Mode
    // No Event
    func testSubscribeModeEmitsNothingWhenNoEvents() {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Camera_CameraServiceSubscribeModeCallTestStub()
        fakeService.subscribeModeCalls.append(fakeCall)
        
        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(CameraMode.self)
        
        let _ = camera.cameraModeObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count)
    }
    
    // One Event
    func testCameraModeObservableReceivesOneEvent() {
        let cameraMode = createRPCCameraMode(status: .photo)
        let cameraModeStates = [cameraMode]
        
        checkSubscribeModeReceivesEvents(cameraModeStates: cameraModeStates)
    }
    
    // Multiple Events
    func testCameraModeObservableReceivesMultipleEvents() {
        var cameraModeStates = [DronecodeSdk_Rpc_Camera_CameraMode]()
        cameraModeStates.append(createRPCCameraMode(status: .photo))
        cameraModeStates.append(createRPCCameraMode(status: .video))
        cameraModeStates.append(createRPCCameraMode(status: .unknown))

        checkSubscribeModeReceivesEvents(cameraModeStates: cameraModeStates)
    }
    
    // Generic Methods
    func checkSubscribeModeReceivesEvents(cameraModeStates: [DronecodeSdk_Rpc_Camera_CameraMode]) {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Camera_CameraServiceSubscribeModeCallTestStub()
        
        cameraModeStates.forEach {
            fakeCall.outputs.append(createCameraModeResponse(cameraMode: $0))
        }
        fakeService.subscribeModeCalls.append(fakeCall)

        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(CameraMode.self)
        
        let _ = camera.cameraModeObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<CameraMode>>]()
        cameraModeStates.forEach {
            expectedEvents.append(next(0, CameraMode.translateFromRPC($0)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func createCameraModeResponse(cameraMode: DronecodeSdk_Rpc_Camera_CameraMode) -> DronecodeSdk_Rpc_Camera_ModeResponse {
        var response = DronecodeSdk_Rpc_Camera_ModeResponse()
        response.cameraMode = cameraMode
        
        return response
    }
    
    func createRPCCameraMode(status: DronecodeSdk_Rpc_Camera_CameraMode) -> DronecodeSdk_Rpc_Camera_CameraMode {
        var cameraMode = DronecodeSdk_Rpc_Camera_CameraMode()
        cameraMode = status
        
        return cameraMode
    }
    
    // MARK: - Set Video Stream Settings
    func testSetVideoStreamSettings() {
        assertSuccess(result: setVideoStreamSettingsWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result.success))
    }

    func setVideoStreamSettingsWithFakeResult(result: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        let response = DronecodeSdk_Rpc_Camera_SetVideoStreamSettingsResponse()
        
        fakeService.setVideoStreamSettingsResponses.append(response)
        let client = Camera(service: fakeService, scheduler: scheduler)
        
        let videoStreamSettings = VideoStreamSettings(frameRateHz: 4.5, horizontalResolutionPix: 32, verticalResolutionPix: 32, bitRateBS: 32, rotationDegree: 32, uri: "testUri") // Random values
        
        return client.setVideoStreamSettings(settings: videoStreamSettings).toBlocking().materialize()
    }
    
    // MARK: - Subscribe Video Stream Info
    // No Event
    func testVideoStreamInfoEmitsNothingWhenNoEvents() {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Camera_CameraServiceSubscribeVideoStreamInfoCallTestStub()
        fakeService.subscribeVideoStreamInfoCalls.append(fakeCall)
        
        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(VideoStreamInfo.self)
        
        let _ = camera.videoStreamInfoObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count)
    }

    // One Event
    func testVideoStreamInfoObservableReceivesOneEvent() {
        let videoStreamInfo = createRPCVideoStreamInfo(status: .inProgress)
        let videoStreamInfoStates = [videoStreamInfo]
        
        checkVideoStreamInfoReceivesEvents(videoStreamStates: videoStreamInfoStates)
    }
    
    // Multiple Events
    func testVideoStreamObservableReceivesMultipleEvents() {
        var videoStreamInfoStates = [DronecodeSdk_Rpc_Camera_VideoStreamInfo]()
        videoStreamInfoStates.append(createRPCVideoStreamInfo(status: .inProgress))
        videoStreamInfoStates.append(createRPCVideoStreamInfo(status: .notRunning))
        videoStreamInfoStates.append(createRPCVideoStreamInfo(status: .UNRECOGNIZED(7)))
        
        checkVideoStreamInfoReceivesEvents(videoStreamStates: videoStreamInfoStates)
    }
    
    
    // Generic Methods
    func checkVideoStreamInfoReceivesEvents(videoStreamStates: [DronecodeSdk_Rpc_Camera_VideoStreamInfo]) {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Camera_CameraServiceSubscribeVideoStreamInfoCallTestStub()
        
        videoStreamStates.forEach {
            fakeCall.outputs.append(createVideoStreamInfoResponse(videoStreamInfo: $0))
        }
        fakeService.subscribeVideoStreamInfoCalls.append(fakeCall)
        
        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(VideoStreamInfo.self)
        
        let _ = camera.videoStreamInfoObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<VideoStreamInfo>>]()
        videoStreamStates.forEach {
            expectedEvents.append(next(0, VideoStreamInfo.translateFromRPC($0)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func createVideoStreamInfoResponse(videoStreamInfo: DronecodeSdk_Rpc_Camera_VideoStreamInfo) -> DronecodeSdk_Rpc_Camera_VideoStreamInfoResponse {
        var response = DronecodeSdk_Rpc_Camera_VideoStreamInfoResponse()
        response.videoStreamInfo = videoStreamInfo
        
        return response
    }
    
    func createRPCVideoStreamInfo(status: DronecodeSdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus) -> DronecodeSdk_Rpc_Camera_VideoStreamInfo {
        var videoStreamInfo = DronecodeSdk_Rpc_Camera_VideoStreamInfo()
        videoStreamInfo.videoStreamStatus = status
        
        return videoStreamInfo
    }
    
    // MARK: - Subscribe Capture Info
    // No events
    func testCaptureInfoEmitsNothingWhenNoEvents() {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Camera_CameraServiceSubscribeCaptureInfoCallTestStub()
        fakeService.subscribeCaptureInfoCalls.append(fakeCall)
        
        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(CaptureInfo.self)
        
        let _ = camera.captureInfoObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count)
    }
    
    // One Event
    func testCaptureInfoReceivesOneEvent() {
        let position = Position(latitudeDeg: 34.44, longitudeDeg: 34.44, absoluteAltitudeM: 34.44, relativeAltitudeM: 34.44)
        let quaternion = Quaternion(w: 4, x: 4, y: 4, z: 4)
        let captureInfo = CaptureInfo(position: position, quaternion: quaternion, timeUTC: 5455454, isSuccess: true, index: 45, fileURL: "fileURLTest").rpcCaptureInfo
        let captureInfoArray = [captureInfo]
        
        checkCaptureInfoReceivesEvents(captureInfo: captureInfoArray)
    }
    
    // Multiple Events
    func testCaptureInfoReceivesMultipleEvents() {
        var captureInfoEvents = [DronecodeSdk_Rpc_Camera_CaptureInfo]()
        captureInfoEvents.append(generateRandomCaptureInfo().rpcCaptureInfo)
        captureInfoEvents.append(generateRandomCaptureInfo().rpcCaptureInfo)
        captureInfoEvents.append(generateRandomCaptureInfo().rpcCaptureInfo)
        captureInfoEvents.append(generateRandomCaptureInfo().rpcCaptureInfo)
        
        checkCaptureInfoReceivesEvents(captureInfo: captureInfoEvents)
    }
    
    // Generic Methods
    func checkCaptureInfoReceivesEvents(captureInfo: [DronecodeSdk_Rpc_Camera_CaptureInfo]) {
        let fakeService = DronecodeSdk_Rpc_Camera_CameraServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Camera_CameraServiceSubscribeCaptureInfoCallTestStub()
        
        captureInfo.forEach {
            fakeCall.outputs.append(createCaptureInfoResponse(captureInfo: $0))
        }
        fakeService.subscribeCaptureInfoCalls.append(fakeCall)
        
        let camera = Camera(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(CaptureInfo.self)
        
        let _ = camera.captureInfoObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<CaptureInfo>>]()
        captureInfo.forEach {
            expectedEvents.append(next(0, CaptureInfo.translateFromRPC($0)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func createCaptureInfoResponse(captureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo) -> DronecodeSdk_Rpc_Camera_CaptureInfoResponse {
        var response = DronecodeSdk_Rpc_Camera_CaptureInfoResponse()
        response.captureInfo = captureInfo
        
        return response
    }
    
    func generateRandomCaptureInfo() -> CaptureInfo {
        
        let randomBool = {
            return arc4random_uniform(2) == 0
        }
        
        let randomString = { () -> String in
            // Source: https://learnappmaking.com/random-numbers-swift/
            let n = 10
            
            let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
            var s = ""
            
            for _ in 0..<n {
                let r = Int(arc4random_uniform(UInt32(a.count)))
                s += String(a[a.index(a.startIndex, offsetBy: r)])
            }
            
            return s
        }
        
        let randomNumber = {
            return arc4random_uniform(10000)
        }
        
        let position = Position(latitudeDeg: Double(randomNumber()), longitudeDeg: Double(randomNumber()), absoluteAltitudeM: Float(randomNumber()), relativeAltitudeM: Float(randomNumber()))
        let quaternion = Quaternion(w: Float(randomNumber()), x: Float(randomNumber()), y: Float(randomNumber()), z: Float(randomNumber()))
        let captureInfo = CaptureInfo(position: position, quaternion: quaternion, timeUTC: UInt64(randomNumber()), isSuccess: randomBool(), index: Int32(randomNumber()), fileURL: randomString()).rpcCaptureInfo
        
        return CaptureInfo.translateFromRPC(captureInfo)
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
