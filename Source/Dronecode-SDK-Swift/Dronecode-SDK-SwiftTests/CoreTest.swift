import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CoreTest: XCTestCase {
    let ARBITRARY_UUID: UInt64 = 42
    
    func testDiscoverObservableEmitNothingWhenNoEvent() {
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
    
    func createDiscoverResponse(uuid: UInt64) -> Dronecore_Rpc_Core_DiscoverResponse {
        var response = Dronecore_Rpc_Core_DiscoverResponse()
        response.uuid = uuid
        
        return response
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
        
        XCTAssertEqual(observer.events, expectedEvents)
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
        
        XCTAssertEqual(observer.events, expectedEvents)
    }
}
