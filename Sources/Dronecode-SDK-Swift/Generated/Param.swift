import Foundation
import RxSwift
import SwiftGRPC

public class Param {
    private let service: DronecodeSdk_Rpc_Param_ParamServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = DronecodeSdk_Rpc_Param_ParamServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Param_ParamServiceService, scheduler: SchedulerType) {
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

            internal var rpcResult: DronecodeSdk_Rpc_Param_ParamResult.Result {
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

            internal static func translateFromRpc(_ rpcResult: DronecodeSdk_Rpc_Param_ParamResult.Result) -> Result {
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

        internal var rpcParamResult: DronecodeSdk_Rpc_Param_ParamResult {
            var rpcParamResult = DronecodeSdk_Rpc_Param_ParamResult()
            
                
            rpcParamResult.result = result.rpcResult
                
            
            
                
            rpcParamResult.resultStr = resultStr
                
            

            return rpcParamResult
        }

        internal static func translateFromRpc(_ rpcParamResult: DronecodeSdk_Rpc_Param_ParamResult) -> ParamResult {
            return ParamResult(result: Result.translateFromRpc(rpcParamResult.result), resultStr: rpcParamResult.resultStr)
        }

        public static func == (lhs: ParamResult, rhs: ParamResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func getIntParam(name: String) -> Single<Int32> {
        return Single<Int32>.create { single in
            var request = DronecodeSdk_Rpc_Param_GetIntParamRequest()

            
                
            request.name = name
                
            

            do {
                let response = try self.service.getIntParam(request)

                
                if (response.paramResult.result != DronecodeSdk_Rpc_Param_ParamResult.Result.success) {
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

    public func setIntParam(name: String, value: Int32) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Param_SetIntParamRequest()

            
                
            request.name = name
                
            
                
            request.value = value
                
            

            do {
                
                let response = try self.service.setIntParam(request)

                if (response.paramResult.result == DronecodeSdk_Rpc_Param_ParamResult.Result.success) {
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

    public func getFloatParam(name: String) -> Single<Float> {
        return Single<Float>.create { single in
            var request = DronecodeSdk_Rpc_Param_GetFloatParamRequest()

            
                
            request.name = name
                
            

            do {
                let response = try self.service.getFloatParam(request)

                
                if (response.paramResult.result != DronecodeSdk_Rpc_Param_ParamResult.Result.success) {
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

    public func setFloatParam(name: String, value: Float) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Param_SetFloatParamRequest()

            
                
            request.name = name
                
            
                
            request.value = value
                
            

            do {
                
                let response = try self.service.setFloatParam(request)

                if (response.paramResult.result == DronecodeSdk_Rpc_Param_ParamResult.Result.success) {
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