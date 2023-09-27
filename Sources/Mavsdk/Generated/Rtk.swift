import Foundation
import RxSwift
import GRPC
import NIO

/**
 Service to send RTK corrections to the vehicle.
 */
public class Rtk {
    private let service: Mavsdk_Rpc_Rtk_RtkServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Rtk` plugin.

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
        let service = Mavsdk_Rpc_Rtk_RtkServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Rtk_RtkServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeRtkError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct RtkError: Error {
        public let code: Rtk.RtkResult.Result
        public let description: String
    }
    


    /**
     RTCM data type
     */
    public struct RtcmData: Equatable {
        public let data: String

        

        /**
         Initializes a new `RtcmData`.

         
         - Parameter data:  The data encoded as a string
         
         */
        public init(data: String) {
            self.data = data
        }

        internal var rpcRtcmData: Mavsdk_Rpc_Rtk_RtcmData {
            var rpcRtcmData = Mavsdk_Rpc_Rtk_RtcmData()
            
                
            rpcRtcmData.data = data
                
            

            return rpcRtcmData
        }

        internal static func translateFromRpc(_ rpcRtcmData: Mavsdk_Rpc_Rtk_RtcmData) -> RtcmData {
            return RtcmData(data: rpcRtcmData.data)
        }

        public static func == (lhs: RtcmData, rhs: RtcmData) -> Bool {
            return lhs.data == rhs.data
        }
    }

    /**
     
     */
    public struct RtkResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for rtk requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  Passed data is too long.
            case tooLong
            ///  No system connected.
            case noSystem
            ///  Connection error.
            case connectionError
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Rtk_RtkResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .tooLong:
                    return .tooLong
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Rtk_RtkResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .tooLong:
                    return .tooLong
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `RtkResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcRtkResult: Mavsdk_Rpc_Rtk_RtkResult {
            var rpcRtkResult = Mavsdk_Rpc_Rtk_RtkResult()
            
                
            rpcRtkResult.result = result.rpcResult
                
            
            
                
            rpcRtkResult.resultStr = resultStr
                
            

            return rpcRtkResult
        }

        internal static func translateFromRpc(_ rpcRtkResult: Mavsdk_Rpc_Rtk_RtkResult) -> RtkResult {
            return RtkResult(result: Result.translateFromRpc(rpcRtkResult.result), resultStr: rpcRtkResult.resultStr)
        }

        public static func == (lhs: RtkResult, rhs: RtkResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Send RTCM data.

     - Parameter rtcmData: The data
     
     */
    public func sendRtcmData(rtcmData: RtcmData) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Rtk_SendRtcmDataRequest()

            
                
            request.rtcmData = rtcmData.rpcRtcmData
                
            

            do {
                
                let response = self.service.sendRtcmData(request)

                let result = try response.response.wait().rtkResult
                if (result.result == Mavsdk_Rpc_Rtk_RtkResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(RtkError(code: RtkResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}