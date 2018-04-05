import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CoreTest: XCTestCase {
    let ARBITRARY_UUID: UInt64 = 42

    func testDiscoverObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()
        fakeService.subscribediscoverCalls.append(fakeCall)

        let client = Core(service: fakeService)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.getDiscoverObservable().subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testDiscoverObservableReceivesOneEvent() {
        let fakeService = Dronecore_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()

        let expectedUUID = ARBITRARY_UUID
        fakeCall.outputs = [createDiscoverResponse(uuid: expectedUUID)]
        fakeService.subscribediscoverCalls.append(fakeCall)

        let client = Core(service: fakeService)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.getDiscoverObservable().subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        let expectedEvents = [
            next(0, expectedUUID),
            completed(0)
        ]

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func createDiscoverResponse(uuid: UInt64) -> Dronecore_Rpc_Core_DiscoverResponse {
        var response = Dronecore_Rpc_Core_DiscoverResponse()
        response.uuid = uuid

        return response
    }

    func testDiscoverObservableReceivesMultipleEvents() {
        let fakeService = Dronecore_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()

        fakeCall.outputs = []
        let expectedUUIDs = [4433522, 7654454, 1234567]
        for expectedUUID in expectedUUIDs {
            fakeCall.outputs.append(createDiscoverResponse(uuid: UInt64(expectedUUID)))
        }
        fakeService.subscribediscoverCalls.append(fakeCall)

        let client = Core(service: fakeService)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.getDiscoverObservable().subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<UInt64>>]()
        for expectedUUID in expectedUUIDs {
            expectedEvents.append(next(0, UInt64(expectedUUID)))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
    }

    func testTimeoutObservableEmitsNothingWhenNoEvent() {
        let fakeService = Dronecore_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Core_CoreServiceSubscribeTimeoutCallTestStub()
        fakeService.subscribetimeoutCalls.append(fakeCall)

        let client = Core(service: fakeService)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)

        let _ = client.getTimeoutObservable().subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count)
    }

    func testTimeoutObservableReceivesOneEvent() {
        checkTimeoutObservableReceivesEvents(nbEvents: 1)
    }

    func checkTimeoutObservableReceivesEvents(nbEvents: Int) {
        let fakeService = Dronecore_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Dronecore_Rpc_Core_CoreServiceSubscribeTimeoutCallTestStub()

        fakeCall.outputs = []
        for _ in 1...nbEvents {
            fakeCall.outputs.append(Dronecore_Rpc_Core_TimeoutResponse())
        }
        fakeService.subscribetimeoutCalls.append(fakeCall)

        let client = Core(service: fakeService)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)

        let _ = client.getTimeoutObservable().subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(nbEvents + 1, observer.events.count) // "completed" is one event
    }

    func testTimeoutObservableReceivesMultipleEvents() {
        checkTimeoutObservableReceivesEvents(nbEvents: 5)
    }
}
