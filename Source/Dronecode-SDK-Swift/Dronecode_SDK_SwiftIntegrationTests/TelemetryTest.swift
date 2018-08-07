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
    
    func testAttitudeQuaternionEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let attitudeQuaternionEvents = try telemetry.attitudeQuaternionObservable.take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("AttitudeQuaternionObservable is expected to receive 5 events in 5 seconds, but it did not!")
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

    func testCameraAttitudeQuaternionEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let attitudeEulerEvents = try telemetry.cameraAttitudeQuaternionObservable.take(5).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("CameraAttitudeQuaternionObservable is expected to receive 5 events in 5 seconds, but it did not!")
        }
    }
    
    func testHomePositionEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let homePositionEvents = try telemetry.homePositionObservable.take(1).toBlocking(timeout: 5).toArray()
        } catch {
            XCTFail("HomePositionObservable is expected to receive at least one event, but it did not!")
        }
    }

    func testGPSInfoEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let gpsInfoEvents = try telemetry.GPSInfoObservable.take(1).toBlocking(timeout: 3).toArray()
        } catch {
            XCTFail("GPSInfoObservable is expected to receive at least one event, but it did not!")
        }
    }
    
    func testFlightModeEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let flightModeEvents = try telemetry.flightModeObservable.take(1).toBlocking(timeout: 3).toArray()
        } catch {
            XCTFail("FlightModeObservable is expected to receive at least one event, but it did not!")
        }
    }

    func testGroundSpeedEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)

        do {
            let groundSpeedEvents = try telemetry.groundSpeedNEDObservable.take(3).toBlocking(timeout: 3).toArray()
        } catch {
            XCTFail("GroundSpeedObservable is expected to receive at least one event, but it did not!")
        }
    }

    func testRCStatusEmitsValues() {
        let core = Core()
        core.connect().toBlocking().materialize()
        let telemetry = Telemetry(address: "localhost", port: 50051)
        
        do {
            let rcStatusEvents = try telemetry.rcStatusObservable.take(1).toBlocking(timeout: 3).toArray()
        } catch {
            XCTFail("RCStatusObservable is expected to receive at least one event, but it did not!")
        }
    }
}
