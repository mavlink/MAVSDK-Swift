import Foundation
import gRPC
import RxSwift

extension String: Error {
}

public class Action {
    let service: Dronecore_Rpc_Action_ActionServiceService

    public convenience init(address: String, port: Int) {
        let service = Dronecore_Rpc_Action_ActionServiceServiceClient(address: "\(address):\(port)", secure: false)
        self.init(service: service)
    }
    
    init(service: Dronecore_Rpc_Action_ActionServiceService) {
        self.service = service
    }

    public func arm() -> Completable {
        return Completable.create { completable in
            let armRequest = Dronecore_Rpc_Action_ArmRequest()
            
            do {
                let armResponse = try self.service.arm(armRequest)
                if (armResponse.actionResult.result == Dronecore_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                    return Disposables.create {}
                } else {
                    completable(.error("Cannot arm: \(armResponse.actionResult.result)"))
                    return Disposables.create {}
                }
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }
    }
    
    public func takeoff() -> Completable {
        return Completable.create { completable in
            let takeoffRequest = Dronecore_Rpc_Action_TakeoffRequest()
            
            do {
                let takeoffResponse = try self.service.takeoff(takeoffRequest)
                if (takeoffResponse.actionResult.result == Dronecore_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                    return Disposables.create {}
                } else {
                    completable(.error("Cannot takeoff: \(takeoffResponse.actionResult.result)"))
                    return Disposables.create {}
                }
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }
    }
    
    public func land() -> Completable {
        return Completable.create { completable in
            let landRequest = Dronecore_Rpc_Action_LandRequest()
            
            do {
                let landResponse = try self.service.land(landRequest)
                if (landResponse.actionResult.result == Dronecore_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                    return Disposables.create {}
                } else {
                    completable(.error("Cannot land: \(landResponse.actionResult.result)"))
                    return Disposables.create {}
                }
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }
    }
}
