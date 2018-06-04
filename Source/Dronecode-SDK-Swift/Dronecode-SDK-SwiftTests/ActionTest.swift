import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class ActionTest: XCTestCase {
    
    let ARBITRARY_ALTITUDE: Float = 123.5
    let ARBITRARY_SPEED: Float = 321.5
    
    let actionResultsArray: [Dronecore_Rpc_Action_ActionResult.Result] = [.busy, .commandDenied, .commandDeniedNotLanded, .commandDeniedLandedStateUnknown, .connectionError, .noSystem, .noVtolTransitionSupport, .timeout, .unknown, .vtolTransitionSupportUnknown]
    
    // MARK: - ARM
    func testArmSucceedsOnSuccess() {
        assertSuccess(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.success))
    }
    
    func testArmFailsOnFailure() {
        actionResultsArray.forEach { result in
            assertFailure(result: armWithFakeResult(result: result))
        }
    }
    
    func armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_ArmResponse()
        response.actionResult.result = result
        fakeService.armResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.arm().toBlocking().materialize()
    }

    // MARK: - DISARM
    func testDisarmSucceedsOnSuccess() {
        assertSuccess(result: disarmWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.success))
    }
    
    func testDisarmFailsOnFailure() {
        actionResultsArray.forEach { result in
             assertFailure(result: disarmWithFakeResult(result: result))
        }
    }
    
    func disarmWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_DisarmResponse()
        response.actionResult.result = result
        fakeService.disarmResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.disarm().toBlocking().materialize()
    }
    
    // MARK: - KILL
    func testKillSucceedsOnSuccess() {
        assertSuccess(result: killWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.success))
    }
    
    func testKillFailsOnFailure() {
        actionResultsArray.forEach { result in
            assertFailure(result: killWithFakeResult(result: result))
        }
    }
    
    func killWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_KillResponse()
        response.actionResult.result = result
        fakeService.killResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.kill().toBlocking().materialize()
    }
    
    // MARK: - RETURN TO LAUNCH
    func testReturnToLaunchSucceedsOnSuccess() {
        assertSuccess(result: returnToLaunchWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.success))
    }
    
    func testReturnToLaunchFailsOnFailure() {
        actionResultsArray.forEach { result in
             assertFailure(result: returnToLaunchWithFakeResult(result: result))
        }
    }
    
    func returnToLaunchWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_ReturnToLaunchResponse()
        response.actionResult.result = result
        fakeService.returntolaunchResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.returnToLaunch().toBlocking().materialize()
    }
    
    // MARK: - TRANSITION TO FIXED WINGS
    func testTransitionToFixedWingsSucceedsOnSuccess() {
        assertSuccess(result: transitionToFixedWingsWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.success))
    }
    
    func testTransitionToFixedWingsFailsOnFailure() {
        actionResultsArray.forEach { result in
            assertFailure(result: transitionToFixedWingsWithFakeResult(result: result))
        }
    }
    
    func transitionToFixedWingsWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_TransitionToFixedWingResponse()
        response.actionResult.result = result
        fakeService.transitiontofixedwingResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.transitionToFixedWing().toBlocking().materialize()
    }
    
    // MARK: - TRANSITION TO MULTICOPTER
    func testTransitionToMulticopterSucceedsOnSuccess() {
        assertSuccess(result: transitionToMulticopterWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.success))
    }
    
    func testTransitionToMulticopterFailsOnFailure() {
        actionResultsArray.forEach { result in
            assertFailure(result: transitionToMulticopterWithFakeResult(result: result))
        }
    }
    
    func transitionToMulticopterWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_TransitionToMulticopterResponse()
        response.actionResult.result = result
        fakeService.transitiontomulticopterResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.transitionToMulticopter().toBlocking().materialize()
    }
    
    // MARK: - GET TAKEOFF ALTITUDE
    func testGetTakeoffAltitudeSucceedsOnSuccess() {
        let expectedAltitude: Float = ARBITRARY_ALTITUDE
        
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_GetTakeoffAltitudeResponse()
        response.altitudeM = expectedAltitude
        fakeService.gettakeoffaltitudeResponses.append(response)
        let client = Action(service: fakeService)
        
        _ = client.getTakeoffAltitude().subscribe { event in
            switch event {
            case .success(let altitude):
                XCTAssert(altitude == expectedAltitude)
                break
            case .error(let error):
                XCTFail("Expecting success, got failure: getTakeoffAltitude() \(error) ")
            }
        }
    }
    
    // MARK: - SET TAKEOFF ALTITUDE
    func testSetTakeoffAltitudeSucceedsOnSuccess() {
        assertSuccess(result: setTakeoffAltitudeWithFakeResult())
    }
    
    func setTakeoffAltitudeWithFakeResult() -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        let response = Dronecore_Rpc_Action_SetTakeoffAltitudeResponse()
        
        fakeService.settakeoffaltitudeResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.setTakeoffAltitude(altitude: 20.0).toBlocking().materialize()
    }
    
    // MARK: - GET MAXIMUM SPEED
    func testGetMaximumSpeedSucceedsOnSuccess() {
        let expectedSpeed = ARBITRARY_SPEED
        
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_GetMaximumSpeedResponse()
        response.speedMS = expectedSpeed
        
        fakeService.getmaximumspeedResponses.append(response)
        let client = Action(service: fakeService)
        
        _ = client.getMaximumSpeed().subscribe { event in
            switch event {
            case .success(let speed):
                XCTAssert(speed == expectedSpeed)
                break
            case .error(let error):
                XCTFail("Expecting success, got failure: getMaximumSpeed() \(error) ")
            }
        }
    }
    
    // MARK: - SET MAXIMUM SPEED
    func testSetMaximumSpeedSucceedsOnSuccess() {
        assertSuccess(result: setMaximumSpeedWithFakeResult())
    }
    
    func setMaximumSpeedWithFakeResult() -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        let response = Dronecore_Rpc_Action_SetMaximumSpeedResponse()
        fakeService.setmaximumspeedResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.setMaximumSpeed(speed: 20.0).toBlocking().materialize()
    }
    
    // MARK: - Utils
    func assertSuccess(result: MaterializedSequenceResult<Never>) {
        switch result {
            case .completed:
                break
            case .failed:
                XCTFail("Expecting success, got failure")
        }
    }

    func assertFailure(result: MaterializedSequenceResult<Never>) {
        switch result {
            case .completed:
                XCTFail("Expecting failure, got success")
            case .failed:
                break
        }
    }
}
