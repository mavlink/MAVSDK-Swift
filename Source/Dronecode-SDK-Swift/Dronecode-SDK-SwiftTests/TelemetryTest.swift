import RxTest
import RxSwift
import XCTest
@testable import Dronecode_SDK_Swift

class TelemetryTest: XCTestCase {
    let scheduler = MainScheduler.instance

    // MARK: - POSITION

    func testPositionObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribePositionCallTestStub()
        fakeService.subscribePositionCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Position.self)

        let _ = telemetry.positionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    // One Event
    func testPositionObservableReceivesOneEvent() {
        let position = createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3);
        let positions = [position]

        checkPositionObservableReceivesEvents(positions: positions)
    }
    
    func createRPCPosition(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, relativeAltitudeM: Float) -> DronecodeSdk_Rpc_Telemetry_Position {
        var position = DronecodeSdk_Rpc_Telemetry_Position()
        position.latitudeDeg = latitudeDeg
        position.longitudeDeg = longitudeDeg
        position.absoluteAltitudeM = absoluteAltitudeM
        position.relativeAltitudeM = relativeAltitudeM
        
        return position
    }

    
    // Generic Methods
    func checkPositionObservableReceivesEvents(positions: [DronecodeSdk_Rpc_Telemetry_Position]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribePositionCallTestStub()
        
        for position in positions {
            fakeCall.outputs.append(createPositionResponse(position: position))
        }
        fakeService.subscribePositionCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Position.self)
        
        let _ = telemetry.positionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<Position>>]()
        for position in positions {
            expectedEvents.append(next(0, translateRPCPosition(positionRPC: position)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    // Multiple Events
    func testPositionObservableReceivesMultipleEvents() {
        var positions = [DronecodeSdk_Rpc_Telemetry_Position]()
        positions.append(createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3));
        positions.append(createRPCPosition(latitudeDeg: 46.522626, longitudeDeg: 6.635356, absoluteAltitudeM: 542.2, relativeAltitudeM: 79.8));
        positions.append(createRPCPosition(latitudeDeg: -50.995944711358824, longitudeDeg: -72.99892046835936, absoluteAltitudeM: 1217.12, relativeAltitudeM: 2.52));
        
        checkPositionObservableReceivesEvents(positions: positions)
    }

    func createPositionResponse(position: DronecodeSdk_Rpc_Telemetry_Position) -> DronecodeSdk_Rpc_Telemetry_PositionResponse {
        var response = DronecodeSdk_Rpc_Telemetry_PositionResponse()
        response.position = position

        return response
    }

    func translateRPCPosition(positionRPC: DronecodeSdk_Rpc_Telemetry_Position) -> Position {
        return Position(latitudeDeg: positionRPC.latitudeDeg, longitudeDeg: positionRPC.longitudeDeg, absoluteAltitudeM: positionRPC.absoluteAltitudeM, relativeAltitudeM: positionRPC.relativeAltitudeM)
    }

    // MARK: - HEALTH
    func testHealthObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeHealthCallTestStub()
        fakeService.subscribeHealthCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Health.self)
        
        let _ = telemetry.healthObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }
    
    // One Event
    func testHealthObservableReceivesOneEvent() {
        checkHealthObservableReceivesEvents(nbEvents: 1)
    }
    
    // Multiple Events
    func testHealthObservableReceivesMultipleEvents() {
        checkHealthObservableReceivesEvents(nbEvents: 10)
    }
    
    // Generic Methods
    func checkHealthObservableReceivesEvents(nbEvents: UInt) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeHealthCallTestStub()
        
        var healths = [DronecodeSdk_Rpc_Telemetry_Health]()
        for _ in 1...nbEvents {
            healths.append(createRandomRPCHealth())
        }
        
        for health in healths {
            fakeCall.outputs.append(createHealthResponse(health: health))
        }
        fakeService.subscribeHealthCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Health.self)
        
        let _ = telemetry.healthObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<Health>>]()
        for health in healths {
            expectedEvents.append(next(0, translateRPCHealth(healthRPC: health)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func translateRPCHealth(healthRPC: DronecodeSdk_Rpc_Telemetry_Health) -> Health {
        return Health(isGyrometerCalibrationOk: healthRPC.isGyrometerCalibrationOk, isAccelerometerCalibrationOk: healthRPC.isAccelerometerCalibrationOk, isMagnetometerCalibrationOk: healthRPC.isMagnetometerCalibrationOk, isLevelCalibrationOk: healthRPC.isLevelCalibrationOk, isLocalPositionOk: healthRPC.isLocalPositionOk, isGlobalPositionOk: healthRPC.isGlobalPositionOk, isHomePositionOk: healthRPC.isHomePositionOk)
    }
    
    func createHealthResponse(health: DronecodeSdk_Rpc_Telemetry_Health) -> DronecodeSdk_Rpc_Telemetry_HealthResponse {
        var response = DronecodeSdk_Rpc_Telemetry_HealthResponse()
        response.health = health
        
        return response
    }
    
    func generateRandomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func createRandomRPCHealth() -> DronecodeSdk_Rpc_Telemetry_Health {
        var health = DronecodeSdk_Rpc_Telemetry_Health()
        
        health.isGyrometerCalibrationOk = generateRandomBool()
        health.isAccelerometerCalibrationOk = generateRandomBool()
        health.isMagnetometerCalibrationOk = generateRandomBool()
        health.isLevelCalibrationOk = generateRandomBool()
        health.isLocalPositionOk = generateRandomBool()
        health.isGlobalPositionOk = generateRandomBool()
        health.isHomePositionOk = generateRandomBool()
        
        return health
    }
    
    // MARK: - CAMERA ATTITUDE EULER
    func testCameraAttitudeEulerObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeCameraAttitudeEulerCallTestStub()
        fakeService.subscribeCameraAttitudeEulerCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(EulerAngle.self)
        
        let _ = telemetry.cameraAttitudeEulerObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }
    
    // One Event
    func testCameraAttitudeEulerObservableReceivesOneEvent() {
        let attitudeEuler = createRPCCameraAttitudeEuler(pitchDeg: 45.0, rollDeg: 35.0, yawDeg: 25.0)
        let attitudes = [attitudeEuler]
        
        checkCameraAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }
    
    // Multiple Events
    func testCameraAttitudeEulerObservableReceivesMultipleEvents() {
        var attitudes = [DronecodeSdk_Rpc_Telemetry_EulerAngle]()
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 12.0, rollDeg: 13.2, yawDeg: 24.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 13.0, rollDeg: 12.2, yawDeg: 34.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 14.0, rollDeg: 11.2, yawDeg: 44.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 15.0, rollDeg: 10.2, yawDeg: 54.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 16.0, rollDeg: 9.2, yawDeg: 64.1))
        
        checkCameraAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }
    
    // Generic Methods
    func checkCameraAttitudeEulerObservableReceivesEvents(attitudes: [DronecodeSdk_Rpc_Telemetry_EulerAngle]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeCameraAttitudeEulerCallTestStub()
        
        for attitude in attitudes {
            fakeCall.outputs.append(createCameraAttitudeEulerResponse(attitudeEuler: attitude))
        }
        fakeService.subscribeCameraAttitudeEulerCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(EulerAngle.self)
        
        let _ = telemetry.cameraAttitudeEulerObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<EulerAngle>>]()
        for attitude in attitudes {
            expectedEvents.append(next(0, translateRPCAttitudeEuler(attitudeEulerRPC: attitude)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func createRPCCameraAttitudeEuler(pitchDeg: Float, rollDeg: Float, yawDeg: Float) -> DronecodeSdk_Rpc_Telemetry_EulerAngle {
        var attitudeEuler = DronecodeSdk_Rpc_Telemetry_EulerAngle()
        attitudeEuler.pitchDeg = pitchDeg
        attitudeEuler.rollDeg = rollDeg
        attitudeEuler.yawDeg = yawDeg
        
        return attitudeEuler
    }

    func createCameraAttitudeEulerResponse(attitudeEuler: DronecodeSdk_Rpc_Telemetry_EulerAngle) -> DronecodeSdk_Rpc_Telemetry_CameraAttitudeEulerResponse {
        var response = DronecodeSdk_Rpc_Telemetry_CameraAttitudeEulerResponse()
        response.attitudeEuler = attitudeEuler
        
        return response
    }

    // MARK: - BATTERY
    func testBatteryObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeBatteryCallTestStub()
        fakeService.subscribeBatteryCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Battery.self)

        let _ = telemetry.batteryObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    // One Event
    func testBatteryObservableReceivesOneEvent() {
        let battery = createRPCBattery(remainingPercent: 0.55, voltageV: 12.5)
        let batteryStates = [battery]

        checkBatteryObservableReceivesEvents(batteryStates: batteryStates)
    }
        
    // Multiple Events
    func testBatteryObservableReceivesMultipleEvents() {
        var batteryStates = [DronecodeSdk_Rpc_Telemetry_Battery]()
        batteryStates.append(createRPCBattery(remainingPercent: 0.45, voltageV: 12.4))
        batteryStates.append(createRPCBattery(remainingPercent: 0.44, voltageV: 12.5))
        batteryStates.append(createRPCBattery(remainingPercent: 0.43, voltageV: 12.6))
        batteryStates.append(createRPCBattery(remainingPercent: 0.42, voltageV: 12.7))
        batteryStates.append(createRPCBattery(remainingPercent: 0.41, voltageV: 12.8))
        
        checkBatteryObservableReceivesEvents(batteryStates: batteryStates)
    }

    func createRPCBattery(remainingPercent: Float, voltageV: Float) -> DronecodeSdk_Rpc_Telemetry_Battery {
        var battery = DronecodeSdk_Rpc_Telemetry_Battery()
        battery.remainingPercent = remainingPercent
        battery.voltageV = voltageV

        return battery
    }

    // Generic Methods
    func checkBatteryObservableReceivesEvents(batteryStates: [DronecodeSdk_Rpc_Telemetry_Battery]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeBatteryCallTestStub()
        
        for battery in batteryStates {
            fakeCall.outputs.append(createBatteryResponse(battery: battery))
        }
        fakeService.subscribeBatteryCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Battery.self)
        
        let _ = telemetry.batteryObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<Battery>>]()
        for battery in batteryStates {
            expectedEvents.append(next(0, translateRPCBattery(batteryRPC: battery)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func createBatteryResponse(battery: DronecodeSdk_Rpc_Telemetry_Battery) -> DronecodeSdk_Rpc_Telemetry_BatteryResponse {
        var response = DronecodeSdk_Rpc_Telemetry_BatteryResponse()
        response.battery = battery

        return response
    }

    func translateRPCBattery(batteryRPC: DronecodeSdk_Rpc_Telemetry_Battery) -> Battery {
        return Battery(remainingPercent: batteryRPC.remainingPercent, voltageV: batteryRPC.voltageV)
    }
    
     // MARK: - ATTITUDE EULER
    func testAttitudeEulerObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeAttitudeEulerCallTestStub()
        fakeService.subscribeAttitudeEulerCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(EulerAngle.self)
        
        let _ = telemetry.attitudeEulerObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }
    
    // One Event
    func testAttitudeEulerObservableReceivesOneEvent() {
        let attitudeEuler = createRPCAttitudeEuler(pitchDeg: 45.0, rollDeg: 35.0, yawDeg: 25.0)
        let attitudes = [attitudeEuler]
        
        checkAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }
    
    // Multiple Events
    func testAttitudeEulerObservableReceivesMultipleEvents() {
        var attitudes = [DronecodeSdk_Rpc_Telemetry_EulerAngle]()
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 12.0, rollDeg: 13.2, yawDeg: 24.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 13.0, rollDeg: 12.2, yawDeg: 34.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 14.0, rollDeg: 11.2, yawDeg: 44.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 15.0, rollDeg: 10.2, yawDeg: 54.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 16.0, rollDeg: 9.2, yawDeg: 64.1))
        
        checkAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }
    
    // Generic Methods
    func checkAttitudeEulerObservableReceivesEvents(attitudes: [DronecodeSdk_Rpc_Telemetry_EulerAngle]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeAttitudeEulerCallTestStub()
        
        for attitude in attitudes {
            fakeCall.outputs.append(createAttitudeEulerResponse(attitudeEuler: attitude))
        }
        fakeService.subscribeAttitudeEulerCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(EulerAngle.self)
        
        let _ = telemetry.attitudeEulerObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<EulerAngle>>]()
        for attitude in attitudes {
            expectedEvents.append(next(0, translateRPCAttitudeEuler(attitudeEulerRPC: attitude)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func createRPCAttitudeEuler(pitchDeg: Float, rollDeg: Float, yawDeg: Float) -> DronecodeSdk_Rpc_Telemetry_EulerAngle {
        var attitudeEuler = DronecodeSdk_Rpc_Telemetry_EulerAngle()
        attitudeEuler.pitchDeg = pitchDeg
        attitudeEuler.rollDeg = rollDeg
        attitudeEuler.yawDeg = yawDeg
        
        return attitudeEuler
    }
    
    func createAttitudeEulerResponse(attitudeEuler: DronecodeSdk_Rpc_Telemetry_EulerAngle) -> DronecodeSdk_Rpc_Telemetry_AttitudeEulerResponse {
        var response = DronecodeSdk_Rpc_Telemetry_AttitudeEulerResponse()
        response.attitudeEuler = attitudeEuler
        
        return response
    }
    
    func translateRPCAttitudeEuler(attitudeEulerRPC: DronecodeSdk_Rpc_Telemetry_EulerAngle) -> EulerAngle {
        return EulerAngle(pitchDeg: attitudeEulerRPC.pitchDeg, rollDeg: attitudeEulerRPC.rollDeg, yawDeg: attitudeEulerRPC.yawDeg)
    }
    
    // MARK: - ATTITUDE QUARTERNION
    func testAttitudeQuaternionObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeAttitudeQuaternionCallTestStub()
        fakeService.subscribeAttitudeQuaternionCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Quaternion.self)
        
        let _ = telemetry.attitudeQuaternionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testAttitudeQuaternionObservableReceivesOneEvent() {
        let attitudeQuaternion = createRPCAttitudeQuaternion(w: 45.0, x: 35.0, y: 25.0, z: 25.0)
        let attitudes = [attitudeQuaternion]
        
        checkAttitudeQuaternionObservableReceivesEvents(attitudes: attitudes)
    }

    func createRPCAttitudeQuaternion(w: Float, x: Float, y: Float, z: Float) -> DronecodeSdk_Rpc_Telemetry_Quaternion {
        var attitudeQuaternion = DronecodeSdk_Rpc_Telemetry_Quaternion()
        attitudeQuaternion.w = w
        attitudeQuaternion.x = x
        attitudeQuaternion.y = y
        attitudeQuaternion.z = z
        
        return attitudeQuaternion
    }

    func checkAttitudeQuaternionObservableReceivesEvents(attitudes: [DronecodeSdk_Rpc_Telemetry_Quaternion]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeAttitudeQuaternionCallTestStub()
        
        for attitude in attitudes {
            fakeCall.outputs.append(createAttitudeQuaternionResponse(attitudeQuaternion: attitude))
        }
        fakeService.subscribeAttitudeQuaternionCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Quaternion.self)
        
        let _ = telemetry.attitudeQuaternionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<Quaternion>>]()
        for attitude in attitudes {
            expectedEvents.append(next(0, translateRPCAttitudeQuaternion(attitudeQuaternionRPC: attitude)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testAttitudeQuaternionObservableReceivesMultipleEvents() {
        var attitudes = [DronecodeSdk_Rpc_Telemetry_Quaternion]()
        attitudes.append(createRPCAttitudeQuaternion(w: 12.0, x: 13.2, y: 24.1, z: 14.1))
        attitudes.append(createRPCAttitudeQuaternion(w: 13.0, x: 12.2, y: 34.1, z: 24.1))
        attitudes.append(createRPCAttitudeQuaternion(w: 14.0, x: 11.2, y: 44.1, z: 34.1))
        attitudes.append(createRPCAttitudeQuaternion(w: 15.0, x: 10.2, y: 54.1, z: 44.1))
        attitudes.append(createRPCAttitudeQuaternion(w: 16.0, x: 9.2, y: 64.1, z: 54.1))
        
        checkAttitudeQuaternionObservableReceivesEvents(attitudes: attitudes)
    }

    func createAttitudeQuaternionResponse(attitudeQuaternion: DronecodeSdk_Rpc_Telemetry_Quaternion) -> DronecodeSdk_Rpc_Telemetry_AttitudeQuaternionResponse {
        var response = DronecodeSdk_Rpc_Telemetry_AttitudeQuaternionResponse()
        response.attitudeQuaternion = attitudeQuaternion
        
        return response
    }

    func translateRPCAttitudeQuaternion(attitudeQuaternionRPC: DronecodeSdk_Rpc_Telemetry_Quaternion) -> Quaternion {
        return Quaternion(w: attitudeQuaternionRPC.w, x: attitudeQuaternionRPC.x, y: attitudeQuaternionRPC.y, z: attitudeQuaternionRPC.z)
    }

    // MARK: - CAMERA ATTITUDE QUATERNION
    func testCameraAttitudeQuaternionObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeCameraAttitudeQuaternionCallTestStub()
        fakeService.subscribeCameraAttitudeQuaternionCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Quaternion.self)
        
        let _ = telemetry.cameraAttitudeQuaternionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }
    
    func testCameraAttitudeQuaternionObservableReceivesOneEvent() {
        let attitudeQuaternion = createRPCCameraAttitudeQuaternion(w: 45.0, x: 35.0, y: 25.0, z: 14.0)
        let attitudes = [attitudeQuaternion]
        
        checkCameraAttitudeQuaternionObservableReceivesEvents(attitudes: attitudes)
    }
    
    func createRPCCameraAttitudeQuaternion(w: Float, x: Float, y: Float, z: Float) -> DronecodeSdk_Rpc_Telemetry_Quaternion {
        var attitudeQuaternion = DronecodeSdk_Rpc_Telemetry_Quaternion()
        attitudeQuaternion.w = w
        attitudeQuaternion.x = x
        attitudeQuaternion.y = y
        attitudeQuaternion.z = z
        return attitudeQuaternion
    }
    
    func checkCameraAttitudeQuaternionObservableReceivesEvents(attitudes: [DronecodeSdk_Rpc_Telemetry_Quaternion]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeCameraAttitudeQuaternionCallTestStub()
        
        for attitude in attitudes {
            fakeCall.outputs.append(createCameraAttitudeQuaternionResponse(attitudeQuaternion: attitude))
        }
        fakeService.subscribeCameraAttitudeQuaternionCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Quaternion.self)
        
        let _ = telemetry.cameraAttitudeQuaternionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<Quaternion>>]()
        for attitude in attitudes {
            expectedEvents.append(next(0, translateRPCAttitudeQuaternion(attitudeQuaternionRPC: attitude)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testCameraAttitudeQuaternionObservableReceivesMultipleEvents() {
        var attitudes = [DronecodeSdk_Rpc_Telemetry_Quaternion]()
        attitudes.append(createRPCAttitudeQuaternion(w: 12.0, x: 13.2, y: 24.1, z: 14.1))
        attitudes.append(createRPCAttitudeQuaternion(w: 13.0, x: 13.4, y: 34.1, z: 14.2))
        attitudes.append(createRPCAttitudeQuaternion(w: 14.0, x: 13.6, y: 44.1, z: 14.3))
        attitudes.append(createRPCAttitudeQuaternion(w: 15.0, x: 13.8, y: 54.1, z: 14.4))
        attitudes.append(createRPCAttitudeQuaternion(w: 16.0, x: 14.2, y: 64.1, z: 14.5))
        
        checkCameraAttitudeQuaternionObservableReceivesEvents(attitudes: attitudes)
    }
    
    func createCameraAttitudeQuaternionResponse(attitudeQuaternion: DronecodeSdk_Rpc_Telemetry_Quaternion) -> DronecodeSdk_Rpc_Telemetry_CameraAttitudeQuaternionResponse {
        var response = DronecodeSdk_Rpc_Telemetry_CameraAttitudeQuaternionResponse()
        response.attitudeQuaternion = attitudeQuaternion
        
        return response
    }
    
    // MARK: - HOME
    func testHomePositionObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeHomeCallTestStub()
        fakeService.subscribeHomeCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Position.self)

        let _ = telemetry.homePositionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testHomePositionObservableReceivesOneEvent() {
        let position = createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3);
        let positions = [position]

        checkHomePositionObservableReceivesEvents(positions: positions)
    }

    func checkHomePositionObservableReceivesEvents(positions: [DronecodeSdk_Rpc_Telemetry_Position]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeHomeCallTestStub()

        for position in positions {
            fakeCall.outputs.append(createHomeResponse(home: position))
        }
        fakeService.subscribeHomeCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Position.self)

        let _ = telemetry.homePositionObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<Position>>]()
        for position in positions {
            expectedEvents.append(next(0, translateRPCPosition(positionRPC: position)))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func createHomeResponse(home: DronecodeSdk_Rpc_Telemetry_Position) -> DronecodeSdk_Rpc_Telemetry_HomeResponse {
        var response = DronecodeSdk_Rpc_Telemetry_HomeResponse()
        response.home = home

        return response
    }

    func testHomePositionObservableReceivesMultipleEvents() {
        var positions = [DronecodeSdk_Rpc_Telemetry_Position]()
        positions.append(createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3));
        positions.append(createRPCPosition(latitudeDeg: 46.522626, longitudeDeg: 6.635356, absoluteAltitudeM: 542.2, relativeAltitudeM: 79.8));
        positions.append(createRPCPosition(latitudeDeg: -50.995944711358824, longitudeDeg: -72.99892046835936, absoluteAltitudeM: 1217.12, relativeAltitudeM: 2.52));

        checkHomePositionObservableReceivesEvents(positions: positions)
    }

    // MARK: - IN AIR
    func testInAirObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeInAirCallTestStub()
        fakeService.subscribeInAirCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)

        let _ = telemetry.inAirObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testInAirObservableReceivesOneEvent() {
        let inAirEvents = [false]

        checkInAirObservableReceivesEvents(inAirEvents: inAirEvents)
    }

    func checkInAirObservableReceivesEvents(inAirEvents: [Bool]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeInAirCallTestStub()

        for inAirEvent in inAirEvents {
            fakeCall.outputs.append(createInAirResponse(isInAir: inAirEvent))
        }
        fakeService.subscribeInAirCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)

        let _ = telemetry.inAirObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<Bool>>]()
        for inAirEvent in inAirEvents {
            expectedEvents.append(next(0, inAirEvent))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func createInAirResponse(isInAir: Bool) -> DronecodeSdk_Rpc_Telemetry_InAirResponse {
        var response = DronecodeSdk_Rpc_Telemetry_InAirResponse()
        response.isInAir = isInAir

        return response
    }

    func testInAirObservableReceivesMultipleEvents() {
        let inAirEvents = [false, true, true, false, false, true]

        checkInAirObservableReceivesEvents(inAirEvents: inAirEvents)
    }

    // MARK: - IS ARMED
    func testArmedObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeArmedCallTestStub()
        fakeService.subscribeArmedCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)

        let _ = telemetry.armedObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testArmedObservableReceivesOneEvent() {
        let armedEvents = [false]

        checkArmedObservableReceivesEvents(armedEvents: armedEvents)
    }

    func checkArmedObservableReceivesEvents(armedEvents: [Bool]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeArmedCallTestStub()

        for armedEvent in armedEvents {
            fakeCall.outputs.append(createArmedResponse(isArmed: armedEvent))
        }
        fakeService.subscribeArmedCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Bool.self)

        let _ = telemetry.armedObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<Bool>>]()
        for armedEvent in armedEvents {
            expectedEvents.append(next(0, armedEvent))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func createArmedResponse(isArmed: Bool) -> DronecodeSdk_Rpc_Telemetry_ArmedResponse {
        var response = DronecodeSdk_Rpc_Telemetry_ArmedResponse()
        response.isArmed = isArmed

        return response
    }

    func testArmedObservableReceivesMultipleEvents() {
        let armedEvents = [false, true, true, false, false, true]

        checkArmedObservableReceivesEvents(armedEvents: armedEvents)
    }

    // MARK: - GPSInfo
    func testGPSInfoObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeGPSInfoCallTestStub()
        fakeService.subscribeGPSInfoCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(GPSInfo.self)

        let _ = telemetry.GPSInfoObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testGPSInfoObservableReceivesOneEvent() {
        let gpsInfo = createRPCGPSInfo(numSatellites: 10, fixType: eDroneCoreGPSInfoFix.fix2D)
        let gpsInfoStates = [gpsInfo]

        checkGPSInfoObservableReceivesEvents(gpsInfoStates: gpsInfoStates)
    }

    func createRPCGPSInfo(numSatellites: Int32, fixType: eDroneCoreGPSInfoFix) -> DronecodeSdk_Rpc_Telemetry_GPSInfo {
        var gpsInfo = DronecodeSdk_Rpc_Telemetry_GPSInfo()
        gpsInfo.numSatellites = numSatellites
        gpsInfo.fixType = DronecodeSdk_Rpc_Telemetry_FixType(rawValue: fixType.rawValue)!

        return gpsInfo
    }

    func checkGPSInfoObservableReceivesEvents(gpsInfoStates: [DronecodeSdk_Rpc_Telemetry_GPSInfo]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeGPSInfoCallTestStub()

        for gpsInfo in gpsInfoStates {
            fakeCall.outputs.append(createGPSInfoResponse(gpsInfo: gpsInfo))
        }
        fakeService.subscribeGPSInfoCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(GPSInfo.self)

        let _ = telemetry.GPSInfoObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<GPSInfo>>]()
        for gpsInfo in gpsInfoStates {
            expectedEvents.append(next(0, translateRPCGPSInfo(gpsInfoRPC: gpsInfo)))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testGPSInfoObservableReceivesMultipleEvents() {
        var gpsInfoStates = [DronecodeSdk_Rpc_Telemetry_GPSInfo]()
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 6, fixType: eDroneCoreGPSInfoFix.noFix))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 7, fixType: eDroneCoreGPSInfoFix.noGps))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 9, fixType: eDroneCoreGPSInfoFix.fix2D))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 10, fixType: eDroneCoreGPSInfoFix.fix3D))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 12, fixType: eDroneCoreGPSInfoFix.fixDgps))

        checkGPSInfoObservableReceivesEvents(gpsInfoStates: gpsInfoStates)
    }

    func createGPSInfoResponse(gpsInfo: DronecodeSdk_Rpc_Telemetry_GPSInfo) -> DronecodeSdk_Rpc_Telemetry_GPSInfoResponse {
        var response = DronecodeSdk_Rpc_Telemetry_GPSInfoResponse()
        response.gpsInfo = gpsInfo

        return response
    }

    func translateRPCGPSInfo(gpsInfoRPC: DronecodeSdk_Rpc_Telemetry_GPSInfo) -> GPSInfo {
        return GPSInfo(numSatellites: gpsInfoRPC.numSatellites, fixType: eDroneCoreGPSInfoFix(rawValue: gpsInfoRPC.fixType.rawValue)!)
    }

    // MARK: - FLIGHT MODE
    func testFlightModeObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeFlightModeCallTestStub()
        fakeService.subscribeFlightModeCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(eDroneCoreFlightMode.self)

        let _ = telemetry.flightModeObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testFlightModeObservableReceivesOneEvent() {
        let flightModeEvents = [eDroneCoreFlightMode.ready]
        
        checkFlightModeObservableReceivesEvents(flightModeEvents: flightModeEvents)
    }

    func checkFlightModeObservableReceivesEvents(flightModeEvents: [eDroneCoreFlightMode]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeFlightModeCallTestStub()

        for flightModeEvent in flightModeEvents {
            fakeCall.outputs.append(createFlightModeResponse(flightMode: flightModeEvent))
        }
        fakeService.subscribeFlightModeCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(eDroneCoreFlightMode.self)

        let _ = telemetry.flightModeObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<eDroneCoreFlightMode>>]()
        for flightModeEvent in flightModeEvents {
            expectedEvents.append(next(0, flightModeEvent))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func createFlightModeResponse(flightMode: eDroneCoreFlightMode) -> DronecodeSdk_Rpc_Telemetry_FlightModeResponse {
        var response = DronecodeSdk_Rpc_Telemetry_FlightModeResponse()
        response.flightMode = DronecodeSdk_Rpc_Telemetry_FlightMode(rawValue: flightMode.rawValue)!

        return response
    }

    func testFlightModeObservableReceivesMultipleEvents() {
        let flightModeEvents = [eDroneCoreFlightMode.unknown, eDroneCoreFlightMode.ready, eDroneCoreFlightMode.takeoff, eDroneCoreFlightMode.hold, eDroneCoreFlightMode.mission, eDroneCoreFlightMode.returnToLaunch]

        checkFlightModeObservableReceivesEvents(flightModeEvents: flightModeEvents)
    }

    // MARK: - GroundSpeedNED
    func testGroundSpeedNEDObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeGroundSpeedNEDCallTestStub()
        fakeService.subscribeGroundSpeedNEDCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(GroundSpeedNED.self)

        let _ = telemetry.groundSpeedNEDObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testGroundSpeedNEDObservableReceivesOneEvent() {
        let speed = createRPCGroundSpeedNED(velocityNorthMS: 1.6, velocityEastMS: 1.6, velocityDownMS: 1.6)
        let speedStates = [speed]
        
        checkGroundSpeedNEDObservableReceivesEvents(speedStates: speedStates)
    }

    func createRPCGroundSpeedNED(velocityNorthMS: Float, velocityEastMS: Float, velocityDownMS: Float) -> DronecodeSdk_Rpc_Telemetry_SpeedNED {
        var speedNED = DronecodeSdk_Rpc_Telemetry_SpeedNED()
        speedNED.velocityNorthMS = velocityNorthMS
        speedNED.velocityEastMS = velocityEastMS
        speedNED.velocityDownMS = velocityDownMS
        return speedNED
    }

    func checkGroundSpeedNEDObservableReceivesEvents(speedStates: [DronecodeSdk_Rpc_Telemetry_SpeedNED]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeGroundSpeedNEDCallTestStub()

        for speed in speedStates {
            fakeCall.outputs.append(createGroundSpeedNEDResponse(speed: speed))
        }
        fakeService.subscribeGroundSpeedNEDCalls.append(fakeCall)

        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(GroundSpeedNED.self)

        let _ = telemetry.groundSpeedNEDObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<GroundSpeedNED>>]()
        for speed in speedStates {
            expectedEvents.append(next(0, translateRPCGroundSpeedNED(speedRPC: speed)))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testGroundSpeedNEDObservableReceivesMultipleEvents() {
        var speedStates = [DronecodeSdk_Rpc_Telemetry_SpeedNED]()
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 1.6, velocityEastMS: 1.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 2.7, velocityEastMS: 2.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 3.9, velocityEastMS: 3.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 10,  velocityEastMS: 4.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 12,  velocityEastMS: 5.6, velocityDownMS: 1.6 ))

        checkGroundSpeedNEDObservableReceivesEvents(speedStates: speedStates)
    }

    func createGroundSpeedNEDResponse(speed: DronecodeSdk_Rpc_Telemetry_SpeedNED) -> DronecodeSdk_Rpc_Telemetry_GroundSpeedNEDResponse {
        var response = DronecodeSdk_Rpc_Telemetry_GroundSpeedNEDResponse()
        response.groundSpeedNed = speed

        return response
    }

    func translateRPCGroundSpeedNED(speedRPC: DronecodeSdk_Rpc_Telemetry_SpeedNED) -> GroundSpeedNED {
        return GroundSpeedNED(velocityNorthMS: speedRPC.velocityNorthMS, velocityEastMS:speedRPC.velocityEastMS, velocityDownMS: speedRPC.velocityDownMS)
    }
    
    // MARK: - RCStatus
    func testRCStatusObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeRCStatusCallTestStub()
        fakeService.subscribeRCStatusCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(RCStatus.self)
        
        let _ = telemetry.rcStatusObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }
    
    func testRCStatusObservableReceivesOneEvent() {
        let rcstatus = createRPCRCStatus(wasAvailableOnce: false, isAvailable: true, signalStrengthPercent: 25.6)
        let rcStatusStates = [rcstatus]
        
        checkRCStatusObservableReceivesEvents(rcStatusStates: rcStatusStates)
    }
    
    func createRPCRCStatus(wasAvailableOnce: Bool, isAvailable: Bool, signalStrengthPercent: Float) -> DronecodeSdk_Rpc_Telemetry_RCStatus {
        var rcStatus = DronecodeSdk_Rpc_Telemetry_RCStatus()
        rcStatus.wasAvailableOnce = wasAvailableOnce
        rcStatus.isAvailable = isAvailable
        rcStatus.signalStrengthPercent = signalStrengthPercent
        return rcStatus
    }
    
    func checkRCStatusObservableReceivesEvents(rcStatusStates: [DronecodeSdk_Rpc_Telemetry_RCStatus]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeRCStatusCallTestStub()
        
        for rcStatus in rcStatusStates {
            fakeCall.outputs.append(createRCStatusResponse(rcStatus: rcStatus))
        }
        fakeService.subscribeRCStatusCalls.append(fakeCall)
        
        let telemetry = Telemetry(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(RCStatus.self)
        
        let _ = telemetry.rcStatusObservable.subscribe(observer)
        scheduler.start()
        observer.onCompleted()
        
        var expectedEvents = [Recorded<Event<RCStatus>>]()
        for rcStatus in rcStatusStates {
            expectedEvents.append(next(0, translateRPCRCStatus(rcStatusRPC: rcStatus)))
        }
        expectedEvents.append(completed(0))
        
        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }
    
    func testRCStatusObservableReceivesMultipleEvents() {
        var rcStatusStates = [DronecodeSdk_Rpc_Telemetry_RCStatus]()
        rcStatusStates.append(createRPCRCStatus(wasAvailableOnce: false, isAvailable: false, signalStrengthPercent: 50))
        rcStatusStates.append(createRPCRCStatus(wasAvailableOnce: false, isAvailable: true, signalStrengthPercent: 41))
        rcStatusStates.append(createRPCRCStatus(wasAvailableOnce: false, isAvailable: true, signalStrengthPercent: 32))
        rcStatusStates.append(createRPCRCStatus(wasAvailableOnce: true, isAvailable: false, signalStrengthPercent: 65))
        rcStatusStates.append(createRPCRCStatus(wasAvailableOnce: true, isAvailable: false, signalStrengthPercent: 78))
        checkRCStatusObservableReceivesEvents(rcStatusStates: rcStatusStates)
    }
    
    func createRCStatusResponse(rcStatus: DronecodeSdk_Rpc_Telemetry_RCStatus) -> DronecodeSdk_Rpc_Telemetry_RCStatusResponse {
        var response = DronecodeSdk_Rpc_Telemetry_RCStatusResponse()
        response.rcStatus = rcStatus
        
        return response
    }
    
    func translateRPCRCStatus(rcStatusRPC: DronecodeSdk_Rpc_Telemetry_RCStatus) -> RCStatus {
        return RCStatus(wasAvailableOnce: rcStatusRPC.wasAvailableOnce , isAvailable: rcStatusRPC.isAvailable, signalStrengthPercent: rcStatusRPC.signalStrengthPercent)
    }
}
