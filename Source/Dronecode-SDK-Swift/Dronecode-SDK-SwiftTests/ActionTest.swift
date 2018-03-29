import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import Dronecode_SDK_Swift

class ActionTest: XCTestCase {
    func testArmSucceedsOnSuccess() {
        assertSuccess(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.success))
    }
    
    func armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result) -> MaterializedSequenceResult<Never> {
        let fakeService = Dronecore_Rpc_Action_ActionServiceServiceTestStub()
        var response = Dronecore_Rpc_Action_ArmResponse()
        response.actionResult.result = result
        fakeService.armResponses.append(response)
        let client = Action(service: fakeService)
        
        return client.arm().toBlocking().materialize()
    }
    
    func assertSuccess(result: MaterializedSequenceResult<Never>) {
        switch result {
            case .completed:
                break
            case .failed:
                XCTFail("Expecting success, got failure")
        }
    }
    
    func testArmFailsOnFailure() {
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.busy))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.commandDenied))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.commandDeniedNotLanded))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.commandDeniedLandedStateUnknown))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.connectionError))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.noDevice))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.noVtolTransitionSupport))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.timeout))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.unknown))
        assertFailure(result: armWithFakeResult(result: Dronecore_Rpc_Action_ActionResult.Result.vtolTransitionSupportUnknown))
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
