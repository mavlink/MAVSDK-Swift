import RxTest
import RxSwift
import XCTest
@testable import Dronecode_SDK_Swift

class TelemetryTest: XCTestCase {
    let scheduler = MainScheduler.instance
 
    // MARK: - Subscribe Position
    // No Event
    func testPositionObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribePositionCallTestStub()
        fakeService.subscribepositionCalls.append(fakeCall)

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
    
    // Multiple Events
    func testPositionObservableReceivesMultipleEvents() {
        var positions = [Dronecore_Rpc_Telemetry_Position]()
        positions.append(createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3));
        positions.append(createRPCPosition(latitudeDeg: 46.522626, longitudeDeg: 6.635356, absoluteAltitudeM: 542.2, relativeAltitudeM: 79.8));
        positions.append(createRPCPosition(latitudeDeg: -50.995944711358824, longitudeDeg: -72.99892046835936, absoluteAltitudeM: 1217.12, relativeAltitudeM: 2.52));
        
        checkPositionObservableReceivesEvents(positions: positions)
    }
    
    // Generic Methods
    func checkPositionObservableReceivesEvents(positions: [Dronecore_Rpc_Telemetry_Position]) {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribePositionCallTestStub()
        
        for position in positions {
            fakeCall.outputs.append(createPositionResponse(position: position))
        }
        fakeService.subscribepositionCalls.append(fakeCall)
        
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
    
    func createRPCPosition(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, relativeAltitudeM: Float) -> Dronecore_Rpc_Telemetry_Position {
        var position = Dronecore_Rpc_Telemetry_Position()
        position.latitudeDeg = latitudeDeg
        position.longitudeDeg = longitudeDeg
        position.absoluteAltitudeM = absoluteAltitudeM
        position.relativeAltitudeM = relativeAltitudeM

        return position
    }

    func createPositionResponse(position: Dronecore_Rpc_Telemetry_Position) -> Dronecore_Rpc_Telemetry_PositionResponse {
        var response = Dronecore_Rpc_Telemetry_PositionResponse()
        response.position = position

        return response
    }

    func translateRPCPosition(positionRPC: Dronecore_Rpc_Telemetry_Position) -> Position {
        return Position(latitudeDeg: positionRPC.latitudeDeg, longitudeDeg: positionRPC.longitudeDeg, absoluteAltitudeM: positionRPC.absoluteAltitudeM, relativeAltitudeM: positionRPC.relativeAltitudeM)
    }
    
    // MARK: - Subscribe Altitude Euler
    // No Event
    func testAttitudeEulerObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeAttitudeEulerCallTestStub()
        fakeService.subscribeattitudeeulerCalls.append(fakeCall)
        
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
        var attitudes = [Dronecore_Rpc_Telemetry_EulerAngle]()
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 12.0, rollDeg: 13.2, yawDeg: 24.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 13.0, rollDeg: 12.2, yawDeg: 34.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 14.0, rollDeg: 11.2, yawDeg: 44.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 15.0, rollDeg: 10.2, yawDeg: 54.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 16.0, rollDeg: 9.2, yawDeg: 64.1))
        
        checkAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }
    
    // Generic Methods
    func checkAttitudeEulerObservableReceivesEvents(attitudes: [Dronecore_Rpc_Telemetry_EulerAngle]) {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeAttitudeEulerCallTestStub()
        
        for attitude in attitudes {
            fakeCall.outputs.append(createAttitudeEulerResponse(attitudeEuler: attitude))
        }
        fakeService.subscribeattitudeeulerCalls.append(fakeCall)
        
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

    func createRPCAttitudeEuler(pitchDeg: Float, rollDeg: Float, yawDeg: Float) -> Dronecore_Rpc_Telemetry_EulerAngle {
        var attitudeEuler = Dronecore_Rpc_Telemetry_EulerAngle()
        attitudeEuler.pitchDeg = pitchDeg
        attitudeEuler.rollDeg = rollDeg
        attitudeEuler.yawDeg = yawDeg
        
        return attitudeEuler
    }
    
    func createAttitudeEulerResponse(attitudeEuler: Dronecore_Rpc_Telemetry_EulerAngle) -> Dronecore_Rpc_Telemetry_AttitudeEulerResponse {
        var response = Dronecore_Rpc_Telemetry_AttitudeEulerResponse()
        response.attitudeEuler = attitudeEuler
        
        return response
    }
    
    func translateRPCAttitudeEuler(attitudeEulerRPC: Dronecore_Rpc_Telemetry_EulerAngle) -> EulerAngle {
        return EulerAngle(pitchDeg: attitudeEulerRPC.pitchDeg, rollDeg: attitudeEulerRPC.rollDeg, yawDeg: attitudeEulerRPC.yawDeg)
    }
    
    // MARK: - Subscribe Camera Altitude Euler
    // No Event
    func testCameraAttitudeEulerObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeCameraAttitudeEulerCallTestStub()
        fakeService.subscribecameraattitudeeulerCalls.append(fakeCall)
        
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
        var attitudes = [Dronecore_Rpc_Telemetry_EulerAngle]()
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 12.0, rollDeg: 13.2, yawDeg: 24.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 13.0, rollDeg: 12.2, yawDeg: 34.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 14.0, rollDeg: 11.2, yawDeg: 44.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 15.0, rollDeg: 10.2, yawDeg: 54.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 16.0, rollDeg: 9.2, yawDeg: 64.1))
        
        checkCameraAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }
    
    // Generic Methods
    func checkCameraAttitudeEulerObservableReceivesEvents(attitudes: [Dronecore_Rpc_Telemetry_EulerAngle]) {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeCameraAttitudeEulerCallTestStub()
        
        for attitude in attitudes {
            fakeCall.outputs.append(createCameraAttitudeEulerResponse(attitudeEuler: attitude))
        }
        fakeService.subscribecameraattitudeeulerCalls.append(fakeCall)
        
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
    
    func createRPCCameraAttitudeEuler(pitchDeg: Float, rollDeg: Float, yawDeg: Float) -> Dronecore_Rpc_Telemetry_EulerAngle {
        var attitudeEuler = Dronecore_Rpc_Telemetry_EulerAngle()
        attitudeEuler.pitchDeg = pitchDeg
        attitudeEuler.rollDeg = rollDeg
        attitudeEuler.yawDeg = yawDeg
        
        return attitudeEuler
    }

    func createCameraAttitudeEulerResponse(attitudeEuler: Dronecore_Rpc_Telemetry_EulerAngle) -> Dronecore_Rpc_Telemetry_CameraAttitudeEulerResponse {
        var response = Dronecore_Rpc_Telemetry_CameraAttitudeEulerResponse()
        response.attitudeEuler = attitudeEuler
        
        return response
    }
    
    // MARK: - Subscribe Battery
    // No Event
    func testBatteryObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeBatteryCallTestStub()
        fakeService.subscribebatteryCalls.append(fakeCall)

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
        var batteryStates = [Dronecore_Rpc_Telemetry_Battery]()
        batteryStates.append(createRPCBattery(remainingPercent: 0.45, voltageV: 12.4))
        batteryStates.append(createRPCBattery(remainingPercent: 0.44, voltageV: 12.5))
        batteryStates.append(createRPCBattery(remainingPercent: 0.43, voltageV: 12.6))
        batteryStates.append(createRPCBattery(remainingPercent: 0.42, voltageV: 12.7))
        batteryStates.append(createRPCBattery(remainingPercent: 0.41, voltageV: 12.8))
        
        checkBatteryObservableReceivesEvents(batteryStates: batteryStates)
    }

    // Generic Methods
    func checkBatteryObservableReceivesEvents(batteryStates: [Dronecore_Rpc_Telemetry_Battery]) {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeBatteryCallTestStub()
        
        for battery in batteryStates {
            fakeCall.outputs.append(createBatteryResponse(battery: battery))
        }
        fakeService.subscribebatteryCalls.append(fakeCall)
        
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
    
    func createRPCBattery(remainingPercent: Float, voltageV: Float) -> Dronecore_Rpc_Telemetry_Battery {
        var battery = Dronecore_Rpc_Telemetry_Battery()
        battery.remainingPercent = remainingPercent
        battery.voltageV = voltageV
        
        return battery
    }

    func createBatteryResponse(battery: Dronecore_Rpc_Telemetry_Battery) -> Dronecore_Rpc_Telemetry_BatteryResponse {
        var response = Dronecore_Rpc_Telemetry_BatteryResponse()
        response.battery = battery

        return response
    }

    func translateRPCBattery(batteryRPC: Dronecore_Rpc_Telemetry_Battery) -> Battery {
        return Battery(remainingPercent: batteryRPC.remainingPercent, voltageV: batteryRPC.voltageV)
    }
    
    // MARK: - Subscribe Health
    // No Event
    func testHealthObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeHealthCallTestStub()
        fakeService.subscribehealthCalls.append(fakeCall)
        
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
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeHealthCallTestStub()
        
        var healths = [Dronecore_Rpc_Telemetry_Health]()
        for _ in 1...nbEvents {
            healths.append(createRandomRPCHealth())
        }
        
        for health in healths {
            fakeCall.outputs.append(createHealthResponse(health: health))
        }
        fakeService.subscribehealthCalls.append(fakeCall)
        
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
    
    func createHealthResponse(health: Dronecore_Rpc_Telemetry_Health) -> Dronecore_Rpc_Telemetry_HealthResponse {
        var response = Dronecore_Rpc_Telemetry_HealthResponse()
        response.health = health
        
        return response
    }
    
    func translateRPCHealth(healthRPC: Dronecore_Rpc_Telemetry_Health) -> Health {
        return Health(isGyrometerCalibrationOk: healthRPC.isGyrometerCalibrationOk, isAccelerometerCalibrationOk: healthRPC.isAccelerometerCalibrationOk, isMagnetometerCalibrationOk: healthRPC.isMagnetometerCalibrationOk, isLevelCalibrationOk: healthRPC.isLevelCalibrationOk, isLocalPositionOk: healthRPC.isLocalPositionOk, isGlobalPositionOk: healthRPC.isGlobalPositionOk, isHomePositionOk: healthRPC.isHomePositionOk)
    }
    
    func generateRandomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func createRandomRPCHealth() -> Dronecore_Rpc_Telemetry_Health {
        var health = Dronecore_Rpc_Telemetry_Health()
        
        health.isGyrometerCalibrationOk = generateRandomBool()
        health.isAccelerometerCalibrationOk = generateRandomBool()
        health.isMagnetometerCalibrationOk = generateRandomBool()
        health.isLevelCalibrationOk = generateRandomBool()
        health.isLocalPositionOk = generateRandomBool()
        health.isGlobalPositionOk = generateRandomBool()
        health.isHomePositionOk = generateRandomBool()
        
        return health
    }
}
