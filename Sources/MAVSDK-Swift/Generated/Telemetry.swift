import Foundation
import RxSwift
import SwiftGRPC

public class Telemetry {
    private let service: Mavsdk_Rpc_Telemetry_TelemetryServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Telemetry_TelemetryServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Telemetry_TelemetryServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeTelemetryError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    

    public enum FixType: Equatable {
        case noGps
        case noFix
        case fix2D
        case fix3D
        case fixDgps
        case rtkFloat
        case rtkFixed
        case UNRECOGNIZED(Int)

        internal var rpcFixType: Mavsdk_Rpc_Telemetry_FixType {
            switch self {
            case .noGps:
                return .noGps
            case .noFix:
                return .noFix
            case .fix2D:
                return .fix2D
            case .fix3D:
                return .fix3D
            case .fixDgps:
                return .fixDgps
            case .rtkFloat:
                return .rtkFloat
            case .rtkFixed:
                return .rtkFixed
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcFixType: Mavsdk_Rpc_Telemetry_FixType) -> FixType {
            switch rpcFixType {
            case .noGps:
                return .noGps
            case .noFix:
                return .noFix
            case .fix2D:
                return .fix2D
            case .fix3D:
                return .fix3D
            case .fixDgps:
                return .fixDgps
            case .rtkFloat:
                return .rtkFloat
            case .rtkFixed:
                return .rtkFixed
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    public enum FlightMode: Equatable {
        case unknown
        case ready
        case takeoff
        case hold
        case mission
        case returnToLaunch
        case land
        case offboard
        case followMe
        case UNRECOGNIZED(Int)

        internal var rpcFlightMode: Mavsdk_Rpc_Telemetry_FlightMode {
            switch self {
            case .unknown:
                return .unknown
            case .ready:
                return .ready
            case .takeoff:
                return .takeoff
            case .hold:
                return .hold
            case .mission:
                return .mission
            case .returnToLaunch:
                return .returnToLaunch
            case .land:
                return .land
            case .offboard:
                return .offboard
            case .followMe:
                return .followMe
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcFlightMode: Mavsdk_Rpc_Telemetry_FlightMode) -> FlightMode {
            switch rpcFlightMode {
            case .unknown:
                return .unknown
            case .ready:
                return .ready
            case .takeoff:
                return .takeoff
            case .hold:
                return .hold
            case .mission:
                return .mission
            case .returnToLaunch:
                return .returnToLaunch
            case .land:
                return .land
            case .offboard:
                return .offboard
            case .followMe:
                return .followMe
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    public enum LandedState: Equatable {
        case landedStateUnknown
        case landedStateOnGround
        case landedStateInAir
        case landedStateTakingOff
        case landedStateLanding
        case UNRECOGNIZED(Int)

        internal var rpcLandedState: Mavsdk_Rpc_Telemetry_LandedState {
            switch self {
            case .landedStateUnknown:
                return .unknown
            case .landedStateOnGround:
                return .onGround
            case .landedStateInAir:
                return .inAir
            case .landedStateTakingOff:
                return .takingOff
            case .landedStateLanding:
                return .landing
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcLandedState: Mavsdk_Rpc_Telemetry_LandedState) -> LandedState {
            switch rpcLandedState {
            case .unknown:
                return .landedStateUnknown
            case .onGround:
                return .landedStateOnGround
            case .inAir:
                return .landedStateInAir
            case .takingOff:
                return .landedStateTakingOff
            case .landing:
                return .landedStateLanding
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    public struct Position: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float
        public let relativeAltitudeM: Float

        

        public init(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, relativeAltitudeM: Float) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.absoluteAltitudeM = absoluteAltitudeM
            self.relativeAltitudeM = relativeAltitudeM
        }

        internal var rpcPosition: Mavsdk_Rpc_Telemetry_Position {
            var rpcPosition = Mavsdk_Rpc_Telemetry_Position()
            
                
            rpcPosition.latitudeDeg = latitudeDeg
                
            
            
                
            rpcPosition.longitudeDeg = longitudeDeg
                
            
            
                
            rpcPosition.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcPosition.relativeAltitudeM = relativeAltitudeM
                
            

            return rpcPosition
        }

        internal static func translateFromRpc(_ rpcPosition: Mavsdk_Rpc_Telemetry_Position) -> Position {
            return Position(latitudeDeg: rpcPosition.latitudeDeg, longitudeDeg: rpcPosition.longitudeDeg, absoluteAltitudeM: rpcPosition.absoluteAltitudeM, relativeAltitudeM: rpcPosition.relativeAltitudeM)
        }

        public static func == (lhs: Position, rhs: Position) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
                && lhs.relativeAltitudeM == rhs.relativeAltitudeM
        }
    }

    public struct Quaternion: Equatable {
        public let w: Float
        public let x: Float
        public let y: Float
        public let z: Float

        

        public init(w: Float, x: Float, y: Float, z: Float) {
            self.w = w
            self.x = x
            self.y = y
            self.z = z
        }

        internal var rpcQuaternion: Mavsdk_Rpc_Telemetry_Quaternion {
            var rpcQuaternion = Mavsdk_Rpc_Telemetry_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: Mavsdk_Rpc_Telemetry_Quaternion) -> Quaternion {
            return Quaternion(w: rpcQuaternion.w, x: rpcQuaternion.x, y: rpcQuaternion.y, z: rpcQuaternion.z)
        }

        public static func == (lhs: Quaternion, rhs: Quaternion) -> Bool {
            return lhs.w == rhs.w
                && lhs.x == rhs.x
                && lhs.y == rhs.y
                && lhs.z == rhs.z
        }
    }

    public struct EulerAngle: Equatable {
        public let rollDeg: Float
        public let pitchDeg: Float
        public let yawDeg: Float

        

        public init(rollDeg: Float, pitchDeg: Float, yawDeg: Float) {
            self.rollDeg = rollDeg
            self.pitchDeg = pitchDeg
            self.yawDeg = yawDeg
        }

        internal var rpcEulerAngle: Mavsdk_Rpc_Telemetry_EulerAngle {
            var rpcEulerAngle = Mavsdk_Rpc_Telemetry_EulerAngle()
            
                
            rpcEulerAngle.rollDeg = rollDeg
                
            
            
                
            rpcEulerAngle.pitchDeg = pitchDeg
                
            
            
                
            rpcEulerAngle.yawDeg = yawDeg
                
            

            return rpcEulerAngle
        }

        internal static func translateFromRpc(_ rpcEulerAngle: Mavsdk_Rpc_Telemetry_EulerAngle) -> EulerAngle {
            return EulerAngle(rollDeg: rpcEulerAngle.rollDeg, pitchDeg: rpcEulerAngle.pitchDeg, yawDeg: rpcEulerAngle.yawDeg)
        }

        public static func == (lhs: EulerAngle, rhs: EulerAngle) -> Bool {
            return lhs.rollDeg == rhs.rollDeg
                && lhs.pitchDeg == rhs.pitchDeg
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    public struct AngularVelocityBody: Equatable {
        public let rollRadS: Float
        public let pitchRadS: Float
        public let yawRadS: Float

        

        public init(rollRadS: Float, pitchRadS: Float, yawRadS: Float) {
            self.rollRadS = rollRadS
            self.pitchRadS = pitchRadS
            self.yawRadS = yawRadS
        }

        internal var rpcAngularVelocityBody: Mavsdk_Rpc_Telemetry_AngularVelocityBody {
            var rpcAngularVelocityBody = Mavsdk_Rpc_Telemetry_AngularVelocityBody()
            
                
            rpcAngularVelocityBody.rollRadS = rollRadS
                
            
            
                
            rpcAngularVelocityBody.pitchRadS = pitchRadS
                
            
            
                
            rpcAngularVelocityBody.yawRadS = yawRadS
                
            

            return rpcAngularVelocityBody
        }

        internal static func translateFromRpc(_ rpcAngularVelocityBody: Mavsdk_Rpc_Telemetry_AngularVelocityBody) -> AngularVelocityBody {
            return AngularVelocityBody(rollRadS: rpcAngularVelocityBody.rollRadS, pitchRadS: rpcAngularVelocityBody.pitchRadS, yawRadS: rpcAngularVelocityBody.yawRadS)
        }

        public static func == (lhs: AngularVelocityBody, rhs: AngularVelocityBody) -> Bool {
            return lhs.rollRadS == rhs.rollRadS
                && lhs.pitchRadS == rhs.pitchRadS
                && lhs.yawRadS == rhs.yawRadS
        }
    }

    public struct SpeedNed: Equatable {
        public let velocityNorthMS: Float
        public let velocityEastMS: Float
        public let velocityDownMS: Float

        

        public init(velocityNorthMS: Float, velocityEastMS: Float, velocityDownMS: Float) {
            self.velocityNorthMS = velocityNorthMS
            self.velocityEastMS = velocityEastMS
            self.velocityDownMS = velocityDownMS
        }

        internal var rpcSpeedNed: Mavsdk_Rpc_Telemetry_SpeedNed {
            var rpcSpeedNed = Mavsdk_Rpc_Telemetry_SpeedNed()
            
                
            rpcSpeedNed.velocityNorthMS = velocityNorthMS
                
            
            
                
            rpcSpeedNed.velocityEastMS = velocityEastMS
                
            
            
                
            rpcSpeedNed.velocityDownMS = velocityDownMS
                
            

            return rpcSpeedNed
        }

        internal static func translateFromRpc(_ rpcSpeedNed: Mavsdk_Rpc_Telemetry_SpeedNed) -> SpeedNed {
            return SpeedNed(velocityNorthMS: rpcSpeedNed.velocityNorthMS, velocityEastMS: rpcSpeedNed.velocityEastMS, velocityDownMS: rpcSpeedNed.velocityDownMS)
        }

        public static func == (lhs: SpeedNed, rhs: SpeedNed) -> Bool {
            return lhs.velocityNorthMS == rhs.velocityNorthMS
                && lhs.velocityEastMS == rhs.velocityEastMS
                && lhs.velocityDownMS == rhs.velocityDownMS
        }
    }

    public struct GpsInfo: Equatable {
        public let numSatellites: Int32
        public let fixType: FixType

        

        public init(numSatellites: Int32, fixType: FixType) {
            self.numSatellites = numSatellites
            self.fixType = fixType
        }

        internal var rpcGpsInfo: Mavsdk_Rpc_Telemetry_GpsInfo {
            var rpcGpsInfo = Mavsdk_Rpc_Telemetry_GpsInfo()
            
                
            rpcGpsInfo.numSatellites = numSatellites
                
            
            
                
            rpcGpsInfo.fixType = fixType.rpcFixType
                
            

            return rpcGpsInfo
        }

        internal static func translateFromRpc(_ rpcGpsInfo: Mavsdk_Rpc_Telemetry_GpsInfo) -> GpsInfo {
            return GpsInfo(numSatellites: rpcGpsInfo.numSatellites, fixType: FixType.translateFromRpc(rpcGpsInfo.fixType))
        }

        public static func == (lhs: GpsInfo, rhs: GpsInfo) -> Bool {
            return lhs.numSatellites == rhs.numSatellites
                && lhs.fixType == rhs.fixType
        }
    }

    public struct Battery: Equatable {
        public let voltageV: Float
        public let remainingPercent: Float

        

        public init(voltageV: Float, remainingPercent: Float) {
            self.voltageV = voltageV
            self.remainingPercent = remainingPercent
        }

        internal var rpcBattery: Mavsdk_Rpc_Telemetry_Battery {
            var rpcBattery = Mavsdk_Rpc_Telemetry_Battery()
            
                
            rpcBattery.voltageV = voltageV
                
            
            
                
            rpcBattery.remainingPercent = remainingPercent
                
            

            return rpcBattery
        }

        internal static func translateFromRpc(_ rpcBattery: Mavsdk_Rpc_Telemetry_Battery) -> Battery {
            return Battery(voltageV: rpcBattery.voltageV, remainingPercent: rpcBattery.remainingPercent)
        }

        public static func == (lhs: Battery, rhs: Battery) -> Bool {
            return lhs.voltageV == rhs.voltageV
                && lhs.remainingPercent == rhs.remainingPercent
        }
    }

    public struct Health: Equatable {
        public let isGyrometerCalibrationOk: Bool
        public let isAccelerometerCalibrationOk: Bool
        public let isMagnetometerCalibrationOk: Bool
        public let isLevelCalibrationOk: Bool
        public let isLocalPositionOk: Bool
        public let isGlobalPositionOk: Bool
        public let isHomePositionOk: Bool

        

        public init(isGyrometerCalibrationOk: Bool, isAccelerometerCalibrationOk: Bool, isMagnetometerCalibrationOk: Bool, isLevelCalibrationOk: Bool, isLocalPositionOk: Bool, isGlobalPositionOk: Bool, isHomePositionOk: Bool) {
            self.isGyrometerCalibrationOk = isGyrometerCalibrationOk
            self.isAccelerometerCalibrationOk = isAccelerometerCalibrationOk
            self.isMagnetometerCalibrationOk = isMagnetometerCalibrationOk
            self.isLevelCalibrationOk = isLevelCalibrationOk
            self.isLocalPositionOk = isLocalPositionOk
            self.isGlobalPositionOk = isGlobalPositionOk
            self.isHomePositionOk = isHomePositionOk
        }

        internal var rpcHealth: Mavsdk_Rpc_Telemetry_Health {
            var rpcHealth = Mavsdk_Rpc_Telemetry_Health()
            
                
            rpcHealth.isGyrometerCalibrationOk = isGyrometerCalibrationOk
                
            
            
                
            rpcHealth.isAccelerometerCalibrationOk = isAccelerometerCalibrationOk
                
            
            
                
            rpcHealth.isMagnetometerCalibrationOk = isMagnetometerCalibrationOk
                
            
            
                
            rpcHealth.isLevelCalibrationOk = isLevelCalibrationOk
                
            
            
                
            rpcHealth.isLocalPositionOk = isLocalPositionOk
                
            
            
                
            rpcHealth.isGlobalPositionOk = isGlobalPositionOk
                
            
            
                
            rpcHealth.isHomePositionOk = isHomePositionOk
                
            

            return rpcHealth
        }

        internal static func translateFromRpc(_ rpcHealth: Mavsdk_Rpc_Telemetry_Health) -> Health {
            return Health(isGyrometerCalibrationOk: rpcHealth.isGyrometerCalibrationOk, isAccelerometerCalibrationOk: rpcHealth.isAccelerometerCalibrationOk, isMagnetometerCalibrationOk: rpcHealth.isMagnetometerCalibrationOk, isLevelCalibrationOk: rpcHealth.isLevelCalibrationOk, isLocalPositionOk: rpcHealth.isLocalPositionOk, isGlobalPositionOk: rpcHealth.isGlobalPositionOk, isHomePositionOk: rpcHealth.isHomePositionOk)
        }

        public static func == (lhs: Health, rhs: Health) -> Bool {
            return lhs.isGyrometerCalibrationOk == rhs.isGyrometerCalibrationOk
                && lhs.isAccelerometerCalibrationOk == rhs.isAccelerometerCalibrationOk
                && lhs.isMagnetometerCalibrationOk == rhs.isMagnetometerCalibrationOk
                && lhs.isLevelCalibrationOk == rhs.isLevelCalibrationOk
                && lhs.isLocalPositionOk == rhs.isLocalPositionOk
                && lhs.isGlobalPositionOk == rhs.isGlobalPositionOk
                && lhs.isHomePositionOk == rhs.isHomePositionOk
        }
    }

    public struct RcStatus: Equatable {
        public let wasAvailableOnce: Bool
        public let isAvailable: Bool
        public let signalStrengthPercent: Float

        

        public init(wasAvailableOnce: Bool, isAvailable: Bool, signalStrengthPercent: Float) {
            self.wasAvailableOnce = wasAvailableOnce
            self.isAvailable = isAvailable
            self.signalStrengthPercent = signalStrengthPercent
        }

        internal var rpcRcStatus: Mavsdk_Rpc_Telemetry_RcStatus {
            var rpcRcStatus = Mavsdk_Rpc_Telemetry_RcStatus()
            
                
            rpcRcStatus.wasAvailableOnce = wasAvailableOnce
                
            
            
                
            rpcRcStatus.isAvailable = isAvailable
                
            
            
                
            rpcRcStatus.signalStrengthPercent = signalStrengthPercent
                
            

            return rpcRcStatus
        }

        internal static func translateFromRpc(_ rpcRcStatus: Mavsdk_Rpc_Telemetry_RcStatus) -> RcStatus {
            return RcStatus(wasAvailableOnce: rpcRcStatus.wasAvailableOnce, isAvailable: rpcRcStatus.isAvailable, signalStrengthPercent: rpcRcStatus.signalStrengthPercent)
        }

        public static func == (lhs: RcStatus, rhs: RcStatus) -> Bool {
            return lhs.wasAvailableOnce == rhs.wasAvailableOnce
                && lhs.isAvailable == rhs.isAvailable
                && lhs.signalStrengthPercent == rhs.signalStrengthPercent
        }
    }

    public struct StatusText: Equatable {
        public let type: StatusType
        public let text: String

        
        

        public enum StatusType: Equatable {
            case info
            case warning
            case critical
            case UNRECOGNIZED(Int)

            internal var rpcStatusType: Mavsdk_Rpc_Telemetry_StatusText.StatusType {
                switch self {
                case .info:
                    return .info
                case .warning:
                    return .warning
                case .critical:
                    return .critical
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcStatusType: Mavsdk_Rpc_Telemetry_StatusText.StatusType) -> StatusType {
                switch rpcStatusType {
                case .info:
                    return .info
                case .warning:
                    return .warning
                case .critical:
                    return .critical
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(type: StatusType, text: String) {
            self.type = type
            self.text = text
        }

        internal var rpcStatusText: Mavsdk_Rpc_Telemetry_StatusText {
            var rpcStatusText = Mavsdk_Rpc_Telemetry_StatusText()
            
                
            rpcStatusText.type = type.rpcStatusType
                
            
            
                
            rpcStatusText.text = text
                
            

            return rpcStatusText
        }

        internal static func translateFromRpc(_ rpcStatusText: Mavsdk_Rpc_Telemetry_StatusText) -> StatusText {
            return StatusText(type: StatusType.translateFromRpc(rpcStatusText.type), text: rpcStatusText.text)
        }

        public static func == (lhs: StatusText, rhs: StatusText) -> Bool {
            return lhs.type == rhs.type
                && lhs.text == rhs.text
        }
    }

    public struct ActuatorControlTarget: Equatable {
        public let group: Int32
        public let controls: [Float]

        

        public init(group: Int32, controls: [Float]) {
            self.group = group
            self.controls = controls
        }

        internal var rpcActuatorControlTarget: Mavsdk_Rpc_Telemetry_ActuatorControlTarget {
            var rpcActuatorControlTarget = Mavsdk_Rpc_Telemetry_ActuatorControlTarget()
            
                
            rpcActuatorControlTarget.group = group
                
            
            
                
            rpcActuatorControlTarget.controls = controls
                
            

            return rpcActuatorControlTarget
        }

        internal static func translateFromRpc(_ rpcActuatorControlTarget: Mavsdk_Rpc_Telemetry_ActuatorControlTarget) -> ActuatorControlTarget {
            return ActuatorControlTarget(group: rpcActuatorControlTarget.group, controls: rpcActuatorControlTarget.controls)
        }

        public static func == (lhs: ActuatorControlTarget, rhs: ActuatorControlTarget) -> Bool {
            return lhs.group == rhs.group
                && lhs.controls == rhs.controls
        }
    }

    public struct ActuatorOutputStatus: Equatable {
        public let active: UInt32
        public let actuator: [Float]

        

        public init(active: UInt32, actuator: [Float]) {
            self.active = active
            self.actuator = actuator
        }

        internal var rpcActuatorOutputStatus: Mavsdk_Rpc_Telemetry_ActuatorOutputStatus {
            var rpcActuatorOutputStatus = Mavsdk_Rpc_Telemetry_ActuatorOutputStatus()
            
                
            rpcActuatorOutputStatus.active = active
                
            
            
                
            rpcActuatorOutputStatus.actuator = actuator
                
            

            return rpcActuatorOutputStatus
        }

        internal static func translateFromRpc(_ rpcActuatorOutputStatus: Mavsdk_Rpc_Telemetry_ActuatorOutputStatus) -> ActuatorOutputStatus {
            return ActuatorOutputStatus(active: rpcActuatorOutputStatus.active, actuator: rpcActuatorOutputStatus.actuator)
        }

        public static func == (lhs: ActuatorOutputStatus, rhs: ActuatorOutputStatus) -> Bool {
            return lhs.active == rhs.active
                && lhs.actuator == rhs.actuator
        }
    }

    public struct Odometry: Equatable {
        public let timeUsec: UInt64
        public let frameID: MavFrame
        public let childFrameID: MavFrame
        public let positionBody: PositionBody
        public let q: Quaternion
        public let speedBody: SpeedBody
        public let angularVelocityBody: AngularVelocityBody
        public let poseCovariance: Covariance
        public let velocityCovariance: Covariance

        
        

        public enum MavFrame: Equatable {
            case undef
            case bodyNed
            case visionNed
            case estimNed
            case UNRECOGNIZED(Int)

            internal var rpcMavFrame: Mavsdk_Rpc_Telemetry_Odometry.MavFrame {
                switch self {
                case .undef:
                    return .undef
                case .bodyNed:
                    return .bodyNed
                case .visionNed:
                    return .visionNed
                case .estimNed:
                    return .estimNed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcMavFrame: Mavsdk_Rpc_Telemetry_Odometry.MavFrame) -> MavFrame {
                switch rpcMavFrame {
                case .undef:
                    return .undef
                case .bodyNed:
                    return .bodyNed
                case .visionNed:
                    return .visionNed
                case .estimNed:
                    return .estimNed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(timeUsec: UInt64, frameID: MavFrame, childFrameID: MavFrame, positionBody: PositionBody, q: Quaternion, speedBody: SpeedBody, angularVelocityBody: AngularVelocityBody, poseCovariance: Covariance, velocityCovariance: Covariance) {
            self.timeUsec = timeUsec
            self.frameID = frameID
            self.childFrameID = childFrameID
            self.positionBody = positionBody
            self.q = q
            self.speedBody = speedBody
            self.angularVelocityBody = angularVelocityBody
            self.poseCovariance = poseCovariance
            self.velocityCovariance = velocityCovariance
        }

        internal var rpcOdometry: Mavsdk_Rpc_Telemetry_Odometry {
            var rpcOdometry = Mavsdk_Rpc_Telemetry_Odometry()
            
                
            rpcOdometry.timeUsec = timeUsec
                
            
            
                
            rpcOdometry.frameID = frameID.rpcMavFrame
                
            
            
                
            rpcOdometry.childFrameID = childFrameID.rpcMavFrame
                
            
            
                
            rpcOdometry.positionBody = positionBody.rpcPositionBody
                
            
            
                
            rpcOdometry.q = q.rpcQuaternion
                
            
            
                
            rpcOdometry.speedBody = speedBody.rpcSpeedBody
                
            
            
                
            rpcOdometry.angularVelocityBody = angularVelocityBody.rpcAngularVelocityBody
                
            
            
                
            rpcOdometry.poseCovariance = poseCovariance.rpcCovariance
                
            
            
                
            rpcOdometry.velocityCovariance = velocityCovariance.rpcCovariance
                
            

            return rpcOdometry
        }

        internal static func translateFromRpc(_ rpcOdometry: Mavsdk_Rpc_Telemetry_Odometry) -> Odometry {
            return Odometry(timeUsec: rpcOdometry.timeUsec, frameID: MavFrame.translateFromRpc(rpcOdometry.frameID), childFrameID: MavFrame.translateFromRpc(rpcOdometry.childFrameID), positionBody: PositionBody.translateFromRpc(rpcOdometry.positionBody), q: Quaternion.translateFromRpc(rpcOdometry.q), speedBody: SpeedBody.translateFromRpc(rpcOdometry.speedBody), angularVelocityBody: AngularVelocityBody.translateFromRpc(rpcOdometry.angularVelocityBody), poseCovariance: Covariance.translateFromRpc(rpcOdometry.poseCovariance), velocityCovariance: Covariance.translateFromRpc(rpcOdometry.velocityCovariance))
        }

        public static func == (lhs: Odometry, rhs: Odometry) -> Bool {
            return lhs.timeUsec == rhs.timeUsec
                && lhs.frameID == rhs.frameID
                && lhs.childFrameID == rhs.childFrameID
                && lhs.positionBody == rhs.positionBody
                && lhs.q == rhs.q
                && lhs.speedBody == rhs.speedBody
                && lhs.angularVelocityBody == rhs.angularVelocityBody
                && lhs.poseCovariance == rhs.poseCovariance
                && lhs.velocityCovariance == rhs.velocityCovariance
        }
    }

    public struct Covariance: Equatable {
        public let covarianceMatrix: [Float]

        

        public init(covarianceMatrix: [Float]) {
            self.covarianceMatrix = covarianceMatrix
        }

        internal var rpcCovariance: Mavsdk_Rpc_Telemetry_Covariance {
            var rpcCovariance = Mavsdk_Rpc_Telemetry_Covariance()
            
                
            rpcCovariance.covarianceMatrix = covarianceMatrix
                
            

            return rpcCovariance
        }

        internal static func translateFromRpc(_ rpcCovariance: Mavsdk_Rpc_Telemetry_Covariance) -> Covariance {
            return Covariance(covarianceMatrix: rpcCovariance.covarianceMatrix)
        }

        public static func == (lhs: Covariance, rhs: Covariance) -> Bool {
            return lhs.covarianceMatrix == rhs.covarianceMatrix
        }
    }

    public struct SpeedBody: Equatable {
        public let velocityXMS: Float
        public let velocityYMS: Float
        public let velocityZMS: Float

        

        public init(velocityXMS: Float, velocityYMS: Float, velocityZMS: Float) {
            self.velocityXMS = velocityXMS
            self.velocityYMS = velocityYMS
            self.velocityZMS = velocityZMS
        }

        internal var rpcSpeedBody: Mavsdk_Rpc_Telemetry_SpeedBody {
            var rpcSpeedBody = Mavsdk_Rpc_Telemetry_SpeedBody()
            
                
            rpcSpeedBody.velocityXMS = velocityXMS
                
            
            
                
            rpcSpeedBody.velocityYMS = velocityYMS
                
            
            
                
            rpcSpeedBody.velocityZMS = velocityZMS
                
            

            return rpcSpeedBody
        }

        internal static func translateFromRpc(_ rpcSpeedBody: Mavsdk_Rpc_Telemetry_SpeedBody) -> SpeedBody {
            return SpeedBody(velocityXMS: rpcSpeedBody.velocityXMS, velocityYMS: rpcSpeedBody.velocityYMS, velocityZMS: rpcSpeedBody.velocityZMS)
        }

        public static func == (lhs: SpeedBody, rhs: SpeedBody) -> Bool {
            return lhs.velocityXMS == rhs.velocityXMS
                && lhs.velocityYMS == rhs.velocityYMS
                && lhs.velocityZMS == rhs.velocityZMS
        }
    }

    public struct PositionBody: Equatable {
        public let xM: Float
        public let yM: Float
        public let zM: Float

        

        public init(xM: Float, yM: Float, zM: Float) {
            self.xM = xM
            self.yM = yM
            self.zM = zM
        }

        internal var rpcPositionBody: Mavsdk_Rpc_Telemetry_PositionBody {
            var rpcPositionBody = Mavsdk_Rpc_Telemetry_PositionBody()
            
                
            rpcPositionBody.xM = xM
                
            
            
                
            rpcPositionBody.yM = yM
                
            
            
                
            rpcPositionBody.zM = zM
                
            

            return rpcPositionBody
        }

        internal static func translateFromRpc(_ rpcPositionBody: Mavsdk_Rpc_Telemetry_PositionBody) -> PositionBody {
            return PositionBody(xM: rpcPositionBody.xM, yM: rpcPositionBody.yM, zM: rpcPositionBody.zM)
        }

        public static func == (lhs: PositionBody, rhs: PositionBody) -> Bool {
            return lhs.xM == rhs.xM
                && lhs.yM == rhs.yM
                && lhs.zM == rhs.zM
        }
    }


    public lazy var position: Observable<Position> = createPositionObservable()

    private func createPositionObservable() -> Observable<Position> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribePositionRequest()

            

            do {
                let call = try self.service.subscribePosition(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let position = Position.translateFromRpc(response.position)
                        

                        
                        observer.onNext(position)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var home: Observable<Position> = createHomeObservable()

    private func createHomeObservable() -> Observable<Position> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeHomeRequest()

            

            do {
                let call = try self.service.subscribeHome(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let home = Position.translateFromRpc(response.home)
                        

                        
                        observer.onNext(home)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var inAir: Observable<Bool> = createInAirObservable()

    private func createInAirObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeInAirRequest()

            

            do {
                let call = try self.service.subscribeInAir(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let inAir = response.isInAir
                            
                        

                        
                        observer.onNext(inAir)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var landedState: Observable<LandedState> = createLandedStateObservable()

    private func createLandedStateObservable() -> Observable<LandedState> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeLandedStateRequest()

            

            do {
                let call = try self.service.subscribeLandedState(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let landedState = LandedState.translateFromRpc(response.landedState)
                        

                        
                        observer.onNext(landedState)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var armed: Observable<Bool> = createArmedObservable()

    private func createArmedObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeArmedRequest()

            

            do {
                let call = try self.service.subscribeArmed(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let armed = response.isArmed
                            
                        

                        
                        observer.onNext(armed)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var attitudeQuaternion: Observable<Quaternion> = createAttitudeQuaternionObservable()

    private func createAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeAttitudeQuaternionRequest()

            

            do {
                let call = try self.service.subscribeAttitudeQuaternion(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let attitudeQuaternion = Quaternion.translateFromRpc(response.attitudeQuaternion)
                        

                        
                        observer.onNext(attitudeQuaternion)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var attitudeEuler: Observable<EulerAngle> = createAttitudeEulerObservable()

    private func createAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeAttitudeEulerRequest()

            

            do {
                let call = try self.service.subscribeAttitudeEuler(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let attitudeEuler = EulerAngle.translateFromRpc(response.attitudeEuler)
                        

                        
                        observer.onNext(attitudeEuler)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var attitudeAngularVelocityBody: Observable<AngularVelocityBody> = createAttitudeAngularVelocityBodyObservable()

    private func createAttitudeAngularVelocityBodyObservable() -> Observable<AngularVelocityBody> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeAttitudeAngularVelocityBodyRequest()

            

            do {
                let call = try self.service.subscribeAttitudeAngularVelocityBody(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let attitudeAngularVelocityBody = AngularVelocityBody.translateFromRpc(response.attitudeAngularVelocityBody)
                        

                        
                        observer.onNext(attitudeAngularVelocityBody)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var cameraAttitudeQuaternion: Observable<Quaternion> = createCameraAttitudeQuaternionObservable()

    private func createCameraAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeCameraAttitudeQuaternionRequest()

            

            do {
                let call = try self.service.subscribeCameraAttitudeQuaternion(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let cameraAttitudeQuaternion = Quaternion.translateFromRpc(response.attitudeQuaternion)
                        

                        
                        observer.onNext(cameraAttitudeQuaternion)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var cameraAttitudeEuler: Observable<EulerAngle> = createCameraAttitudeEulerObservable()

    private func createCameraAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeCameraAttitudeEulerRequest()

            

            do {
                let call = try self.service.subscribeCameraAttitudeEuler(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let cameraAttitudeEuler = EulerAngle.translateFromRpc(response.attitudeEuler)
                        

                        
                        observer.onNext(cameraAttitudeEuler)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var groundSpeedNed: Observable<SpeedNed> = createGroundSpeedNedObservable()

    private func createGroundSpeedNedObservable() -> Observable<SpeedNed> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeGroundSpeedNedRequest()

            

            do {
                let call = try self.service.subscribeGroundSpeedNed(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let groundSpeedNed = SpeedNed.translateFromRpc(response.groundSpeedNed)
                        

                        
                        observer.onNext(groundSpeedNed)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var gpsInfo: Observable<GpsInfo> = createGpsInfoObservable()

    private func createGpsInfoObservable() -> Observable<GpsInfo> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeGpsInfoRequest()

            

            do {
                let call = try self.service.subscribeGpsInfo(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let gpsInfo = GpsInfo.translateFromRpc(response.gpsInfo)
                        

                        
                        observer.onNext(gpsInfo)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var battery: Observable<Battery> = createBatteryObservable()

    private func createBatteryObservable() -> Observable<Battery> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeBatteryRequest()

            

            do {
                let call = try self.service.subscribeBattery(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let battery = Battery.translateFromRpc(response.battery)
                        

                        
                        observer.onNext(battery)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var flightMode: Observable<FlightMode> = createFlightModeObservable()

    private func createFlightModeObservable() -> Observable<FlightMode> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeFlightModeRequest()

            

            do {
                let call = try self.service.subscribeFlightMode(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let flightMode = FlightMode.translateFromRpc(response.flightMode)
                        

                        
                        observer.onNext(flightMode)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var health: Observable<Health> = createHealthObservable()

    private func createHealthObservable() -> Observable<Health> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeHealthRequest()

            

            do {
                let call = try self.service.subscribeHealth(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let health = Health.translateFromRpc(response.health)
                        

                        
                        observer.onNext(health)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var rcStatus: Observable<RcStatus> = createRcStatusObservable()

    private func createRcStatusObservable() -> Observable<RcStatus> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeRcStatusRequest()

            

            do {
                let call = try self.service.subscribeRcStatus(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let rcStatus = RcStatus.translateFromRpc(response.rcStatus)
                        

                        
                        observer.onNext(rcStatus)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var statusText: Observable<StatusText> = createStatusTextObservable()

    private func createStatusTextObservable() -> Observable<StatusText> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeStatusTextRequest()

            

            do {
                let call = try self.service.subscribeStatusText(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let statusText = StatusText.translateFromRpc(response.statusText)
                        

                        
                        observer.onNext(statusText)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var actuatorControlTarget: Observable<ActuatorControlTarget> = createActuatorControlTargetObservable()

    private func createActuatorControlTargetObservable() -> Observable<ActuatorControlTarget> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeActuatorControlTargetRequest()

            

            do {
                let call = try self.service.subscribeActuatorControlTarget(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let actuatorControlTarget = ActuatorControlTarget.translateFromRpc(response.actuatorControlTarget)
                        

                        
                        observer.onNext(actuatorControlTarget)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var actuatorOutputStatus: Observable<ActuatorOutputStatus> = createActuatorOutputStatusObservable()

    private func createActuatorOutputStatusObservable() -> Observable<ActuatorOutputStatus> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeActuatorOutputStatusRequest()

            

            do {
                let call = try self.service.subscribeActuatorOutputStatus(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let actuatorOutputStatus = ActuatorOutputStatus.translateFromRpc(response.actuatorOutputStatus)
                        

                        
                        observer.onNext(actuatorOutputStatus)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var odometry: Observable<Odometry> = createOdometryObservable()

    private func createOdometryObservable() -> Observable<Odometry> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeOdometryRequest()

            

            do {
                let call = try self.service.subscribeOdometry(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let odometry = Odometry.translateFromRpc(response.odometry)
                        

                        
                        observer.onNext(odometry)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}