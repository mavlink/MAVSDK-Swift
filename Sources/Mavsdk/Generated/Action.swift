import Foundation
import RxSwift
import GRPC
import NIO

/**
 Enable simple actions such as arming, taking off, and landing.
 */
public class Action {
    private let service: Mavsdk_Rpc_Action_ActionServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Action` plugin.

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
        let service = Mavsdk_Rpc_Action_ActionServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Action_ActionServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeActionError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ActionError: Error {
        public let code: Action.ActionResult.Result
        public let description: String
    }
    

    /**
     Yaw behaviour during orbit flight.
     */
    public enum OrbitYawBehavior: Equatable {
        ///  Vehicle front points to the center (default).
        case holdFrontToCircleCenter
        ///  Vehicle front holds heading when message received.
        case holdInitialHeading
        ///  Yaw uncontrolled.
        case uncontrolled
        ///  Vehicle front follows flight path (tangential to circle).
        case holdFrontTangentToCircle
        ///  Yaw controlled by RC input.
        case rcControlled
        case UNRECOGNIZED(Int)

        internal var rpcOrbitYawBehavior: Mavsdk_Rpc_Action_OrbitYawBehavior {
            switch self {
            case .holdFrontToCircleCenter:
                return .holdFrontToCircleCenter
            case .holdInitialHeading:
                return .holdInitialHeading
            case .uncontrolled:
                return .uncontrolled
            case .holdFrontTangentToCircle:
                return .holdFrontTangentToCircle
            case .rcControlled:
                return .rcControlled
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcOrbitYawBehavior: Mavsdk_Rpc_Action_OrbitYawBehavior) -> OrbitYawBehavior {
            switch rpcOrbitYawBehavior {
            case .holdFrontToCircleCenter:
                return .holdFrontToCircleCenter
            case .holdInitialHeading:
                return .holdInitialHeading
            case .uncontrolled:
                return .uncontrolled
            case .holdFrontTangentToCircle:
                return .holdFrontTangentToCircle
            case .rcControlled:
                return .rcControlled
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Result type.
     */
    public struct ActionResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for action requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request was successful.
            case success
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command refused by vehicle.
            case commandDenied
            ///  Command refused because landed state is unknown.
            case commandDeniedLandedStateUnknown
            ///  Command refused because vehicle not landed.
            case commandDeniedNotLanded
            ///  Request timed out.
            case timeout
            ///  Hybrid/VTOL transition support is unknown.
            case vtolTransitionSupportUnknown
            ///  Vehicle does not support hybrid/VTOL transitions.
            case noVtolTransitionSupport
            ///  Error getting or setting parameter.
            case parameterError
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Action_ActionResult.Result {
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
                case .commandDeniedLandedStateUnknown:
                    return .commandDeniedLandedStateUnknown
                case .commandDeniedNotLanded:
                    return .commandDeniedNotLanded
                case .timeout:
                    return .timeout
                case .vtolTransitionSupportUnknown:
                    return .vtolTransitionSupportUnknown
                case .noVtolTransitionSupport:
                    return .noVtolTransitionSupport
                case .parameterError:
                    return .parameterError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Action_ActionResult.Result) -> Result {
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
                case .commandDeniedLandedStateUnknown:
                    return .commandDeniedLandedStateUnknown
                case .commandDeniedNotLanded:
                    return .commandDeniedNotLanded
                case .timeout:
                    return .timeout
                case .vtolTransitionSupportUnknown:
                    return .vtolTransitionSupportUnknown
                case .noVtolTransitionSupport:
                    return .noVtolTransitionSupport
                case .parameterError:
                    return .parameterError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ActionResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcActionResult: Mavsdk_Rpc_Action_ActionResult {
            var rpcActionResult = Mavsdk_Rpc_Action_ActionResult()
            
                
            rpcActionResult.result = result.rpcResult
                
            
            
                
            rpcActionResult.resultStr = resultStr
                
            

            return rpcActionResult
        }

        internal static func translateFromRpc(_ rpcActionResult: Mavsdk_Rpc_Action_ActionResult) -> ActionResult {
            return ActionResult(result: Result.translateFromRpc(rpcActionResult.result), resultStr: rpcActionResult.resultStr)
        }

        public static func == (lhs: ActionResult, rhs: ActionResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Send command to arm the drone.

     Arming a drone normally causes motors to spin at idle.
     Before arming take all safety precautions and stand clear of the drone!

     
     */
    public func arm() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_ArmRequest()

            

            do {
                
                let response = self.service.arm(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to disarm the drone.

     This will disarm a drone that considers itself landed. If flying, the drone should
     reject the disarm command. Disarming means that all motors will stop.

     
     */
    public func disarm() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_DisarmRequest()

            

            do {
                
                let response = self.service.disarm(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to take off and hover.

     This switches the drone into position control mode and commands
     it to take off and hover at the takeoff altitude.

     Note that the vehicle must be armed before it can take off.

     
     */
    public func takeoff() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TakeoffRequest()

            

            do {
                
                let response = self.service.takeoff(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to land at the current position.

     This switches the drone to 'Land' flight mode.

     
     */
    public func land() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_LandRequest()

            

            do {
                
                let response = self.service.land(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to reboot the drone components.

     This will reboot the autopilot, companion computer, camera and gimbal.

     
     */
    public func reboot() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_RebootRequest()

            

            do {
                
                let response = self.service.reboot(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to shut down the drone components.

     This will shut down the autopilot, onboard computer, camera and gimbal.
     This command should only be used when the autopilot is disarmed and autopilots commonly
     reject it if they are not already ready to shut down.

     
     */
    public func shutdown() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_ShutdownRequest()

            

            do {
                
                let response = self.service.shutdown(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to terminate the drone.

     This will run the terminate routine as configured on the drone (e.g. disarm and open the parachute).

     
     */
    public func terminate() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TerminateRequest()

            

            do {
                
                let response = self.service.terminate(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to kill the drone.

     This will disarm a drone irrespective of whether it is landed or flying.
     Note that the drone will fall out of the sky if this command is used while flying.

     
     */
    public func kill() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_KillRequest()

            

            do {
                
                let response = self.service.kill(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to return to the launch (takeoff) position and land.

     This switches the drone into [Return mode](https://docs.px4.io/master/en/flight_modes/return.html) which
     generally means it will rise up to a certain altitude to clear any obstacles before heading
     back to the launch (takeoff) position and land there.

     
     */
    public func returnToLaunch() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_ReturnToLaunchRequest()

            

            do {
                
                let response = self.service.returnToLaunch(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to move the vehicle to a specific global position.

     The latitude and longitude are given in degrees (WGS84 frame) and the altitude
     in meters AMSL (above mean sea level).

     The yaw angle is in degrees (frame is NED, 0 is North, positive is clockwise).

     - Parameters:
        - latitudeDeg: Latitude (in degrees)
        - longitudeDeg: Longitude (in degrees)
        - absoluteAltitudeM: Altitude AMSL (in meters)
        - yawDeg: Yaw angle (in degrees, frame is NED, 0 is North, positive is clockwise)
     
     */
    public func gotoLocation(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, yawDeg: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_GotoLocationRequest()

            
                
            request.latitudeDeg = latitudeDeg
                
            
                
            request.longitudeDeg = longitudeDeg
                
            
                
            request.absoluteAltitudeM = absoluteAltitudeM
                
            
                
            request.yawDeg = yawDeg
                
            

            do {
                
                let response = self.service.gotoLocation(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command do orbit to the drone.

     This will run the orbit routine with the given parameters.

     - Parameters:
        - radiusM: Radius of circle (in meters)
        - velocityMs: Tangential velocity (in m/s)
        - yawBehavior: Yaw behavior of vehicle (ORBIT_YAW_BEHAVIOUR)
        - latitudeDeg: Center point latitude in degrees. NAN: use current latitude for center
        - longitudeDeg: Center point longitude in degrees. NAN: use current longitude for center
        - absoluteAltitudeM: Center point altitude in meters. NAN: use current altitude for center
     
     */
    public func doOrbit(radiusM: Float, velocityMs: Float, yawBehavior: OrbitYawBehavior, latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_DoOrbitRequest()

            
                
            request.radiusM = radiusM
                
            
                
            request.velocityMs = velocityMs
                
            
                
            request.yawBehavior = yawBehavior.rpcOrbitYawBehavior
                
            
                
            request.latitudeDeg = latitudeDeg
                
            
                
            request.longitudeDeg = longitudeDeg
                
            
                
            request.absoluteAltitudeM = absoluteAltitudeM
                
            

            do {
                
                let response = self.service.doOrbit(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to hold position (a.k.a. "Loiter").

     Sends a command to drone to change to Hold flight mode, causing the
     vehicle to stop and maintain its current GPS position and altitude.

     Note: this command is specific to the PX4 Autopilot flight stack as
     it implies a change to a PX4-specific mode.

     
     */
    public func hold() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_HoldRequest()

            

            do {
                
                let response = self.service.hold(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to transition the drone to fixedwing.

     The associated action will only be executed for VTOL vehicles (on other vehicle types the
     command will fail). The command will succeed if called when the vehicle
     is already in fixedwing mode.

     
     */
    public func transitionToFixedwing() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TransitionToFixedwingRequest()

            

            do {
                
                let response = self.service.transitionToFixedwing(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Send command to transition the drone to multicopter.

     The associated action will only be executed for VTOL vehicles (on other vehicle types the
     command will fail). The command will succeed if called when the vehicle
     is already in multicopter mode.

     
     */
    public func transitionToMulticopter() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Action_TransitionToMulticopterRequest()

            

            do {
                
                let response = self.service.transitionToMulticopter(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the takeoff altitude (in meters above ground).

     
     */
    public func getTakeoffAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let request = Mavsdk_Rpc_Action_GetTakeoffAltitudeRequest()

            

            do {
                let response = self.service.getTakeoffAltitude(request)

                
                let result = try response.response.wait().actionResult
                if (result.result != Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let altitude = try response.response.wait().altitude
                
                single(.success(altitude))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set takeoff altitude (in meters above ground).

     - Parameter altitude: Takeoff altitude relative to ground/takeoff location (in meters)
     
     */
    public func setTakeoffAltitude(altitude: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_SetTakeoffAltitudeRequest()

            
                
            request.altitude = altitude
                
            

            do {
                
                let response = self.service.setTakeoffAltitude(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the vehicle maximum speed (in metres/second).

     
     */
    public func getMaximumSpeed() -> Single<Float> {
        return Single<Float>.create { single in
            let request = Mavsdk_Rpc_Action_GetMaximumSpeedRequest()

            

            do {
                let response = self.service.getMaximumSpeed(request)

                
                let result = try response.response.wait().actionResult
                if (result.result != Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let speed = try response.response.wait().speed
                
                single(.success(speed))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set vehicle maximum speed (in metres/second).

     - Parameter speed: Maximum speed (in metres/second)
     
     */
    public func setMaximumSpeed(speed: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_SetMaximumSpeedRequest()

            
                
            request.speed = speed
                
            

            do {
                
                let response = self.service.setMaximumSpeed(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the return to launch minimum return altitude (in meters).

     
     */
    public func getReturnToLaunchAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let request = Mavsdk_Rpc_Action_GetReturnToLaunchAltitudeRequest()

            

            do {
                let response = self.service.getReturnToLaunchAltitude(request)

                
                let result = try response.response.wait().actionResult
                if (result.result != Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    single(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let relativeAltitudeM = try response.response.wait().relativeAltitudeM
                
                single(.success(relativeAltitudeM))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the return to launch minimum return altitude (in meters).

     - Parameter relativeAltitudeM: Return altitude relative to takeoff location (in meters)
     
     */
    public func setReturnToLaunchAltitude(relativeAltitudeM: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Action_SetReturnToLaunchAltitudeRequest()

            
                
            request.relativeAltitudeM = relativeAltitudeM
                
            

            do {
                
                let response = self.service.setReturnToLaunchAltitude(request)

                let result = try response.response.wait().actionResult
                if (result.result == Mavsdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ActionError(code: ActionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}