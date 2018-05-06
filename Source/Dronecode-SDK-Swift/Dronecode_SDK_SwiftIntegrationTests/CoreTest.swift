import Dronecode_SDK_Swift
import RxBlocking
import RxSwift
import XCTest

class CoreTest: XCTestCase {

    func testDiscoverEmitsWhenConnecting() {
        
        let core = Core()
        core.connect().toBlocking().materialize()
        
        do {
            let uuid = try core.discoverObservable.take(1).toBlocking(timeout: 2).single()
        } catch {
            XCTFail("At least one system should be discovered when the backend is connected!")
        }
    }

    func testPluginsAreRunning() {
        let core = Core()
        core.connect().toBlocking().materialize()

        do {
            let plugins = try core.runningPluginsObservable.toBlocking().toArray()

            XCTAssertEqual(3, plugins.count)
            checkPluginInfoListContains(pluginInfoList: plugins, name: "action")
            checkPluginInfoListContains(pluginInfoList: plugins, name: "mission")
            checkPluginInfoListContains(pluginInfoList: plugins, name: "telemetry")
        } catch {
            XCTFail("Failed to fetch running plugins")
        }
    }

    func checkPluginInfoListContains(pluginInfoList: [PluginInfo], name: String) {
        for plugin in pluginInfoList {
            if (plugin.name == name) {
                return
            }
        }

        XCTFail("Plugin '\(name)' is not listed as a running plugin!")
    }
}
