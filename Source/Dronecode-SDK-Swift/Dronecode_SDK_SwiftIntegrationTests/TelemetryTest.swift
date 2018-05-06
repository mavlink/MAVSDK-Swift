import Dronecode_SDK_Swift
import RxBlocking
import RxSwift
import XCTest

class TelemetryTest: XCTestCase {

    func testPositionEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let positionEvents = try telemetry.positionObservable.take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("PositionObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }

    func testHealthEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let healthEvents = try telemetry.healthObservable.take(2).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("HealthObservable is expected to receive 2 events in 5 seconds, but it did not!")
        }
    }
    
    func testBatteryEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let batteryEvents = try telemetry.batteryObservable.take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("BatteryObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
    
    func testAttitudeEulerEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let attitudeEulerEvents = try telemetry.attitudeEulerObservable.take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("AttitudeEulerObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
    
    func testCameraAttitudeEulerEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let attitudeEulerEvents = try telemetry.cameraAttitudeEulerObservable.take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("CameraAttitudeEulerObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
}
