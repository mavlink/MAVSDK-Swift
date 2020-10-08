import Foundation
import RxSwift
import GRPC
import NIO

public class Param {
    private let service: Mavsdk_Rpc_Param_ParamServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_Param_ParamServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Param_ParamServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeParamError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ParamError: Error {
        public let code: Param.ParamResult.Result
        public let description: String
    }
    


    public struct ParamResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case timeout
            case connectionError
            case wrongType
            case paramNameTooLong
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Param_ParamResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .timeout:
                    return .timeout
                case .connectionError:
                    return .connectionError
                case .wrongType:
                    return .wrongType
                case .paramNameTooLong:
                    return .paramNameTooLong
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Param_ParamResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .timeout:
                    return .timeout
                case .connectionError:
                    return .connectionError
                case .wrongType:
                    return .wrongType
                case .paramNameTooLong:
                    return .paramNameTooLong
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcParamResult: Mavsdk_Rpc_Param_ParamResult {
            var rpcParamResult = Mavsdk_Rpc_Param_ParamResult()
            
                
            rpcParamResult.result = result.rpcResult
                
            
            
                
            rpcParamResult.resultStr = resultStr
                
            

            return rpcParamResult
        }

        internal static func translateFromRpc(_ rpcParamResult: Mavsdk_Rpc_Param_ParamResult) -> ParamResult {
            return ParamResult(result: Result.translateFromRpc(rpcParamResult.result), resultStr: rpcParamResult.resultStr)
        }

        public static func == (lhs: ParamResult, rhs: ParamResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func getParamInt(name: String) -> Single<Int32> {
        return Single<Int32>.create { single in
            var request = Mavsdk_Rpc_Param_GetParamIntRequest()

            
                
            request.name = name
                
            

            do {
                let response = self.service.getParamInt(request)

                
                let result = try response.response.wait().paramResult
                if (result.result != Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    single(.error(ParamError(code: ParamResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let value = try response.response.wait().value
                
                single(.success(value))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setParamInt(name: String, value: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Param_SetParamIntRequest()

            
                
            request.name = name
                
            
                
            request.value = value
                
            

            do {
                
                let response = self.service.setParamInt(request)

                let result = try response.response.wait().paramResult
                if (result.result == Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ParamError(code: ParamResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getParamFloat(name: String) -> Single<Float> {
        return Single<Float>.create { single in
            var request = Mavsdk_Rpc_Param_GetParamFloatRequest()

            
                
            request.name = name
                
            

            do {
                let response = self.service.getParamFloat(request)

                
                let result = try response.response.wait().paramResult
                if (result.result != Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    single(.error(ParamError(code: ParamResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let value = try response.response.wait().value
                
                single(.success(value))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setParamFloat(name: String, value: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Param_SetParamFloatRequest()

            
                
            request.name = name
                
            
                
            request.value = value
                
            

            do {
                
                let response = self.service.setParamFloat(request)

                let result = try response.response.wait().paramResult
                if (result.result == Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ParamError(code: ParamResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}