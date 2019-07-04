import Foundation
import RxBlocking
import RxSwift
import RxTest
import XCTest
@testable import MAVSDK_Swift

class CoreTest: XCTestCase {
    let ARBITRARY_UUID: UInt64 = 42
    let ARBITRARY_PLUGIN_NAME: String = "action"
    let ARBITRARY_PLUGIN_ADDRESS: String = "localhost"
    let ARBITRARY_PLUGIN_PORT: Int32 = 1291

    func testConnectionStateObservableEmitsNothingWhenNoEvent() {
        let fakeService = Mavsdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Mavsdk_Rpc_Core_CoreServiceSubscribeConnectionStateCallTestStub()
        fakeService.subscribeConnectionStateCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Core.ConnectionState.self)

        let _ = client.connectionState.subscribe(observer)
        scheduler.start()

        XCTAssertTrue(observer.events.isEmpty)
    }

    func testConnectionStateObservableReceivesOneEvent() {
        let fakeService = Mavsdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Mavsdk_Rpc_Core_CoreServiceSubscribeConnectionStateCallTestStub()

        let expectedConnectionState = Core.ConnectionState(uuid: ARBITRARY_UUID, isConnected: true)
        fakeCall.outputs = [createConnectionStateResponse(connectionState: expectedConnectionState)]
        fakeService.subscribeConnectionStateCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Core.ConnectionState.self)

        let _ = client.connectionState.subscribe(observer)
        scheduler.start()

        let expectedEvents = [
            next(0, expectedConnectionState),
        ]

        XCTAssertEqual(expectedEvents.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedEvents, by: { (observed, expected) in
            observed.value == expected.value
        }))
    }

    func createConnectionStateResponse(connectionState: Core.ConnectionState) -> Mavsdk_Rpc_Core_ConnectionStateResponse {
        var response = Mavsdk_Rpc_Core_ConnectionStateResponse()
        response.connectionState.uuid = connectionState.uuid
        response.connectionState.isConnected = connectionState.isConnected

        return response
    }

    func testDiscoverObservableReceivesMultipleEvents() {
        let fakeService = Mavsdk_Rpc_Core_CoreServiceServiceTestStub()
        let fakeCall = Mavsdk_Rpc_Core_CoreServiceSubscribeConnectionStateCallTestStub()

        fakeCall.outputs = []
        var expectedConnectionStates = [Core.ConnectionState]()
        expectedConnectionStates.append(Core.ConnectionState(uuid: 4352334, isConnected: false))
        expectedConnectionStates.append(Core.ConnectionState(uuid: 213534, isConnected: true))
        expectedConnectionStates.append(Core.ConnectionState(uuid: 12, isConnected: false))
        expectedConnectionStates.append(Core.ConnectionState(uuid: 9985232, isConnected: false))
        expectedConnectionStates.append(Core.ConnectionState(uuid: 1872358, isConnected: true))

        for expectedConnectionState in expectedConnectionStates {
            fakeCall.outputs.append(createConnectionStateResponse(connectionState: expectedConnectionState))
        }
        fakeService.subscribeConnectionStateCalls.append(fakeCall)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        let observer = scheduler.createObserver(Core.ConnectionState.self)

        let _ = client.connectionState.subscribe(observer)
        scheduler.start()

        XCTAssertEqual(expectedConnectionStates.count, observer.events.count)
        XCTAssertTrue(observer.events.elementsEqual(expectedConnectionStates.map({ connState in next(1, connState) }), by: { (observed, expected) in observed.value == expected.value}))
    }

    func testListRunningPluginsEmitsNothingWhenEmpty() {
        let fakeService = Mavsdk_Rpc_Core_CoreServiceServiceTestStub()
        fakeService.listRunningPluginsResponses.append(Mavsdk_Rpc_Core_ListRunningPluginsResponse())
        let scheduler = TestScheduler(initialClock: 0)
        let client = Core(service: fakeService, scheduler: scheduler)
        scheduler.start()

        let pluginInfos = try! client.listRunningPlugins().toBlocking().single()

        XCTAssertTrue(pluginInfos.isEmpty)
    }

    func testListRunningPluginsEmitsOnePluginInfo() throws {
        let fakeService = Mavsdk_Rpc_Core_CoreServiceServiceTestStub()
        var response = Mavsdk_Rpc_Core_ListRunningPluginsResponse()
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

    func createRPCPluginInfo(name: String, address: String, port: Int32) -> Mavsdk_Rpc_Core_PluginInfo {
        var pluginInfo = Mavsdk_Rpc_Core_PluginInfo()
        pluginInfo.name = ARBITRARY_PLUGIN_NAME
        pluginInfo.address = ARBITRARY_PLUGIN_ADDRESS
        pluginInfo.port = ARBITRARY_PLUGIN_PORT

        return pluginInfo
    }

    func testListRunningPluginsEmitsMultiplePluginInfos() throws {
        let fakeService = Mavsdk_Rpc_Core_CoreServiceServiceTestStub()
        var response = Mavsdk_Rpc_Core_ListRunningPluginsResponse()
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
