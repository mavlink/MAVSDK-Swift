import Dronecode_SDK_Swift
import RxSwift
import XCTest

class ActionTest: XCTestCase {

    func testArmSucceeds() {
        let expectation = XCTestExpectation(description: "Arm succeeded.")

        let core = Core()
        core.connect().toBlocking().materialize()
        let action = Action(address: "localhost", port: 50051)

        sleep(1) // Wait for action plugin to be ready. Do NOT do this in production.

        action.arm()
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testDisarmSucceeds() {
        
        let expectation = XCTestExpectation(description: "Disarm succeeded.")

        let core = Core()
        core.connect().toBlocking().materialize()
        let action = Action(address: "localhost", port: 50051)
        
        sleep(1) // Wait for action plugin to be ready. Do NOT do this in production.
        
        action.arm().do(onError: { error in XCTFail("\(error)")})
                    .delay(15, scheduler: MainScheduler.instance)
            .andThen(action.disarm().do(onError: { error in XCTFail("\(error)") }))
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        wait(for: [expectation], timeout: 20.0)
    }

    func testTakeoffAndLandSucceeds() {
        let expectation = XCTestExpectation(description: "Take off and land succeeded.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let action = Action(address: "localhost", port: 50051)

        sleep(1) // Wait for action plugin to be ready. Do NOT do this in production.

        action.arm().do(onError: { error in XCTFail("\(error)")})
            .andThen(
                action.takeoff().do(onError: { error in
                    XCTFail("\(error)")
                    
                }).delay(15, scheduler: MainScheduler.instance))
            .andThen(
                action.land().do(onError: { error in
                    XCTFail("\(error)")
                })
            )
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })
        
        wait(for: [expectation], timeout: 20.0)
    }
    
    func testTakeoffAndKillSucceeds() {
        let expectation = XCTestExpectation(description: "Take off and kill succeeded.")
        
        let core = Core()
        core.connect().toBlocking().materialize()
        let action = Action(address: "localhost", port: 50051)
        
        sleep(1) // Wait for action plugin to be ready. Do NOT do this in production.
        
        action.arm().do(onError: { error in XCTFail("\(error)")})
            .andThen(action.takeoff().do(onError: { error in XCTFail("\(error)") })
                .delay(15, scheduler: MainScheduler.instance))
            .andThen(action.kill().do(onError: { error in XCTFail("\(error)") }))
            .subscribe(onCompleted: {
                expectation.fulfill()
            }, onError: { (error) in
                XCTFail("\(error)")
            })

        wait(for: [expectation], timeout: 20.0)
    }
    
    //TODO add tests ReturnToLaunch, transitionToFixedWings, transitionToMulticopter, getTakeoffAltitude, setTakeoffAltitude
}
