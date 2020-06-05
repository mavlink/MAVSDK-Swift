import Foundation
import RxSwift
import SwiftGRPC

public class FollowMe {
    private let service: Mavsdk_Rpc_FollowMe_FollowMeServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_FollowMe_FollowMeServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_FollowMe_FollowMeServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeFollowMeError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct FollowMeError: Error {
        public let code: FollowMe.FollowMeResult.Result
        public let description: String
    }
    


    public struct Config: Equatable {
        public let minHeightM: Float
        public let followDistanceM: Float
        public let followDirection: FollowDirection
        public let responsiveness: Float

        
        

        public enum FollowDirection: Equatable {
            case none
            case behind
            case front
            case frontRight
            case frontLeft
            case UNRECOGNIZED(Int)

            internal var rpcFollowDirection: Mavsdk_Rpc_FollowMe_Config.FollowDirection {
                switch self {
                case .none:
                    return .none
                case .behind:
                    return .behind
                case .front:
                    return .front
                case .frontRight:
                    return .frontRight
                case .frontLeft:
                    return .frontLeft
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcFollowDirection: Mavsdk_Rpc_FollowMe_Config.FollowDirection) -> FollowDirection {
                switch rpcFollowDirection {
                case .none:
                    return .none
                case .behind:
                    return .behind
                case .front:
                    return .front
                case .frontRight:
                    return .frontRight
                case .frontLeft:
                    return .frontLeft
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(minHeightM: Float, followDistanceM: Float, followDirection: FollowDirection, responsiveness: Float) {
            self.minHeightM = minHeightM
            self.followDistanceM = followDistanceM
            self.followDirection = followDirection
            self.responsiveness = responsiveness
        }

        internal var rpcConfig: Mavsdk_Rpc_FollowMe_Config {
            var rpcConfig = Mavsdk_Rpc_FollowMe_Config()
            
                
            rpcConfig.minHeightM = minHeightM
                
            
            
                
            rpcConfig.followDistanceM = followDistanceM
                
            
            
                
            rpcConfig.followDirection = followDirection.rpcFollowDirection
                
            
            
                
            rpcConfig.responsiveness = responsiveness
                
            

            return rpcConfig
        }

        internal static func translateFromRpc(_ rpcConfig: Mavsdk_Rpc_FollowMe_Config) -> Config {
            return Config(minHeightM: rpcConfig.minHeightM, followDistanceM: rpcConfig.followDistanceM, followDirection: FollowDirection.translateFromRpc(rpcConfig.followDirection), responsiveness: rpcConfig.responsiveness)
        }

        public static func == (lhs: Config, rhs: Config) -> Bool {
            return lhs.minHeightM == rhs.minHeightM
                && lhs.followDistanceM == rhs.followDistanceM
                && lhs.followDirection == rhs.followDirection
                && lhs.responsiveness == rhs.responsiveness
        }
    }

    public struct TargetLocation: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float
        public let velocityXMS: Float
        public let velocityYMS: Float
        public let velocityZMS: Float

        

        public init(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, velocityXMS: Float, velocityYMS: Float, velocityZMS: Float) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.absoluteAltitudeM = absoluteAltitudeM
            self.velocityXMS = velocityXMS
            self.velocityYMS = velocityYMS
            self.velocityZMS = velocityZMS
        }

        internal var rpcTargetLocation: Mavsdk_Rpc_FollowMe_TargetLocation {
            var rpcTargetLocation = Mavsdk_Rpc_FollowMe_TargetLocation()
            
                
            rpcTargetLocation.latitudeDeg = latitudeDeg
                
            
            
                
            rpcTargetLocation.longitudeDeg = longitudeDeg
                
            
            
                
            rpcTargetLocation.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcTargetLocation.velocityXMS = velocityXMS
                
            
            
                
            rpcTargetLocation.velocityYMS = velocityYMS
                
            
            
                
            rpcTargetLocation.velocityZMS = velocityZMS
                
            

            return rpcTargetLocation
        }

        internal static func translateFromRpc(_ rpcTargetLocation: Mavsdk_Rpc_FollowMe_TargetLocation) -> TargetLocation {
            return TargetLocation(latitudeDeg: rpcTargetLocation.latitudeDeg, longitudeDeg: rpcTargetLocation.longitudeDeg, absoluteAltitudeM: rpcTargetLocation.absoluteAltitudeM, velocityXMS: rpcTargetLocation.velocityXMS, velocityYMS: rpcTargetLocation.velocityYMS, velocityZMS: rpcTargetLocation.velocityZMS)
        }

        public static func == (lhs: TargetLocation, rhs: TargetLocation) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
                && lhs.velocityXMS == rhs.velocityXMS
                && lhs.velocityYMS == rhs.velocityYMS
                && lhs.velocityZMS == rhs.velocityZMS
        }
    }

