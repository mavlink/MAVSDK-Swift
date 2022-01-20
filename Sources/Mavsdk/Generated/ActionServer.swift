import Foundation
import RxSwift
import GRPC
import NIO

/**
 Provide vehicle actions (as a server) such as arming, taking off, and landing.
 */
public class ActionServer {
    private let service: Mavsdk_Rpc_ActionServer_ActionServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `ActionServer` plugin.

     Normally never created manually, but used from the `Drone` helper class instead.

     - Parameters:
        - address: The address of the `MavsdkServer` instance to connect to
        - port: The port of the `MavsdkServer` instance to connect to
        - scheduler: The scheduler to be used by `Observable`s
     */
    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_ActionServer_ActionServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ActionServer_ActionServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeActionServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ActionServerError: Error {
        public let code: ActionServer.ActionServerResult.Result
        public let description: String
    }
    

    /**
     Flight modes.

     For more information about flight modes, check out
     https://docs.px4.io/master/en/config/flight_mode.html.
     */
    public enum FlightMode: Equatable {
        ///  Mode not known.
        case unknown
        ///  Armed and ready to take off.
        case ready
        ///  Taking off.
        case takeoff
        ///  Holding (hovering in place (or circling for fixed-wing vehicles).
        case hold
        ///  In mission.
        case mission
        ///  Returning to launch position (then landing).
        case returnToLaunch
        ///  Landing.
        case land
        ///  In 'offboard' mode.
        case offboard
        ///  In 'follow-me' mode.
        case followMe
        ///  In 'Manual' mode.
        case manual
        ///  In 'Altitude Control' mode.
        case altctl
        ///  In 'Position Control' mode.
        case posctl
        ///  In 'Acro' mode.
        case acro
        ///  In 'Stabilize' mode.
        case stabilized
        case UNRECOGNIZED(Int)

