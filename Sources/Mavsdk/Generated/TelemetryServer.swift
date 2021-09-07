import Foundation
import RxSwift
import GRPC
import NIO

/**
 Allow users to provide vehicle telemetry and state information
 (e.g. battery, GPS, RC connection, flight mode etc.) and set telemetry update rates.
 */
public class TelemetryServer {
    private let service: Mavsdk_Rpc_TelemetryServer_TelemetryServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `TelemetryServer` plugin.

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
        let service = Mavsdk_Rpc_TelemetryServer_TelemetryServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_TelemetryServer_TelemetryServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeTelemetryServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct TelemetryServerError: Error {
        public let code: TelemetryServer.TelemetryServerResult.Result
        public let description: String
    }
    

    /**
     GPS fix type.
     */
    public enum FixType: Equatable {
        ///  No GPS connected.
        case noGps
        ///  No position information, GPS is connected.
        case noFix
        ///  2D position.
        case fix2D
        ///  3D position.
        case fix3D
        ///  DGPS/SBAS aided 3D position.
        case fixDgps
        ///  RTK float, 3D position.
        case rtkFloat
        ///  RTK Fixed, 3D position.
        case rtkFixed
        case UNRECOGNIZED(Int)

        internal var rpcFixType: Mavsdk_Rpc_TelemetryServer_FixType {
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

        internal static func translateFromRpc(_ rpcFixType: Mavsdk_Rpc_TelemetryServer_FixType) -> FixType {
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

    /**
     Maps to MAV_VTOL_STATE
     */
    public enum VtolState: Equatable {
        ///  Not VTOL.
        case undefined
        ///  Transitioning to fixed-wing.
        case transitionToFw
        ///  Transitioning to multi-copter.
        case transitionToMc
        ///  Multi-copter.
        case mc
        ///  Fixed-wing.
        case fw
        case UNRECOGNIZED(Int)

        internal var rpcVtolState: Mavsdk_Rpc_TelemetryServer_VtolState {
            switch self {
            case .undefined:
                return .undefined
            case .transitionToFw:
                return .transitionToFw
            case .transitionToMc:
                return .transitionToMc
            case .mc:
                return .mc
            case .fw:
                return .fw
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcVtolState: Mavsdk_Rpc_TelemetryServer_VtolState) -> VtolState {
            switch rpcVtolState {
            case .undefined:
                return .undefined
            case .transitionToFw:
                return .transitionToFw
            case .transitionToMc:
                return .transitionToMc
            case .mc:
                return .mc
            case .fw:
                return .fw
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    /**
     Status types.
     */
    public enum StatusTextType: Equatable {
        ///  Debug.
        case debug
        ///  Information.
        case info
        ///  Notice.
        case notice
        ///  Warning.
        case warning
        ///  Error.
        case error
        ///  Critical.
        case critical
        ///  Alert.
        case alert
        ///  Emergency.
        case emergency
        case UNRECOGNIZED(Int)

        internal var rpcStatusTextType: Mavsdk_Rpc_TelemetryServer_StatusTextType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                return .notice
            case .warning:
                return .warning
            case .error:
                return .error
            case .critical:
                return .critical
            case .alert:
                return .alert
            case .emergency:
                return .emergency
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcStatusTextType: Mavsdk_Rpc_TelemetryServer_StatusTextType) -> StatusTextType {
            switch rpcStatusTextType {
            case .debug:
                return .debug
            case .info:
                return .info
            case .notice:
                return .notice
            case .warning:
                return .warning
            case .error:
                return .error
            case .critical:
                return .critical
            case .alert:
                return .alert
            case .emergency:
                return .emergency
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    /**
     Landed State enumeration.
     */
    public enum LandedState: Equatable {
        ///  Landed state is unknown.
        case unknown
        ///  The vehicle is on the ground.
        case onGround
        ///  The vehicle is in the air.
        case inAir
        ///  The vehicle is taking off.
        case takingOff
        ///  The vehicle is landing.
        case landing
        case UNRECOGNIZED(Int)

        internal var rpcLandedState: Mavsdk_Rpc_TelemetryServer_LandedState {
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

        internal static func translateFromRpc(_ rpcLandedState: Mavsdk_Rpc_TelemetryServer_LandedState) -> LandedState {
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


    /**
     Position type in global coordinates.
     */
    public struct Position: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float
        public let relativeAltitudeM: Float

        

        /**
         Initializes a new `Position`.

         
         - Parameters:
            
            - latitudeDeg:  Latitude in degrees (range: -90 to +90)
            
            - longitudeDeg:  Longitude in degrees (range: -180 to +180)
            
            - absoluteAltitudeM:  Altitude AMSL (above mean sea level) in metres
            
            - relativeAltitudeM:  Altitude relative to takeoff altitude in metres
            
         
         */
        public init(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, relativeAltitudeM: Float) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.absoluteAltitudeM = absoluteAltitudeM
            self.relativeAltitudeM = relativeAltitudeM
        }

        internal var rpcPosition: Mavsdk_Rpc_TelemetryServer_Position {
            var rpcPosition = Mavsdk_Rpc_TelemetryServer_Position()
            
                
            rpcPosition.latitudeDeg = latitudeDeg
                
            
            
                
            rpcPosition.longitudeDeg = longitudeDeg
                
            
            
                
            rpcPosition.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcPosition.relativeAltitudeM = relativeAltitudeM
                
            

            return rpcPosition
        }

        internal static func translateFromRpc(_ rpcPosition: Mavsdk_Rpc_TelemetryServer_Position) -> Position {
            return Position(latitudeDeg: rpcPosition.latitudeDeg, longitudeDeg: rpcPosition.longitudeDeg, absoluteAltitudeM: rpcPosition.absoluteAltitudeM, relativeAltitudeM: rpcPosition.relativeAltitudeM)
        }

        public static func == (lhs: Position, rhs: Position) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
                && lhs.relativeAltitudeM == rhs.relativeAltitudeM
        }
    }

    /**
     Heading type used for global position
     */
    public struct Heading: Equatable {
        public let headingDeg: Double

        

        /**
         Initializes a new `Heading`.

         
         - Parameter headingDeg:  Heading in degrees (range: 0 to +360)
         
         */
        public init(headingDeg: Double) {
            self.headingDeg = headingDeg
        }

        internal var rpcHeading: Mavsdk_Rpc_TelemetryServer_Heading {
            var rpcHeading = Mavsdk_Rpc_TelemetryServer_Heading()
            
                
            rpcHeading.headingDeg = headingDeg
                
            

            return rpcHeading
        }

        internal static func translateFromRpc(_ rpcHeading: Mavsdk_Rpc_TelemetryServer_Heading) -> Heading {
            return Heading(headingDeg: rpcHeading.headingDeg)
        }

        public static func == (lhs: Heading, rhs: Heading) -> Bool {
            return lhs.headingDeg == rhs.headingDeg
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
        public let timestampUs: UInt64

        

        /**
         Initializes a new `Quaternion`.

         
         - Parameters:
            
            - w:  Quaternion entry 0, also denoted as a
            
            - x:  Quaternion entry 1, also denoted as b
            
            - y:  Quaternion entry 2, also denoted as c
            
            - z:  Quaternion entry 3, also denoted as d
            
            - timestampUs:  Timestamp in microseconds
            
         
         */
        public init(w: Float, x: Float, y: Float, z: Float, timestampUs: UInt64) {
            self.w = w
            self.x = x
            self.y = y
            self.z = z
            self.timestampUs = timestampUs
        }

        internal var rpcQuaternion: Mavsdk_Rpc_TelemetryServer_Quaternion {
            var rpcQuaternion = Mavsdk_Rpc_TelemetryServer_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            
            
                
            rpcQuaternion.timestampUs = timestampUs
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: Mavsdk_Rpc_TelemetryServer_Quaternion) -> Quaternion {
            return Quaternion(w: rpcQuaternion.w, x: rpcQuaternion.x, y: rpcQuaternion.y, z: rpcQuaternion.z, timestampUs: rpcQuaternion.timestampUs)
        }

        public static func == (lhs: Quaternion, rhs: Quaternion) -> Bool {
            return lhs.w == rhs.w
                && lhs.x == rhs.x
                && lhs.y == rhs.y
                && lhs.z == rhs.z
                && lhs.timestampUs == rhs.timestampUs
        }
    }

    /**
     Euler angle type.

     All rotations and axis systems follow the right-hand rule.
     The Euler angles follow the convention of a 3-2-1 intrinsic Tait-Bryan rotation sequence.

     For more info see https://en.wikipedia.org/wiki/Euler_angles
     */
    public struct EulerAngle: Equatable {
        public let rollDeg: Float
        public let pitchDeg: Float
        public let yawDeg: Float
        public let timestampUs: UInt64

        

        /**
         Initializes a new `EulerAngle`.

         
         - Parameters:
            
            - rollDeg:  Roll angle in degrees, positive is banking to the right
            
            - pitchDeg:  Pitch angle in degrees, positive is pitching nose up
            
            - yawDeg:  Yaw angle in degrees, positive is clock-wise seen from above
            
            - timestampUs:  Timestamp in microseconds
            
         
         */
        public init(rollDeg: Float, pitchDeg: Float, yawDeg: Float, timestampUs: UInt64) {
            self.rollDeg = rollDeg
            self.pitchDeg = pitchDeg
            self.yawDeg = yawDeg
            self.timestampUs = timestampUs
        }

        internal var rpcEulerAngle: Mavsdk_Rpc_TelemetryServer_EulerAngle {
            var rpcEulerAngle = Mavsdk_Rpc_TelemetryServer_EulerAngle()
            
                
            rpcEulerAngle.rollDeg = rollDeg
                
            
            
                
            rpcEulerAngle.pitchDeg = pitchDeg
                
            
            
                
            rpcEulerAngle.yawDeg = yawDeg
                
            
            
                
            rpcEulerAngle.timestampUs = timestampUs
                
            

            return rpcEulerAngle
        }

        internal static func translateFromRpc(_ rpcEulerAngle: Mavsdk_Rpc_TelemetryServer_EulerAngle) -> EulerAngle {
            return EulerAngle(rollDeg: rpcEulerAngle.rollDeg, pitchDeg: rpcEulerAngle.pitchDeg, yawDeg: rpcEulerAngle.yawDeg, timestampUs: rpcEulerAngle.timestampUs)
        }

        public static func == (lhs: EulerAngle, rhs: EulerAngle) -> Bool {
            return lhs.rollDeg == rhs.rollDeg
                && lhs.pitchDeg == rhs.pitchDeg
                && lhs.yawDeg == rhs.yawDeg
                && lhs.timestampUs == rhs.timestampUs
        }
    }

    /**
     Angular velocity type.
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

        internal var rpcAngularVelocityBody: Mavsdk_Rpc_TelemetryServer_AngularVelocityBody {
            var rpcAngularVelocityBody = Mavsdk_Rpc_TelemetryServer_AngularVelocityBody()
            
                
            rpcAngularVelocityBody.rollRadS = rollRadS
                
            
            
                
            rpcAngularVelocityBody.pitchRadS = pitchRadS
                
            
            
                
            rpcAngularVelocityBody.yawRadS = yawRadS
                
            

            return rpcAngularVelocityBody
        }

        internal static func translateFromRpc(_ rpcAngularVelocityBody: Mavsdk_Rpc_TelemetryServer_AngularVelocityBody) -> AngularVelocityBody {
            return AngularVelocityBody(rollRadS: rpcAngularVelocityBody.rollRadS, pitchRadS: rpcAngularVelocityBody.pitchRadS, yawRadS: rpcAngularVelocityBody.yawRadS)
        }

        public static func == (lhs: AngularVelocityBody, rhs: AngularVelocityBody) -> Bool {
            return lhs.rollRadS == rhs.rollRadS
                && lhs.pitchRadS == rhs.pitchRadS
                && lhs.yawRadS == rhs.yawRadS
        }
    }

    /**
     GPS information type.
     */
    public struct GpsInfo: Equatable {
        public let numSatellites: Int32
        public let fixType: FixType

        

        /**
         Initializes a new `GpsInfo`.

         
         - Parameters:
            
            - numSatellites:  Number of visible satellites in use
            
            - fixType:  Fix type
            
         
         */
        public init(numSatellites: Int32, fixType: FixType) {
            self.numSatellites = numSatellites
            self.fixType = fixType
        }

        internal var rpcGpsInfo: Mavsdk_Rpc_TelemetryServer_GpsInfo {
            var rpcGpsInfo = Mavsdk_Rpc_TelemetryServer_GpsInfo()
            
                
            rpcGpsInfo.numSatellites = numSatellites
                
            
            
                
            rpcGpsInfo.fixType = fixType.rpcFixType
                
            

            return rpcGpsInfo
        }

        internal static func translateFromRpc(_ rpcGpsInfo: Mavsdk_Rpc_TelemetryServer_GpsInfo) -> GpsInfo {
            return GpsInfo(numSatellites: rpcGpsInfo.numSatellites, fixType: FixType.translateFromRpc(rpcGpsInfo.fixType))
        }

        public static func == (lhs: GpsInfo, rhs: GpsInfo) -> Bool {
            return lhs.numSatellites == rhs.numSatellites
                && lhs.fixType == rhs.fixType
        }
    }

    /**
     Raw GPS information type.

     Warning: this is an advanced type! If you want the location of the drone, use
     the position instead. This message exposes the raw values of the GNSS sensor.
     */
    public struct RawGps: Equatable {
        public let timestampUs: UInt64
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float
        public let hdop: Float
        public let vdop: Float
        public let velocityMS: Float
        public let cogDeg: Float
        public let altitudeEllipsoidM: Float
        public let horizontalUncertaintyM: Float
        public let verticalUncertaintyM: Float
        public let velocityUncertaintyMS: Float
        public let headingUncertaintyDeg: Float
        public let yawDeg: Float

        

        /**
         Initializes a new `RawGps`.

         
         - Parameters:
            
            - timestampUs:  Timestamp in microseconds (UNIX Epoch time or time since system boot, to be inferred)
            
            - latitudeDeg:  Latitude in degrees (WGS84, EGM96 ellipsoid)
            
            - longitudeDeg:  Longitude in degrees (WGS84, EGM96 ellipsoid)
            
            - absoluteAltitudeM:  Altitude AMSL (above mean sea level) in metres
            
            - hdop:  GPS HDOP horizontal dilution of position (unitless). If unknown, set to NaN
            
            - vdop:  GPS VDOP vertical dilution of position (unitless). If unknown, set to NaN
            
            - velocityMS:  Ground velocity in metres per second
            
            - cogDeg:  Course over ground (NOT heading, but direction of movement) in degrees. If unknown, set to NaN
            
            - altitudeEllipsoidM:  Altitude in metres (above WGS84, EGM96 ellipsoid)
            
            - horizontalUncertaintyM:  Position uncertainty in metres
            
            - verticalUncertaintyM:  Altitude uncertainty in metres
            
            - velocityUncertaintyMS:  Velocity uncertainty in metres per second
            
            - headingUncertaintyDeg:  Heading uncertainty in degrees
            
            - yawDeg:  Yaw in earth frame from north.
            
         
         */
        public init(timestampUs: UInt64, latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, hdop: Float, vdop: Float, velocityMS: Float, cogDeg: Float, altitudeEllipsoidM: Float, horizontalUncertaintyM: Float, verticalUncertaintyM: Float, velocityUncertaintyMS: Float, headingUncertaintyDeg: Float, yawDeg: Float) {
            self.timestampUs = timestampUs
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.absoluteAltitudeM = absoluteAltitudeM
            self.hdop = hdop
            self.vdop = vdop
            self.velocityMS = velocityMS
            self.cogDeg = cogDeg
            self.altitudeEllipsoidM = altitudeEllipsoidM
            self.horizontalUncertaintyM = horizontalUncertaintyM
            self.verticalUncertaintyM = verticalUncertaintyM
            self.velocityUncertaintyMS = velocityUncertaintyMS
            self.headingUncertaintyDeg = headingUncertaintyDeg
            self.yawDeg = yawDeg
        }

        internal var rpcRawGps: Mavsdk_Rpc_TelemetryServer_RawGps {
            var rpcRawGps = Mavsdk_Rpc_TelemetryServer_RawGps()
            
                
            rpcRawGps.timestampUs = timestampUs
                
            
            
                
            rpcRawGps.latitudeDeg = latitudeDeg
                
            
            
                
            rpcRawGps.longitudeDeg = longitudeDeg
                
            
            
                
            rpcRawGps.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcRawGps.hdop = hdop
                
            
            
                
            rpcRawGps.vdop = vdop
                
            
            
                
            rpcRawGps.velocityMS = velocityMS
                
            
            
                
            rpcRawGps.cogDeg = cogDeg
                
            
            
                
            rpcRawGps.altitudeEllipsoidM = altitudeEllipsoidM
                
            
            
                
            rpcRawGps.horizontalUncertaintyM = horizontalUncertaintyM
                
            
            
                
            rpcRawGps.verticalUncertaintyM = verticalUncertaintyM
                
            
            
                
            rpcRawGps.velocityUncertaintyMS = velocityUncertaintyMS
                
            
            
                
            rpcRawGps.headingUncertaintyDeg = headingUncertaintyDeg
                
            
            
                
            rpcRawGps.yawDeg = yawDeg
                
            

            return rpcRawGps
        }

        internal static func translateFromRpc(_ rpcRawGps: Mavsdk_Rpc_TelemetryServer_RawGps) -> RawGps {
            return RawGps(timestampUs: rpcRawGps.timestampUs, latitudeDeg: rpcRawGps.latitudeDeg, longitudeDeg: rpcRawGps.longitudeDeg, absoluteAltitudeM: rpcRawGps.absoluteAltitudeM, hdop: rpcRawGps.hdop, vdop: rpcRawGps.vdop, velocityMS: rpcRawGps.velocityMS, cogDeg: rpcRawGps.cogDeg, altitudeEllipsoidM: rpcRawGps.altitudeEllipsoidM, horizontalUncertaintyM: rpcRawGps.horizontalUncertaintyM, verticalUncertaintyM: rpcRawGps.verticalUncertaintyM, velocityUncertaintyMS: rpcRawGps.velocityUncertaintyMS, headingUncertaintyDeg: rpcRawGps.headingUncertaintyDeg, yawDeg: rpcRawGps.yawDeg)
        }

        public static func == (lhs: RawGps, rhs: RawGps) -> Bool {
            return lhs.timestampUs == rhs.timestampUs
                && lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
                && lhs.hdop == rhs.hdop
                && lhs.vdop == rhs.vdop
                && lhs.velocityMS == rhs.velocityMS
                && lhs.cogDeg == rhs.cogDeg
                && lhs.altitudeEllipsoidM == rhs.altitudeEllipsoidM
                && lhs.horizontalUncertaintyM == rhs.horizontalUncertaintyM
                && lhs.verticalUncertaintyM == rhs.verticalUncertaintyM
                && lhs.velocityUncertaintyMS == rhs.velocityUncertaintyMS
                && lhs.headingUncertaintyDeg == rhs.headingUncertaintyDeg
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    /**
     Battery type.
     */
    public struct Battery: Equatable {
        public let voltageV: Float
        public let remainingPercent: Float

        

        /**
         Initializes a new `Battery`.

         
         - Parameters:
            
            - voltageV:  Voltage in volts
            
            - remainingPercent:  Estimated battery remaining (range: 0.0 to 1.0)
            
         
         */
        public init(voltageV: Float, remainingPercent: Float) {
            self.voltageV = voltageV
            self.remainingPercent = remainingPercent
        }

        internal var rpcBattery: Mavsdk_Rpc_TelemetryServer_Battery {
            var rpcBattery = Mavsdk_Rpc_TelemetryServer_Battery()
            
                
            rpcBattery.voltageV = voltageV
                
            
            
                
            rpcBattery.remainingPercent = remainingPercent
                
            

            return rpcBattery
        }

        internal static func translateFromRpc(_ rpcBattery: Mavsdk_Rpc_TelemetryServer_Battery) -> Battery {
            return Battery(voltageV: rpcBattery.voltageV, remainingPercent: rpcBattery.remainingPercent)
        }

        public static func == (lhs: Battery, rhs: Battery) -> Bool {
            return lhs.voltageV == rhs.voltageV
                && lhs.remainingPercent == rhs.remainingPercent
        }
    }

    /**
     Remote control status type.
     */
    public struct RcStatus: Equatable {
        public let wasAvailableOnce: Bool
        public let isAvailable: Bool
        public let signalStrengthPercent: Float

        

        /**
         Initializes a new `RcStatus`.

         
         - Parameters:
            
            - wasAvailableOnce:  True if an RC signal has been available once
            
            - isAvailable:  True if the RC signal is available now
            
            - signalStrengthPercent:  Signal strength (range: 0 to 100, NaN if unknown)
            
         
         */
        public init(wasAvailableOnce: Bool, isAvailable: Bool, signalStrengthPercent: Float) {
            self.wasAvailableOnce = wasAvailableOnce
            self.isAvailable = isAvailable
            self.signalStrengthPercent = signalStrengthPercent
        }

        internal var rpcRcStatus: Mavsdk_Rpc_TelemetryServer_RcStatus {
            var rpcRcStatus = Mavsdk_Rpc_TelemetryServer_RcStatus()
            
                
            rpcRcStatus.wasAvailableOnce = wasAvailableOnce
                
            
            
                
            rpcRcStatus.isAvailable = isAvailable
                
            
            
                
            rpcRcStatus.signalStrengthPercent = signalStrengthPercent
                
            

            return rpcRcStatus
        }

        internal static func translateFromRpc(_ rpcRcStatus: Mavsdk_Rpc_TelemetryServer_RcStatus) -> RcStatus {
            return RcStatus(wasAvailableOnce: rpcRcStatus.wasAvailableOnce, isAvailable: rpcRcStatus.isAvailable, signalStrengthPercent: rpcRcStatus.signalStrengthPercent)
        }

        public static func == (lhs: RcStatus, rhs: RcStatus) -> Bool {
            return lhs.wasAvailableOnce == rhs.wasAvailableOnce
                && lhs.isAvailable == rhs.isAvailable
                && lhs.signalStrengthPercent == rhs.signalStrengthPercent
        }
    }

    /**
     StatusText information type.
     */
    public struct StatusText: Equatable {
        public let type: StatusTextType
        public let text: String

        

        /**
         Initializes a new `StatusText`.

         
         - Parameters:
            
            - type:  Message type
            
            - text:  MAVLink status message
            
         
         */
        public init(type: StatusTextType, text: String) {
            self.type = type
            self.text = text
        }

        internal var rpcStatusText: Mavsdk_Rpc_TelemetryServer_StatusText {
            var rpcStatusText = Mavsdk_Rpc_TelemetryServer_StatusText()
            
                
            rpcStatusText.type = type.rpcStatusTextType
                
            
            
                
            rpcStatusText.text = text
                
            

            return rpcStatusText
        }

        internal static func translateFromRpc(_ rpcStatusText: Mavsdk_Rpc_TelemetryServer_StatusText) -> StatusText {
            return StatusText(type: StatusTextType.translateFromRpc(rpcStatusText.type), text: rpcStatusText.text)
        }

        public static func == (lhs: StatusText, rhs: StatusText) -> Bool {
            return lhs.type == rhs.type
                && lhs.text == rhs.text
        }
    }

    /**
     Actuator control target type.
     */
    public struct ActuatorControlTarget: Equatable {
        public let group: Int32
        public let controls: [Float]

        

        /**
         Initializes a new `ActuatorControlTarget`.

         
         - Parameters:
            
            - group:  An actuator control group is e.g. 'attitude' for the core flight controls, or 'gimbal' for a payload.
            
            - controls:  Controls normed from -1 to 1, where 0 is neutral position.
            
         
         */
        public init(group: Int32, controls: [Float]) {
            self.group = group
            self.controls = controls
        }

        internal var rpcActuatorControlTarget: Mavsdk_Rpc_TelemetryServer_ActuatorControlTarget {
            var rpcActuatorControlTarget = Mavsdk_Rpc_TelemetryServer_ActuatorControlTarget()
            
                
            rpcActuatorControlTarget.group = group
                
            
            
                
            rpcActuatorControlTarget.controls = controls
                
            

            return rpcActuatorControlTarget
        }

        internal static func translateFromRpc(_ rpcActuatorControlTarget: Mavsdk_Rpc_TelemetryServer_ActuatorControlTarget) -> ActuatorControlTarget {
            return ActuatorControlTarget(group: rpcActuatorControlTarget.group, controls: rpcActuatorControlTarget.controls)
        }

        public static func == (lhs: ActuatorControlTarget, rhs: ActuatorControlTarget) -> Bool {
            return lhs.group == rhs.group
                && lhs.controls == rhs.controls
        }
    }

    /**
     Actuator output status type.
     */
    public struct ActuatorOutputStatus: Equatable {
        public let active: UInt32
        public let actuator: [Float]

        

        /**
         Initializes a new `ActuatorOutputStatus`.

         
         - Parameters:
            
            - active:  Active outputs
            
            - actuator:  Servo/motor output values
            
         
         */
        public init(active: UInt32, actuator: [Float]) {
            self.active = active
            self.actuator = actuator
        }

        internal var rpcActuatorOutputStatus: Mavsdk_Rpc_TelemetryServer_ActuatorOutputStatus {
            var rpcActuatorOutputStatus = Mavsdk_Rpc_TelemetryServer_ActuatorOutputStatus()
            
                
            rpcActuatorOutputStatus.active = active
                
            
            
                
            rpcActuatorOutputStatus.actuator = actuator
                
            

            return rpcActuatorOutputStatus
        }

        internal static func translateFromRpc(_ rpcActuatorOutputStatus: Mavsdk_Rpc_TelemetryServer_ActuatorOutputStatus) -> ActuatorOutputStatus {
            return ActuatorOutputStatus(active: rpcActuatorOutputStatus.active, actuator: rpcActuatorOutputStatus.actuator)
        }

        public static func == (lhs: ActuatorOutputStatus, rhs: ActuatorOutputStatus) -> Bool {
            return lhs.active == rhs.active
                && lhs.actuator == rhs.actuator
        }
    }

    /**
     Covariance type.

     Row-major representation of a 6x6 cross-covariance matrix
     upper right triangle.
     Set first to NaN if unknown.
     */
    public struct Covariance: Equatable {
        public let covarianceMatrix: [Float]

        

        /**
         Initializes a new `Covariance`.

         
         - Parameter covarianceMatrix:  Representation of a covariance matrix.
         
         */
        public init(covarianceMatrix: [Float]) {
            self.covarianceMatrix = covarianceMatrix
        }

        internal var rpcCovariance: Mavsdk_Rpc_TelemetryServer_Covariance {
            var rpcCovariance = Mavsdk_Rpc_TelemetryServer_Covariance()
            
                
            rpcCovariance.covarianceMatrix = covarianceMatrix
                
            

            return rpcCovariance
        }

        internal static func translateFromRpc(_ rpcCovariance: Mavsdk_Rpc_TelemetryServer_Covariance) -> Covariance {
            return Covariance(covarianceMatrix: rpcCovariance.covarianceMatrix)
        }

        public static func == (lhs: Covariance, rhs: Covariance) -> Bool {
            return lhs.covarianceMatrix == rhs.covarianceMatrix
        }
    }

    /**
     Velocity type, represented in the Body (X Y Z) frame and in metres/second.
     */
    public struct VelocityBody: Equatable {
        public let xMS: Float
        public let yMS: Float
        public let zMS: Float

        

        /**
         Initializes a new `VelocityBody`.

         
         - Parameters:
            
            - xMS:  Velocity in X in metres/second
            
            - yMS:  Velocity in Y in metres/second
            
            - zMS:  Velocity in Z in metres/second
            
         
         */
        public init(xMS: Float, yMS: Float, zMS: Float) {
            self.xMS = xMS
            self.yMS = yMS
            self.zMS = zMS
        }

        internal var rpcVelocityBody: Mavsdk_Rpc_TelemetryServer_VelocityBody {
            var rpcVelocityBody = Mavsdk_Rpc_TelemetryServer_VelocityBody()
            
                
            rpcVelocityBody.xMS = xMS
                
            
            
                
            rpcVelocityBody.yMS = yMS
                
            
            
                
            rpcVelocityBody.zMS = zMS
                
            

            return rpcVelocityBody
        }

        internal static func translateFromRpc(_ rpcVelocityBody: Mavsdk_Rpc_TelemetryServer_VelocityBody) -> VelocityBody {
            return VelocityBody(xMS: rpcVelocityBody.xMS, yMS: rpcVelocityBody.yMS, zMS: rpcVelocityBody.zMS)
        }

        public static func == (lhs: VelocityBody, rhs: VelocityBody) -> Bool {
            return lhs.xMS == rhs.xMS
                && lhs.yMS == rhs.yMS
                && lhs.zMS == rhs.zMS
        }
    }

    /**
     Position type, represented in the Body (X Y Z) frame
     */
    public struct PositionBody: Equatable {
        public let xM: Float
        public let yM: Float
        public let zM: Float

        

        /**
         Initializes a new `PositionBody`.

         
         - Parameters:
            
            - xM:  X Position in metres.
            
            - yM:  Y Position in metres.
            
            - zM:  Z Position in metres.
            
         
         */
        public init(xM: Float, yM: Float, zM: Float) {
            self.xM = xM
            self.yM = yM
            self.zM = zM
        }

        internal var rpcPositionBody: Mavsdk_Rpc_TelemetryServer_PositionBody {
            var rpcPositionBody = Mavsdk_Rpc_TelemetryServer_PositionBody()
            
                
            rpcPositionBody.xM = xM
                
            
            
                
            rpcPositionBody.yM = yM
                
            
            
                
            rpcPositionBody.zM = zM
                
            

            return rpcPositionBody
        }

        internal static func translateFromRpc(_ rpcPositionBody: Mavsdk_Rpc_TelemetryServer_PositionBody) -> PositionBody {
            return PositionBody(xM: rpcPositionBody.xM, yM: rpcPositionBody.yM, zM: rpcPositionBody.zM)
        }

        public static func == (lhs: PositionBody, rhs: PositionBody) -> Bool {
            return lhs.xM == rhs.xM
                && lhs.yM == rhs.yM
                && lhs.zM == rhs.zM
        }
    }

    /**
     Odometry message type.
     */
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

        
        

        /**
         Mavlink frame id
         */
        public enum MavFrame: Equatable {
            ///  Frame is undefined..
            case undef
            ///  Setpoint in body NED frame. This makes sense if all position control is externalized - e.g. useful to command 2 m/s^2 acceleration to the right..
            case bodyNed
            ///  Odometry local coordinate frame of data given by a vision estimation system, Z-down (x: north, y: east, z: down)..
            case visionNed
            ///  Odometry local coordinate frame of data given by an estimator running onboard the vehicle, Z-down (x: north, y: east, z: down)..
            case estimNed
            case UNRECOGNIZED(Int)

            internal var rpcMavFrame: Mavsdk_Rpc_TelemetryServer_Odometry.MavFrame {
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

            internal static func translateFromRpc(_ rpcMavFrame: Mavsdk_Rpc_TelemetryServer_Odometry.MavFrame) -> MavFrame {
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
        

        /**
         Initializes a new `Odometry`.

         
         - Parameters:
            
            - timeUsec:  Timestamp (0 to use Backend timestamp).
            
            - frameID:  Coordinate frame of reference for the pose data.
            
            - childFrameID:  Coordinate frame of reference for the velocity in free space (twist) data.
            
            - positionBody:  Position.
            
            - q:  Quaternion components, w, x, y, z (1 0 0 0 is the null-rotation).
            
            - velocityBody:  Linear velocity (m/s).
            
            - angularVelocityBody:  Angular velocity (rad/s).
            
            - poseCovariance:  Pose cross-covariance matrix.
            
            - velocityCovariance:  Velocity cross-covariance matrix.
            
         
         */
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

        internal var rpcOdometry: Mavsdk_Rpc_TelemetryServer_Odometry {
            var rpcOdometry = Mavsdk_Rpc_TelemetryServer_Odometry()
            
                
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

        internal static func translateFromRpc(_ rpcOdometry: Mavsdk_Rpc_TelemetryServer_Odometry) -> Odometry {
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

    /**
     DistanceSensor message type.
     */
    public struct DistanceSensor: Equatable {
        public let minimumDistanceM: Float
        public let maximumDistanceM: Float
        public let currentDistanceM: Float

        

        /**
         Initializes a new `DistanceSensor`.

         
         - Parameters:
            
            - minimumDistanceM:  Minimum distance the sensor can measure, NaN if unknown.
            
            - maximumDistanceM:  Maximum distance the sensor can measure, NaN if unknown.
            
            - currentDistanceM:  Current distance reading, NaN if unknown.
            
         
         */
        public init(minimumDistanceM: Float, maximumDistanceM: Float, currentDistanceM: Float) {
            self.minimumDistanceM = minimumDistanceM
            self.maximumDistanceM = maximumDistanceM
            self.currentDistanceM = currentDistanceM
        }

        internal var rpcDistanceSensor: Mavsdk_Rpc_TelemetryServer_DistanceSensor {
            var rpcDistanceSensor = Mavsdk_Rpc_TelemetryServer_DistanceSensor()
            
                
            rpcDistanceSensor.minimumDistanceM = minimumDistanceM
                
            
            
                
            rpcDistanceSensor.maximumDistanceM = maximumDistanceM
                
            
            
                
            rpcDistanceSensor.currentDistanceM = currentDistanceM
                
            

            return rpcDistanceSensor
        }

        internal static func translateFromRpc(_ rpcDistanceSensor: Mavsdk_Rpc_TelemetryServer_DistanceSensor) -> DistanceSensor {
            return DistanceSensor(minimumDistanceM: rpcDistanceSensor.minimumDistanceM, maximumDistanceM: rpcDistanceSensor.maximumDistanceM, currentDistanceM: rpcDistanceSensor.currentDistanceM)
        }

        public static func == (lhs: DistanceSensor, rhs: DistanceSensor) -> Bool {
            return lhs.minimumDistanceM == rhs.minimumDistanceM
                && lhs.maximumDistanceM == rhs.maximumDistanceM
                && lhs.currentDistanceM == rhs.currentDistanceM
        }
    }

    /**
     Scaled Pressure message type.
     */
    public struct ScaledPressure: Equatable {
        public let timestampUs: UInt64
        public let absolutePressureHpa: Float
        public let differentialPressureHpa: Float
        public let temperatureDeg: Float
        public let differentialPressureTemperatureDeg: Float

        

        /**
         Initializes a new `ScaledPressure`.

         
         - Parameters:
            
            - timestampUs:  Timestamp (time since system boot)
            
            - absolutePressureHpa:  Absolute pressure in hPa
            
            - differentialPressureHpa:  Differential pressure 1 in hPa
            
            - temperatureDeg:  Absolute pressure temperature (in celsius)
            
            - differentialPressureTemperatureDeg:  Differential pressure temperature (in celsius, 0 if not available)
            
         
         */
        public init(timestampUs: UInt64, absolutePressureHpa: Float, differentialPressureHpa: Float, temperatureDeg: Float, differentialPressureTemperatureDeg: Float) {
            self.timestampUs = timestampUs
            self.absolutePressureHpa = absolutePressureHpa
            self.differentialPressureHpa = differentialPressureHpa
            self.temperatureDeg = temperatureDeg
            self.differentialPressureTemperatureDeg = differentialPressureTemperatureDeg
        }

        internal var rpcScaledPressure: Mavsdk_Rpc_TelemetryServer_ScaledPressure {
            var rpcScaledPressure = Mavsdk_Rpc_TelemetryServer_ScaledPressure()
            
                
            rpcScaledPressure.timestampUs = timestampUs
                
            
            
                
            rpcScaledPressure.absolutePressureHpa = absolutePressureHpa
                
            
            
                
            rpcScaledPressure.differentialPressureHpa = differentialPressureHpa
                
            
            
                
            rpcScaledPressure.temperatureDeg = temperatureDeg
                
            
            
                
            rpcScaledPressure.differentialPressureTemperatureDeg = differentialPressureTemperatureDeg
                
            

            return rpcScaledPressure
        }

        internal static func translateFromRpc(_ rpcScaledPressure: Mavsdk_Rpc_TelemetryServer_ScaledPressure) -> ScaledPressure {
            return ScaledPressure(timestampUs: rpcScaledPressure.timestampUs, absolutePressureHpa: rpcScaledPressure.absolutePressureHpa, differentialPressureHpa: rpcScaledPressure.differentialPressureHpa, temperatureDeg: rpcScaledPressure.temperatureDeg, differentialPressureTemperatureDeg: rpcScaledPressure.differentialPressureTemperatureDeg)
        }

        public static func == (lhs: ScaledPressure, rhs: ScaledPressure) -> Bool {
            return lhs.timestampUs == rhs.timestampUs
                && lhs.absolutePressureHpa == rhs.absolutePressureHpa
                && lhs.differentialPressureHpa == rhs.differentialPressureHpa
                && lhs.temperatureDeg == rhs.temperatureDeg
                && lhs.differentialPressureTemperatureDeg == rhs.differentialPressureTemperatureDeg
        }
    }

    /**
     PositionNed message type.
     */
    public struct PositionNed: Equatable {
        public let northM: Float
        public let eastM: Float
        public let downM: Float

        

        /**
         Initializes a new `PositionNed`.

         
         - Parameters:
            
            - northM:  Position along north direction in metres
            
            - eastM:  Position along east direction in metres
            
            - downM:  Position along down direction in metres
            
         
         */
        public init(northM: Float, eastM: Float, downM: Float) {
            self.northM = northM
            self.eastM = eastM
            self.downM = downM
        }

        internal var rpcPositionNed: Mavsdk_Rpc_TelemetryServer_PositionNed {
            var rpcPositionNed = Mavsdk_Rpc_TelemetryServer_PositionNed()
            
                
            rpcPositionNed.northM = northM
                
            
            
                
            rpcPositionNed.eastM = eastM
                
            
            
                
            rpcPositionNed.downM = downM
                
            

            return rpcPositionNed
        }

        internal static func translateFromRpc(_ rpcPositionNed: Mavsdk_Rpc_TelemetryServer_PositionNed) -> PositionNed {
            return PositionNed(northM: rpcPositionNed.northM, eastM: rpcPositionNed.eastM, downM: rpcPositionNed.downM)
        }

        public static func == (lhs: PositionNed, rhs: PositionNed) -> Bool {
            return lhs.northM == rhs.northM
                && lhs.eastM == rhs.eastM
                && lhs.downM == rhs.downM
        }
    }

    /**
     VelocityNed message type.
     */
    public struct VelocityNed: Equatable {
        public let northMS: Float
        public let eastMS: Float
        public let downMS: Float

        

        /**
         Initializes a new `VelocityNed`.

         
         - Parameters:
            
            - northMS:  Velocity along north direction in metres per second
            
            - eastMS:  Velocity along east direction in metres per second
            
            - downMS:  Velocity along down direction in metres per second
            
         
         */
        public init(northMS: Float, eastMS: Float, downMS: Float) {
            self.northMS = northMS
            self.eastMS = eastMS
            self.downMS = downMS
        }

        internal var rpcVelocityNed: Mavsdk_Rpc_TelemetryServer_VelocityNed {
            var rpcVelocityNed = Mavsdk_Rpc_TelemetryServer_VelocityNed()
            
                
            rpcVelocityNed.northMS = northMS
                
            
            
                
            rpcVelocityNed.eastMS = eastMS
                
            
            
                
            rpcVelocityNed.downMS = downMS
                
            

            return rpcVelocityNed
        }

        internal static func translateFromRpc(_ rpcVelocityNed: Mavsdk_Rpc_TelemetryServer_VelocityNed) -> VelocityNed {
            return VelocityNed(northMS: rpcVelocityNed.northMS, eastMS: rpcVelocityNed.eastMS, downMS: rpcVelocityNed.downMS)
        }

        public static func == (lhs: VelocityNed, rhs: VelocityNed) -> Bool {
            return lhs.northMS == rhs.northMS
                && lhs.eastMS == rhs.eastMS
                && lhs.downMS == rhs.downMS
        }
    }

    /**
     PositionVelocityNed message type.
     */
    public struct PositionVelocityNed: Equatable {
        public let position: PositionNed
        public let velocity: VelocityNed

        

        /**
         Initializes a new `PositionVelocityNed`.

         
         - Parameters:
            
            - position:  Position (NED)
            
            - velocity:  Velocity (NED)
            
         
         */
        public init(position: PositionNed, velocity: VelocityNed) {
            self.position = position
            self.velocity = velocity
        }

        internal var rpcPositionVelocityNed: Mavsdk_Rpc_TelemetryServer_PositionVelocityNed {
            var rpcPositionVelocityNed = Mavsdk_Rpc_TelemetryServer_PositionVelocityNed()
            
                
            rpcPositionVelocityNed.position = position.rpcPositionNed
                
            
            
                
            rpcPositionVelocityNed.velocity = velocity.rpcVelocityNed
                
            

            return rpcPositionVelocityNed
        }

        internal static func translateFromRpc(_ rpcPositionVelocityNed: Mavsdk_Rpc_TelemetryServer_PositionVelocityNed) -> PositionVelocityNed {
            return PositionVelocityNed(position: PositionNed.translateFromRpc(rpcPositionVelocityNed.position), velocity: VelocityNed.translateFromRpc(rpcPositionVelocityNed.velocity))
        }

        public static func == (lhs: PositionVelocityNed, rhs: PositionVelocityNed) -> Bool {
            return lhs.position == rhs.position
                && lhs.velocity == rhs.velocity
        }
    }

    /**
     GroundTruth message type.
     */
    public struct GroundTruth: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float

        

        /**
         Initializes a new `GroundTruth`.

         
         - Parameters:
            
            - latitudeDeg:  Latitude in degrees (range: -90 to +90)
            
            - longitudeDeg:  Longitude in degrees (range: -180 to 180)
            
            - absoluteAltitudeM:  Altitude AMSL (above mean sea level) in metres
            
         
         */
        public init(latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.absoluteAltitudeM = absoluteAltitudeM
        }

        internal var rpcGroundTruth: Mavsdk_Rpc_TelemetryServer_GroundTruth {
            var rpcGroundTruth = Mavsdk_Rpc_TelemetryServer_GroundTruth()
            
                
            rpcGroundTruth.latitudeDeg = latitudeDeg
                
            
            
                
            rpcGroundTruth.longitudeDeg = longitudeDeg
                
            
            
                
            rpcGroundTruth.absoluteAltitudeM = absoluteAltitudeM
                
            

            return rpcGroundTruth
        }

        internal static func translateFromRpc(_ rpcGroundTruth: Mavsdk_Rpc_TelemetryServer_GroundTruth) -> GroundTruth {
            return GroundTruth(latitudeDeg: rpcGroundTruth.latitudeDeg, longitudeDeg: rpcGroundTruth.longitudeDeg, absoluteAltitudeM: rpcGroundTruth.absoluteAltitudeM)
        }

        public static func == (lhs: GroundTruth, rhs: GroundTruth) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
        }
    }

    /**
     FixedwingMetrics message type.
     */
    public struct FixedwingMetrics: Equatable {
        public let airspeedMS: Float
        public let throttlePercentage: Float
        public let climbRateMS: Float

        

        /**
         Initializes a new `FixedwingMetrics`.

         
         - Parameters:
            
            - airspeedMS:  Current indicated airspeed (IAS) in metres per second
            
            - throttlePercentage:  Current throttle setting (0 to 100)
            
            - climbRateMS:  Current climb rate in metres per second
            
         
         */
        public init(airspeedMS: Float, throttlePercentage: Float, climbRateMS: Float) {
            self.airspeedMS = airspeedMS
            self.throttlePercentage = throttlePercentage
            self.climbRateMS = climbRateMS
        }

        internal var rpcFixedwingMetrics: Mavsdk_Rpc_TelemetryServer_FixedwingMetrics {
            var rpcFixedwingMetrics = Mavsdk_Rpc_TelemetryServer_FixedwingMetrics()
            
                
            rpcFixedwingMetrics.airspeedMS = airspeedMS
                
            
            
                
            rpcFixedwingMetrics.throttlePercentage = throttlePercentage
                
            
            
                
            rpcFixedwingMetrics.climbRateMS = climbRateMS
                
            

            return rpcFixedwingMetrics
        }

        internal static func translateFromRpc(_ rpcFixedwingMetrics: Mavsdk_Rpc_TelemetryServer_FixedwingMetrics) -> FixedwingMetrics {
            return FixedwingMetrics(airspeedMS: rpcFixedwingMetrics.airspeedMS, throttlePercentage: rpcFixedwingMetrics.throttlePercentage, climbRateMS: rpcFixedwingMetrics.climbRateMS)
        }

        public static func == (lhs: FixedwingMetrics, rhs: FixedwingMetrics) -> Bool {
            return lhs.airspeedMS == rhs.airspeedMS
                && lhs.throttlePercentage == rhs.throttlePercentage
                && lhs.climbRateMS == rhs.climbRateMS
        }
    }

    /**
     AccelerationFrd message type.
     */
    public struct AccelerationFrd: Equatable {
        public let forwardMS2: Float
        public let rightMS2: Float
        public let downMS2: Float

        

        /**
         Initializes a new `AccelerationFrd`.

         
         - Parameters:
            
            - forwardMS2:  Acceleration in forward direction in metres per second^2
            
            - rightMS2:  Acceleration in right direction in metres per second^2
            
            - downMS2:  Acceleration in down direction in metres per second^2
            
         
         */
        public init(forwardMS2: Float, rightMS2: Float, downMS2: Float) {
            self.forwardMS2 = forwardMS2
            self.rightMS2 = rightMS2
            self.downMS2 = downMS2
        }

        internal var rpcAccelerationFrd: Mavsdk_Rpc_TelemetryServer_AccelerationFrd {
            var rpcAccelerationFrd = Mavsdk_Rpc_TelemetryServer_AccelerationFrd()
            
                
            rpcAccelerationFrd.forwardMS2 = forwardMS2
                
            
            
                
            rpcAccelerationFrd.rightMS2 = rightMS2
                
            
            
                
            rpcAccelerationFrd.downMS2 = downMS2
                
            

            return rpcAccelerationFrd
        }

        internal static func translateFromRpc(_ rpcAccelerationFrd: Mavsdk_Rpc_TelemetryServer_AccelerationFrd) -> AccelerationFrd {
            return AccelerationFrd(forwardMS2: rpcAccelerationFrd.forwardMS2, rightMS2: rpcAccelerationFrd.rightMS2, downMS2: rpcAccelerationFrd.downMS2)
        }

        public static func == (lhs: AccelerationFrd, rhs: AccelerationFrd) -> Bool {
            return lhs.forwardMS2 == rhs.forwardMS2
                && lhs.rightMS2 == rhs.rightMS2
                && lhs.downMS2 == rhs.downMS2
        }
    }

    /**
     AngularVelocityFrd message type.
     */
    public struct AngularVelocityFrd: Equatable {
        public let forwardRadS: Float
        public let rightRadS: Float
        public let downRadS: Float

        

        /**
         Initializes a new `AngularVelocityFrd`.

         
         - Parameters:
            
            - forwardRadS:  Angular velocity in forward direction in radians per second
            
            - rightRadS:  Angular velocity in right direction in radians per second
            
            - downRadS:  Angular velocity in Down direction in radians per second
            
         
         */
        public init(forwardRadS: Float, rightRadS: Float, downRadS: Float) {
            self.forwardRadS = forwardRadS
            self.rightRadS = rightRadS
            self.downRadS = downRadS
        }

        internal var rpcAngularVelocityFrd: Mavsdk_Rpc_TelemetryServer_AngularVelocityFrd {
            var rpcAngularVelocityFrd = Mavsdk_Rpc_TelemetryServer_AngularVelocityFrd()
            
                
            rpcAngularVelocityFrd.forwardRadS = forwardRadS
                
            
            
                
            rpcAngularVelocityFrd.rightRadS = rightRadS
                
            
            
                
            rpcAngularVelocityFrd.downRadS = downRadS
                
            

            return rpcAngularVelocityFrd
        }

        internal static func translateFromRpc(_ rpcAngularVelocityFrd: Mavsdk_Rpc_TelemetryServer_AngularVelocityFrd) -> AngularVelocityFrd {
            return AngularVelocityFrd(forwardRadS: rpcAngularVelocityFrd.forwardRadS, rightRadS: rpcAngularVelocityFrd.rightRadS, downRadS: rpcAngularVelocityFrd.downRadS)
        }

        public static func == (lhs: AngularVelocityFrd, rhs: AngularVelocityFrd) -> Bool {
            return lhs.forwardRadS == rhs.forwardRadS
                && lhs.rightRadS == rhs.rightRadS
                && lhs.downRadS == rhs.downRadS
        }
    }

    /**
     MagneticFieldFrd message type.
     */
    public struct MagneticFieldFrd: Equatable {
        public let forwardGauss: Float
        public let rightGauss: Float
        public let downGauss: Float

        

        /**
         Initializes a new `MagneticFieldFrd`.

         
         - Parameters:
            
            - forwardGauss:  Magnetic field in forward direction measured in Gauss
            
            - rightGauss:  Magnetic field in East direction measured in Gauss
            
            - downGauss:  Magnetic field in Down direction measured in Gauss
            
         
         */
        public init(forwardGauss: Float, rightGauss: Float, downGauss: Float) {
            self.forwardGauss = forwardGauss
            self.rightGauss = rightGauss
            self.downGauss = downGauss
        }

        internal var rpcMagneticFieldFrd: Mavsdk_Rpc_TelemetryServer_MagneticFieldFrd {
            var rpcMagneticFieldFrd = Mavsdk_Rpc_TelemetryServer_MagneticFieldFrd()
            
                
            rpcMagneticFieldFrd.forwardGauss = forwardGauss
                
            
            
                
            rpcMagneticFieldFrd.rightGauss = rightGauss
                
            
            
                
            rpcMagneticFieldFrd.downGauss = downGauss
                
            

            return rpcMagneticFieldFrd
        }

        internal static func translateFromRpc(_ rpcMagneticFieldFrd: Mavsdk_Rpc_TelemetryServer_MagneticFieldFrd) -> MagneticFieldFrd {
            return MagneticFieldFrd(forwardGauss: rpcMagneticFieldFrd.forwardGauss, rightGauss: rpcMagneticFieldFrd.rightGauss, downGauss: rpcMagneticFieldFrd.downGauss)
        }

        public static func == (lhs: MagneticFieldFrd, rhs: MagneticFieldFrd) -> Bool {
            return lhs.forwardGauss == rhs.forwardGauss
                && lhs.rightGauss == rhs.rightGauss
                && lhs.downGauss == rhs.downGauss
        }
    }

    /**
     Imu message type.
     */
    public struct Imu: Equatable {
        public let accelerationFrd: AccelerationFrd
        public let angularVelocityFrd: AngularVelocityFrd
        public let magneticFieldFrd: MagneticFieldFrd
        public let temperatureDegc: Float
        public let timestampUs: UInt64

        

        /**
         Initializes a new `Imu`.

         
         - Parameters:
            
            - accelerationFrd:  Acceleration
            
            - angularVelocityFrd:  Angular velocity
            
            - magneticFieldFrd:  Magnetic field
            
            - temperatureDegc:  Temperature
            
            - timestampUs:  Timestamp in microseconds
            
         
         */
        public init(accelerationFrd: AccelerationFrd, angularVelocityFrd: AngularVelocityFrd, magneticFieldFrd: MagneticFieldFrd, temperatureDegc: Float, timestampUs: UInt64) {
            self.accelerationFrd = accelerationFrd
            self.angularVelocityFrd = angularVelocityFrd
            self.magneticFieldFrd = magneticFieldFrd
            self.temperatureDegc = temperatureDegc
            self.timestampUs = timestampUs
        }

        internal var rpcImu: Mavsdk_Rpc_TelemetryServer_Imu {
            var rpcImu = Mavsdk_Rpc_TelemetryServer_Imu()
            
                
            rpcImu.accelerationFrd = accelerationFrd.rpcAccelerationFrd
                
            
            
                
            rpcImu.angularVelocityFrd = angularVelocityFrd.rpcAngularVelocityFrd
                
            
            
                
            rpcImu.magneticFieldFrd = magneticFieldFrd.rpcMagneticFieldFrd
                
            
            
                
            rpcImu.temperatureDegc = temperatureDegc
                
            
            
                
            rpcImu.timestampUs = timestampUs
                
            

            return rpcImu
        }

        internal static func translateFromRpc(_ rpcImu: Mavsdk_Rpc_TelemetryServer_Imu) -> Imu {
            return Imu(accelerationFrd: AccelerationFrd.translateFromRpc(rpcImu.accelerationFrd), angularVelocityFrd: AngularVelocityFrd.translateFromRpc(rpcImu.angularVelocityFrd), magneticFieldFrd: MagneticFieldFrd.translateFromRpc(rpcImu.magneticFieldFrd), temperatureDegc: rpcImu.temperatureDegc, timestampUs: rpcImu.timestampUs)
        }

        public static func == (lhs: Imu, rhs: Imu) -> Bool {
            return lhs.accelerationFrd == rhs.accelerationFrd
                && lhs.angularVelocityFrd == rhs.angularVelocityFrd
                && lhs.magneticFieldFrd == rhs.magneticFieldFrd
                && lhs.temperatureDegc == rhs.temperatureDegc
                && lhs.timestampUs == rhs.timestampUs
        }
    }

    /**
     Result type.
     */
    public struct TelemetryServerResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for telemetry requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Success: the telemetry command was accepted by the vehicle.
            case success
            ///  No system connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command refused by vehicle.
            case commandDenied
            ///  Request timed out.
            case timeout
            ///  Request not supported.
            case unsupported
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result {
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
                case .unsupported:
                    return .unsupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result) -> Result {
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
                case .unsupported:
                    return .unsupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `TelemetryServerResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcTelemetryServerResult: Mavsdk_Rpc_TelemetryServer_TelemetryServerResult {
            var rpcTelemetryServerResult = Mavsdk_Rpc_TelemetryServer_TelemetryServerResult()
            
                
            rpcTelemetryServerResult.result = result.rpcResult
                
            
            
                
            rpcTelemetryServerResult.resultStr = resultStr
                
            

            return rpcTelemetryServerResult
        }

        internal static func translateFromRpc(_ rpcTelemetryServerResult: Mavsdk_Rpc_TelemetryServer_TelemetryServerResult) -> TelemetryServerResult {
            return TelemetryServerResult(result: Result.translateFromRpc(rpcTelemetryServerResult.result), resultStr: rpcTelemetryServerResult.resultStr)
        }

        public static func == (lhs: TelemetryServerResult, rhs: TelemetryServerResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Publish to 'position' updates.

     - Parameters:
        - position: The next position
        - velocityNed: The next velocity (NED)
        - heading: Heading (yaw) in degrees
     
     */
    public func publishPosition(position: Position, velocityNed: VelocityNed, heading: Heading) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishPositionRequest()

            
                
            request.position = position.rpcPosition
                
            
                
            request.velocityNed = velocityNed.rpcVelocityNed
                
            
                
            request.heading = heading.rpcHeading
                
            

            do {
                
                let response = self.service.publishPosition(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'home position' updates.

     - Parameter home: The next home position
     
     */
    public func publishHome(home: Position) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishHomeRequest()

            
                
            request.home = home.rpcPosition
                
            

            do {
                
                let response = self.service.publishHome(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish 'sys status' updates.

     - Parameters:
        - battery: The next 'battery' state
        - rcReceiverStatus: rc receiver status
        - gyroStatus:
        - accelStatus:
        - magStatus:
        - gpsStatus:
     
     */
    public func publishSysStatus(battery: Battery, rcReceiverStatus: Bool, gyroStatus: Bool, accelStatus: Bool, magStatus: Bool, gpsStatus: Bool) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishSysStatusRequest()

            
                
            request.battery = battery.rpcBattery
                
            
                
            request.rcReceiverStatus = rcReceiverStatus
                
            
                
            request.gyroStatus = gyroStatus
                
            
                
            request.accelStatus = accelStatus
                
            
                
            request.magStatus = magStatus
                
            
                
            request.gpsStatus = gpsStatus
                
            

            do {
                
                let response = self.service.publishSysStatus(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish 'extended sys state' updates.

     - Parameters:
        - vtolState:
        - landedState:
     
     */
    public func publishExtendedSysState(vtolState: VtolState, landedState: LandedState) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishExtendedSysStateRequest()

            
                
            request.vtolState = vtolState.rpcVtolState
                
            
                
            request.landedState = landedState.rpcLandedState
                
            

            do {
                
                let response = self.service.publishExtendedSysState(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'Raw GPS' updates.

     - Parameters:
        - rawGps: The next 'Raw GPS' state. Warning: this is an advanced feature, use `Position` updates to get the location of the drone!
        - gpsInfo: The next 'GPS info' state
     
     */
    public func publishRawGps(rawGps: RawGps, gpsInfo: GpsInfo) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishRawGpsRequest()

            
                
            request.rawGps = rawGps.rpcRawGps
                
            
                
            request.gpsInfo = gpsInfo.rpcGpsInfo
                
            

            do {
                
                let response = self.service.publishRawGps(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'battery' updates.

     - Parameter battery: The next 'battery' state
     
     */
    public func publishBattery(battery: Battery) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishBatteryRequest()

            
                
            request.battery = battery.rpcBattery
                
            

            do {
                
                let response = self.service.publishBattery(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'status text' updates.

     - Parameter statusText: The next 'status text'
     
     */
    public func publishStatusText(statusText: StatusText) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishStatusTextRequest()

            
                
            request.statusText = statusText.rpcStatusText
                
            

            do {
                
                let response = self.service.publishStatusText(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'odometry' updates.

     - Parameter odometry: The next odometry status
     
     */
    public func publishOdometry(odometry: Odometry) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishOdometryRequest()

            
                
            request.odometry = odometry.rpcOdometry
                
            

            do {
                
                let response = self.service.publishOdometry(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'position velocity' updates.

     - Parameter positionVelocityNed: The next position and velocity status
     
     */
    public func publishPositionVelocityNed(positionVelocityNed: PositionVelocityNed) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishPositionVelocityNedRequest()

            
                
            request.positionVelocityNed = positionVelocityNed.rpcPositionVelocityNed
                
            

            do {
                
                let response = self.service.publishPositionVelocityNed(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'ground truth' updates.

     - Parameter groundTruth: Ground truth position information available in simulation
     
     */
    public func publishGroundTruth(groundTruth: GroundTruth) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishGroundTruthRequest()

            
                
            request.groundTruth = groundTruth.rpcGroundTruth
                
            

            do {
                
                let response = self.service.publishGroundTruth(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'IMU' updates (in SI units in NED body frame).

     - Parameter imu: The next IMU status
     
     */
    public func publishImu(imu: Imu) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishImuRequest()

            
                
            request.imu = imu.rpcImu
                
            

            do {
                
                let response = self.service.publishImu(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'Scaled IMU' updates.

     - Parameter imu: The next scaled IMU status
     
     */
    public func publishScaledImu(imu: Imu) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishScaledImuRequest()

            
                
            request.imu = imu.rpcImu
                
            

            do {
                
                let response = self.service.publishScaledImu(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'Raw IMU' updates.

     - Parameter imu: The next raw IMU status
     
     */
    public func publishRawImu(imu: Imu) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishRawImuRequest()

            
                
            request.imu = imu.rpcImu
                
            

            do {
                
                let response = self.service.publishRawImu(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Publish to 'unix epoch time' updates.

     - Parameter timeUs: The next 'unix epoch time' status
     
     */
    public func publishUnixEpochTime(timeUs: UInt64) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TelemetryServer_PublishUnixEpochTimeRequest()

            
                
            request.timeUs = timeUs
                
            

            do {
                
                let response = self.service.publishUnixEpochTime(request)

                let result = try response.response.wait().telemetryServerResult
                if (result.result == Mavsdk_Rpc_TelemetryServer_TelemetryServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryServerError(code: TelemetryServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}