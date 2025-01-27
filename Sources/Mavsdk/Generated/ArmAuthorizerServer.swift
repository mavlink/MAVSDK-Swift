import Foundation
import RxSwift
import GRPC
import NIO

/**
 
 */
public class ArmAuthorizerServer {
    private let service: Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `ArmAuthorizerServer` plugin.

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
        let service = Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeArmAuthorizerServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ArmAuthorizerServerError: Error {
        public let code: ArmAuthorizerServer.ArmAuthorizerServerResult.Result
        public let description: String
    }
    

    /**
     
     */
    public enum RejectionReason: Equatable {
        ///  Not a specific reason.
        case generic
        ///  Authorizer will send the error as string to GCS.
        case none
        ///  At least one waypoint have a invalid value.
        case invalidWaypoint
        ///  Timeout in the authorizer process(in case it depends on network).
        case timeout
        ///  Airspace of the mission in use by another vehicle, second result parameter can have the waypoint id that caused it to be denied..
        case airspaceInUse
        ///  Weather is not good to fly.
        case badWeather
        case UNRECOGNIZED(Int)

        internal var rpcRejectionReason: Mavsdk_Rpc_ArmAuthorizerServer_RejectionReason {
            switch self {
            case .generic:
                return .generic
            case .none:
                return .none
            case .invalidWaypoint:
                return .invalidWaypoint
            case .timeout:
                return .timeout
            case .airspaceInUse:
                return .airspaceInUse
            case .badWeather:
                return .badWeather
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcRejectionReason: Mavsdk_Rpc_ArmAuthorizerServer_RejectionReason) -> RejectionReason {
            switch rpcRejectionReason {
            case .generic:
                return .generic
            case .none:
                return .none
            case .invalidWaypoint:
                return .invalidWaypoint
            case .timeout:
                return .timeout
            case .airspaceInUse:
                return .airspaceInUse
            case .badWeather:
                return .badWeather
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     
     */
    public struct ArmAuthorizerServerResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Command accepted.
            case success
            ///  Command failed.
            case failed
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .failed:
                    return .failed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .failed:
                    return .failed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ArmAuthorizerServerResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcArmAuthorizerServerResult: Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerResult {
            var rpcArmAuthorizerServerResult = Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerResult()
            
                
            rpcArmAuthorizerServerResult.result = result.rpcResult
                
            
            
                
            rpcArmAuthorizerServerResult.resultStr = resultStr
                
            

            return rpcArmAuthorizerServerResult
        }

        internal static func translateFromRpc(_ rpcArmAuthorizerServerResult: Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerResult) -> ArmAuthorizerServerResult {
            return ArmAuthorizerServerResult(result: Result.translateFromRpc(rpcArmAuthorizerServerResult.result), resultStr: rpcArmAuthorizerServerResult.resultStr)
        }

        public static func == (lhs: ArmAuthorizerServerResult, rhs: ArmAuthorizerServerResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }



    /**
     Subscribe to arm authorization request messages. Each request received should respond to using RespondArmAuthorization
     */

    public lazy var armAuthorization: Observable<UInt32> = createArmAuthorizationObservable()




    private func createArmAuthorizationObservable() -> Observable<UInt32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_ArmAuthorizerServer_SubscribeArmAuthorizationRequest()

            

            let serverStreamingCall = self.service.subscribeArmAuthorization(request, handler: { (response) in

                
                     
                let armAuthorization = response.systemID
                    
                

                
                observer.onNext(armAuthorization)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeArmAuthorizerServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Authorize arm for the specific time

     - Parameter validTimeS: Time in seconds for which this authorization is valid
     
     */
    public func acceptArmAuthorization(validTimeS: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ArmAuthorizerServer_AcceptArmAuthorizationRequest()

            
                
            request.validTimeS = validTimeS
                
            

            do {
                
                let response = self.service.acceptArmAuthorization(request)

                let result = try response.response.wait().armAuthorizerServerResult
                if (result.result == Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ArmAuthorizerServerError(code: ArmAuthorizerServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Reject arm authorization request

     - Parameters:
        - temporarily: True if the answer should be TEMPORARILY_REJECTED, false for DENIED
        - reason: Reason for the arm to be rejected
        - extraInfo: Extra information specific to the rejection reason (see https://mavlink.io/en/services/arm_authorization.html)
     
     */
    public func rejectArmAuthorization(temporarily: Bool, reason: RejectionReason, extraInfo: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ArmAuthorizerServer_RejectArmAuthorizationRequest()

            
                
            request.temporarily = temporarily
                
            
                
            request.reason = reason.rpcRejectionReason
                
            
                
            request.extraInfo = extraInfo
                
            

            do {
                
                let response = self.service.rejectArmAuthorization(request)

                let result = try response.response.wait().armAuthorizerServerResult
                if (result.result == Mavsdk_Rpc_ArmAuthorizerServer_ArmAuthorizerServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ArmAuthorizerServerError(code: ArmAuthorizerServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}