        internal var rpcFlightMode: Mavsdk_Rpc_ActionServer_FlightMode {
            switch self {
            case .unknown:
                return .unknown
            case .ready:
                return .ready
            case .takeoff:
                return .takeoff
            case .hold:
                return .hold
            case .mission:
                return .mission
            case .returnToLaunch:
                return .returnToLaunch
            case .land:
                return .land
            case .offboard:
                return .offboard
            case .followMe:
                return .followMe
            case .manual:
                return .manual
            case .altctl:
                return .altctl
            case .posctl:
                return .posctl
            case .acro:
                return .acro
            case .stabilized:
                return .stabilized
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcFlightMode: Mavsdk_Rpc_ActionServer_FlightMode) -> FlightMode {
            switch rpcFlightMode {
            case .unknown:
                return .unknown
            case .ready:
                return .ready
            case .takeoff:
                return .takeoff
            case .hold:
                return .hold
            case .mission:
                return .mission
            case .returnToLaunch:
                return .returnToLaunch
            case .land:
                return .land
            case .offboard:
                return .offboard
            case .followMe:
                return .followMe
            case .manual:
                return .manual
            case .altctl:
                return .altctl
            case .posctl:
                return .posctl
            case .acro:
                return .acro
            case .stabilized:
                return .stabilized
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     State to check if the vehicle can transition to
     respective flightmodes
     */
    public struct AllowableFlightModes: Equatable {
        public let canAutoMode: Bool
        public let canGuidedMode: Bool
        public let canStabilizeMode: Bool

        

        /**
         Initializes a new `AllowableFlightModes`.

         
         - Parameters:
            
            - canAutoMode:  Auto/mission mode
            
            - canGuidedMode:  Guided mode
            
            - canStabilizeMode:  Stabilize mode
            
         
         */
        public init(canAutoMode: Bool, canGuidedMode: Bool, canStabilizeMode: Bool) {
            self.canAutoMode = canAutoMode
            self.canGuidedMode = canGuidedMode
            self.canStabilizeMode = canStabilizeMode
        }

        internal var rpcAllowableFlightModes: Mavsdk_Rpc_ActionServer_AllowableFlightModes {
            var rpcAllowableFlightModes = Mavsdk_Rpc_ActionServer_AllowableFlightModes()
            
                
            rpcAllowableFlightModes.canAutoMode = canAutoMode
                
            
            
                
            rpcAllowableFlightModes.canGuidedMode = canGuidedMode
                
            
            
                
            rpcAllowableFlightModes.canStabilizeMode = canStabilizeMode
                
            

            return rpcAllowableFlightModes
        }

        internal static func translateFromRpc(_ rpcAllowableFlightModes: Mavsdk_Rpc_ActionServer_AllowableFlightModes) -> AllowableFlightModes {
            return AllowableFlightModes(canAutoMode: rpcAllowableFlightModes.canAutoMode, canGuidedMode: rpcAllowableFlightModes.canGuidedMode, canStabilizeMode: rpcAllowableFlightModes.canStabilizeMode)
        }

        public static func == (lhs: AllowableFlightModes, rhs: AllowableFlightModes) -> Bool {
            return lhs.canAutoMode == rhs.canAutoMode
                && lhs.canGuidedMode == rhs.canGuidedMode
                && lhs.canStabilizeMode == rhs.canStabilizeMode
        }
    }

    /**
     Arming message type
     */
    public struct ArmDisarm: Equatable {
        public let arm: Bool
        public let force: Bool

        

        /**
         Initializes a new `ArmDisarm`.

         
         - Parameters:
            
            - arm:  Should vehicle arm
            
            - force:  Should arm override pre-flight checks
            
         
         */
        public init(arm: Bool, force: Bool) {
            self.arm = arm
            self.force = force
        }

        internal var rpcArmDisarm: Mavsdk_Rpc_ActionServer_ArmDisarm {
            var rpcArmDisarm = Mavsdk_Rpc_ActionServer_ArmDisarm()
            
                
            rpcArmDisarm.arm = arm
                
            
            
                
            rpcArmDisarm.force = force
                
            

            return rpcArmDisarm
        }

        internal static func translateFromRpc(_ rpcArmDisarm: Mavsdk_Rpc_ActionServer_ArmDisarm) -> ArmDisarm {
            return ArmDisarm(arm: rpcArmDisarm.arm, force: rpcArmDisarm.force)
        }

        public static func == (lhs: ArmDisarm, rhs: ArmDisarm) -> Bool {
            return lhs.arm == rhs.arm
                && lhs.force == rhs.force
        }
    }

    /**
     Result type.
     */
    public struct ActionServerResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for action requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request was successful.
            case success
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command refused by vehicle.
            case commandDenied
            ///  Command refused because landed state is unknown.
            case commandDeniedLandedStateUnknown
            ///  Command refused because vehicle not landed.
            case commandDeniedNotLanded
            ///  Request timed out.
            case timeout
            ///  Hybrid/VTOL transition support is unknown.
            case vtolTransitionSupportUnknown
            ///  Vehicle does not support hybrid/VTOL transitions.
            case noVtolTransitionSupport
            ///  Error getting or setting parameter.
            case parameterError
            ///  Intermediate message showing progress or instructions on the next steps.
            case next
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_ActionServer_ActionServerResult.Result {
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
                case .next:
                    return .next
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_ActionServer_ActionServerResult.Result) -> Result {
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
                case .next:
                    return .next
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ActionServerResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcActionServerResult: Mavsdk_Rpc_ActionServer_ActionServerResult {
            var rpcActionServerResult = Mavsdk_Rpc_ActionServer_ActionServerResult()
            
                
            rpcActionServerResult.result = result.rpcResult
                
            
            
                
            rpcActionServerResult.resultStr = resultStr
                
            

            return rpcActionServerResult
        }

        internal static func translateFromRpc(_ rpcActionServerResult: Mavsdk_Rpc_ActionServer_ActionServerResult) -> ActionServerResult {
            return ActionServerResult(result: Result.translateFromRpc(rpcActionServerResult.result), resultStr: rpcActionServerResult.resultStr)
        }

        public static func == (lhs: ActionServerResult, rhs: ActionServerResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }



    /**
     Subscribe to ARM/DISARM commands
     */
    public lazy var armDisarm: Observable<ArmDisarm> = createArmDisarmObservable()



    private func createArmDisarmObservable() -> Observable<ArmDisarm> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ActionServer_SubscribeArmDisarmRequest()

            

            _ = self.service.subscribeArmDisarm(request, handler: { (response) in

                
                     
                let armDisarm = ArmDisarm.translateFromRpc(response.arm)
                

                
                let result = ActionServerResult.translateFromRpc(response.actionServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(armDisarm)
                default:
                    observer.onError(ActionServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeActionServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to DO_SET_MODE
     */
    public lazy var flightModeChange: Observable<FlightMode> = createFlightModeChangeObservable()



    private func createFlightModeChangeObservable() -> Observable<FlightMode> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ActionServer_SubscribeFlightModeChangeRequest()

            

            _ = self.service.subscribeFlightModeChange(request, handler: { (response) in

                
                     
                let flightModeChange = FlightMode.translateFromRpc(response.flightMode)
                

                
                let result = ActionServerResult.translateFromRpc(response.actionServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(flightModeChange)
                default:
                    observer.onError(ActionServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeActionServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to takeoff command
     */
    public lazy var takeoff: Observable<Bool> = createTakeoffObservable()



    private func createTakeoffObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ActionServer_SubscribeTakeoffRequest()

            

            _ = self.service.subscribeTakeoff(request, handler: { (response) in

                
                     
                let takeoff = response.takeoff
                    
                

                
                let result = ActionServerResult.translateFromRpc(response.actionServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(takeoff)
                default:
                    observer.onError(ActionServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeActionServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to land command
     */
    public lazy var land: Observable<Bool> = createLandObservable()



    private func createLandObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ActionServer_SubscribeLandRequest()

            

            _ = self.service.subscribeLand(request, handler: { (response) in

                
                     
                let land = response.land
                    
                

                
                let result = ActionServerResult.translateFromRpc(response.actionServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(land)
                default:
                    observer.onError(ActionServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeActionServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to reboot command
     */
    public lazy var reboot: Observable<Bool> = createRebootObservable()



    private func createRebootObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ActionServer_SubscribeRebootRequest()

            

            _ = self.service.subscribeReboot(request, handler: { (response) in

                
                     
                let reboot = response.reboot
                    
                

                
                let result = ActionServerResult.translateFromRpc(response.actionServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(reboot)
                default:
                    observer.onError(ActionServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeActionServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to shutdown command
     */
    public lazy var shutdown: Observable<Bool> = createShutdownObservable()



    private func createShutdownObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ActionServer_SubscribeShutdownRequest()

            

            _ = self.service.subscribeShutdown(request, handler: { (response) in

                
                     
                let shutdown = response.shutdown
                    
                

                
                let result = ActionServerResult.translateFromRpc(response.actionServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(shutdown)
                default:
                    observer.onError(ActionServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeActionServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to terminate command
     */
    public lazy var terminate: Observable<Bool> = createTerminateObservable()



    private func createTerminateObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ActionServer_SubscribeTerminateRequest()

            

            _ = self.service.subscribeTerminate(request, handler: { (response) in

                
                     
                let terminate = response.terminate
                    
                

                
                let result = ActionServerResult.translateFromRpc(response.actionServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(terminate)
                default:
                    observer.onError(ActionServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeActionServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Can the vehicle takeoff

     - Parameter allowTakeoff: Is takeoff allowed?
     
     */
    public func setAllowTakeoff(allowTakeoff: Bool) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ActionServer_SetAllowTakeoffRequest()

            
                
            request.allowTakeoff = allowTakeoff
                
            

            do {
                
                let response = self.service.setAllowTakeoff(request)

                let result = try response.response.wait().actionServerResult
                if (result.result == Mavsdk_Rpc_ActionServer_ActionServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionServerError(code: ActionServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Can the vehicle arm when requested

     - Parameters:
        - armable: Is Armable now?
        - forceArmable: Is armable with force?
     
     */
    public func setArmable(armable: Bool, forceArmable: Bool) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ActionServer_SetArmableRequest()

            
                
            request.armable = armable
                
            
                
            request.forceArmable = forceArmable
                
            

            do {
                
                let response = self.service.setArmable(request)

                let result = try response.response.wait().actionServerResult
                if (result.result == Mavsdk_Rpc_ActionServer_ActionServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionServerError(code: ActionServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Can the vehicle disarm when requested

     - Parameters:
        - disarmable: Is disarmable now?
        - forceDisarmable: Is disarmable with force? (Kill)
     
     */
    public func setDisarmable(disarmable: Bool, forceDisarmable: Bool) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ActionServer_SetDisarmableRequest()

            
                
            request.disarmable = disarmable
                
            
                
            request.forceDisarmable = forceDisarmable
                
            

            do {
                
                let response = self.service.setDisarmable(request)

                let result = try response.response.wait().actionServerResult
                if (result.result == Mavsdk_Rpc_ActionServer_ActionServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionServerError(code: ActionServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set which modes the vehicle can transition to (Manual always allowed)

     - Parameter flightModes:
     
     */
    public func setAllowableFlightModes(flightModes: AllowableFlightModes) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ActionServer_SetAllowableFlightModesRequest()

            
                
            request.flightModes = flightModes.rpcAllowableFlightModes
                
            

            do {
                
                let response = self.service.setAllowableFlightModes(request)

                let result = try response.response.wait().actionServerResult
                if (result.result == Mavsdk_Rpc_ActionServer_ActionServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionServerError(code: ActionServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get which modes the vehicle can transition to (Manual always allowed)

     
     */
    public func getAllowableFlightModes() -> Single<AllowableFlightModes> {
        return Single<AllowableFlightModes>.create { single in
            let request = Mavsdk_Rpc_ActionServer_GetAllowableFlightModesRequest()

            

            do {
                let response = self.service.getAllowableFlightModes(request)

                

    	    
                    let flightModes = try AllowableFlightModes.translateFromRpc(response.response.wait().flightModes)
                
                single(.success(flightModes))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}