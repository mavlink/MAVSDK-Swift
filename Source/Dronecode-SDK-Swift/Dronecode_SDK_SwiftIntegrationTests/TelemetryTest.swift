import Dronecode_SDK_Swift
import RxBlocking
import RxSwift
import XCTest

class TelemetryTest: XCTestCase {

    func testPositionEmitsValues() {
        let core = Core()
        core.connect()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let positionEvents = try telemetry.getPositionObservable().take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("PositionObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }

    func testHealthEmitsValues() {
        let core = Core()
        core.connect()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let healthEvents = try telemetry.getHealthObservable().take(2).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("HealthObservable is expected to receive 2 events in 5 seconds, but it did not!")
        }
    }
    
    func testBatteryEmitsValues() {
        let core = Core()
        core.connect()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let batteryEvents = try telemetry.getBatteryObservable().take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("BatteryObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
    
    func testAttitudeEulerEmitsValues() {
        let core = Core()
        core.connect()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let attitudeEulerEvents = try telemetry.getAttitudeEulerObservable().take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("AttitudeEulerObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
    
    func testCameraAttitudeEulerEmitsValues() {
        let core = Core()
        core.connect()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let attitudeEulerEvents = try telemetry.getCameraAttitudeEulerObservable().take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("CameraAttitudeEulerObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
}
