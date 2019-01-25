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

    let scheduler = MainScheduler.instance

    func testDiscoverObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()
        fakeService.subscribeDiscoverCalls.append(fakeCall)

        let client = Core(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.discover.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count) // "completed" is one event
    }

    func testDiscoverObservableReceivesOneEvent() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeDiscoverCallTestStub()

        let expectedUUID = ARBITRARY_UUID
        fakeCall.outputs = [createDiscoverResponse(uuid: expectedUUID)]
        fakeService.subscribeDiscoverCalls.append(fakeCall)

        let client = Core(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.discover.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        let expectedEvents = [
            next(0, expectedUUID),
            completed(0)
        ]

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(observer.events, expectedEvents)
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

        let client = Core(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(UInt64.self)

        let _ = client.discover.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        var expectedEvents = [Recorded<Event<UInt64>>]()
        for expectedUUID in expectedUUIDs {
            expectedEvents.append(next(0, UInt64(expectedUUID)))
        }
        expectedEvents.append(completed(0))

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertEqual(expectedEvents, observer.events)
    }

    func testTimeoutObservableEmitsNothingWhenNoEvent() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = DronecodeSdk_Rpc_Core_CoreServiceSubscribeTimeoutCallTestStub()
        fakeService.subscribeTimeoutCalls.append(fakeCall)

        let client = Core(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)

        let _ = client.timeout.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(1, observer.events.count)
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

        let client = Core(service: fakeService, scheduler: self.scheduler)
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Void.self)

        let _ = client.timeout.subscribe(observer)
        scheduler.start()
        observer.onCompleted()

        XCTAssertEqual(nbEvents + 1, observer.events.count) // "completed" is one event
    }

    func testTimeoutObservableReceivesMultipleEvents() {
        checkTimeoutObservableReceivesEvents(nbEvents: 5)
    }

    func testListRunningPluginsEmitsNothingWhenEmpty() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        fakeService.listRunningPluginsResponses.append(DronecodeSdk_Rpc_Core_ListRunningPluginsResponse())
        let client = Core(service: fakeService, scheduler: self.scheduler)

        let pluginInfos = try! client.listRunningPlugins().toBlocking().single()

        XCTAssertEqual(0, pluginInfos.count)
    }

    func testListRunningPluginsEmitsOnePluginInfo() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Core_ListRunningPluginsResponse()
        response.pluginInfo.append(createRPCPluginInfo(name: ARBITRARY_PLUGIN_NAME, address: ARBITRARY_PLUGIN_ADDRESS, port: ARBITRARY_PLUGIN_PORT))
        fakeService.listRunningPluginsResponses.append(response)
        let client = Core(service: fakeService, scheduler: self.scheduler)
        let expectedPluginInfo = translateRPCPluginInfo(pluginInfoRPC: response.pluginInfo[0])

        let pluginInfos = try? client.listRunningPlugins().toBlocking().single()

        XCTAssertEqual(1, pluginInfos?.count)
        XCTAssertEqual(expectedPluginInfo, pluginInfos![0])
    }

    func createRPCPluginInfo(name: String, address: String, port: Int32) -> DronecodeSdk_Rpc_Core_PluginInfo {
        var pluginInfo = DronecodeSdk_Rpc_Core_PluginInfo()
        pluginInfo.name = ARBITRARY_PLUGIN_NAME
        pluginInfo.address = ARBITRARY_PLUGIN_ADDRESS
        pluginInfo.port = ARBITRARY_PLUGIN_PORT

        return pluginInfo
    }

    func translateRPCPluginInfo(pluginInfoRPC: DronecodeSdk_Rpc_Core_PluginInfo) -> Core.PluginInfo {
        return Core.PluginInfo(name: pluginInfoRPC.name, address: pluginInfoRPC.address, port: pluginInfoRPC.port)
    }

    func testListRunningPluginsEmitsMultiplePluginInfos() {
        let fakeService = DronecodeSdk_Rpc_Core_CoreServiceServiceTestStub()
        var response = DronecodeSdk_Rpc_Core_ListRunningPluginsResponse()
        response.pluginInfo.append(createRPCPluginInfo(name: "name1", address: "add1", port: 1291))
        response.pluginInfo.append(createRPCPluginInfo(name: "name2", address: "add2", port: 1492))
        response.pluginInfo.append(createRPCPluginInfo(name: "name3", address: "add3", port: 1515))
        fakeService.listRunningPluginsResponses.append(response)
        let client = Core(service: fakeService, scheduler: self.scheduler)

        let pluginInfos = try? client.listRunningPlugins().toBlocking().single()

        XCTAssertEqual(pluginInfos?.count, response.pluginInfo.count)

        for i in 0 ... pluginInfos!.count - 1 {
            XCTAssertEqual(translateRPCPluginInfo(pluginInfoRPC: response.pluginInfo[i]), pluginInfos![i])
        }
    }
}
