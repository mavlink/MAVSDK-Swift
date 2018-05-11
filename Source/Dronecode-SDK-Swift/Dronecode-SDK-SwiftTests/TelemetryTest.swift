import RxTest
import RxSwift
import XCTest
@testable import Dronecode_SDK_Swift

class TelemetryTest: XCTestCase {
    let scheduler = MainScheduler.instance

    // MARK: - POSITION
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

    func testPositionObservableReceivesOneEvent() {
        let position = createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3);
        let positions = [position]

        checkPositionObservableReceivesEvents(positions: positions)
    }

    func createRPCPosition(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, relativeAltitudeM: Float) -> Dronecore_Rpc_Telemetry_Position {
        var position = Dronecore_Rpc_Telemetry_Position()
        position.latitudeDeg = latitudeDeg
        position.longitudeDeg = longitudeDeg
        position.absoluteAltitudeM = absoluteAltitudeM
        position.relativeAltitudeM = relativeAltitudeM

        return position
    }

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

    func createPositionResponse(position: Dronecore_Rpc_Telemetry_Position) -> Dronecore_Rpc_Telemetry_PositionResponse {
        var response = Dronecore_Rpc_Telemetry_PositionResponse()
        response.position = position

        return response
    }

    func translateRPCPosition(positionRPC: Dronecore_Rpc_Telemetry_Position) -> Position {
        return Position(latitudeDeg: positionRPC.latitudeDeg, longitudeDeg: positionRPC.longitudeDeg, absoluteAltitudeM: positionRPC.absoluteAltitudeM, relativeAltitudeM: positionRPC.relativeAltitudeM)
    }

    func testPositionObservableReceivesMultipleEvents() {
        var positions = [Dronecore_Rpc_Telemetry_Position]()
        positions.append(createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3));
        positions.append(createRPCPosition(latitudeDeg: 46.522626, longitudeDeg: 6.635356, absoluteAltitudeM: 542.2, relativeAltitudeM: 79.8));
        positions.append(createRPCPosition(latitudeDeg: -50.995944711358824, longitudeDeg: -72.99892046835936, absoluteAltitudeM: 1217.12, relativeAltitudeM: 2.52));

        checkPositionObservableReceivesEvents(positions: positions)
    }

    // MARK: - HEALTH
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

    func testHealthObservableReceivesOneEvent() {
        checkHealthObservableReceivesEvents(nbEvents: 1)
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

    func generateRandomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }

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

    func testHealthObservableReceivesMultipleEvents() {
        checkHealthObservableReceivesEvents(nbEvents: 10)
    }

    // MARK: - BATTERY
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

    func testBatteryObservableReceivesOneEvent() {
        let battery = createRPCBattery(remainingPercent: 0.55, voltageV: 12.5)
        let batteryStates = [battery]

        checkBatteryObservableReceivesEvents(batteryStates: batteryStates)
    }

    func createRPCBattery(remainingPercent: Float, voltageV: Float) -> Dronecore_Rpc_Telemetry_Battery {
        var battery = Dronecore_Rpc_Telemetry_Battery()
        battery.remainingPercent = remainingPercent
        battery.voltageV = voltageV

        return battery
    }

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

    func testBatteryObservableReceivesMultipleEvents() {
        var batteryStates = [Dronecore_Rpc_Telemetry_Battery]()
        batteryStates.append(createRPCBattery(remainingPercent: 0.45, voltageV: 12.4))
        batteryStates.append(createRPCBattery(remainingPercent: 0.44, voltageV: 12.5))
        batteryStates.append(createRPCBattery(remainingPercent: 0.43, voltageV: 12.6))
        batteryStates.append(createRPCBattery(remainingPercent: 0.42, voltageV: 12.7))
        batteryStates.append(createRPCBattery(remainingPercent: 0.41, voltageV: 12.8))

        checkBatteryObservableReceivesEvents(batteryStates: batteryStates)
    }

    func createBatteryResponse(battery: Dronecore_Rpc_Telemetry_Battery) -> Dronecore_Rpc_Telemetry_BatteryResponse {
        var response = Dronecore_Rpc_Telemetry_BatteryResponse()
        response.battery = battery

        return response
    }

    func translateRPCBattery(batteryRPC: Dronecore_Rpc_Telemetry_Battery) -> Battery {
        return Battery(remainingPercent: batteryRPC.remainingPercent, voltageV: batteryRPC.voltageV)
    }
    
     // MARK: - ATTITUDE EULER
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

    func testAttitudeEulerObservableReceivesOneEvent() {
        let attitudeEuler = createRPCAttitudeEuler(pitchDeg: 45.0, rollDeg: 35.0, yawDeg: 25.0)
        let attitudes = [attitudeEuler]

        checkAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }

    func createRPCAttitudeEuler(pitchDeg: Float, rollDeg: Float, yawDeg: Float) -> Dronecore_Rpc_Telemetry_EulerAngle {
        var attitudeEuler = Dronecore_Rpc_Telemetry_EulerAngle()
        attitudeEuler.pitchDeg = pitchDeg
        attitudeEuler.rollDeg = rollDeg
        attitudeEuler.yawDeg = yawDeg

        return attitudeEuler
    }

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

    func testAttitudeEulerObservableReceivesMultipleEvents() {
        var attitudes = [Dronecore_Rpc_Telemetry_EulerAngle]()
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 12.0, rollDeg: 13.2, yawDeg: 24.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 13.0, rollDeg: 12.2, yawDeg: 34.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 14.0, rollDeg: 11.2, yawDeg: 44.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 15.0, rollDeg: 10.2, yawDeg: 54.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 16.0, rollDeg: 9.2, yawDeg: 64.1))

        checkAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }

    func createAttitudeEulerResponse(attitudeEuler: Dronecore_Rpc_Telemetry_EulerAngle) -> Dronecore_Rpc_Telemetry_AttitudeEulerResponse {
        var response = Dronecore_Rpc_Telemetry_AttitudeEulerResponse()
        response.attitudeEuler = attitudeEuler

        return response
    }

    func translateRPCAttitudeEuler(attitudeEulerRPC: Dronecore_Rpc_Telemetry_EulerAngle) -> EulerAngle {
        return EulerAngle(pitchDeg: attitudeEulerRPC.pitchDeg, rollDeg: attitudeEulerRPC.rollDeg, yawDeg: attitudeEulerRPC.yawDeg)
    }

    // MARK: - CAMERA ATTITUDE EULER
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
    
    func testCameraAttitudeEulerObservableReceivesOneEvent() {
        let attitudeEuler = createRPCCameraAttitudeEuler(pitchDeg: 45.0, rollDeg: 35.0, yawDeg: 25.0)
        let attitudes = [attitudeEuler]

        checkCameraAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }

    func createRPCCameraAttitudeEuler(pitchDeg: Float, rollDeg: Float, yawDeg: Float) -> Dronecore_Rpc_Telemetry_EulerAngle {
        var attitudeEuler = Dronecore_Rpc_Telemetry_EulerAngle()
        attitudeEuler.pitchDeg = pitchDeg
        attitudeEuler.rollDeg = rollDeg
        attitudeEuler.yawDeg = yawDeg

        return attitudeEuler
    }

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

    func testCameraAttitudeEulerObservableReceivesMultipleEvents() {
        var attitudes = [Dronecore_Rpc_Telemetry_EulerAngle]()
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 12.0, rollDeg: 13.2, yawDeg: 24.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 13.0, rollDeg: 12.2, yawDeg: 34.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 14.0, rollDeg: 11.2, yawDeg: 44.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 15.0, rollDeg: 10.2, yawDeg: 54.1))
        attitudes.append(createRPCAttitudeEuler(pitchDeg: 16.0, rollDeg: 9.2, yawDeg: 64.1))

        checkCameraAttitudeEulerObservableReceivesEvents(attitudes: attitudes)
    }

    func createCameraAttitudeEulerResponse(attitudeEuler: Dronecore_Rpc_Telemetry_EulerAngle) -> Dronecore_Rpc_Telemetry_CameraAttitudeEulerResponse {
        var response = Dronecore_Rpc_Telemetry_CameraAttitudeEulerResponse()
        response.attitudeEuler = attitudeEuler

        return response
    }

    // MARK: - HOME
    func testHomePositionObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeHomeCallTestStub()
        fakeService.subscribehomeCalls.append(fakeCall)

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

    func checkHomePositionObservableReceivesEvents(positions: [Dronecore_Rpc_Telemetry_Position]) {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeHomeCallTestStub()

        for position in positions {
            fakeCall.outputs.append(createHomeResponse(home: position))
        }
        fakeService.subscribehomeCalls.append(fakeCall)

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

    func createHomeResponse(home: Dronecore_Rpc_Telemetry_Position) -> Dronecore_Rpc_Telemetry_HomeResponse {
        var response = Dronecore_Rpc_Telemetry_HomeResponse()
        response.home = home

        return response
    }

    func testHomePositionObservableReceivesMultipleEvents() {
        var positions = [Dronecore_Rpc_Telemetry_Position]()
        positions.append(createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3));
        positions.append(createRPCPosition(latitudeDeg: 46.522626, longitudeDeg: 6.635356, absoluteAltitudeM: 542.2, relativeAltitudeM: 79.8));
        positions.append(createRPCPosition(latitudeDeg: -50.995944711358824, longitudeDeg: -72.99892046835936, absoluteAltitudeM: 1217.12, relativeAltitudeM: 2.52));

        checkHomePositionObservableReceivesEvents(positions: positions)
    }

    // MARK: - IN AIR
    func testInAirObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeInAirCallTestStub()
        fakeService.subscribeinairCalls.append(fakeCall)

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
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeInAirCallTestStub()

        for inAirEvent in inAirEvents {
            fakeCall.outputs.append(createInAirResponse(isInAir: inAirEvent))
        }
        fakeService.subscribeinairCalls.append(fakeCall)

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

    func createInAirResponse(isInAir: Bool) -> Dronecore_Rpc_Telemetry_InAirResponse {
        var response = Dronecore_Rpc_Telemetry_InAirResponse()
        response.isInAir = isInAir

        return response
    }

    func testInAirObservableReceivesMultipleEvents() {
        let inAirEvents = [false, true, true, false, false, true]

        checkInAirObservableReceivesEvents(inAirEvents: inAirEvents)
    }

    // MARK: - IS ARMED
    func testArmedObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeArmedCallTestStub()
        fakeService.subscribearmedCalls.append(fakeCall)

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
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeArmedCallTestStub()

        for armedEvent in armedEvents {
            fakeCall.outputs.append(createArmedResponse(isArmed: armedEvent))
        }
        fakeService.subscribearmedCalls.append(fakeCall)

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

    func createArmedResponse(isArmed: Bool) -> Dronecore_Rpc_Telemetry_ArmedResponse {
        var response = Dronecore_Rpc_Telemetry_ArmedResponse()
        response.isArmed = isArmed

        return response
    }

    func testArmedObservableReceivesMultipleEvents() {
        let armedEvents = [false, true, true, false, false, true]

        checkArmedObservableReceivesEvents(armedEvents: armedEvents)
    }

    // MARK: - GPSInfo
    func testGPSInfoObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeGPSInfoCallTestStub()
        fakeService.subscribegpsinfoCalls.append(fakeCall)

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

    func createRPCGPSInfo(numSatellites: Int32, fixType: eDroneCoreGPSInfoFix) -> Dronecore_Rpc_Telemetry_GPSInfo {
        var gpsInfo = Dronecore_Rpc_Telemetry_GPSInfo()
        gpsInfo.numSatellites = numSatellites
        gpsInfo.fixType = Dronecore_Rpc_Telemetry_FixType(rawValue: fixType.rawValue)!

        return gpsInfo
    }

    func checkGPSInfoObservableReceivesEvents(gpsInfoStates: [Dronecore_Rpc_Telemetry_GPSInfo]) {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeGPSInfoCallTestStub()

        for gpsInfo in gpsInfoStates {
            fakeCall.outputs.append(createGPSInfoResponse(gpsInfo: gpsInfo))
        }
        fakeService.subscribegpsinfoCalls.append(fakeCall)

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
        var gpsInfoStates = [Dronecore_Rpc_Telemetry_GPSInfo]()
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 6, fixType: eDroneCoreGPSInfoFix.noFix))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 7, fixType: eDroneCoreGPSInfoFix.noGps))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 9, fixType: eDroneCoreGPSInfoFix.fix2D))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 10, fixType: eDroneCoreGPSInfoFix.fix3D))
        gpsInfoStates.append(createRPCGPSInfo(numSatellites: 12, fixType: eDroneCoreGPSInfoFix.fixDgps))

        checkGPSInfoObservableReceivesEvents(gpsInfoStates: gpsInfoStates)
    }

    func createGPSInfoResponse(gpsInfo: Dronecore_Rpc_Telemetry_GPSInfo) -> Dronecore_Rpc_Telemetry_GPSInfoResponse {
        var response = Dronecore_Rpc_Telemetry_GPSInfoResponse()
        response.gpsInfo = gpsInfo

        return response
    }

    func translateRPCGPSInfo(gpsInfoRPC: Dronecore_Rpc_Telemetry_GPSInfo) -> GPSInfo {
        return GPSInfo(numSatellites: gpsInfoRPC.numSatellites, fixType: eDroneCoreGPSInfoFix(rawValue: gpsInfoRPC.fixType.rawValue)!)
    }
    
    // MARK: - FLIGHT MODE
    func testFlightModeObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeFlightModeCallTestStub()
        fakeService.subscribeflightmodeCalls.append(fakeCall)
        
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
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeFlightModeCallTestStub()
        
        for flightModeEvent in flightModeEvents {
            fakeCall.outputs.append(createFlightModeResponse(flightMode: flightModeEvent))
        }
        fakeService.subscribeflightmodeCalls.append(fakeCall)
        
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
    
    func createFlightModeResponse(flightMode: eDroneCoreFlightMode) -> Dronecore_Rpc_Telemetry_FlightModeResponse {
        var response = Dronecore_Rpc_Telemetry_FlightModeResponse()
        response.flightMode = Dronecore_Rpc_Telemetry_FlightMode(rawValue: flightMode.rawValue)!
        
        return response
    }
    func testFlightModeObservableReceivesMultipleEvents() {
        let flightModeEvents = [eDroneCoreFlightMode.unknown, eDroneCoreFlightMode.ready, eDroneCoreFlightMode.takeoff, eDroneCoreFlightMode.hold, eDroneCoreFlightMode.mission, eDroneCoreFlightMode.returnToLaunch]
        
        checkFlightModeObservableReceivesEvents(flightModeEvents: flightModeEvents)
    }
    
    
    // MARK: - GroundSpeedNED
    func testGroundSpeedNEDObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeGroundSpeedNEDCallTestStub()
        fakeService.subscribegroundspeednedCalls.append(fakeCall)
        
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
    
    
    func createRPCGroundSpeedNED(velocityNorthMS: Float, velocityEastMS: Float, velocityDownMS: Float) -> Dronecore_Rpc_Telemetry_SpeedNED {
        var speedNED = Dronecore_Rpc_Telemetry_SpeedNED()
        speedNED.velocityNorthMS = velocityNorthMS
        speedNED.velocityEastMS = velocityEastMS
        speedNED.velocityDownMS = velocityDownMS
        return speedNED
    }
    
    func checkGroundSpeedNEDObservableReceivesEvents(speedStates: [Dronecore_Rpc_Telemetry_SpeedNED]) {
        let fakeService = Dronecore_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Telemetry_TelemetryServiceSubscribeGroundSpeedNEDCallTestStub()
        
        for speed in speedStates {
            fakeCall.outputs.append(createGroundSpeedNEDResponse(speed: speed))
        }
        fakeService.subscribegroundspeednedCalls.append(fakeCall)
        
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
        var speedStates = [Dronecore_Rpc_Telemetry_SpeedNED]()
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 1.6, velocityEastMS: 1.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 2.7, velocityEastMS: 2.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 3.9, velocityEastMS: 3.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 10,  velocityEastMS: 4.6, velocityDownMS: 1.6 ))
        speedStates.append(createRPCGroundSpeedNED(velocityNorthMS: 12,  velocityEastMS: 5.6, velocityDownMS: 1.6 ))
        
        checkGroundSpeedNEDObservableReceivesEvents(speedStates: speedStates)
    }
    
    func createGroundSpeedNEDResponse(speed: Dronecore_Rpc_Telemetry_SpeedNED) -> Dronecore_Rpc_Telemetry_GroundSpeedNEDResponse {
        var response = Dronecore_Rpc_Telemetry_GroundSpeedNEDResponse()
        response.groundSpeedNed = speed
        
        return response
    }
    
    func translateRPCGroundSpeedNED(speedRPC: Dronecore_Rpc_Telemetry_SpeedNED) -> GroundSpeedNED {
        return GroundSpeedNED(velocityNorthMS: speedRPC.velocityNorthMS, velocityEastMS:speedRPC.velocityEastMS, velocityDownMS: speedRPC.velocityDownMS)
    }

}
