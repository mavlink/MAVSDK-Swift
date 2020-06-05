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

    
    public struct TelemetryError: Error {
        public let code: Telemetry.TelemetryResult.Result
        public let description: String
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
        case manual
        case altctl
        case posctl
        case acro
        case stabilized
        case rattitude
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
            case .manual:
                return .manual
            case .altctl:
                return .altctl
            case .posctl:
                return .posctl
            case .acro:
                return .acro
            case .stabilized:
                return .stabilized
            case .rattitude:
                return .rattitude
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
            case .manual:
                return .manual
            case .altctl:
                return .altctl
            case .posctl:
                return .posctl
            case .acro:
                return .acro
            case .stabilized:
                return .stabilized
            case .rattitude:
                return .rattitude
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    public enum StatusTextType: Equatable {
        case info
        case warning
        case critical
        case UNRECOGNIZED(Int)

        internal var rpcStatusTextType: Mavsdk_Rpc_Telemetry_StatusTextType {
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

        internal static func translateFromRpc(_ rpcStatusTextType: Mavsdk_Rpc_Telemetry_StatusTextType) -> StatusTextType {
            switch rpcStatusTextType {
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

    public enum LandedState: Equatable {
        case unknown
        case onGround
        case inAir
        case takingOff
        case landing
        case UNRECOGNIZED(Int)

        internal var rpcLandedState: Mavsdk_Rpc_Telemetry_LandedState {
            switch self {
            case .unknown:
                return .unknown
            case .onGround:
                return .onGround
            case .inAir:
                return .inAir
            case .takingOff:
                return .takingOff
            case .landing:
                return .landing
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcLandedState: Mavsdk_Rpc_Telemetry_LandedState) -> LandedState {
            switch rpcLandedState {
            case .unknown:
                return .unknown
            case .onGround:
                return .onGround
            case .inAir:
                return .inAir
            case .takingOff:
                return .takingOff
            case .landing:
                return .landing
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
        public let type: StatusTextType
        public let text: String

        

        public init(type: StatusTextType, text: String) {
            self.type = type
            self.text = text
        }

        internal var rpcStatusText: Mavsdk_Rpc_Telemetry_StatusText {
            var rpcStatusText = Mavsdk_Rpc_Telemetry_StatusText()
            
                
            rpcStatusText.type = type.rpcStatusTextType
                
            
            
                
            rpcStatusText.text = text
                
            

            return rpcStatusText
        }

        internal static func translateFromRpc(_ rpcStatusText: Mavsdk_Rpc_Telemetry_StatusText) -> StatusText {
            return StatusText(type: StatusTextType.translateFromRpc(rpcStatusText.type), text: rpcStatusText.text)
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

    public struct VelocityBody: Equatable {
        public let xMS: Float
        public let yMS: Float
        public let zMS: Float

        

        public init(xMS: Float, yMS: Float, zMS: Float) {
            self.xMS = xMS
            self.yMS = yMS
            self.zMS = zMS
        }

        internal var rpcVelocityBody: Mavsdk_Rpc_Telemetry_VelocityBody {
            var rpcVelocityBody = Mavsdk_Rpc_Telemetry_VelocityBody()
            
                
            rpcVelocityBody.xMS = xMS
                
            
            
                
            rpcVelocityBody.yMS = yMS
                
            
            
                
            rpcVelocityBody.zMS = zMS
                
            

            return rpcVelocityBody
        }

        internal static func translateFromRpc(_ rpcVelocityBody: Mavsdk_Rpc_Telemetry_VelocityBody) -> VelocityBody {
            return VelocityBody(xMS: rpcVelocityBody.xMS, yMS: rpcVelocityBody.yMS, zMS: rpcVelocityBody.zMS)
        }

        public static func == (lhs: VelocityBody, rhs: VelocityBody) -> Bool {
            return lhs.xMS == rhs.xMS
                && lhs.yMS == rhs.yMS
                && lhs.zMS == rhs.zMS
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

    public struct Odometry: Equatable {
        public let timeUsec: UInt64
        public let frameID: MavFrame
        public let childFrameID: MavFrame
        public let positionBody: PositionBody
        public let q: Quaternion
        public let velocityBody: VelocityBody
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
        

        public init(timeUsec: UInt64, frameID: MavFrame, childFrameID: MavFrame, positionBody: PositionBody, q: Quaternion, velocityBody: VelocityBody, angularVelocityBody: AngularVelocityBody, poseCovariance: Covariance, velocityCovariance: Covariance) {
            self.timeUsec = timeUsec
            self.frameID = frameID
            self.childFrameID = childFrameID
            self.positionBody = positionBody
            self.q = q
            self.velocityBody = velocityBody
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
                
            
            
                
            rpcOdometry.velocityBody = velocityBody.rpcVelocityBody
                
            
            
                
            rpcOdometry.angularVelocityBody = angularVelocityBody.rpcAngularVelocityBody
                
            
            
                
            rpcOdometry.poseCovariance = poseCovariance.rpcCovariance
                
            
            
                
            rpcOdometry.velocityCovariance = velocityCovariance.rpcCovariance
                
            

            return rpcOdometry
        }

        internal static func translateFromRpc(_ rpcOdometry: Mavsdk_Rpc_Telemetry_Odometry) -> Odometry {
            return Odometry(timeUsec: rpcOdometry.timeUsec, frameID: MavFrame.translateFromRpc(rpcOdometry.frameID), childFrameID: MavFrame.translateFromRpc(rpcOdometry.childFrameID), positionBody: PositionBody.translateFromRpc(rpcOdometry.positionBody), q: Quaternion.translateFromRpc(rpcOdometry.q), velocityBody: VelocityBody.translateFromRpc(rpcOdometry.velocityBody), angularVelocityBody: AngularVelocityBody.translateFromRpc(rpcOdometry.angularVelocityBody), poseCovariance: Covariance.translateFromRpc(rpcOdometry.poseCovariance), velocityCovariance: Covariance.translateFromRpc(rpcOdometry.velocityCovariance))
        }

        public static func == (lhs: Odometry, rhs: Odometry) -> Bool {
            return lhs.timeUsec == rhs.timeUsec
                && lhs.frameID == rhs.frameID
                && lhs.childFrameID == rhs.childFrameID
                && lhs.positionBody == rhs.positionBody
                && lhs.q == rhs.q
                && lhs.velocityBody == rhs.velocityBody
                && lhs.angularVelocityBody == rhs.angularVelocityBody
                && lhs.poseCovariance == rhs.poseCovariance
                && lhs.velocityCovariance == rhs.velocityCovariance
        }
    }

    public struct PositionNed: Equatable {
        public let northM: Float
        public let eastM: Float
        public let downM: Float

        

        public init(northM: Float, eastM: Float, downM: Float) {
            self.northM = northM
            self.eastM = eastM
            self.downM = downM
        }

        internal var rpcPositionNed: Mavsdk_Rpc_Telemetry_PositionNed {
            var rpcPositionNed = Mavsdk_Rpc_Telemetry_PositionNed()
            
                
            rpcPositionNed.northM = northM
                
            
            
                
            rpcPositionNed.eastM = eastM
                
            
            
                
            rpcPositionNed.downM = downM
                
            

            return rpcPositionNed
        }

        internal static func translateFromRpc(_ rpcPositionNed: Mavsdk_Rpc_Telemetry_PositionNed) -> PositionNed {
            return PositionNed(northM: rpcPositionNed.northM, eastM: rpcPositionNed.eastM, downM: rpcPositionNed.downM)
        }

        public static func == (lhs: PositionNed, rhs: PositionNed) -> Bool {
            return lhs.northM == rhs.northM
                && lhs.eastM == rhs.eastM
                && lhs.downM == rhs.downM
        }
    }

    public struct VelocityNed: Equatable {
        public let northMS: Float
        public let eastMS: Float
        public let downMS: Float

        

        public init(northMS: Float, eastMS: Float, downMS: Float) {
            self.northMS = northMS
            self.eastMS = eastMS
            self.downMS = downMS
        }

        internal var rpcVelocityNed: Mavsdk_Rpc_Telemetry_VelocityNed {
            var rpcVelocityNed = Mavsdk_Rpc_Telemetry_VelocityNed()
            
                
            rpcVelocityNed.northMS = northMS
                
            
            
                
            rpcVelocityNed.eastMS = eastMS
                
            
            
                
            rpcVelocityNed.downMS = downMS
                
            

            return rpcVelocityNed
        }

        internal static func translateFromRpc(_ rpcVelocityNed: Mavsdk_Rpc_Telemetry_VelocityNed) -> VelocityNed {
            return VelocityNed(northMS: rpcVelocityNed.northMS, eastMS: rpcVelocityNed.eastMS, downMS: rpcVelocityNed.downMS)
        }

        public static func == (lhs: VelocityNed, rhs: VelocityNed) -> Bool {
            return lhs.northMS == rhs.northMS
                && lhs.eastMS == rhs.eastMS
                && lhs.downMS == rhs.downMS
        }
    }

    public struct PositionVelocityNed: Equatable {
        public let position: PositionNed
        public let velocity: VelocityNed

        

        public init(position: PositionNed, velocity: VelocityNed) {
            self.position = position
            self.velocity = velocity
        }

        internal var rpcPositionVelocityNed: Mavsdk_Rpc_Telemetry_PositionVelocityNed {
            var rpcPositionVelocityNed = Mavsdk_Rpc_Telemetry_PositionVelocityNed()
            
                
            rpcPositionVelocityNed.position = position.rpcPositionNed
                
            
            
                
            rpcPositionVelocityNed.velocity = velocity.rpcVelocityNed
                
            

            return rpcPositionVelocityNed
        }

        internal static func translateFromRpc(_ rpcPositionVelocityNed: Mavsdk_Rpc_Telemetry_PositionVelocityNed) -> PositionVelocityNed {
            return PositionVelocityNed(position: PositionNed.translateFromRpc(rpcPositionVelocityNed.position), velocity: VelocityNed.translateFromRpc(rpcPositionVelocityNed.velocity))
        }

        public static func == (lhs: PositionVelocityNed, rhs: PositionVelocityNed) -> Bool {
            return lhs.position == rhs.position
                && lhs.velocity == rhs.velocity
        }
    }

    public struct GroundTruth: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float

        

        public init(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.absoluteAltitudeM = absoluteAltitudeM
        }

        internal var rpcGroundTruth: Mavsdk_Rpc_Telemetry_GroundTruth {
            var rpcGroundTruth = Mavsdk_Rpc_Telemetry_GroundTruth()
            
                
            rpcGroundTruth.latitudeDeg = latitudeDeg
                
            
            
                
            rpcGroundTruth.longitudeDeg = longitudeDeg
                
            
            
                
            rpcGroundTruth.absoluteAltitudeM = absoluteAltitudeM
                
            

            return rpcGroundTruth
        }

        internal static func translateFromRpc(_ rpcGroundTruth: Mavsdk_Rpc_Telemetry_GroundTruth) -> GroundTruth {
            return GroundTruth(latitudeDeg: rpcGroundTruth.latitudeDeg, longitudeDeg: rpcGroundTruth.longitudeDeg, absoluteAltitudeM: rpcGroundTruth.absoluteAltitudeM)
        }

        public static func == (lhs: GroundTruth, rhs: GroundTruth) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
        }
    }

    public struct FixedwingMetrics: Equatable {
        public let airspeedMS: Float
        public let throttlePercentage: Float
        public let climbRateMS: Float

        

        public init(airspeedMS: Float, throttlePercentage: Float, climbRateMS: Float) {
            self.airspeedMS = airspeedMS
            self.throttlePercentage = throttlePercentage
            self.climbRateMS = climbRateMS
        }

        internal var rpcFixedwingMetrics: Mavsdk_Rpc_Telemetry_FixedwingMetrics {
            var rpcFixedwingMetrics = Mavsdk_Rpc_Telemetry_FixedwingMetrics()
            
                
            rpcFixedwingMetrics.airspeedMS = airspeedMS
                
            
            
                
            rpcFixedwingMetrics.throttlePercentage = throttlePercentage
                
            
            
                
            rpcFixedwingMetrics.climbRateMS = climbRateMS
                
            

            return rpcFixedwingMetrics
        }

        internal static func translateFromRpc(_ rpcFixedwingMetrics: Mavsdk_Rpc_Telemetry_FixedwingMetrics) -> FixedwingMetrics {
            return FixedwingMetrics(airspeedMS: rpcFixedwingMetrics.airspeedMS, throttlePercentage: rpcFixedwingMetrics.throttlePercentage, climbRateMS: rpcFixedwingMetrics.climbRateMS)
        }

        public static func == (lhs: FixedwingMetrics, rhs: FixedwingMetrics) -> Bool {
            return lhs.airspeedMS == rhs.airspeedMS
                && lhs.throttlePercentage == rhs.throttlePercentage
                && lhs.climbRateMS == rhs.climbRateMS
        }
    }

    public struct AccelerationFrd: Equatable {
        public let forwardMS2: Float
        public let rightMS2: Float
        public let downMS2: Float

        

        public init(forwardMS2: Float, rightMS2: Float, downMS2: Float) {
            self.forwardMS2 = forwardMS2
            self.rightMS2 = rightMS2
            self.downMS2 = downMS2
        }

        internal var rpcAccelerationFrd: Mavsdk_Rpc_Telemetry_AccelerationFrd {
            var rpcAccelerationFrd = Mavsdk_Rpc_Telemetry_AccelerationFrd()
            
                
            rpcAccelerationFrd.forwardMS2 = forwardMS2
                
            
            
                
            rpcAccelerationFrd.rightMS2 = rightMS2
                
            
            
                
            rpcAccelerationFrd.downMS2 = downMS2
                
            

            return rpcAccelerationFrd
        }

        internal static func translateFromRpc(_ rpcAccelerationFrd: Mavsdk_Rpc_Telemetry_AccelerationFrd) -> AccelerationFrd {
            return AccelerationFrd(forwardMS2: rpcAccelerationFrd.forwardMS2, rightMS2: rpcAccelerationFrd.rightMS2, downMS2: rpcAccelerationFrd.downMS2)
        }

        public static func == (lhs: AccelerationFrd, rhs: AccelerationFrd) -> Bool {
            return lhs.forwardMS2 == rhs.forwardMS2
                && lhs.rightMS2 == rhs.rightMS2
                && lhs.downMS2 == rhs.downMS2
        }
    }

    public struct AngularVelocityFrd: Equatable {
        public let forwardRadS: Float
        public let rightRadS: Float
        public let downRadS: Float

        

        public init(forwardRadS: Float, rightRadS: Float, downRadS: Float) {
            self.forwardRadS = forwardRadS
            self.rightRadS = rightRadS
            self.downRadS = downRadS
        }

        internal var rpcAngularVelocityFrd: Mavsdk_Rpc_Telemetry_AngularVelocityFrd {
            var rpcAngularVelocityFrd = Mavsdk_Rpc_Telemetry_AngularVelocityFrd()
            
                
            rpcAngularVelocityFrd.forwardRadS = forwardRadS
                
            
            
                
            rpcAngularVelocityFrd.rightRadS = rightRadS
                
            
            
                
            rpcAngularVelocityFrd.downRadS = downRadS
                
            

            return rpcAngularVelocityFrd
        }

        internal static func translateFromRpc(_ rpcAngularVelocityFrd: Mavsdk_Rpc_Telemetry_AngularVelocityFrd) -> AngularVelocityFrd {
            return AngularVelocityFrd(forwardRadS: rpcAngularVelocityFrd.forwardRadS, rightRadS: rpcAngularVelocityFrd.rightRadS, downRadS: rpcAngularVelocityFrd.downRadS)
        }

        public static func == (lhs: AngularVelocityFrd, rhs: AngularVelocityFrd) -> Bool {
            return lhs.forwardRadS == rhs.forwardRadS
                && lhs.rightRadS == rhs.rightRadS
                && lhs.downRadS == rhs.downRadS
        }
    }

    public struct MagneticFieldFrd: Equatable {
        public let forwardGauss: Float
        public let rightGauss: Float
        public let downGauss: Float

        

        public init(forwardGauss: Float, rightGauss: Float, downGauss: Float) {
            self.forwardGauss = forwardGauss
            self.rightGauss = rightGauss
            self.downGauss = downGauss
        }

        internal var rpcMagneticFieldFrd: Mavsdk_Rpc_Telemetry_MagneticFieldFrd {
            var rpcMagneticFieldFrd = Mavsdk_Rpc_Telemetry_MagneticFieldFrd()
            
                
            rpcMagneticFieldFrd.forwardGauss = forwardGauss
                
            
            
                
            rpcMagneticFieldFrd.rightGauss = rightGauss
                
            
            
                
            rpcMagneticFieldFrd.downGauss = downGauss
                
            

            return rpcMagneticFieldFrd
        }

        internal static func translateFromRpc(_ rpcMagneticFieldFrd: Mavsdk_Rpc_Telemetry_MagneticFieldFrd) -> MagneticFieldFrd {
            return MagneticFieldFrd(forwardGauss: rpcMagneticFieldFrd.forwardGauss, rightGauss: rpcMagneticFieldFrd.rightGauss, downGauss: rpcMagneticFieldFrd.downGauss)
        }

        public static func == (lhs: MagneticFieldFrd, rhs: MagneticFieldFrd) -> Bool {
            return lhs.forwardGauss == rhs.forwardGauss
                && lhs.rightGauss == rhs.rightGauss
                && lhs.downGauss == rhs.downGauss
        }
    }

    public struct Imu: Equatable {
        public let accelerationFrd: AccelerationFrd
        public let angularVelocityFrd: AngularVelocityFrd
        public let magneticFieldFrd: MagneticFieldFrd
        public let temperatureDegc: Float

        

        public init(accelerationFrd: AccelerationFrd, angularVelocityFrd: AngularVelocityFrd, magneticFieldFrd: MagneticFieldFrd, temperatureDegc: Float) {
            self.accelerationFrd = accelerationFrd
            self.angularVelocityFrd = angularVelocityFrd
            self.magneticFieldFrd = magneticFieldFrd
            self.temperatureDegc = temperatureDegc
        }

        internal var rpcImu: Mavsdk_Rpc_Telemetry_Imu {
            var rpcImu = Mavsdk_Rpc_Telemetry_Imu()
            
                
            rpcImu.accelerationFrd = accelerationFrd.rpcAccelerationFrd
                
            
            
                
            rpcImu.angularVelocityFrd = angularVelocityFrd.rpcAngularVelocityFrd
                
            
            
                
            rpcImu.magneticFieldFrd = magneticFieldFrd.rpcMagneticFieldFrd
                
            
            
                
            rpcImu.temperatureDegc = temperatureDegc
                
            

            return rpcImu
        }

        internal static func translateFromRpc(_ rpcImu: Mavsdk_Rpc_Telemetry_Imu) -> Imu {
            return Imu(accelerationFrd: AccelerationFrd.translateFromRpc(rpcImu.accelerationFrd), angularVelocityFrd: AngularVelocityFrd.translateFromRpc(rpcImu.angularVelocityFrd), magneticFieldFrd: MagneticFieldFrd.translateFromRpc(rpcImu.magneticFieldFrd), temperatureDegc: rpcImu.temperatureDegc)
        }

        public static func == (lhs: Imu, rhs: Imu) -> Bool {
            return lhs.accelerationFrd == rhs.accelerationFrd
                && lhs.angularVelocityFrd == rhs.angularVelocityFrd
                && lhs.magneticFieldFrd == rhs.magneticFieldFrd
                && lhs.temperatureDegc == rhs.temperatureDegc
        }
    }

    public struct TelemetryResult: Equatable {
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
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Telemetry_TelemetryResult.Result {
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Telemetry_TelemetryResult.Result) -> Result {
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcTelemetryResult: Mavsdk_Rpc_Telemetry_TelemetryResult {
            var rpcTelemetryResult = Mavsdk_Rpc_Telemetry_TelemetryResult()
            
                
            rpcTelemetryResult.result = result.rpcResult
                
            
            
                
            rpcTelemetryResult.resultStr = resultStr
                
            

            return rpcTelemetryResult
        }

        internal static func translateFromRpc(_ rpcTelemetryResult: Mavsdk_Rpc_Telemetry_TelemetryResult) -> TelemetryResult {
            return TelemetryResult(result: Result.translateFromRpc(rpcTelemetryResult.result), resultStr: rpcTelemetryResult.resultStr)
        }

        public static func == (lhs: TelemetryResult, rhs: TelemetryResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
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


    public lazy var velocityNed: Observable<VelocityNed> = createVelocityNedObservable()


    private func createVelocityNedObservable() -> Observable<VelocityNed> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeVelocityNedRequest()

            

            do {
                let call = try self.service.subscribeVelocityNed(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let velocityNed = VelocityNed.translateFromRpc(response.velocityNed)
                        

                        
                        observer.onNext(velocityNed)
                        
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


    public lazy var positionVelocityNed: Observable<PositionVelocityNed> = createPositionVelocityNedObservable()


    private func createPositionVelocityNedObservable() -> Observable<PositionVelocityNed> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribePositionVelocityNedRequest()

            

            do {
                let call = try self.service.subscribePositionVelocityNed(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let positionVelocityNed = PositionVelocityNed.translateFromRpc(response.positionVelocityNed)
                        

                        
                        observer.onNext(positionVelocityNed)
                        
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


    public lazy var groundTruth: Observable<GroundTruth> = createGroundTruthObservable()


    private func createGroundTruthObservable() -> Observable<GroundTruth> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeGroundTruthRequest()

            

            do {
                let call = try self.service.subscribeGroundTruth(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let groundTruth = GroundTruth.translateFromRpc(response.groundTruth)
                        

                        
                        observer.onNext(groundTruth)
                        
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


    public lazy var fixedwingMetrics: Observable<FixedwingMetrics> = createFixedwingMetricsObservable()


    private func createFixedwingMetricsObservable() -> Observable<FixedwingMetrics> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeFixedwingMetricsRequest()

            

            do {
                let call = try self.service.subscribeFixedwingMetrics(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let fixedwingMetrics = FixedwingMetrics.translateFromRpc(response.fixedwingMetrics)
                        

                        
                        observer.onNext(fixedwingMetrics)
                        
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


    public lazy var imu: Observable<Imu> = createImuObservable()


    private func createImuObservable() -> Observable<Imu> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeImuRequest()

            

            do {
                let call = try self.service.subscribeImu(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let imu = Imu.translateFromRpc(response.imu)
                        

                        
                        observer.onNext(imu)
                        
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


    public lazy var healthAllOk: Observable<Bool> = createHealthAllOkObservable()


    private func createHealthAllOkObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeHealthAllOkRequest()

            

            do {
                let call = try self.service.subscribeHealthAllOk(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let healthAllOk = response.isHealthAllOk
                            
                        

                        
                        observer.onNext(healthAllOk)
                        
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


    public lazy var unixEpochTime: Observable<UInt64> = createUnixEpochTimeObservable()


    private func createUnixEpochTimeObservable() -> Observable<UInt64> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeUnixEpochTimeRequest()

            

            do {
                let call = try self.service.subscribeUnixEpochTime(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeTelemetryError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let unixEpochTime = response.timeUs
                            
                        

                        
                        observer.onNext(unixEpochTime)
                        
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

    public func setRatePosition(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRatePositionRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRatePosition(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateHome(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateHomeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateHome(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateInAir(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateInAirRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateInAir(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateLandedState(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateLandedStateRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateLandedState(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateAttitude(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateAttitudeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateAttitude(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateCameraAttitude(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateCameraAttitudeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateCameraAttitude(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateVelocityNed(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateVelocityNedRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateVelocityNed(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateGpsInfo(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateGpsInfoRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateGpsInfo(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateBattery(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateBatteryRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateBattery(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateRcStatus(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateRcStatusRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateRcStatus(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateActuatorControlTarget(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateActuatorControlTargetRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateActuatorControlTarget(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateActuatorOutputStatus(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateActuatorOutputStatusRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateActuatorOutputStatus(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateOdometry(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateOdometryRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateOdometry(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRatePositionVelocityNed(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRatePositionVelocityNedRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRatePositionVelocityNed(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateGroundTruth(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateGroundTruthRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateGroundTruth(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateFixedwingMetrics(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateFixedwingMetricsRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateFixedwingMetrics(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateImu(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateImuRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateImu(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRateUnixEpochTime(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateUnixEpochTimeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = try self.service.setRateUnixEpochTime(request)

                if (response.telemetryResult.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(response.telemetryResult.result), description: response.telemetryResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}