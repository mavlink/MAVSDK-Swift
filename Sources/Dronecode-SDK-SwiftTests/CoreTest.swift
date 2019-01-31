import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import Dronecode_SDK_Swift

class CoreTest: XCTestCase {
    let ARBITRARY_UUID: UInt64 = 42
    let ARBITRARY_PLUGIN_NAME: String = "action"
    let ARBITRARY_PLUGIN_ADDRESS: String = "localhost"
    let ARBITRARY_PLUGIN_PORT: Int32 = 1291

    func testDiscoverObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()
        fakeService.subscribeDiscoverCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.discover.subscribe(observer)
        scheduler.start()

        XCTAssertTrue(observer.events.isEmpty)
    }

    func testDiscoverObservableReceivesOneEvent() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()

        let expectedUUID = ARBITRARY_UUID
        fakeCall.outputs = [createDiscoverResponse(uuid: expectedUUID)]
        fakeService.subscribeDiscoverCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.discover.subscribe(observer)
        scheduler.start()

        let expectedEvents = [
            next(0, expectedUUID),
        ]

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
            observed.value == expected.value
        }))
    }

    func createDiscoverResponse(uuid: UInt64) -> DronecodeSdk_Rpc_Core_DiscoverResponse {
        var response = DronecodeSdk_Rpc_Core_DiscoverResponse()
        response.uuid = uuid

        return response
    }

    func testDiscoverObservableReceivesMultipleEvents() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()

        fakeCall.outputs = []
        let expectedUUIDs = [4433522, 7654454, 1234567]
        for expectedUUID in expectedUUIDs {
            fakeCall.outputs.append(createDiscoverResponse(uuid: UInt64(expectedUUID)))
        }
        fakeService.subscribeDiscoverCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.discover.subscribe(observer)
        scheduler.start()

        var expectedEvents = [Recorded<Event<UInt64>>]()
        for expectedUUID in expectedUUIDs {
            expectedEvents.append(next(0, UInt64(expectedUUID)))
        }

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
            observed.value == expected.value
        }))
    }

    func testTimeoutObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeTimeoutCallTestStub()
        fakeService.subscribeTimeoutCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Void.self)

        let _ = client.timeout.subscribe(observer)
        scheduler.start()

        XCTAssertTrue(observer.events.isEmpty)
    }

    func testTimeoutObservableReceivesOneEvent() {
        checkTimeoutObservableReceivesEvents(nbEvents: 1)
    }

    func checkTimeoutObservableReceivesEvents(nbEvents: Int) {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeTimeoutCallTestStub()

        fakeCall.outputs = []
        for _ in 1...nbEvents {
            fakeCall.outputs.append(DronecodeSdk_Rpc_Core_TimeoutResponse())
        }
        fakeService.subscribeTimeoutCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Void.self)

        let _ = client.timeout.subscribe(observer)
        scheduler.start()

        XCTAssertEqual(nbEvents, observer.events.count)
    }

    func testTimeoutObservableReceivesMultipleEvents() {
        checkTimeoutObservableReceivesEvents(nbEvents: 5)
    }

    func testListRunningPluginsEmitsNothingWhenEmpty() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        fakeService.listRunningPluginsResponses.append(DronecodeSdk_Rpc_Core_ListRunningPluginsResponse())
        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        scheduler.start()

        let pluginInfos = try! client.listRunningPlugins().toBlocking().single()

        XCTAssertTrue(pluginInfos.isEmpty)
    }

    func testListRunningPluginsEmitsOnePluginInfo() throws {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Core_ListRunningPluginsResponse()
        response.pluginInfo.append(createRPCPluginInfo(name: ARBITRARY_PLUGIN_NAME, address: ARBITRARY_PLUGIN_ADDRESS, port: ARBITRARY_PLUGIN_PORT))
        fakeService.listRunningPluginsResponses.append(response)
        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let expectedPluginInfo = Core.PluginInfo.translateFromRpc(response.pluginInfo[0])

        scheduler.start()
        let pluginInfos = try client.listRunningPlugins().toBlocking().single()

        XCTAssertEqual(1, pluginInfos.count)
        XCTAssertEqual(expectedPluginInfo, pluginInfos.first)
    }

    func createRPCPluginInfo(name: String, address: String, port: Int32) -> DronecodeSdk_Rpc_Core_PluginInfo {
        var pluginInfo = DronecodeSdk_Rpc_Core_PluginInfo()
        pluginInfo.name = ARBITRARY_PLUGIN_NAME
        pluginInfo.address = ARBITRARY_PLUGIN_ADDRESS
        pluginInfo.port = ARBITRARY_PLUGIN_PORT

        return pluginInfo
    }

    func testListRunningPluginsEmitsMultiplePluginInfos() throws {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Core_ListRunningPluginsResponse()
        response.pluginInfo.append(createRPCPluginInfo(name: "name1", address: "add1", port: 1291))
        response.pluginInfo.append(createRPCPluginInfo(name: "name2", address: "add2", port: 1492))
        response.pluginInfo.append(createRPCPluginInfo(name: "name3", address: "add3", port: 1515))
        fakeService.listRunningPluginsResponses.append(response)
        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)

        scheduler.start()
        let pluginInfos = try client.listRunningPlugins().toBlocking().single()

        XCTAssertEqual(pluginInfos.count, response.pluginInfo.count)

        for i in 0 ... pluginInfos.count - 1 {
            XCTAssertEqual(Core.PluginInfo.translateFromRpc(response.pluginInfo[i]), pluginInfos[i])
        }
    }
}
