import Dronecode_SDK_Swift
import RxSwift
import XCTest

class ActionTest: XCTestCase {

    func testArmSucceeds() {
        let core = Core()
        core.connect()
        let action = Action(address: "localhost", port: 50051)

        sleep(1) // Wait for action plugin to be ready. Do NOT do this in production.

        action.arm().subscribe(onError: { error in XCTFail("\(error)") })
    }

    func testTakeoffAndLandSucceeds() {
        let core = Core()
        core.connect()
        let action = Action(address: "localhost", port: 50051)

        sleep(1) // Wait for action plugin to be ready. Do NOT do this in production.

        action.arm().do(onError: { error in XCTFail("\(error)")})
            .andThen(action.takeoff().do(onError: { error in XCTFail("\(error)") })
                                     .delay(15, scheduler: MainScheduler.instance))
            .andThen(action.land().do(onError: { error in XCTFail("\(error)") }))
            .subscribe()
    }
}
