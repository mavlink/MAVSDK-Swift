import Foundation
import RxSwift
import GRPC
import NIO

public class ManualControl {
    private let service: Mavsdk_Rpc_ManualControl_ManualControlServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_ManualControl_ManualControlServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ManualControl_ManualControlServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeManualControlError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ManualControlError: Error {
        public let code: ManualControl.ManualControlResult.Result
        public let description: String
    }
    


    public struct ManualControlResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case noSystem
            case connectionError
            case busy
            case commandDenied
            case timeout
            case inputOutOfRange
            case inputNotSet
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_ManualControl_ManualControlResult.Result {
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
                case .timeout:
                    return .timeout
                case .inputOutOfRange:
                    return .inputOutOfRange
                case .inputNotSet:
                    return .inputNotSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_ManualControl_ManualControlResult.Result) -> Result {
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
                case .timeout:
                    return .timeout
                case .inputOutOfRange:
                    return .inputOutOfRange
                case .inputNotSet:
                    return .inputNotSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcManualControlResult: Mavsdk_Rpc_ManualControl_ManualControlResult {
            var rpcManualControlResult = Mavsdk_Rpc_ManualControl_ManualControlResult()
            
                
            rpcManualControlResult.result = result.rpcResult
                
            
            
                
            rpcManualControlResult.resultStr = resultStr
                
            

            return rpcManualControlResult
        }

        internal static func translateFromRpc(_ rpcManualControlResult: Mavsdk_Rpc_ManualControl_ManualControlResult) -> ManualControlResult {
            return ManualControlResult(result: Result.translateFromRpc(rpcManualControlResult.result), resultStr: rpcManualControlResult.resultStr)
        }

        public static func == (lhs: ManualControlResult, rhs: ManualControlResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func startPositionControl() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_ManualControl_StartPositionControlRequest()

            

            do {
                
                let response = self.service.startPositionControl(request)

                let result = try response.response.wait().manualControlResult
                if (result.result == Mavsdk_Rpc_ManualControl_ManualControlResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ManualControlError(code: ManualControlResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func startAltitudeControl() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest()

            

            do {
                
                let response = self.service.startAltitudeControl(request)

                let result = try response.response.wait().manualControlResult
                if (result.result == Mavsdk_Rpc_ManualControl_ManualControlResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ManualControlError(code: ManualControlResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setManualControlInput(x: Float, y: Float, z: Float, r: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ManualControl_SetManualControlInputRequest()

            
                
            request.x = x
                
            
                
            request.y = y
                
            
                
            request.z = z
                
            
                
            request.r = r
                
            

            do {
                
                let response = self.service.setManualControlInput(request)

                let result = try response.response.wait().manualControlResult
                if (result.result == Mavsdk_Rpc_ManualControl_ManualControlResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ManualControlError(code: ManualControlResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}