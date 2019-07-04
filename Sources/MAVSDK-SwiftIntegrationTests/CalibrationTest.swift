import RxSwift
import XCTest
@testable import MAVSDK_Swift

class CalibrationTest: XCTestCase {

    /*
    func testGyroCalibration() {
        let expectation = XCTestExpectation(description: "Gyro calibration succeeded.")

        let core = Core()
        core.connect().toBlocking().materialize()
        let calibration = Calibration(address: "localhost", port: 50051)

        calibration.calibrateGyro
            .do(onNext: { progressData in print(progressData) },
                onError: { error in print(error) })
            .subscribe(onError: { error in XCTFail(); expectation.fulfill() },
                       onCompleted: { expectation.fulfill() })

        wait(for: [expectation], timeout: 180.0)
    }

    func testAccelerometerCalibration() {
        let expectation = XCTestExpectation(description: "Accelerometer calibration succeeded.")

        let core = Core()
        core.connect().toBlocking().materialize()
        let calibration = Calibration(address: "localhost", port: 50051)

        calibration.calibrateAccelerometer
            .do(onNext: { progressData in print(progressData) },
                onError: { error in print(error) })
            .subscribe(onError: { error in XCTFail(); expectation.fulfill() },
                       onCompleted: { expectation.fulfill() })

        wait(for: [expectation], timeout: 180.0)
    }

    func testMagnetometerCalibration() {
        let expectation = XCTestExpectation(description: "Magnetometer calibration succeeded.")

        let core = Core()
        core.connect().toBlocking().materialize()
        let calibration = Calibration(address: "localhost", port: 50051)

        calibration.calibrateMagnetometer
            .do(onNext: { progressData in print(progressData) },
                onError: { error in print(error) })
            .subscribe(onError: { error in XCTFail(); expectation.fulfill() },
                       onCompleted: { expectation.fulfill() })

        wait(for: [expectation], timeout: 180.0)
    }
 */
}
