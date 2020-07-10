import Foundation
import RxSwift
import GRPC
import NIO

public class Action {
    private let service: Mavsdk_Rpc_Action_ActionServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_Action_ActionServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Action_ActionServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
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

            internal var rpcResult: Mavsdk_Rpc_Action_ActionResult.Result {
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

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Action_ActionResult.Result) -> Result {
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

        internal var rpcActionResult: Mavsdk_Rpc_Action_ActionResult {
            var rpcActionResult = Mavsdk_Rpc_Action_ActionResult()
            
                
            rpcActionResult.result = result.rpcResult
                
            
            
                
            rpcActionResult.resultStr = resultStr
                
            

            return rpcActionResult
        }

        internal static func translateFromRpc(_ rpcActionResult: Mavsdk_Rpc_Action_ActionResult) -> ActionResult {
            return ActionResult(result: Result.translateFromRpc(rpcActionResult.result), resultStr: rpcActionResult.resultStr)
        }

        public static func == (lhs: ActionResult, rhs: ActionResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func arm() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_ArmRequest()

            

            do {
                
                let response = self.service.arm(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func disarm() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_DisarmRequest()

            

            do {
                
                let response = self.service.disarm(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func takeoff() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TakeoffRequest()

            

            do {
                
                let response = self.service.takeoff(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func land() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_LandRequest()

            

            do {
                
                let response = self.service.land(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func reboot() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_RebootRequest()

            

            do {
                
                let response = self.service.reboot(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func shutdown() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_ShutdownRequest()

            

            do {
                
                let response = self.service.shutdown(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func terminate() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TerminateRequest()

            

            do {
                
                let response = try self.service.terminate(request)

                if (response.actionResult.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
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
            let request = Mavsdk_Rpc_Action_KillRequest()

            

            do {
                
                let response = self.service.kill(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func returnToLaunch() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_ReturnToLaunchRequest()

            

            do {
                
                let response = self.service.returnToLaunch(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func gotoLocation(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, yawDeg: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_GotoLocationRequest()

            
                
            request.latitudeDeg = latitudeDeg
                
            
                
            request.longitudeDeg = longitudeDeg
                
            
                
            request.absoluteAltitudeM = absoluteAltitudeM
                
            
                
            request.yawDeg = yawDeg
                
            

            do {
                
                let response = self.service.gotoLocation(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func transitionToFixedwing() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TransitionToFixedwingRequest()

            

            do {
                
                let response = self.service.transitionToFixedwing(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func transitionToMulticopter() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TransitionToMulticopterRequest()

            

            do {
                
                let response = self.service.transitionToMulticopter(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getTakeoffAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let request = Mavsdk_Rpc_Action_GetTakeoffAltitudeRequest()

            

            do {
                let response = self.service.getTakeoffAltitude(request)

                
                let result = try response.response.wait().actionResult
                if (result.result != Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let altitude = try response.response.wait().altitude
                
                single(.success(altitude))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setTakeoffAltitude(altitude: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_SetTakeoffAltitudeRequest()

            
                
            request.altitude = altitude
                
            

            do {
                
                let response = self.service.setTakeoffAltitude(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getMaximumSpeed() -> Single<Float> {
        return Single<Float>.create { single in
            let request = Mavsdk_Rpc_Action_GetMaximumSpeedRequest()

            

            do {
                let response = self.service.getMaximumSpeed(request)

                
                let result = try response.response.wait().actionResult
                if (result.result != Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let speed = try response.response.wait().speed
                
                single(.success(speed))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setMaximumSpeed(speed: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_SetMaximumSpeedRequest()

            
                
            request.speed = speed
                
            

            do {
                
                let response = self.service.setMaximumSpeed(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getReturnToLaunchAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let request = Mavsdk_Rpc_Action_GetReturnToLaunchAltitudeRequest()

            

            do {
                let response = self.service.getReturnToLaunchAltitude(request)

                
                let result = try response.response.wait().actionResult
                if (result.result != Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let relativeAltitudeM = try response.response.wait().relativeAltitudeM
                
                single(.success(relativeAltitudeM))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setReturnToLaunchAltitude(relativeAltitudeM: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_SetReturnToLaunchAltitudeRequest()

            
                
            request.relativeAltitudeM = relativeAltitudeM
                
            

            do {
                
                let response = self.service.setReturnToLaunchAltitude(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}