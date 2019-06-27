import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class ActionTest: XCTestCase {
    
    let ARBITRARY_ALTITUDE: Float = 123.5
    let ARBITRARY_SPEED: Float = 321.5
    
    let actionResultsArray: [Mavsdk_Rpc_Action_ActionResult.Result] = [.busy, .commandDenied, .commandDeniedNotLanded, .commandDeniedLandedStateUnknown, .connectionError, .noSystem, .noVtolTransitionSupport, .timeout, .unknown, .vtolTransitionSupportUnknown]
    
    func testArmSucceedsOnSuccess() throws {
        try armWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result.success)
    }
    
    func testArmFailsOnFailure() throws {
        try actionResultsArray.forEach { result in
            try armWithFakeResult(result: result)
        }
    }
    
    func armWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Action_ActionServiceServiceTestStub()
        var response = Mavsdk_Rpc_Action_ArmResponse()
        response.actionResult.result = result
        fakeService.armResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let action = Action(service: fakeService, scheduler: scheduler)

        scheduler.start()
        _ = action.arm().toBlocking().materialize()
    }

    func testDisarmSucceedsOnSuccess() throws {
        try disarmWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result.success)
    }
    
    func testDisarmFailsOnFailure() throws {
        try actionResultsArray.forEach { result in
             try disarmWithFakeResult(result: result)
        }
    }
    
    func disarmWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Action_ActionServiceServiceTestStub()
        var response = Mavsdk_Rpc_Action_DisarmResponse()
        response.actionResult.result = result
        fakeService.disarmResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Action(service: fakeService, scheduler: scheduler)

        scheduler.start()
        _ = client.disarm().toBlocking().materialize()
    }
    
    func testReturnToLaunchSucceedsOnSuccess() throws {
        try returnToLaunchWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result.success)
    }
    
    func testReturnToLaunchFailsOnFailure() throws {
        try actionResultsArray.forEach { result in
             try returnToLaunchWithFakeResult(result: result)
        }
    }
    
    func returnToLaunchWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Action_ActionServiceServiceTestStub()
        var response = Mavsdk_Rpc_Action_ReturnToLaunchResponse()
        response.actionResult.result = result
        fakeService.returnToLaunchResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Action(service: fakeService, scheduler: scheduler)

        scheduler.start()
        _ = client.returnToLaunch().toBlocking().materialize()
    }
    
    func testTransitionToFixedWingsSucceedsOnSuccess() throws {
        try transitionToFixedWingsWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result.success)
    }
    
    func testTransitionToFixedWingsFailsOnFailure() throws {
        try actionResultsArray.forEach { result in
            try transitionToFixedWingsWithFakeResult(result: result)
        }
    }
    
    func transitionToFixedWingsWithFakeResult(result: Mavsdk_Rpc_Action_ActionResult.Result) throws {
        let fakeService = Mavsdk_Rpc_Action_ActionServiceServiceTestStub()
        var response = Mavsdk_Rpc_Action_TransitionToFixedWingResponse()
        response.actionResult.result = result
        fakeService.transitionToFixedWingResponses.append(response)

        let scheduler = TestScheduler(initialClock: 0)
        let client = Action(service: fakeService, scheduler: scheduler)

        scheduler.start()
        _ = client.transitionToFixedWing().toBlocking().materialize()
    }
}
