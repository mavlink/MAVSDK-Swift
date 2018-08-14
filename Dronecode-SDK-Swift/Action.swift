import Foundation
import SwiftGRPC
import RxSwift

extension String: Error {
}

public class Action {
    private let service: DronecodeSdk_Rpc_Action_ActionServiceService

    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Action_ActionServiceServiceClient(address: "\(address):\(port)", secure: false)
        self.init(service: service)
    }
    
    init(service: DronecodeSdk_Rpc_Action_ActionServiceService) {
        self.service = service
    }

    public func arm() -> Completable {
        return Completable.create { completable in
            let armRequest = DronecodeSdk_Rpc_Action_ArmRequest()
            
            do {
                let armResponse = try self.service.arm(armRequest)
                if (armResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot arm: \(armResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func disarm() -> Completable {
        return Completable.create { completable in
            let disarmRequest = DronecodeSdk_Rpc_Action_DisarmRequest()
            
            do {
                let disarmResponse = try self.service.disarm(disarmRequest)
                if (disarmResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot disarm: \(disarmResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func takeoff() -> Completable {
        return Completable.create { completable in
            let takeoffRequest = DronecodeSdk_Rpc_Action_TakeoffRequest()
            
            do {
                let takeoffResponse = try self.service.takeoff(takeoffRequest)
                if (takeoffResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot takeoff: \(takeoffResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func land() -> Completable {
        return Completable.create { completable in
            let landRequest = DronecodeSdk_Rpc_Action_LandRequest()
            
            do {
                let landResponse = try self.service.land(landRequest)
                if (landResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot land: \(landResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func kill() -> Completable {
        return Completable.create { completable in
            let killRequest = DronecodeSdk_Rpc_Action_KillRequest()
            
            do {
                let killResponse = try self.service.kill(killRequest)
                if (killResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot kill: \(killResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
    
    public func returnToLaunch() -> Completable {
        return Completable.create { completable in
            let rtlRequest = DronecodeSdk_Rpc_Action_ReturnToLaunchRequest()
            
            do {
                let rtlResponse = try self.service.returnToLaunch(rtlRequest)
                if (rtlResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot return to launch: \(rtlResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func transitionToFixedWing() -> Completable {
        return Completable.create { completable in
            let toFixedWingRequest = DronecodeSdk_Rpc_Action_TransitionToFixedWingRequest()
            
            do {
                let toFixedWingResponse = try self.service.transitionToFixedWing(toFixedWingRequest)
                if (toFixedWingResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot transition to fixed wings: \(toFixedWingResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func transitionToMulticopter() -> Completable {
        return Completable.create { completable in
            let toMulticopterRequest = DronecodeSdk_Rpc_Action_TransitionToMulticopterRequest()
            
            do {
                let toMulticopterResponse = try self.service.transitionToMulticopter(toMulticopterRequest)
                if (toMulticopterResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot transition to multicopter: \(toMulticopterResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    
    public func getTakeoffAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let getTakeoffAltitudeRequest = DronecodeSdk_Rpc_Action_GetTakeoffAltitudeRequest()
            
            do {
                let getTakeoffAltitudeResponse = try self.service.getTakeoffAltitude(getTakeoffAltitudeRequest)
                single(.success(getTakeoffAltitudeResponse.altitude))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func setTakeoffAltitude(altitude: Float) -> Completable {
        return Completable.create { completable in
            var setTakeoffAltitudeRequest = DronecodeSdk_Rpc_Action_SetTakeoffAltitudeRequest()
            setTakeoffAltitudeRequest.altitude = altitude
            
            do {
                let _ = try self.service.setTakeoffAltitude(setTakeoffAltitudeRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
    
    public func getMaximumSpeed() -> Single<Float> {
        return Single<Float>.create { single in
            let getMaximumSpeedRequest = DronecodeSdk_Rpc_Action_GetMaximumSpeedRequest()
            
            do {
                let getMaximumSpeedResponse = try self.service.getMaximumSpeed(getMaximumSpeedRequest)
                single(.success(getMaximumSpeedResponse.speed))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func setMaximumSpeed(speed: Float) -> Completable {
        return Completable.create { completable in
            var setMaximumSpeedRequest = DronecodeSdk_Rpc_Action_SetMaximumSpeedRequest()
            setMaximumSpeedRequest.speed = speed
            
            do {
                let _ = try self.service.setMaximumSpeed(setMaximumSpeedRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
    
}