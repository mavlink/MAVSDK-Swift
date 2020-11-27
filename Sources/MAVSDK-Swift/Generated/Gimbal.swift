import Foundation
import RxSwift
import GRPC
import NIO

/**
 Provide control over a gimbal.
 */
public class Gimbal {
    private let service: Mavsdk_Rpc_Gimbal_GimbalServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Gimbal` plugin.

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
        let service = Mavsdk_Rpc_Gimbal_GimbalServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Gimbal_GimbalServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
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
    

    /**
     Gimbal mode type.
     */
    public enum GimbalMode: Equatable {
        ///  Yaw follow will point the gimbal to the vehicle heading.
        case yawFollow
        ///  Yaw lock will fix the gimbal poiting to an absolute direction.
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


    /**
     Result type.
     */
    public struct GimbalResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for gimbal commands.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Command was accepted.
            case success
            ///  Error occurred sending the command.
            case error
            ///  Command timed out.
            case timeout
            ///  Functionality not supported.
            case unsupported
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
                case .unsupported:
                    return .unsupported
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
                case .unsupported:
                    return .unsupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `GimbalResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
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


    /**
     Set gimbal pitch and yaw angles.

     This sets the desired pitch and yaw angles of a gimbal.
     Will return when the command is accepted, however, it might
     take the gimbal longer to actually be set to the new angles.

     - Parameters:
        - pitchDeg: Pitch angle in degrees (negative points down)
        - yawDeg: Yaw angle in degrees (positive is clock-wise, range: -180 to 180 or 0 to 360)
     
     */
    public func setPitchAndYaw(pitchDeg: Float, yawDeg: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetPitchAndYawRequest()

            
                
            request.pitchDeg = pitchDeg
                
            
                
            request.yawDeg = yawDeg
                
            

            do {
                
                let response = self.service.setPitchAndYaw(request)

                let result = try response.response.wait().gimbalResult
                if (result.result == Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GimbalError(code: GimbalResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set gimbal mode.

     This sets the desired yaw mode of a gimbal.
     Will return when the command is accepted. However, it might
     take the gimbal longer to actually be set to the new angles.

     - Parameter gimbalMode: The mode to be set.
     
     */
    public func setMode(gimbalMode: GimbalMode) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetModeRequest()

            
                
            request.gimbalMode = gimbalMode.rpcGimbalMode
                
            

            do {
                
                let response = self.service.setMode(request)

                let result = try response.response.wait().gimbalResult
                if (result.result == Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GimbalError(code: GimbalResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set gimbal region of interest (ROI).

     This sets a region of interest that the gimbal will point to.
     The gimbal will continue to point to the specified region until it
     receives a new command.
     The function will return when the command is accepted, however, it might
     take the gimbal longer to actually rotate to the ROI.

     - Parameters:
        - latitudeDeg: Latitude in degrees
        - longitudeDeg: Longitude in degrees
        - altitudeM: Altitude in metres (AMSL)
     
     */
    public func setRoiLocation(latitudeDeg: Double, longitudeDeg: Double, altitudeM: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetRoiLocationRequest()

            
                
            request.latitudeDeg = latitudeDeg
                
            
                
            request.longitudeDeg = longitudeDeg
                
            
                
            request.altitudeM = altitudeM
                
            

            do {
                
                let response = self.service.setRoiLocation(request)

                let result = try response.response.wait().gimbalResult
                if (result.result == Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GimbalError(code: GimbalResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}