import Foundation
import RxSwift
import GRPC
import NIO

/**
 Utility for onboard MAVSDK instances for common "server" tasks.
 */
public class ServerUtility {
    private let service: Mavsdk_Rpc_ServerUtility_ServerUtilityServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `ServerUtility` plugin.

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
        let service = Mavsdk_Rpc_ServerUtility_ServerUtilityServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ServerUtility_ServerUtilityServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeServerUtilityError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ServerUtilityError: Error {
        public let code: ServerUtility.ServerUtilityResult.Result
        public let description: String
    }
    

    /**
     Status types.
     */
    public enum StatusTextType: Equatable {
        ///  Debug.
        case debug
        ///  Information.
        case info
        ///  Notice.
        case notice
        ///  Warning.
        case warning
        ///  Error.
        case error
        ///  Critical.
        case critical
        ///  Alert.
        case alert
        ///  Emergency.
        case emergency
        case UNRECOGNIZED(Int)

        internal var rpcStatusTextType: Mavsdk_Rpc_ServerUtility_StatusTextType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                return .notice
            case .warning:
                return .warning
            case .error:
                return .error
            case .critical:
                return .critical
            case .alert:
                return .alert
            case .emergency:
                return .emergency
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcStatusTextType: Mavsdk_Rpc_ServerUtility_StatusTextType) -> StatusTextType {
            switch rpcStatusTextType {
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                return .notice
            case .warning:
                return .warning
            case .error:
                return .error
            case .critical:
                return .critical
            case .alert:
                return .alert
            case .emergency:
                return .emergency
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     
     */
    public struct ServerUtilityResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for server utility requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Invalid argument.
            case invalidArgument
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_ServerUtility_ServerUtilityResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .invalidArgument:
                    return .invalidArgument
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_ServerUtility_ServerUtilityResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .invalidArgument:
                    return .invalidArgument
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ServerUtilityResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcServerUtilityResult: Mavsdk_Rpc_ServerUtility_ServerUtilityResult {
            var rpcServerUtilityResult = Mavsdk_Rpc_ServerUtility_ServerUtilityResult()
            
                
            rpcServerUtilityResult.result = result.rpcResult
                
            
            
                
            rpcServerUtilityResult.resultStr = resultStr
                
            

            return rpcServerUtilityResult
        }

        internal static func translateFromRpc(_ rpcServerUtilityResult: Mavsdk_Rpc_ServerUtility_ServerUtilityResult) -> ServerUtilityResult {
            return ServerUtilityResult(result: Result.translateFromRpc(rpcServerUtilityResult.result), resultStr: rpcServerUtilityResult.resultStr)
        }

        public static func == (lhs: ServerUtilityResult, rhs: ServerUtilityResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Sends a statustext.

     - Parameters:
        - type: The text to send
        - text: Text message
     
     */
    public func sendStatusText(type: StatusTextType, text: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ServerUtility_SendStatusTextRequest()

            
                
            request.type = type.rpcStatusTextType
                
            
                
            request.text = text
                
            

            do {
                
                let response = self.service.sendStatusText(request)

                let result = try response.response.wait().serverUtilityResult
                if (result.result == Mavsdk_Rpc_ServerUtility_ServerUtilityResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ServerUtilityError(code: ServerUtilityResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}