import Foundation
import RxSwift
import SwiftGRPC

public class Param {
    private let service: Mavsdk_Rpc_Param_ParamServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Param_ParamServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Param_ParamServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
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
                let response = try self.service.getParamInt(request)

                
                if (response.paramResult.result != Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    single(.error(ParamError(code: ParamResult.Result.translateFromRpc(response.paramResult.result), description: response.paramResult.resultStr)))

                    return Disposables.create()
                }
                

                let value = response.value
                
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
                
                let response = try self.service.setParamInt(request)

                if (response.paramResult.result == Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ParamError(code: ParamResult.Result.translateFromRpc(response.paramResult.result), description: response.paramResult.resultStr)))
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
                let response = try self.service.getParamFloat(request)

                
                if (response.paramResult.result != Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    single(.error(ParamError(code: ParamResult.Result.translateFromRpc(response.paramResult.result), description: response.paramResult.resultStr)))

                    return Disposables.create()
                }
                

                let value = response.value
                
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
                
                let response = try self.service.setParamFloat(request)

                if (response.paramResult.result == Mavsdk_Rpc_Param_ParamResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ParamError(code: ParamResult.Result.translateFromRpc(response.paramResult.result), description: response.paramResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}