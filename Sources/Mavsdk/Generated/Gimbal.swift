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
        ///  Yaw lock will fix the gimbal pointing to an absolute direction.
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
     Control mode
     */
    public enum ControlMode: Equatable {
        ///  Indicates that the component does not have control over the gimbal.
        case none
        ///  To take primary control over the gimbal.
        case primary
        ///  To take secondary control over the gimbal.
        case secondary
        case UNRECOGNIZED(Int)

        internal var rpcControlMode: Mavsdk_Rpc_Gimbal_ControlMode {
            switch self {
            case .none:
                return .none
            case .primary:
                return .primary
            case .secondary:
                return .secondary
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcControlMode: Mavsdk_Rpc_Gimbal_ControlMode) -> ControlMode {
            switch rpcControlMode {
            case .none:
                return .none
            case .primary:
                return .primary
            case .secondary:
                return .secondary
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    /**
     
     */
    public enum SendMode: Equatable {
        ///  Send command exactly once with quality of service (use for sporadic commands slower than 1 Hz).
        case once
        ///  Stream setpoint without quality of service (use for setpoints faster than 1 Hz)..
        case stream
        case UNRECOGNIZED(Int)

        internal var rpcSendMode: Mavsdk_Rpc_Gimbal_SendMode {
            switch self {
            case .once:
                return .once
            case .stream:
                return .stream
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcSendMode: Mavsdk_Rpc_Gimbal_SendMode) -> SendMode {
            switch rpcSendMode {
            case .once:
                return .once
            case .stream:
                return .stream
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Quaternion type.

     All rotations and axis systems follow the right-hand rule.
     The Hamilton quaternion product definition is used.
     A zero-rotation quaternion is represented by (1,0,0,0).
     The quaternion could also be written as w + xi + yj + zk.

     For more info see: https://en.wikipedia.org/wiki/Quaternion
     */
    public struct Quaternion: Equatable {
        public let w: Float
        public let x: Float
        public let y: Float
        public let z: Float

        

        /**
         Initializes a new `Quaternion`.

         
         - Parameters:
            
            - w:  Quaternion entry 0, also denoted as a
            
            - x:  Quaternion entry 1, also denoted as b
            
            - y:  Quaternion entry 2, also denoted as c
            
            - z:  Quaternion entry 3, also denoted as d
            
         
         */
        public init(w: Float, x: Float, y: Float, z: Float) {
            self.w = w
            self.x = x
            self.y = y
            self.z = z
        }

        internal var rpcQuaternion: Mavsdk_Rpc_Gimbal_Quaternion {
            var rpcQuaternion = Mavsdk_Rpc_Gimbal_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: Mavsdk_Rpc_Gimbal_Quaternion) -> Quaternion {
            return Quaternion(w: rpcQuaternion.w, x: rpcQuaternion.x, y: rpcQuaternion.y, z: rpcQuaternion.z)
        }

        public static func == (lhs: Quaternion, rhs: Quaternion) -> Bool {
            return lhs.w == rhs.w
                && lhs.x == rhs.x
                && lhs.y == rhs.y
                && lhs.z == rhs.z
        }
    }

    /**
     Euler angle type.

     All rotations and axis systems follow the right-hand rule.
     The Euler angles are converted using the 3-1-2 sequence instead of standard 3-2-1 in order
     to avoid the gimbal lock at 90 degrees down.

     For more info see https://en.wikipedia.org/wiki/Euler_angles
     */
    public struct EulerAngle: Equatable {
        public let rollDeg: Float
        public let pitchDeg: Float
        public let yawDeg: Float

        

        /**
         Initializes a new `EulerAngle`.

         
         - Parameters:
            
            - rollDeg:  Roll angle in degrees, positive is banking to the right
            
            - pitchDeg:  Pitch angle in degrees, positive is pitching nose up
            
            - yawDeg:  Yaw angle in degrees, positive is clock-wise seen from above
            
         
         */
        public init(rollDeg: Float, pitchDeg: Float, yawDeg: Float) {
            self.rollDeg = rollDeg
            self.pitchDeg = pitchDeg
            self.yawDeg = yawDeg
        }

        internal var rpcEulerAngle: Mavsdk_Rpc_Gimbal_EulerAngle {
            var rpcEulerAngle = Mavsdk_Rpc_Gimbal_EulerAngle()
            
                
            rpcEulerAngle.rollDeg = rollDeg
                
            
            
                
            rpcEulerAngle.pitchDeg = pitchDeg
                
            
            
                
            rpcEulerAngle.yawDeg = yawDeg
                
            

            return rpcEulerAngle
        }

        internal static func translateFromRpc(_ rpcEulerAngle: Mavsdk_Rpc_Gimbal_EulerAngle) -> EulerAngle {
            return EulerAngle(rollDeg: rpcEulerAngle.rollDeg, pitchDeg: rpcEulerAngle.pitchDeg, yawDeg: rpcEulerAngle.yawDeg)
        }

        public static func == (lhs: EulerAngle, rhs: EulerAngle) -> Bool {
            return lhs.rollDeg == rhs.rollDeg
                && lhs.pitchDeg == rhs.pitchDeg
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    /**
     Gimbal angular rate type
     */
    public struct AngularVelocityBody: Equatable {
        public let rollRadS: Float
        public let pitchRadS: Float
        public let yawRadS: Float

        

        /**
         Initializes a new `AngularVelocityBody`.

         
         - Parameters:
            
            - rollRadS:  Roll angular velocity
            
            - pitchRadS:  Pitch angular velocity
            
            - yawRadS:  Yaw angular velocity
            
         
         */
        public init(rollRadS: Float, pitchRadS: Float, yawRadS: Float) {
            self.rollRadS = rollRadS
            self.pitchRadS = pitchRadS
            self.yawRadS = yawRadS
        }

        internal var rpcAngularVelocityBody: Mavsdk_Rpc_Gimbal_AngularVelocityBody {
            var rpcAngularVelocityBody = Mavsdk_Rpc_Gimbal_AngularVelocityBody()
            
                
            rpcAngularVelocityBody.rollRadS = rollRadS
                
            
            
                
            rpcAngularVelocityBody.pitchRadS = pitchRadS
                
            
            
                
            rpcAngularVelocityBody.yawRadS = yawRadS
                
            

            return rpcAngularVelocityBody
        }

        internal static func translateFromRpc(_ rpcAngularVelocityBody: Mavsdk_Rpc_Gimbal_AngularVelocityBody) -> AngularVelocityBody {
            return AngularVelocityBody(rollRadS: rpcAngularVelocityBody.rollRadS, pitchRadS: rpcAngularVelocityBody.pitchRadS, yawRadS: rpcAngularVelocityBody.yawRadS)
        }

        public static func == (lhs: AngularVelocityBody, rhs: AngularVelocityBody) -> Bool {
            return lhs.rollRadS == rhs.rollRadS
                && lhs.pitchRadS == rhs.pitchRadS
                && lhs.yawRadS == rhs.yawRadS
        }
    }

    /**
     Gimbal attitude type
     */
    public struct Attitude: Equatable {
        public let gimbalID: Int32
        public let eulerAngleForward: EulerAngle
        public let quaternionForward: Quaternion
        public let eulerAngleNorth: EulerAngle
        public let quaternionNorth: Quaternion
        public let angularVelocity: AngularVelocityBody
        public let timestampUs: UInt64

        

        /**
         Initializes a new `Attitude`.

         
         - Parameters:
            
            - gimbalID:  Gimbal ID
            
            - eulerAngleForward:  Euler angle relative to forward
            
            - quaternionForward:  Quaternion relative to forward
            
            - eulerAngleNorth:  Euler angle relative to North
            
            - quaternionNorth:  Quaternion relative to North
            
            - angularVelocity:  The angular rate
            
            - timestampUs:  Timestamp in microseconds
            
         
         */
        public init(gimbalID: Int32, eulerAngleForward: EulerAngle, quaternionForward: Quaternion, eulerAngleNorth: EulerAngle, quaternionNorth: Quaternion, angularVelocity: AngularVelocityBody, timestampUs: UInt64) {
            self.gimbalID = gimbalID
            self.eulerAngleForward = eulerAngleForward
            self.quaternionForward = quaternionForward
            self.eulerAngleNorth = eulerAngleNorth
            self.quaternionNorth = quaternionNorth
            self.angularVelocity = angularVelocity
            self.timestampUs = timestampUs
        }

        internal var rpcAttitude: Mavsdk_Rpc_Gimbal_Attitude {
            var rpcAttitude = Mavsdk_Rpc_Gimbal_Attitude()
            
                
            rpcAttitude.gimbalID = gimbalID
                
            
            
                
            rpcAttitude.eulerAngleForward = eulerAngleForward.rpcEulerAngle
                
            
            
                
            rpcAttitude.quaternionForward = quaternionForward.rpcQuaternion
                
            
            
                
            rpcAttitude.eulerAngleNorth = eulerAngleNorth.rpcEulerAngle
                
            
            
                
            rpcAttitude.quaternionNorth = quaternionNorth.rpcQuaternion
                
            
            
                
            rpcAttitude.angularVelocity = angularVelocity.rpcAngularVelocityBody
                
            
            
                
            rpcAttitude.timestampUs = timestampUs
                
            

            return rpcAttitude
        }

        internal static func translateFromRpc(_ rpcAttitude: Mavsdk_Rpc_Gimbal_Attitude) -> Attitude {
            return Attitude(gimbalID: rpcAttitude.gimbalID, eulerAngleForward: EulerAngle.translateFromRpc(rpcAttitude.eulerAngleForward), quaternionForward: Quaternion.translateFromRpc(rpcAttitude.quaternionForward), eulerAngleNorth: EulerAngle.translateFromRpc(rpcAttitude.eulerAngleNorth), quaternionNorth: Quaternion.translateFromRpc(rpcAttitude.quaternionNorth), angularVelocity: AngularVelocityBody.translateFromRpc(rpcAttitude.angularVelocity), timestampUs: rpcAttitude.timestampUs)
        }

        public static func == (lhs: Attitude, rhs: Attitude) -> Bool {
            return lhs.gimbalID == rhs.gimbalID
                && lhs.eulerAngleForward == rhs.eulerAngleForward
                && lhs.quaternionForward == rhs.quaternionForward
                && lhs.eulerAngleNorth == rhs.eulerAngleNorth
                && lhs.quaternionNorth == rhs.quaternionNorth
                && lhs.angularVelocity == rhs.angularVelocity
                && lhs.timestampUs == rhs.timestampUs
        }
    }

    /**
     Gimbal list item
     */
    public struct GimbalItem: Equatable {
        public let gimbalID: Int32
        public let vendorName: String
        public let modelName: String
        public let customName: String
        public let gimbalManagerComponentID: Int32
        public let gimbalDeviceID: Int32

        

        /**
         Initializes a new `GimbalItem`.

         
         - Parameters:
            
            - gimbalID:  ID to address it, starting at 1 (0 means all gimbals)
            
            - vendorName:  Vendor name
            
            - modelName:  Model name
            
            - customName:  Custom name name
            
            - gimbalManagerComponentID:  MAVLink component of gimbal manager, for debugging purposes
            
            - gimbalDeviceID:  MAVLink component of gimbal device
            
         
         */
        public init(gimbalID: Int32, vendorName: String, modelName: String, customName: String, gimbalManagerComponentID: Int32, gimbalDeviceID: Int32) {
            self.gimbalID = gimbalID
            self.vendorName = vendorName
            self.modelName = modelName
            self.customName = customName
            self.gimbalManagerComponentID = gimbalManagerComponentID
            self.gimbalDeviceID = gimbalDeviceID
        }

        internal var rpcGimbalItem: Mavsdk_Rpc_Gimbal_GimbalItem {
            var rpcGimbalItem = Mavsdk_Rpc_Gimbal_GimbalItem()
            
                
            rpcGimbalItem.gimbalID = gimbalID
                
            
            
                
            rpcGimbalItem.vendorName = vendorName
                
            
            
                
            rpcGimbalItem.modelName = modelName
                
            
            
                
            rpcGimbalItem.customName = customName
                
            
            
                
            rpcGimbalItem.gimbalManagerComponentID = gimbalManagerComponentID
                
            
            
                
            rpcGimbalItem.gimbalDeviceID = gimbalDeviceID
                
            

            return rpcGimbalItem
        }

        internal static func translateFromRpc(_ rpcGimbalItem: Mavsdk_Rpc_Gimbal_GimbalItem) -> GimbalItem {
            return GimbalItem(gimbalID: rpcGimbalItem.gimbalID, vendorName: rpcGimbalItem.vendorName, modelName: rpcGimbalItem.modelName, customName: rpcGimbalItem.customName, gimbalManagerComponentID: rpcGimbalItem.gimbalManagerComponentID, gimbalDeviceID: rpcGimbalItem.gimbalDeviceID)
        }

        public static func == (lhs: GimbalItem, rhs: GimbalItem) -> Bool {
            return lhs.gimbalID == rhs.gimbalID
                && lhs.vendorName == rhs.vendorName
                && lhs.modelName == rhs.modelName
                && lhs.customName == rhs.customName
                && lhs.gimbalManagerComponentID == rhs.gimbalManagerComponentID
                && lhs.gimbalDeviceID == rhs.gimbalDeviceID
        }
    }

    /**
     Gimbal list
     */
    public struct GimbalList: Equatable {
        public let gimbals: [GimbalItem]

        

        /**
         Initializes a new `GimbalList`.

         
         - Parameter gimbals:  Gimbal items.
         
         */
        public init(gimbals: [GimbalItem]) {
            self.gimbals = gimbals
        }

        internal var rpcGimbalList: Mavsdk_Rpc_Gimbal_GimbalList {
            var rpcGimbalList = Mavsdk_Rpc_Gimbal_GimbalList()
            
                
            rpcGimbalList.gimbals = gimbals.map{ $0.rpcGimbalItem }
                
            

            return rpcGimbalList
        }

        internal static func translateFromRpc(_ rpcGimbalList: Mavsdk_Rpc_Gimbal_GimbalList) -> GimbalList {
            return GimbalList(gimbals: rpcGimbalList.gimbals.map{ GimbalItem.translateFromRpc($0) })
        }

        public static func == (lhs: GimbalList, rhs: GimbalList) -> Bool {
            return lhs.gimbals == rhs.gimbals
        }
    }

    /**
     Control status
     */
    public struct ControlStatus: Equatable {
        public let gimbalID: Int32
        public let controlMode: ControlMode
        public let sysidPrimaryControl: Int32
        public let compidPrimaryControl: Int32
        public let sysidSecondaryControl: Int32
        public let compidSecondaryControl: Int32

        

        /**
         Initializes a new `ControlStatus`.

         
         - Parameters:
            
            - gimbalID:  Gimbal ID
            
            - controlMode:  Control mode (none, primary or secondary)
            
            - sysidPrimaryControl:  Sysid of the component that has primary control over the gimbal (0 if no one is in control)
            
            - compidPrimaryControl:  Compid of the component that has primary control over the gimbal (0 if no one is in control)
            
            - sysidSecondaryControl:  Sysid of the component that has secondary control over the gimbal (0 if no one is in control)
            
            - compidSecondaryControl:  Compid of the component that has secondary control over the gimbal (0 if no one is in control)
            
         
         */
        public init(gimbalID: Int32, controlMode: ControlMode, sysidPrimaryControl: Int32, compidPrimaryControl: Int32, sysidSecondaryControl: Int32, compidSecondaryControl: Int32) {
            self.gimbalID = gimbalID
            self.controlMode = controlMode
            self.sysidPrimaryControl = sysidPrimaryControl
            self.compidPrimaryControl = compidPrimaryControl
            self.sysidSecondaryControl = sysidSecondaryControl
            self.compidSecondaryControl = compidSecondaryControl
        }

        internal var rpcControlStatus: Mavsdk_Rpc_Gimbal_ControlStatus {
            var rpcControlStatus = Mavsdk_Rpc_Gimbal_ControlStatus()
            
                
            rpcControlStatus.gimbalID = gimbalID
                
            
            
                
            rpcControlStatus.controlMode = controlMode.rpcControlMode
                
            
            
                
            rpcControlStatus.sysidPrimaryControl = sysidPrimaryControl
                
            
            
                
            rpcControlStatus.compidPrimaryControl = compidPrimaryControl
                
            
            
                
            rpcControlStatus.sysidSecondaryControl = sysidSecondaryControl
                
            
            
                
            rpcControlStatus.compidSecondaryControl = compidSecondaryControl
                
            

            return rpcControlStatus
        }

        internal static func translateFromRpc(_ rpcControlStatus: Mavsdk_Rpc_Gimbal_ControlStatus) -> ControlStatus {
            return ControlStatus(gimbalID: rpcControlStatus.gimbalID, controlMode: ControlMode.translateFromRpc(rpcControlStatus.controlMode), sysidPrimaryControl: rpcControlStatus.sysidPrimaryControl, compidPrimaryControl: rpcControlStatus.compidPrimaryControl, sysidSecondaryControl: rpcControlStatus.sysidSecondaryControl, compidSecondaryControl: rpcControlStatus.compidSecondaryControl)
        }

        public static func == (lhs: ControlStatus, rhs: ControlStatus) -> Bool {
            return lhs.gimbalID == rhs.gimbalID
                && lhs.controlMode == rhs.controlMode
                && lhs.sysidPrimaryControl == rhs.sysidPrimaryControl
                && lhs.compidPrimaryControl == rhs.compidPrimaryControl
                && lhs.sysidSecondaryControl == rhs.sysidSecondaryControl
                && lhs.compidSecondaryControl == rhs.compidSecondaryControl
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
            ///  No system connected.
            case noSystem
            ///  Invalid argument.
            case invalidArgument
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
                case .noSystem:
                    return .noSystem
                case .invalidArgument:
                    return .invalidArgument
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
                case .noSystem:
                    return .noSystem
                case .invalidArgument:
                    return .invalidArgument
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
     Set gimbal roll, pitch and yaw angles.

     This sets the desired roll, pitch and yaw angles of a gimbal.
     Will return when the command is accepted, however, it might
     take the gimbal longer to actually be set to the new angles.

     Note that the roll angle needs to be set to 0 when send_mode is Once.

     - Parameters:
        - gimbalID: Gimbal id to address (0 for all gimbals)
        - rollDeg: Roll angle in degrees (negative down on the right)
        - pitchDeg: Pitch angle in degrees (negative points down)
        - yawDeg: Yaw angle in degrees (positive is clock-wise, range: -180 to 180 or 0 to 360)
        - gimbalMode: Gimbal mode to use
        - sendMode: Send mode of command/setpoint
     
     */
    public func setAngles(gimbalID: Int32, rollDeg: Float, pitchDeg: Float, yawDeg: Float, gimbalMode: GimbalMode, sendMode: SendMode) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetAnglesRequest()

            
                
            request.gimbalID = gimbalID
                
            
                
            request.rollDeg = rollDeg
                
            
                
            request.pitchDeg = pitchDeg
                
            
                
            request.yawDeg = yawDeg
                
            
                
            request.gimbalMode = gimbalMode.rpcGimbalMode
                
            
                
            request.sendMode = sendMode.rpcSendMode
                
            

            do {
                
                let response = self.service.setAngles(request)

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
     Set gimbal angular rates.

     This sets the desired angular rates around roll, pitch and yaw axes of a gimbal.
     Will return when the command is accepted, however, it might
     take the gimbal longer to actually reach the angular rate.

     Note that the roll angle needs to be set to 0 when send_mode is Once.

     - Parameters:
        - gimbalID: Gimbal id to address (0 for all gimbals)
        - rollRateDegS: Angular rate around roll axis in degrees/second (negative down on the right)
        - pitchRateDegS: Angular rate around pitch axis in degrees/second (negative downward)
        - yawRateDegS: Angular rate around yaw axis in degrees/second (positive is clock-wise)
        - gimbalMode: Gimbal mode to use
        - sendMode: Send mode of command/setpoint
     
     */
    public func setAngularRates(gimbalID: Int32, rollRateDegS: Float, pitchRateDegS: Float, yawRateDegS: Float, gimbalMode: GimbalMode, sendMode: SendMode) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetAngularRatesRequest()

            
                
            request.gimbalID = gimbalID
                
            
                
            request.rollRateDegS = rollRateDegS
                
            
                
            request.pitchRateDegS = pitchRateDegS
                
            
                
            request.yawRateDegS = yawRateDegS
                
            
                
            request.gimbalMode = gimbalMode.rpcGimbalMode
                
            
                
            request.sendMode = sendMode.rpcSendMode
                
            

            do {
                
                let response = self.service.setAngularRates(request)

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
        - gimbalID: Gimbal id to address (0 for all gimbals)
        - latitudeDeg: Latitude in degrees
        - longitudeDeg: Longitude in degrees
        - altitudeM: Altitude in metres (AMSL)
     
     */
    public func setRoiLocation(gimbalID: Int32, latitudeDeg: Double, longitudeDeg: Double, altitudeM: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_SetRoiLocationRequest()

            
                
            request.gimbalID = gimbalID
                
            
                
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

    /**
     Take control.

     There can be only two components in control of a gimbal at any given time.
     One with "primary" control, and one with "secondary" control. The way the
     secondary control is implemented is not specified and hence depends on the
     vehicle.

     Components are expected to be cooperative, which means that they can
     override each other and should therefore do it carefully.

     - Parameters:
        - gimbalID: Gimbal id to address (0 for all gimbals)
        - controlMode: Control mode (primary or secondary)
     
     */
    public func takeControl(gimbalID: Int32, controlMode: ControlMode) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_TakeControlRequest()

            
                
            request.gimbalID = gimbalID
                
            
                
            request.controlMode = controlMode.rpcControlMode
                
            

            do {
                
                let response = self.service.takeControl(request)

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
     Release control.

     Release control, such that other components can control the gimbal.

     - Parameter gimbalID: Gimbal id to address (0 for all gimbals)
     
     */
    public func releaseControl(gimbalID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Gimbal_ReleaseControlRequest()

            
                
            request.gimbalID = gimbalID
                
            

            do {
                
                let response = self.service.releaseControl(request)

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
     Subscribe to list of gimbals.

     This allows to find out what gimbals are connected to the system.
     Based on the gimbal ID, we can then address a specific gimbal.
     */

    public lazy var gimbalList: Observable<GimbalList> = createGimbalListObservable()




    private func createGimbalListObservable() -> Observable<GimbalList> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Gimbal_SubscribeGimbalListRequest()

            

            let serverStreamingCall = self.service.subscribeGimbalList(request, handler: { (response) in

                
                     
                let gimbalList = GimbalList.translateFromRpc(response.gimbalList)
                

                
                observer.onNext(gimbalList)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeGimbalError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to control status updates.

     This allows a component to know if it has primary, secondary or
     no control over the gimbal. Also, it gives the system and component ids
     of the other components in control (if any).
     */

    public lazy var controlStatus: Observable<ControlStatus> = createControlStatusObservable()




    private func createControlStatusObservable() -> Observable<ControlStatus> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Gimbal_SubscribeControlStatusRequest()

            

            let serverStreamingCall = self.service.subscribeControlStatus(request, handler: { (response) in

                
                     
                let controlStatus = ControlStatus.translateFromRpc(response.controlStatus)
                

                
                observer.onNext(controlStatus)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeGimbalError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get control status for specific gimbal.

     - Parameter gimbalID: Gimbal ID
     
     */
    public func getControlStatus(gimbalID: Int32) -> Single<ControlStatus> {
        return Single<ControlStatus>.create { single in
            var request = Mavsdk_Rpc_Gimbal_GetControlStatusRequest()

            
                
            request.gimbalID = gimbalID
                
            

            do {
                let response = self.service.getControlStatus(request)

                
                let result = try response.response.wait().gimbalResult
                if (result.result != Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    single(.failure(GimbalError(code: GimbalResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let controlStatus = try ControlStatus.translateFromRpc(response.response.wait().controlStatus)
                
                single(.success(controlStatus))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to attitude updates.

     This gets you the gimbal's attitude and angular rate.
     */

    public lazy var attitude: Observable<Attitude> = createAttitudeObservable()




    private func createAttitudeObservable() -> Observable<Attitude> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Gimbal_SubscribeAttitudeRequest()

            

            let serverStreamingCall = self.service.subscribeAttitude(request, handler: { (response) in

                
                     
                let attitude = Attitude.translateFromRpc(response.attitude)
                

                
                observer.onNext(attitude)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeGimbalError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get attitude for specific gimbal.

     - Parameter gimbalID: Gimbal ID
     
     */
    public func getAttitude(gimbalID: Int32) -> Single<Attitude> {
        return Single<Attitude>.create { single in
            var request = Mavsdk_Rpc_Gimbal_GetAttitudeRequest()

            
                
            request.gimbalID = gimbalID
                
            

            do {
                let response = self.service.getAttitude(request)

                
                let result = try response.response.wait().gimbalResult
                if (result.result != Mavsdk_Rpc_Gimbal_GimbalResult.Result.success) {
                    single(.failure(GimbalError(code: GimbalResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let attitude = try Attitude.translateFromRpc(response.response.wait().attitude)
                
                single(.success(attitude))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}