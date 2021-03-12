import Foundation
import RxSwift
import GRPC
import NIO

/**
 Allow users to command the vehicle to follow a specific target.
 The target is provided as a GPS coordinate and altitude.
 */
public class FollowMe {
    private let service: Mavsdk_Rpc_FollowMe_FollowMeServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `FollowMe` plugin.

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
        let service = Mavsdk_Rpc_FollowMe_FollowMeServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_FollowMe_FollowMeServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
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
    


    /**
     Configuration type.
     */
    public struct Config: Equatable {
        public let minHeightM: Float
        public let followDistanceM: Float
        public let followDirection: FollowDirection
        public let responsiveness: Float

        
        

        /**
         Direction relative to the target that the vehicle should follow
         */
        public enum FollowDirection: Equatable {
            ///  Do not follow.
            case none
            ///  Follow from behind.
            case behind
            ///  Follow from front.
            case front
            ///  Follow from front right.
            case frontRight
            ///  Follow from front left.
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
        

        /**
         Initializes a new `Config`.

         
         - Parameters:
            
            - minHeightM:  Minimum height for the vehicle in meters (recommended minimum 8 meters)
            
            - followDistanceM:  Distance from target for vehicle to follow in meters (recommended minimum 1 meter)
            
            - followDirection:  Direction to follow in
            
            - responsiveness:  How responsive the vehicle is to the motion of the target (range 0.0 to 1.0)
            
         
         */
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

    /**
     Target location for the vehicle to follow
     */
    public struct TargetLocation: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float
        public let velocityXMS: Float
        public let velocityYMS: Float
        public let velocityZMS: Float

        

        /**
         Initializes a new `TargetLocation`.

         
         - Parameters:
            
            - latitudeDeg:  Target latitude in degrees
            
            - longitudeDeg:  Target longitude in degrees
            
            - absoluteAltitudeM:  Target altitude in meters above MSL
            
            - velocityXMS:  Target velocity in X axis, in meters per second
            
            - velocityYMS:  Target velocity in Y axis, in meters per second
            
            - velocityZMS:  Target velocity in Z axis, in meters per second
            
         
         */
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

    /**
     
     */
    public struct FollowMeResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for followme operations
         */
        public enum Result: Equatable {
            ///  Unkown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  No system connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command denied.
            case commandDenied
            ///  Request timed out.
            case timeout
            ///  FollowMe is not active.
            case notActive
            ///  Failed to set FollowMe configuration.
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
        

        /**
         Initializes a new `FollowMeResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
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


    /**
     Get current configuration.

     
     */
    public func getConfig() -> Single<Config> {
        return Single<Config>.create { single in
            let request = Mavsdk_Rpc_FollowMe_GetConfigRequest()

            

            do {
                let response = self.service.getConfig(request)

                

    	    
                    let config = try Config.translateFromRpc(response.response.wait().config)
                
                single(.success(config))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Apply configuration by sending it to the system.

     - Parameter config: The new configuration to be set
     
     */
    public func setConfig(config: Config) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_FollowMe_SetConfigRequest()

            
                
            request.config = config.rpcConfig
                
            

            do {
                
                let response = self.service.setConfig(request)

                let result = try response.response.wait().followMeResult
                if (result.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Check if FollowMe is active.

     
     */
    public func isActive() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = Mavsdk_Rpc_FollowMe_IsActiveRequest()

            

            do {
                let response = self.service.isActive(request)

                

    	    let isActive = try response.response.wait().isActive
                
                single(.success(isActive))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set location of the moving target.

     - Parameter location: The new TargetLocation to follow
     
     */
    public func setTargetLocation(location: TargetLocation) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_FollowMe_SetTargetLocationRequest()

            
                
            request.location = location.rpcTargetLocation
                
            

            do {
                
                let response = self.service.setTargetLocation(request)

                let result = try response.response.wait().followMeResult
                if (result.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the last location of the target.

     
     */
    public func getLastLocation() -> Single<TargetLocation> {
        return Single<TargetLocation>.create { single in
            let request = Mavsdk_Rpc_FollowMe_GetLastLocationRequest()

            

            do {
                let response = self.service.getLastLocation(request)

                

    	    
                    let location = try TargetLocation.translateFromRpc(response.response.wait().location)
                
                single(.success(location))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start FollowMe mode.

     
     */
    public func start() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_FollowMe_StartRequest()

            

            do {
                
                let response = self.service.start(request)

                let result = try response.response.wait().followMeResult
                if (result.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop FollowMe mode.

     
     */
    public func stop() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_FollowMe_StopRequest()

            

            do {
                
                let response = self.service.stop(request)

                let result = try response.response.wait().followMeResult
                if (result.result == Mavsdk_Rpc_FollowMe_FollowMeResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FollowMeError(code: FollowMeResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}