import RxTest
import RxSwift
import RxBlocking
import XCTest
@testable import Dronecode_SDK_Swift

class TelemetryTest: XCTestCase {

    func testPositionObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribePositionCallTestStub()
        fakeService.subscribePositionCalls.append(fakeCall)
        fakeService.subscribePositionCalls.append(fakeCall)
        fakeService.subscribePositionCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let telemetry = Telemetry(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Telemetry.Position.self)

        let _ = telemetry.position.subscribe(observer)
        scheduler.start()

        XCTAssertEqual(0, observer.events.count)
    }

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

    func checkPositionObservableReceivesEvents(positions: [DronecodeSdk_Rpc_Telemetry_Position]) {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribePositionCallTestStub()

        fakeCall.outputs.append(contentsOf: positions.map{ position in createPositionResponse(position: position) })
        fakeService.subscribePositionCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Telemetry.Position.self)
        let telemetry = Telemetry(service: fakeService, scheduler: scheduler)

        let _ = telemetry.position.subscribe(observer)
        scheduler.start()

        let expectedEvents = positions.map{ position in next(1, Telemetry.Position.translateFromRpc(position)) }

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
            observed.value == expected.value
        }))
    }
    
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

    func testHealthObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Telemetry_TelemetryServiceSubscribeHealthCallTestStub()
        fakeService.subscribeHealthCalls.append(fakeCall)
        
        let scheduler = TestScheduler(initialClock: 0)
        let telemetry = Telemetry(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Telemetry.Health.self)
        
        let _ = telemetry.health.subscribe(observer)
        scheduler.start()

        XCTAssertEqual(0, observer.events.count)
    }
    
    func testHealthObservableReceivesOneEvent() {
        checkHealthObservableReceivesEvents(nbEvents: 1)
    }
    
    func testHealthObservableReceivesMultipleEvents() {
        checkHealthObservableReceivesEvents(nbEvents: 10)
    }
    
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
        
        let scheduler = TestScheduler(initialClock: 0)
        let telemetry = Telemetry(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Telemetry.Health.self)
        
        let _ = telemetry.health.subscribe(observer)
        scheduler.start()

        var expectedEvents = [Recorded<Event<Telemetry.Health>>]()
        for health in healths {
            expectedEvents.append(next(0, Telemetry.Health.translateFromRpc(health)))
        }

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
            observed.value == expected.value
        }))
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
}
