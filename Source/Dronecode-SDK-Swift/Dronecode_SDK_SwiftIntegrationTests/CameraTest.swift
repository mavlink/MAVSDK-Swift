import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CameraTest: XCTestCase {
    func testTakePhoto() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.takePhoto()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testStartPhotoInterval() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.startPhotoInteval(interval: 5)
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testStopPhotoInterval() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.stopPhotoInterval()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testStartVideo() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.startVideo()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testStopVideo() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.stopVideo()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testStartVideoStreaming() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.startVideoStreaming()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testStopVideoStreaming() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.stopVideoStreaming()
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testSetMode() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setMode(mode: .photo).do(onError: { error in XCTFail("\(error)") })
            .andThen( camera.setMode(mode: .video).do(onError: { error in XCTFail("\(error)") }))
            .subscribe()
    }
    
    func testSubscribeMode() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let cameraMode = try camera.cameraModeObservable.take(1).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("SubscribeMode is expected to receive 1 events in 5 seconds, but it did not!")
        }
    }
    
    func testSetVideoStreamSettings() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setVideoStreamSettings(settings: .init(frameRateHz: 43, horizontalResolutionPix: 43, verticalResolutionPix: 43, bitRateBS: 43, rotationDegree: 43, uri: "URI"))
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
    
    func testSubscribeVideoStreamInfo() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let videoStreamInfo = try camera.videoStreamInfoObservable.take(2).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("SubscribeVideoStreamInfo is expected to receive 2 events in 5 seconds, but it did not!")
        }
    }
    
    func testSubscribeCaptureInfo() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let captureInfo = try camera.captureInfoObservable.take(1).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("SubscribeCaptureInfo is expected to receive 1 events in 5 seconds, but it did not!")
        }
    }
    
    func testGetPossibleSettings() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.getPossibleSettings()
            .do(
                onError: { error in XCTFail("\(error)") },
                onNext: { settings in XCTAssert(settings != nil)}
            )
            .subscribe()
    }
    
    func testSetOption() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setOption(option: .init(id: "Setting1", description: "Description1", possibleValue: ["Value1", "Value2"])) // TODO: Change this to set options based on getting possible settings.
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe()
    }
}
