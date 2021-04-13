import Foundation
import RxSwift
import GRPC
import NIO

/**
 *
 Control a drone with position, velocity, attitude or motor commands.

 The module is called offboard because the commands can be sent from external sources
 as opposed to onboard control right inside the autopilot "board".

 Client code must specify a setpoint before starting offboard mode.
 Mavsdk automatically sends setpoints at 20Hz (PX4 Offboard mode requires that setpoints
 are minimally sent at 2Hz).
 */
public class Offboard {
    private let service: Mavsdk_Rpc_Offboard_OffboardServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Offboard` plugin.

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
        let service = Mavsdk_Rpc_Offboard_OffboardServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Offboard_OffboardServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeOffboardError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct OffboardError: Error {
        public let code: Offboard.OffboardResult.Result
        public let description: String
    }
    


    /**
     Type for attitude body angles in NED reference frame (roll, pitch, yaw and thrust)
     */
    public struct Attitude: Equatable {
        public let rollDeg: Float
        public let pitchDeg: Float
        public let yawDeg: Float
        public let thrustValue: Float

        

        /**
         Initializes a new `Attitude`.

         
         - Parameters:
            
            - rollDeg:  Roll angle (in degrees, positive is right side down)
            
            - pitchDeg:  Pitch angle (in degrees, positive is nose up)
            
            - yawDeg:  Yaw angle (in degrees, positive is move nose to the right)
            
            - thrustValue:  Thrust (range: 0 to 1)
            
         
         */
        public init(rollDeg: Float, pitchDeg: Float, yawDeg: Float, thrustValue: Float) {
            self.rollDeg = rollDeg
            self.pitchDeg = pitchDeg
            self.yawDeg = yawDeg
            self.thrustValue = thrustValue
        }

        internal var rpcAttitude: Mavsdk_Rpc_Offboard_Attitude {
            var rpcAttitude = Mavsdk_Rpc_Offboard_Attitude()
            
                
            rpcAttitude.rollDeg = rollDeg
                
            
            
                
            rpcAttitude.pitchDeg = pitchDeg
                
            
            
                
            rpcAttitude.yawDeg = yawDeg
                
            
            
                
            rpcAttitude.thrustValue = thrustValue
                
            

            return rpcAttitude
        }

        internal static func translateFromRpc(_ rpcAttitude: Mavsdk_Rpc_Offboard_Attitude) -> Attitude {
            return Attitude(rollDeg: rpcAttitude.rollDeg, pitchDeg: rpcAttitude.pitchDeg, yawDeg: rpcAttitude.yawDeg, thrustValue: rpcAttitude.thrustValue)
        }

        public static func == (lhs: Attitude, rhs: Attitude) -> Bool {
            return lhs.rollDeg == rhs.rollDeg
                && lhs.pitchDeg == rhs.pitchDeg
                && lhs.yawDeg == rhs.yawDeg
                && lhs.thrustValue == rhs.thrustValue
        }
    }

    /**
     Eight controls that will be given to the group. Each control is a normalized
     (-1..+1) command value, which will be mapped and scaled through the mixer.
     */
    public struct ActuatorControlGroup: Equatable {
        public let controls: [Float]

        

        /**
         Initializes a new `ActuatorControlGroup`.

         
         - Parameter controls:  Controls in the group
         
         */
        public init(controls: [Float]) {
            self.controls = controls
        }

        internal var rpcActuatorControlGroup: Mavsdk_Rpc_Offboard_ActuatorControlGroup {
            var rpcActuatorControlGroup = Mavsdk_Rpc_Offboard_ActuatorControlGroup()
            
                
            rpcActuatorControlGroup.controls = controls
                
            

            return rpcActuatorControlGroup
        }

        internal static func translateFromRpc(_ rpcActuatorControlGroup: Mavsdk_Rpc_Offboard_ActuatorControlGroup) -> ActuatorControlGroup {
            return ActuatorControlGroup(controls: rpcActuatorControlGroup.controls)
        }

        public static func == (lhs: ActuatorControlGroup, rhs: ActuatorControlGroup) -> Bool {
            return lhs.controls == rhs.controls
        }
    }

    /**
     Type for actuator control.

     Control members should be normed to -1..+1 where 0 is neutral position.
     Throttle for single rotation direction motors is 0..1, negative range for reverse direction.

     One group support eight controls.

     Up to 16 actuator controls can be set. To ignore an output group, set all it conrols to NaN.
     If one or more controls in group is not NaN, then all NaN controls will sent as zero.
     The first 8 actuator controls internally map to control group 0, the latter 8 actuator
     controls map to control group 1. Depending on what controls are set (instead of NaN) 1 or 2
     MAVLink messages are actually sent.

     In PX4 v1.9.0 Only first four Control Groups are supported
     (https://github.com/PX4/Firmware/blob/v1.9.0/src/modules/mavlink/mavlink_receiver.cpp#L980).
     */
    public struct ActuatorControl: Equatable {
        public let groups: [ActuatorControlGroup]

        

        /**
         Initializes a new `ActuatorControl`.

         
         - Parameter groups:  Control groups.
         
         */
        public init(groups: [ActuatorControlGroup]) {
            self.groups = groups
        }

        internal var rpcActuatorControl: Mavsdk_Rpc_Offboard_ActuatorControl {
            var rpcActuatorControl = Mavsdk_Rpc_Offboard_ActuatorControl()
            
                
            rpcActuatorControl.groups = groups.map{ $0.rpcActuatorControlGroup }
                
            

            return rpcActuatorControl
        }

        internal static func translateFromRpc(_ rpcActuatorControl: Mavsdk_Rpc_Offboard_ActuatorControl) -> ActuatorControl {
            return ActuatorControl(groups: rpcActuatorControl.groups.map{ ActuatorControlGroup.translateFromRpc($0) })
        }

        public static func == (lhs: ActuatorControl, rhs: ActuatorControl) -> Bool {
            return lhs.groups == rhs.groups
        }
    }

    /**
     Type for attitude rate commands in body coordinates (roll, pitch, yaw angular rate and thrust)
     */
    public struct AttitudeRate: Equatable {
        public let rollDegS: Float
        public let pitchDegS: Float
        public let yawDegS: Float
        public let thrustValue: Float

        

        /**
         Initializes a new `AttitudeRate`.

         
         - Parameters:
            
            - rollDegS:  Roll angular rate (in degrees/second, positive for clock-wise looking from front)
            
            - pitchDegS:  Pitch angular rate (in degrees/second, positive for head/front moving up)
            
            - yawDegS:  Yaw angular rate (in degrees/second, positive for clock-wise looking from above)
            
            - thrustValue:  Thrust (range: 0 to 1)
            
         
         */
        public init(rollDegS: Float, pitchDegS: Float, yawDegS: Float, thrustValue: Float) {
            self.rollDegS = rollDegS
            self.pitchDegS = pitchDegS
            self.yawDegS = yawDegS
            self.thrustValue = thrustValue
        }

        internal var rpcAttitudeRate: Mavsdk_Rpc_Offboard_AttitudeRate {
            var rpcAttitudeRate = Mavsdk_Rpc_Offboard_AttitudeRate()
            
                
            rpcAttitudeRate.rollDegS = rollDegS
                
            
            
                
            rpcAttitudeRate.pitchDegS = pitchDegS
                
            
            
                
            rpcAttitudeRate.yawDegS = yawDegS
                
            
            
                
            rpcAttitudeRate.thrustValue = thrustValue
                
            

            return rpcAttitudeRate
        }

        internal static func translateFromRpc(_ rpcAttitudeRate: Mavsdk_Rpc_Offboard_AttitudeRate) -> AttitudeRate {
            return AttitudeRate(rollDegS: rpcAttitudeRate.rollDegS, pitchDegS: rpcAttitudeRate.pitchDegS, yawDegS: rpcAttitudeRate.yawDegS, thrustValue: rpcAttitudeRate.thrustValue)
        }

        public static func == (lhs: AttitudeRate, rhs: AttitudeRate) -> Bool {
            return lhs.rollDegS == rhs.rollDegS
                && lhs.pitchDegS == rhs.pitchDegS
                && lhs.yawDegS == rhs.yawDegS
                && lhs.thrustValue == rhs.thrustValue
        }
    }

    /**
     Type for position commands in NED (North East Down) coordinates and yaw.
     */
    public struct PositionNedYaw: Equatable {
        public let northM: Float
        public let eastM: Float
        public let downM: Float
        public let yawDeg: Float

        

        /**
         Initializes a new `PositionNedYaw`.

         
         - Parameters:
            
            - northM:  Position North (in metres)
            
            - eastM:  Position East (in metres)
            
            - downM:  Position Down (in metres)
            
            - yawDeg:  Yaw in degrees (0 North, positive is clock-wise looking from above)
            
         
         */
        public init(northM: Float, eastM: Float, downM: Float, yawDeg: Float) {
            self.northM = northM
            self.eastM = eastM
            self.downM = downM
            self.yawDeg = yawDeg
        }

        internal var rpcPositionNedYaw: Mavsdk_Rpc_Offboard_PositionNedYaw {
            var rpcPositionNedYaw = Mavsdk_Rpc_Offboard_PositionNedYaw()
            
                
            rpcPositionNedYaw.northM = northM
                
            
            
                
            rpcPositionNedYaw.eastM = eastM
                
            
            
                
            rpcPositionNedYaw.downM = downM
                
            
            
                
            rpcPositionNedYaw.yawDeg = yawDeg
                
            

            return rpcPositionNedYaw
        }

        internal static func translateFromRpc(_ rpcPositionNedYaw: Mavsdk_Rpc_Offboard_PositionNedYaw) -> PositionNedYaw {
            return PositionNedYaw(northM: rpcPositionNedYaw.northM, eastM: rpcPositionNedYaw.eastM, downM: rpcPositionNedYaw.downM, yawDeg: rpcPositionNedYaw.yawDeg)
        }

        public static func == (lhs: PositionNedYaw, rhs: PositionNedYaw) -> Bool {
            return lhs.northM == rhs.northM
                && lhs.eastM == rhs.eastM
                && lhs.downM == rhs.downM
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    /**
     Type for velocity commands in body coordinates.
     */
    public struct VelocityBodyYawspeed: Equatable {
        public let forwardMS: Float
        public let rightMS: Float
        public let downMS: Float
        public let yawspeedDegS: Float

        

        /**
         Initializes a new `VelocityBodyYawspeed`.

         
         - Parameters:
            
            - forwardMS:  Velocity forward (in metres/second)
            
            - rightMS:  Velocity right (in metres/second)
            
            - downMS:  Velocity down (in metres/second)
            
            - yawspeedDegS:  Yaw angular rate (in degrees/second, positive for clock-wise looking from above)
            
         
         */
        public init(forwardMS: Float, rightMS: Float, downMS: Float, yawspeedDegS: Float) {
            self.forwardMS = forwardMS
            self.rightMS = rightMS
            self.downMS = downMS
            self.yawspeedDegS = yawspeedDegS
        }

        internal var rpcVelocityBodyYawspeed: Mavsdk_Rpc_Offboard_VelocityBodyYawspeed {
            var rpcVelocityBodyYawspeed = Mavsdk_Rpc_Offboard_VelocityBodyYawspeed()
            
                
            rpcVelocityBodyYawspeed.forwardMS = forwardMS
                
            
            
                
            rpcVelocityBodyYawspeed.rightMS = rightMS
                
            
            
                
            rpcVelocityBodyYawspeed.downMS = downMS
                
            
            
                
            rpcVelocityBodyYawspeed.yawspeedDegS = yawspeedDegS
                
            

            return rpcVelocityBodyYawspeed
        }

        internal static func translateFromRpc(_ rpcVelocityBodyYawspeed: Mavsdk_Rpc_Offboard_VelocityBodyYawspeed) -> VelocityBodyYawspeed {
            return VelocityBodyYawspeed(forwardMS: rpcVelocityBodyYawspeed.forwardMS, rightMS: rpcVelocityBodyYawspeed.rightMS, downMS: rpcVelocityBodyYawspeed.downMS, yawspeedDegS: rpcVelocityBodyYawspeed.yawspeedDegS)
        }

        public static func == (lhs: VelocityBodyYawspeed, rhs: VelocityBodyYawspeed) -> Bool {
            return lhs.forwardMS == rhs.forwardMS
                && lhs.rightMS == rhs.rightMS
                && lhs.downMS == rhs.downMS
                && lhs.yawspeedDegS == rhs.yawspeedDegS
        }
    }

    /**
     Type for velocity commands in NED (North East Down) coordinates and yaw.
     */
    public struct VelocityNedYaw: Equatable {
        public let northMS: Float
        public let eastMS: Float
        public let downMS: Float
        public let yawDeg: Float

        

        /**
         Initializes a new `VelocityNedYaw`.

         
         - Parameters:
            
            - northMS:  Velocity North (in metres/second)
            
            - eastMS:  Velocity East (in metres/second)
            
            - downMS:  Velocity Down (in metres/second)
            
            - yawDeg:  Yaw in degrees (0 North, positive is clock-wise looking from above)
            
         
         */
        public init(northMS: Float, eastMS: Float, downMS: Float, yawDeg: Float) {
            self.northMS = northMS
            self.eastMS = eastMS
            self.downMS = downMS
            self.yawDeg = yawDeg
        }

        internal var rpcVelocityNedYaw: Mavsdk_Rpc_Offboard_VelocityNedYaw {
            var rpcVelocityNedYaw = Mavsdk_Rpc_Offboard_VelocityNedYaw()
            
                
            rpcVelocityNedYaw.northMS = northMS
                
            
            
                
            rpcVelocityNedYaw.eastMS = eastMS
                
            
            
                
            rpcVelocityNedYaw.downMS = downMS
                
            
            
                
            rpcVelocityNedYaw.yawDeg = yawDeg
                
            

            return rpcVelocityNedYaw
        }

        internal static func translateFromRpc(_ rpcVelocityNedYaw: Mavsdk_Rpc_Offboard_VelocityNedYaw) -> VelocityNedYaw {
            return VelocityNedYaw(northMS: rpcVelocityNedYaw.northMS, eastMS: rpcVelocityNedYaw.eastMS, downMS: rpcVelocityNedYaw.downMS, yawDeg: rpcVelocityNedYaw.yawDeg)
        }

        public static func == (lhs: VelocityNedYaw, rhs: VelocityNedYaw) -> Bool {
            return lhs.northMS == rhs.northMS
                && lhs.eastMS == rhs.eastMS
                && lhs.downMS == rhs.downMS
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    /**
     Type for acceleration commands in NED (North East Down) coordinates.
     */
    public struct AccelerationNed: Equatable {
        public let northMS2: Float
        public let eastMS2: Float
        public let downMS2: Float

        

        /**
         Initializes a new `AccelerationNed`.

         
         - Parameters:
            
            - northMS2:  Acceleration North (in metres/second^2)
            
            - eastMS2:  Acceleration East (in metres/second^2)
            
            - downMS2:  Acceleration Down (in metres/second^2)
            
         
         */
        public init(northMS2: Float, eastMS2: Float, downMS2: Float) {
            self.northMS2 = northMS2
            self.eastMS2 = eastMS2
            self.downMS2 = downMS2
        }

        internal var rpcAccelerationNed: Mavsdk_Rpc_Offboard_AccelerationNed {
            var rpcAccelerationNed = Mavsdk_Rpc_Offboard_AccelerationNed()
            
                
            rpcAccelerationNed.northMS2 = northMS2
                
            
            
                
            rpcAccelerationNed.eastMS2 = eastMS2
                
            
            
                
            rpcAccelerationNed.downMS2 = downMS2
                
            

            return rpcAccelerationNed
        }

        internal static func translateFromRpc(_ rpcAccelerationNed: Mavsdk_Rpc_Offboard_AccelerationNed) -> AccelerationNed {
            return AccelerationNed(northMS2: rpcAccelerationNed.northMS2, eastMS2: rpcAccelerationNed.eastMS2, downMS2: rpcAccelerationNed.downMS2)
        }

        public static func == (lhs: AccelerationNed, rhs: AccelerationNed) -> Bool {
            return lhs.northMS2 == rhs.northMS2
                && lhs.eastMS2 == rhs.eastMS2
                && lhs.downMS2 == rhs.downMS2
        }
    }

    /**
     Result type.
     */
    public struct OffboardResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for offboard requests
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command denied.
            case commandDenied
            ///  Request timed out.
            case timeout
            ///  Cannot start without setpoint set.
            case noSetpointSet
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Offboard_OffboardResult.Result {
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
                case .noSetpointSet:
                    return .noSetpointSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Offboard_OffboardResult.Result) -> Result {
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
                case .noSetpointSet:
                    return .noSetpointSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `OffboardResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcOffboardResult: Mavsdk_Rpc_Offboard_OffboardResult {
            var rpcOffboardResult = Mavsdk_Rpc_Offboard_OffboardResult()
            
                
            rpcOffboardResult.result = result.rpcResult
                
            
            
                
            rpcOffboardResult.resultStr = resultStr
                
            

            return rpcOffboardResult
        }

