import Foundation
import RxSwift
import SwiftGRPC

public class Action {
    private let service: DronecodeSdk_Rpc_Action_ActionServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = DronecodeSdk_Rpc_Action_ActionServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Action_ActionServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeActionError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ActionError: Error {
        public let code: Action.ActionResult.Result
        public let description: String
    }
    


    public struct ActionResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case noSystem
            case connectionError
            case busy
            case commandDenied
            case commandDeniedLandedStateUnknown
            case commandDeniedNotLanded
            case timeout
            case vtolTransitionSupportUnknown
            case noVtolTransitionSupport
            case parameterError
            case UNRECOGNIZED(Int)

            internal var rpcResult: DronecodeSdk_Rpc_Action_ActionResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .busy:
                    return .busy
                case .commandDenied:
                    return .commandDenied
                case .commandDeniedLandedStateUnknown:
                    return .commandDeniedLandedStateUnknown
                case .commandDeniedNotLanded:
                    return .commandDeniedNotLanded
                case .timeout:
                    return .timeout
                case .vtolTransitionSupportUnknown:
                    return .vtolTransitionSupportUnknown
                case .noVtolTransitionSupport:
                    return .noVtolTransitionSupport
                case .parameterError:
                    return .parameterError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: DronecodeSdk_Rpc_Action_ActionResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .busy:
                    return .busy
                case .commandDenied:
                    return .commandDenied
                case .commandDeniedLandedStateUnknown:
                    return .commandDeniedLandedStateUnknown
                case .commandDeniedNotLanded:
                    return .commandDeniedNotLanded
                case .timeout:
                    return .timeout
                case .vtolTransitionSupportUnknown:
                    return .vtolTransitionSupportUnknown
                case .noVtolTransitionSupport:
                    return .noVtolTransitionSupport
                case .parameterError:
                    return .parameterError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcActionResult: DronecodeSdk_Rpc_Action_ActionResult {
            var rpcActionResult = DronecodeSdk_Rpc_Action_ActionResult()
            
                
            rpcActionResult.result = result.rpcResult
                
            
            
                
            rpcActionResult.resultStr = resultStr
                
            

            return rpcActionResult
        }

        internal static func translateFromRpc(_ rpcActionResult: DronecodeSdk_Rpc_Action_ActionResult) -> ActionResult {
            return ActionResult(result: Result.translateFromRpc(rpcActionResult.result), resultStr: rpcActionResult.resultStr)
        }

        public static func == (lhs: ActionResult, rhs: ActionResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func arm() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_ArmRequest()

            

            do {
                
                let response = try self.service.arm(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func disarm() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_DisarmRequest()

            

            do {
                
                let response = try self.service.disarm(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func takeoff() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_TakeoffRequest()

            

            do {
                
                let response = try self.service.takeoff(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func land() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_LandRequest()

            

            do {
                
                let response = try self.service.land(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func reboot() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_RebootRequest()

            

            do {
                
                let response = try self.service.reboot(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func kill() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_KillRequest()

            

            do {
                
                let response = try self.service.kill(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func returnToLaunch() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_ReturnToLaunchRequest()

            

            do {
                
                let response = try self.service.returnToLaunch(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func transitionToFixedWing() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_TransitionToFixedWingRequest()

            

            do {
                
                let response = try self.service.transitionToFixedWing(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func transitionToMulticopter() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Action_TransitionToMulticopterRequest()

            

            do {
                
                let response = try self.service.transitionToMulticopter(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getTakeoffAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let request = DronecodeSdk_Rpc_Action_GetTakeoffAltitudeRequest()

            

            do {
                let response = try self.service.getTakeoffAltitude(request)

                
                if (response.actionResult.result != DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let altitude = response.altitude
                
                single(.success(altitude))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setTakeoffAltitude(altitude: Float) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Action_SetTakeoffAltitudeRequest()

            
                
            request.altitude = altitude
                
            

            do {
                
                let response = try self.service.setTakeoffAltitude(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getMaximumSpeed() -> Single<Float> {
        return Single<Float>.create { single in
            let request = DronecodeSdk_Rpc_Action_GetMaximumSpeedRequest()

            

            do {
                let response = try self.service.getMaximumSpeed(request)

                
                if (response.actionResult.result != DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let speed = response.speed
                
                single(.success(speed))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setMaximumSpeed(speed: Float) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Action_SetMaximumSpeedRequest()

            
                
            request.speed = speed
                
            

            do {
                
                let response = try self.service.setMaximumSpeed(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getReturnToLaunchAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let request = DronecodeSdk_Rpc_Action_GetReturnToLaunchAltitudeRequest()

            

            do {
                let response = try self.service.getReturnToLaunchAltitude(request)

                
                if (response.actionResult.result != DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let relativeAltitudeM = response.relativeAltitudeM
                
                single(.success(relativeAltitudeM))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setReturnToLaunchAltitude(relativeAltitudeM: Float) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Action_SetReturnToLaunchAltitudeRequest()

            
                
            request.relativeAltitudeM = relativeAltitudeM
                
            

            do {
                
                let response = try self.service.setReturnToLaunchAltitude(request)

                if (response.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(response.actionResult.result), description: response.actionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}