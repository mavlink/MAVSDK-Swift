import Foundation
import RxSwift
import SwiftGRPC

public class Gimbal {
    private let service: Mavsdk_Rpc_Gimbal_GimbalServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Gimbal_GimbalServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Gimbal_GimbalServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeGimbalError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct GimbalError: Error {
        public let code: Gimbal.GimbalResult.Result
        public let description: String
    }
    

    public enum GimbalMode: Equatable {
        case yawFollow
        case yawLock
        case UNRECOGNIZED(Int)

        internal var rpcGimbalMode: Mavsdk_Rpc_Gimbal_GimbalMode {
            switch self {
            case .yawFollow:
                return .yawFollow
            case .yawLock:
                return .yawLock
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcGimbalMode: Mavsdk_Rpc_Gimbal_GimbalMode) -> GimbalMode {
            switch rpcGimbalMode {
            case .yawFollow:
                return .yawFollow
            case .yawLock:
                return .yawLock
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    public struct GimbalResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case error
            case timeout
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Gimbal_GimbalResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .error:
                    return .error
                case .timeout:
                    return .timeout
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Gimbal_GimbalResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .error:
                    return .error
                case .timeout:
                    return .timeout
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcGimbalResult: Mavsdk_Rpc_Gimbal_GimbalResult {
            var rpcGimbalResult = Mavsdk_Rpc_Gimbal_GimbalResult()
            
                
            rpcGimbalResult.result = result.rpcResult
                
            
            
                
            rpcGimbalResult.resultStr = resultStr
                
            

            return rpcGimbalResult
        }

        internal static func translateFromRpc(_ rpcGimbalResult: Mavsdk_Rpc_Gimbal_GimbalResult) -> GimbalResult {
            return GimbalResult(result: Result.translateFromRpc(rpcGimbalResult.result), resultStr: rpcGimbalResult.resultStr)
        }

        public static func == (lhs: GimbalResult, rhs: GimbalResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func setPitchAndYaw(pitchDeg: Float, yawDeg: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest()

            
                
            request.pitchDeg = pitchDeg
                
            
                
            request.yawDeg = yawDeg
                
            

            do {
                
                let response = try self.service.setPitchAndYaw(request)

                if (response.gimbalResult.result == Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GimbalError(code: GimbalResult.Result.translateFromRpc(response.gimbalResult.result), description: response.gimbalResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setMode(gimbalMode: GimbalMode) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetModeRequest()

            
                
            request.gimbalMode = gimbalMode.rpcGimbalMode
                
            

            do {
                
                let response = try self.service.setMode(request)

                if (response.gimbalResult.result == Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GimbalError(code: GimbalResult.Result.translateFromRpc(response.gimbalResult.result), description: response.gimbalResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRoiLocation(latitudeDeg: Double, longitudeDeg: Double, altitudeM: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetRoiLocationRequest()

            
                
            request.latitudeDeg = latitudeDeg
                
            
                
            request.longitudeDeg = longitudeDeg
                
            
                
            request.altitudeM = altitudeM
                
            

            do {
                
                let response = try self.service.setRoiLocation(request)

                if (response.gimbalResult.result == Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GimbalError(code: GimbalResult.Result.translateFromRpc(response.gimbalResult.result), description: response.gimbalResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}