        internal static func translateFromRpc(_ rpcOffboardResult: Mavsdk_Rpc_Offboard_OffboardResult) -> OffboardResult {
            return OffboardResult(result: Result.translateFromRpc(rpcOffboardResult.result), resultStr: rpcOffboardResult.resultStr)
        }

        public static func == (lhs: OffboardResult, rhs: OffboardResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Start offboard control.

     
     */
    public func start() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Offboard_StartRequest()

            

            do {
                
                let response = self.service.start(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop offboard control.

     The vehicle will be put into Hold mode: https://docs.px4.io/en/flight_modes/hold.html

     
     */
    public func stop() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Offboard_StopRequest()

            

            do {
                
                let response = self.service.stop(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Check if offboard control is active.

     True means that the vehicle is in offboard mode and we are actively sending
     setpoints.

     
     */
    public func isActive() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = Mavsdk_Rpc_Offboard_IsActiveRequest()

            

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
     Set the attitude in terms of roll, pitch and yaw in degrees with thrust.

     - Parameter attitude: Attitude roll, pitch and yaw along with thrust
     
     */
    public func setAttitude(attitude: Attitude) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetAttitudeRequest()

            
                
            request.attitude = attitude.rpcAttitude
                
            

            do {
                
                let response = self.service.setAttitude(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set direct actuator control values to groups #0 and #1.

     First 8 controls will go to control group 0, the following 8 controls to control group 1 (if
     actuator_control.num_controls more than 8).

     - Parameter actuatorControl: Actuator control values
     
     */
    public func setActuatorControl(actuatorControl: ActuatorControl) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetActuatorControlRequest()

            
                
            request.actuatorControl = actuatorControl.rpcActuatorControl
                
            

            do {
                
                let response = self.service.setActuatorControl(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the attitude rate in terms of pitch, roll and yaw angular rate along with thrust.

     - Parameter attitudeRate: Attitude rate roll, pitch and yaw angular rate along with thrust
     
     */
    public func setAttitudeRate(attitudeRate: AttitudeRate) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetAttitudeRateRequest()

            
                
            request.attitudeRate = attitudeRate.rpcAttitudeRate
                
            

            do {
                
                let response = self.service.setAttitudeRate(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the position in NED coordinates and yaw.

     - Parameter positionNedYaw: Position and yaw
     
     */
    public func setPositionNed(positionNedYaw: PositionNedYaw) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetPositionNedRequest()

            
                
            request.positionNedYaw = positionNedYaw.rpcPositionNedYaw
                
            

            do {
                
                let response = self.service.setPositionNed(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the velocity in body coordinates and yaw angular rate. Not available for fixed-wing aircraft.

     - Parameter velocityBodyYawspeed: Velocity and yaw angular rate
     
     */
    public func setVelocityBody(velocityBodyYawspeed: VelocityBodyYawspeed) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetVelocityBodyRequest()

            
                
            request.velocityBodyYawspeed = velocityBodyYawspeed.rpcVelocityBodyYawspeed
                
            

            do {
                
                let response = self.service.setVelocityBody(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the velocity in NED coordinates and yaw. Not available for fixed-wing aircraft.

     - Parameter velocityNedYaw: Velocity and yaw
     
     */
    public func setVelocityNed(velocityNedYaw: VelocityNedYaw) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetVelocityNedRequest()

            
                
            request.velocityNedYaw = velocityNedYaw.rpcVelocityNedYaw
                
            

            do {
                
                let response = self.service.setVelocityNed(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the position in NED coordinates, with the velocity to be used as feed-forward.

     - Parameters:
        - positionNedYaw: Position and yaw
        - velocityNedYaw: Velocity and yaw
     
     */
    public func setPositionVelocityNed(positionNedYaw: PositionNedYaw, velocityNedYaw: VelocityNedYaw) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetPositionVelocityNedRequest()

            
                
            request.positionNedYaw = positionNedYaw.rpcPositionNedYaw
                
            
                
            request.velocityNedYaw = velocityNedYaw.rpcVelocityNedYaw
                
            

            do {
                
                let response = self.service.setPositionVelocityNed(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the acceleration in NED coordinates.

     - Parameter accelerationNed: Acceleration
     
     */
    public func setAccelerationNed(accelerationNed: AccelerationNed) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetAccelerationNedRequest()

            
                
            request.accelerationNed = accelerationNed.rpcAccelerationNed
                
            

            do {
                
                let response = self.service.setAccelerationNed(request)

                let result = try response.response.wait().offboardResult
                if (result.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}