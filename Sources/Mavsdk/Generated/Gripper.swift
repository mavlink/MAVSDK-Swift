import Foundation
import RxSwift
import GRPC
import NIO

/**
 Allows users to send gripper actions.
 */
public class Gripper {
    private let service: Mavsdk_Rpc_Gripper_GripperServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Gripper` plugin.

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
        let service = Mavsdk_Rpc_Gripper_GripperServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Gripper_GripperServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeGripperError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct GripperError: Error {
        public let code: Gripper.GripperResult.Result
        public let description: String
    }
    

    /**
     Gripper Actions.

     Available gripper actions are defined in mavlink under
     https://mavlink.io/en/messages/common.html#GRIPPER_ACTIONS
     */
    public enum GripperAction: Equatable {
        ///  Open the gripper to release the cargo.
        case release
        ///  Close the gripper and grab onto cargo.
        case grab
        case UNRECOGNIZED(Int)

        internal var rpcGripperAction: Mavsdk_Rpc_Gripper_GripperAction {
            switch self {
            case .release:
                return .release
            case .grab:
                return .grab
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcGripperAction: Mavsdk_Rpc_Gripper_GripperAction) -> GripperAction {
            switch rpcGripperAction {
            case .release:
                return .release
            case .grab:
                return .grab
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Result type.
     */
    public struct GripperResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for gripper action requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request was successful.
            case success
            ///  No system is connected.
            case noSystem
            ///  Temporarily rejected.
            case busy
            ///  Request timed out.
            case timeout
            ///  Action not supported.
            case unsupported
            ///  Action failed.
            case failed
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Gripper_GripperResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .unsupported:
                    return .unsupported
                case .failed:
                    return .failed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Gripper_GripperResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .unsupported:
                    return .unsupported
                case .failed:
                    return .failed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `GripperResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcGripperResult: Mavsdk_Rpc_Gripper_GripperResult {
            var rpcGripperResult = Mavsdk_Rpc_Gripper_GripperResult()
            
                
            rpcGripperResult.result = result.rpcResult
                
            
            
                
            rpcGripperResult.resultStr = resultStr
                
            

            return rpcGripperResult
        }

        internal static func translateFromRpc(_ rpcGripperResult: Mavsdk_Rpc_Gripper_GripperResult) -> GripperResult {
            return GripperResult(result: Result.translateFromRpc(rpcGripperResult.result), resultStr: rpcGripperResult.resultStr)
        }

        public static func == (lhs: GripperResult, rhs: GripperResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Gripper grab cargo.

     - Parameter instance:
     
     */
    public func grab(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gripper_GrabRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.grab(request)

                let result = try response.response.wait().gripperResult
                if (result.result == Mavsdk_Rpc_Gripper_GripperResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GripperError(code: GripperResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Gripper release cargo.

     - Parameter instance:
     
     */
    public func release(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gripper_ReleaseRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.release(request)

                let result = try response.response.wait().gripperResult
                if (result.result == Mavsdk_Rpc_Gripper_GripperResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GripperError(code: GripperResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}