import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CameraTest: XCTestCase {
    
    func testTakePhoto() {
        let expectation = XCTestExpectation(description: "Take photo.")

        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)

        camera.setMode(mode: .photo)
            .do(onError: { error in
                XCTFail("\(error)")
            })
            .andThen(camera.takePhoto()
                .do(onError: { error in
                    XCTFail("\(error)")
                })
            )
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testStartAndStopPhotoInterval() {
        let expectation = XCTestExpectation(description: "Start and stop photo interval.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setMode(mode: .photo)
            .do(onError: { error in
                XCTFail("\(error)")
            })
            .andThen(
                camera.startPhotoInteval(interval: 5)
                    .do(onError: { error in
                        XCTFail("\(error)")
                    })
            )
            .andThen(
                camera.stopPhotoInterval()
                    .do(onError: { error in
                        XCTFail("\(error)")
                    })
            )
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testStartAndStopVideo() {
        let expectation = XCTestExpectation(description: "Start and stop video succeeded.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setMode(mode: .video)
            .do(onError: { error in
                XCTFail("\(error)")
            }).delay(2, scheduler: MainScheduler.instance)
            .andThen(
                camera.startVideo()
                    .do(onError: { error in
                        XCTFail("\(error)")
                    }).delay(5, scheduler: MainScheduler.instance)
            )
            .andThen(
                camera.stopVideo()
                    .do(onError: { error in
                        XCTFail("\(error)")
                    })
            )
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })

        wait(for: [expectation], timeout: 15.0)
    }
    
    func testSetMode() {
        let expectation = XCTestExpectation(description: "Set mode.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setMode(mode: .video).do(onError: { error in XCTFail("\(error)") })
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSubscribeMode() {
        let expectation = XCTestExpectation(description: "Subscribe mode.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let cameraMode = try camera.cameraModeObservable
                .do(onSubscribed: {
                    camera.setMode(mode: .photo)
                        .do(onError: { error in XCTFail("\(error)") })
                        .subscribe(onCompleted: {
                            expectation.fulfill()
                        }) { (error) in
                            XCTFail("\(error)")
                        }
                })
                .take(1).toBlocking(timeout: 10).toArray()
            print("CameraMode: \(cameraMode)")
        } catch {
            XCTFail("SubscribeMode is expected to receive 1 events in 5 seconds, but it did not!")
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSetVideoStreamSettings() {
        let expectation = XCTestExpectation(description: "Set video stream settings.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setVideoStreamSettings(settings: .init(frameRateHz: 43, horizontalResolutionPix: 43, verticalResolutionPix: 43, bitRateBS: 43, rotationDegree: 43, uri: "URI"))
            .do(onError: { error in XCTFail("\(error)") })
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    
    func testSubscribeVideoStreamInfo() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)

        do {
            let videoStreamInfo = try camera.videoStreamInfoObservable.take(1).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("SubscribeVideoStreamInfo is expected to receive 1 events in 5 seconds, but it did not!")
        }
    }
    
    func testSubscribeCaptureInfo() {
        
        let expectation = XCTestExpectation(description: "Subscribe capture info.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let captureInfo = try camera.captureInfoObservable
                .do(onSubscribed: {
                    camera.takePhoto()
                        .do(onError: { error in XCTFail("\(error)") })
                        .subscribe(onCompleted: {
                            expectation.fulfill()
                        }, onError: { (error) in
                            XCTFail("\(error)")
                        })
                })
                .take(1).toBlocking(timeout: 10).toArray()
        } catch {
            XCTFail("SubscribeCaptureInfo is expected to receive 1 events in 5 seconds, but it did not!")
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSubscribeCameraStatus() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let cameraStatus = try camera.cameraStatusObservable.take(5).toBlocking(timeout: 20).toArray()
//            print("CameraStatus: ", cameraStatus)
        } catch {
            XCTFail("SubscribeCameraStatus is expected to receive 1 events in 5 seconds, but it did not!")
        }
    }
    
    func testSubscribeCurrentSettings() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let currentSettings = try camera.currentSettingsObservable.take(1).toBlocking(timeout: 10).toArray()
//            print("CurrentSettings: ", currentSettings)
        } catch {
            XCTFail("SubscribeCurrentSettings is expected to receive 1 events in 5 seconds, but it did not!")
        }
    }
    
    func testSubscribePossibleSettingOptions() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        do {
            let possibleSettingOptions = try camera.possibleSettingOptionsObservable.take(1).toBlocking(timeout: 5).toArray()
//            print("PossibleSettings: ", possibleSettingOptions)
//
//            possibleSettingOptions[0].forEach {
//                print("SettingID: ", $0.settingId)
//                $0.options.forEach({ (option) in
//                    print("     OptionID: \(option.id)")
//                })
//            }
        } catch {
            XCTFail("SubscribePossibleSettingOptions is expected to receive 1 events in 5 seconds, but it did not!")
        }
    }
    
    func testSetSettings() {
        let expectation = XCTestExpectation(description: "Set settings.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let camera = Camera(address: "localhost", port: 50051)
        
        camera.setSetting(setting: Setting(id: "CAM_COLORMODE", option: Option(id: "3")))
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
        wait(for: [expectation], timeout: 10.0)
    }
    
    //    func testStartVideo() {
    //        let expectation = XCTestExpectation(description: "Stop video succeeded.")
    //
    //        let core = Core()
    //        core.connect().toBlocking().materialize()
    //        let camera = Camera(address: "localhost", port: 50051)
    //
    //        camera.startVideo()
    //            .do(onError: { error in XCTFail("\(error)") })
    //            .subscribe(onCompleted: {
    //                expectation.fulfill()
    //            }) { (error) in
    //                XCTFail("\(error)")
    //        }
    //
    //        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    //        wait(for: [expectation], timeout: 10.0)
    //    }
    //
    //
    //    func testStopVideo() {
    //        let expectation = XCTestExpectation(description: "Stop video succeeded.")
    //
    //        let core = Core()
    //        core.connect().toBlocking().materialize()
    //        let camera = Camera(address: "localhost", port: 50051)
    //
    //        camera.stopVideo()
    //            .do(onError: { error in XCTFail("\(error)") })
    //            .subscribe(onCompleted: {
    //                expectation.fulfill()
    //            }) { (error) in
    //                XCTFail("\(error)")
    //        }
    //
    //        // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
    //        wait(for: [expectation], timeout: 10.0)
    //    }
    
    //    func testStartVideoStreaming() {
    //        let core = Core()
    //        core.connect().toBlocking().materialize()
    //        let camera = Camera(address: "localhost", port: 50051)
    //
    //        camera.startVideoStreaming()
    //            .do(onError: { error in XCTFail("\(error)") })
    //            .subscribe()
    //    }
    //
    //    func testStopVideoStreaming() {
    //        let core = Core()
    //        core.connect().toBlocking().materialize()
    //        let camera = Camera(address: "localhost", port: 50051)
    //
    //        camera.stopVideoStreaming()
    //            .do(onError: { error in XCTFail("\(error)") })
    //            .subscribe()
    //    }
}