    public struct FollowMeResult: Equatable {
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
            case notActive
            case setConfigFailed
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_FollowMe_FollowMeResult.Result {
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
                case .notActive:
                    return .notActive
                case .setConfigFailed:
                    return .setConfigFailed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_FollowMe_FollowMeResult.Result) -> Result {
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
                case .notActive:
                    return .notActive
                case .setConfigFailed:
                    return .setConfigFailed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcFollowMeResult: Mavsdk_Rpc_FollowMe_FollowMeResult {
            var rpcFollowMeResult = Mavsdk_Rpc_FollowMe_FollowMeResult()
            
                
            rpcFollowMeResult.result = result.rpcResult
                
            
            
                
            rpcFollowMeResult.resultStr = resultStr
                
            

            return rpcFollowMeResult
        }

        internal static func translateFromRpc(_ rpcFollowMeResult: Mavsdk_Rpc_FollowMe_FollowMeResult) -> FollowMeResult {
            return FollowMeResult(result: Result.translateFromRpc(rpcFollowMeResult.result), resultStr: rpcFollowMeResult.resultStr)
        }

        public static func == (lhs: FollowMeResult, rhs: FollowMeResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func getConfig() -> Single<Config> {
        return Single<Config>.create { single in
            let request = Mavsdk_Rpc_FollowMe_GetConfigRequest()

            

            do {
                let response = try self.service.getConfig(request)

                

                
                    let config = Config.translateFromRpc(response.config)
                
                single(.success(config))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setConfig(config: Config) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_FollowMe_SetConfigRequest()

            
                
            request.config = config.rpcConfig
                
            

            do {
                
                let response = try self.service.setConfig(request)

                if (response.followMeResult.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(response.followMeResult.result), description: response.followMeResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func isActive() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = Mavsdk_Rpc_FollowMe_IsActiveRequest()

            

            do {
                let response = try self.service.isActive(request)

                

                let isActive = response.isActive
                
                single(.success(isActive))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setTargetLocation(location: TargetLocation) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_FollowMe_SetTargetLocationRequest()

            
                
            request.location = location.rpcTargetLocation
                
            

            do {
                
                let response = try self.service.setTargetLocation(request)

                if (response.followMeResult.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(response.followMeResult.result), description: response.followMeResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getLastLocation() -> Single<TargetLocation> {
        return Single<TargetLocation>.create { single in
            let request = Mavsdk_Rpc_FollowMe_GetLastLocationRequest()

            

            do {
                let response = try self.service.getLastLocation(request)

                

                
                    let location = TargetLocation.translateFromRpc(response.location)
                
                single(.success(location))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func start() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_FollowMe_StartRequest()

            

            do {
                
                let response = try self.service.start(request)

                if (response.followMeResult.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(response.followMeResult.result), description: response.followMeResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func stop() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_FollowMe_StopRequest()

            

            do {
                
                let response = try self.service.stop(request)

                if (response.followMeResult.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(response.followMeResult.result), description: response.followMeResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}