import RxTest
import RxSwift
import RxBlocking
import XCTest
@testable import Mavsdk

import NIO
import GRPC

class TelemetryTest: XCTestCase {

  // MARK: Subject under test

  var sut: Telemetry!
  var eventLoopGroup: MultiThreadedEventLoopGroup!
  var service: Mavsdk_Rpc_Telemetry_TelemetryServiceClient!
  var scheduler: TestScheduler!


  // MARK: Test lifecycle

  override func setUpWithError() throws {
    try super.setUpWithError()
    self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    let configuration = ClientConnection.Configuration(
      target: .hostAndPort("0.0.0.0", 0),
      eventLoopGroup: self.eventLoopGroup
    )

    let channel = ClientConnection(configuration: configuration)
    self.service = Mavsdk_Rpc_Telemetry_TelemetryServiceClient(channel: channel)
    self.scheduler = TestScheduler(initialClock: 0)
    self.sut = Telemetry(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
  }

  override func tearDownWithError() throws {
    self.sut = nil
    try self.eventLoopGroup.syncShutdownGracefully()
    try super.tearDownWithError()
  }

  // MARK: Test doubles

  // MARK: Method call expectations

  // MARK: Spied methods

  // MARK: Tests

  func testPositionObservableEmitsNothingWhenNoEvent() {
    // Given
    let observer = scheduler.createObserver(Telemetry.Position.self)
    _ = sut.position.subscribe(observer)

    // When
    scheduler.start()

    // Then
    XCTAssertEqual(0, observer.events.count)
  }

//  func testPositionObservableReceivesOneEvent() {
//    let position = createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3);
//    let positions = [position]
//
//    checkPositionObservableReceivesEvents(positions: positions)
//  }
//
//  func createRPCPosition(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, relativeAltitudeM: Float) -> Mavsdk_Rpc_Telemetry_Position {
//    var position = Mavsdk_Rpc_Telemetry_Position()
//    position.latitudeDeg = latitudeDeg
//    position.longitudeDeg = longitudeDeg
//    position.absoluteAltitudeM = absoluteAltitudeM
//    position.relativeAltitudeM = relativeAltitudeM
//
//    return position
//  }
//
//  func checkPositionObservableReceivesEvents(positions: [Mavsdk_Rpc_Telemetry_Position]) {
//    let fakeService = Mavsdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
//    let fakeCall = Mavsdk_Rpc_Telemetry_TelemetryServiceSubscribePositionCallTestStub()
//
//    fakeCall.outputs.append(contentsOf: positions.map{ position in createPositionResponse(position: position) })
//    fakeService.subscribePositionCalls.append(fakeCall)
//
//    let scheduler = TestScheduler(initialClock: 0)
//    let observer = scheduler.createObserver(Telemetry.Position.self)
//    let telemetry = Telemetry(service: fakeService, scheduler: scheduler)
//
//    let _ = telemetry.position.subscribe(observer)
//    scheduler.start()
//
//    let expectedEvents = positions.map{ position in next(1, Telemetry.Position.translateFromRpc(position)) }
//
//    XCTAssertEqual(expectedEvents.count, observer.events.count)
//    XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
//      observed.value == expected.value
//    }))
//  }
//
//  func testPositionObservableReceivesMultipleEvents() {
//    var positions = [Mavsdk_Rpc_Telemetry_Position]()
//    positions.append(createRPCPosition(latitudeDeg: 41.848695, longitudeDeg: 75.132751, absoluteAltitudeM: 3002.1, relativeAltitudeM: 50.3));
//    positions.append(createRPCPosition(latitudeDeg: 46.522626, longitudeDeg: 6.635356, absoluteAltitudeM: 542.2, relativeAltitudeM: 79.8));
//    positions.append(createRPCPosition(latitudeDeg: -50.995944711358824, longitudeDeg: -72.99892046835936, absoluteAltitudeM: 1217.12, relativeAltitudeM: 2.52));
//
//    checkPositionObservableReceivesEvents(positions: positions)
//  }
//
//  func createPositionResponse(position: Mavsdk_Rpc_Telemetry_Position) -> Mavsdk_Rpc_Telemetry_PositionResponse {
//    var response = Mavsdk_Rpc_Telemetry_PositionResponse()
//    response.position = position
//
//    return response
//  }
//
//  func testHealthObservableEmitsNothingWhenNoEvent() {
//    let fakeService = Mavsdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
//    let fakeCall = Mavsdk_Rpc_Telemetry_TelemetryServiceSubscribeHealthCallTestStub()
//    fakeService.subscribeHealthCalls.append(fakeCall)
//
//    let scheduler = TestScheduler(initialClock: 0)
//    let telemetry = Telemetry(service: fakeService, scheduler: scheduler)
//    let observer = scheduler.createObserver(Telemetry.Health.self)
//
//    let _ = telemetry.health.subscribe(observer)
//    scheduler.start()
//
//    XCTAssertEqual(0, observer.events.count)
//  }
//
//  func testHealthObservableReceivesOneEvent() {
//    checkHealthObservableReceivesEvents(nbEvents: 1)
//  }
//
//  func testHealthObservableReceivesMultipleEvents() {
//    checkHealthObservableReceivesEvents(nbEvents: 10)
//  }
//
//  func checkHealthObservableReceivesEvents(nbEvents: UInt) {
//    let fakeService = Mavsdk_Rpc_Telemetry_TelemetryServiceServiceTestStub()
//    let fakeCall = Mavsdk_Rpc_Telemetry_TelemetryServiceSubscribeHealthCallTestStub()
//
//    var healths = [Mavsdk_Rpc_Telemetry_Health]()
//    for _ in 1...nbEvents {
//      healths.append(createRandomRPCHealth())
//    }
//
//    for health in healths {
//      fakeCall.outputs.append(createHealthResponse(health: health))
//    }
//    fakeService.subscribeHealthCalls.append(fakeCall)
//
//    let scheduler = TestScheduler(initialClock: 0)
//    let telemetry = Telemetry(service: fakeService, scheduler: scheduler)
//    let observer = scheduler.createObserver(Telemetry.Health.self)
//
//    let _ = telemetry.health.subscribe(observer)
//    scheduler.start()
//
//    var expectedEvents = [Recorded<Event<Telemetry.Health>>]()
//    for health in healths {
//      expectedEvents.append(next(0, Telemetry.Health.translateFromRpc(health)))
//    }
//
//    XCTAssertEqual(expectedEvents.count, observer.events.count)
//    XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
//      observed.value == expected.value
//    }))
//  }
//
//  func createHealthResponse(health: Mavsdk_Rpc_Telemetry_Health) -> Mavsdk_Rpc_Telemetry_HealthResponse {
//    var response = Mavsdk_Rpc_Telemetry_HealthResponse()
//    response.health = health
//
//    return response
//  }
//
//  func generateRandomBool() -> Bool {
//    return arc4random_uniform(2) == 0
//  }
//
//  func createRandomRPCHealth() -> Mavsdk_Rpc_Telemetry_Health {
//    var health = Mavsdk_Rpc_Telemetry_Health()
//
//    health.isGyrometerCalibrationOk = generateRandomBool()
//    health.isAccelerometerCalibrationOk = generateRandomBool()
//    health.isMagnetometerCalibrationOk = generateRandomBool()
//    health.isLevelCalibrationOk = generateRandomBool()
//    health.isLocalPositionOk = generateRandomBool()
//    health.isGlobalPositionOk = generateRandomBool()
//    health.isHomePositionOk = generateRandomBool()
//
//    return health
//  }
}
