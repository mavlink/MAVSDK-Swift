import Foundation
import RxSwift
import GRPC
import NIO

/**
 Allow users to get vehicle telemetry and state information
 (e.g. battery, GPS, RC connection, flight mode etc.) and set telemetry update rates.
 */
public class Telemetry {
    private let service: Mavsdk_Rpc_Telemetry_TelemetryServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Telemetry` plugin.

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
        let service = Mavsdk_Rpc_Telemetry_TelemetryServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Telemetry_TelemetryServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
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

    /**
     Flight modes.

     For more information about flight modes, check out
     https://docs.px4.io/master/en/config/flight_mode.html.
     */
    public enum FlightMode: Equatable {
        ///  Mode not known.
        case unknown
        ///  Armed and ready to take off.
        case ready
        ///  Taking off.
        case takeoff
        ///  Holding (hovering in place (or circling for fixed-wing vehicles).
        case hold
        ///  In mission.
        case mission
        ///  Returning to launch position (then landing).
        case returnToLaunch
        ///  Landing.
        case land
        ///  In 'offboard' mode.
        case offboard
        ///  In 'follow-me' mode.
        case followMe
        ///  In 'Manual' mode.
        case manual
        ///  In 'Altitude Control' mode.
        case altctl
        ///  In 'Position Control' mode.
        case posctl
        ///  In 'Acro' mode.
        case acro
        ///  In 'Stabilize' mode.
        case stabilized
        ///  In 'Rattitude' mode.
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

        internal var rpcStatusTextType: Mavsdk_Rpc_Telemetry_StatusTextType {
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

        internal static func translateFromRpc(_ rpcStatusTextType: Mavsdk_Rpc_Telemetry_StatusTextType) -> StatusTextType {
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

    /**
     VTOL State enumeration
     */
    public enum VtolState: Equatable {
        ///  MAV is not configured as VTOL.
        case undefined
        ///  VTOL is in transition from multicopter to fixed-wing.
        case transitionToFw
        ///  VTOL is in transition from fixed-wing to multicopter.
        case transitionToMc
        ///  VTOL is in multicopter state.
        case mc
        ///  VTOL is in fixed-wing state.
        case fw
        case UNRECOGNIZED(Int)

        internal var rpcVtolState: Mavsdk_Rpc_Telemetry_VtolState {
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

        internal static func translateFromRpc(_ rpcVtolState: Mavsdk_Rpc_Telemetry_VtolState) -> VtolState {
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

        internal var rpcHeading: Mavsdk_Rpc_Telemetry_Heading {
            var rpcHeading = Mavsdk_Rpc_Telemetry_Heading()
            
                
            rpcHeading.headingDeg = headingDeg
                
            

            return rpcHeading
        }

        internal static func translateFromRpc(_ rpcHeading: Mavsdk_Rpc_Telemetry_Heading) -> Heading {
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

        internal var rpcQuaternion: Mavsdk_Rpc_Telemetry_Quaternion {
            var rpcQuaternion = Mavsdk_Rpc_Telemetry_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            
            
                
            rpcQuaternion.timestampUs = timestampUs
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: Mavsdk_Rpc_Telemetry_Quaternion) -> Quaternion {
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

        internal var rpcEulerAngle: Mavsdk_Rpc_Telemetry_EulerAngle {
            var rpcEulerAngle = Mavsdk_Rpc_Telemetry_EulerAngle()
            
                
            rpcEulerAngle.rollDeg = rollDeg
                
            
            
                
            rpcEulerAngle.pitchDeg = pitchDeg
                
            
            
                
            rpcEulerAngle.yawDeg = yawDeg
                
            
            
                
            rpcEulerAngle.timestampUs = timestampUs
                
            

            return rpcEulerAngle
        }

        internal static func translateFromRpc(_ rpcEulerAngle: Mavsdk_Rpc_Telemetry_EulerAngle) -> EulerAngle {
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

        internal var rpcRawGps: Mavsdk_Rpc_Telemetry_RawGps {
            var rpcRawGps = Mavsdk_Rpc_Telemetry_RawGps()
            
                
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

        internal static func translateFromRpc(_ rpcRawGps: Mavsdk_Rpc_Telemetry_RawGps) -> RawGps {
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
        public let id: UInt32
        public let voltageV: Float
        public let remainingPercent: Float

        

        /**
         Initializes a new `Battery`.

         
         - Parameters:
            
            - id:  Battery ID, for systems with multiple batteries
            
            - voltageV:  Voltage in volts
            
            - remainingPercent:  Estimated battery remaining (range: 0.0 to 1.0)
            
         
         */
        public init(id: UInt32, voltageV: Float, remainingPercent: Float) {
            self.id = id
            self.voltageV = voltageV
            self.remainingPercent = remainingPercent
        }

        internal var rpcBattery: Mavsdk_Rpc_Telemetry_Battery {
            var rpcBattery = Mavsdk_Rpc_Telemetry_Battery()
            
                
            rpcBattery.id = id
                
            
            
                
            rpcBattery.voltageV = voltageV
                
            
            
                
            rpcBattery.remainingPercent = remainingPercent
                
            

            return rpcBattery
        }

        internal static func translateFromRpc(_ rpcBattery: Mavsdk_Rpc_Telemetry_Battery) -> Battery {
            return Battery(id: rpcBattery.id, voltageV: rpcBattery.voltageV, remainingPercent: rpcBattery.remainingPercent)
        }

        public static func == (lhs: Battery, rhs: Battery) -> Bool {
            return lhs.id == rhs.id
                && lhs.voltageV == rhs.voltageV
                && lhs.remainingPercent == rhs.remainingPercent
        }
    }

    /**
     Health type.
     */
    public struct Health: Equatable {
        public let isGyrometerCalibrationOk: Bool
        public let isAccelerometerCalibrationOk: Bool
        public let isMagnetometerCalibrationOk: Bool
        public let isLocalPositionOk: Bool
        public let isGlobalPositionOk: Bool
        public let isHomePositionOk: Bool
        public let isArmable: Bool

        

        /**
         Initializes a new `Health`.

         
         - Parameters:
            
            - isGyrometerCalibrationOk:  True if the gyrometer is calibrated
            
            - isAccelerometerCalibrationOk:  True if the accelerometer is calibrated
            
            - isMagnetometerCalibrationOk:  True if the magnetometer is calibrated
            
            - isLocalPositionOk:  True if the local position estimate is good enough to fly in 'position control' mode
            
            - isGlobalPositionOk:  True if the global position estimate is good enough to fly in 'position control' mode
            
            - isHomePositionOk:  True if the home position has been initialized properly
            
            - isArmable:  True if system can be armed
            
         
         */
        public init(isGyrometerCalibrationOk: Bool, isAccelerometerCalibrationOk: Bool, isMagnetometerCalibrationOk: Bool, isLocalPositionOk: Bool, isGlobalPositionOk: Bool, isHomePositionOk: Bool, isArmable: Bool) {
            self.isGyrometerCalibrationOk = isGyrometerCalibrationOk
            self.isAccelerometerCalibrationOk = isAccelerometerCalibrationOk
            self.isMagnetometerCalibrationOk = isMagnetometerCalibrationOk
            self.isLocalPositionOk = isLocalPositionOk
            self.isGlobalPositionOk = isGlobalPositionOk
            self.isHomePositionOk = isHomePositionOk
            self.isArmable = isArmable
        }

        internal var rpcHealth: Mavsdk_Rpc_Telemetry_Health {
            var rpcHealth = Mavsdk_Rpc_Telemetry_Health()
            
                
            rpcHealth.isGyrometerCalibrationOk = isGyrometerCalibrationOk
                
            
            
                
            rpcHealth.isAccelerometerCalibrationOk = isAccelerometerCalibrationOk
                
            
            
                
            rpcHealth.isMagnetometerCalibrationOk = isMagnetometerCalibrationOk
                
            
            
                
            rpcHealth.isLocalPositionOk = isLocalPositionOk
                
            
            
                
            rpcHealth.isGlobalPositionOk = isGlobalPositionOk
                
            
            
                
            rpcHealth.isHomePositionOk = isHomePositionOk
                
            
            
                
            rpcHealth.isArmable = isArmable
                
            

            return rpcHealth
        }

        internal static func translateFromRpc(_ rpcHealth: Mavsdk_Rpc_Telemetry_Health) -> Health {
            return Health(isGyrometerCalibrationOk: rpcHealth.isGyrometerCalibrationOk, isAccelerometerCalibrationOk: rpcHealth.isAccelerometerCalibrationOk, isMagnetometerCalibrationOk: rpcHealth.isMagnetometerCalibrationOk, isLocalPositionOk: rpcHealth.isLocalPositionOk, isGlobalPositionOk: rpcHealth.isGlobalPositionOk, isHomePositionOk: rpcHealth.isHomePositionOk, isArmable: rpcHealth.isArmable)
        }

        public static func == (lhs: Health, rhs: Health) -> Bool {
            return lhs.isGyrometerCalibrationOk == rhs.isGyrometerCalibrationOk
                && lhs.isAccelerometerCalibrationOk == rhs.isAccelerometerCalibrationOk
                && lhs.isMagnetometerCalibrationOk == rhs.isMagnetometerCalibrationOk
                && lhs.isLocalPositionOk == rhs.isLocalPositionOk
                && lhs.isGlobalPositionOk == rhs.isGlobalPositionOk
                && lhs.isHomePositionOk == rhs.isHomePositionOk
                && lhs.isArmable == rhs.isArmable
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

        internal var rpcDistanceSensor: Mavsdk_Rpc_Telemetry_DistanceSensor {
            var rpcDistanceSensor = Mavsdk_Rpc_Telemetry_DistanceSensor()
            
                
            rpcDistanceSensor.minimumDistanceM = minimumDistanceM
                
            
            
                
            rpcDistanceSensor.maximumDistanceM = maximumDistanceM
                
            
            
                
            rpcDistanceSensor.currentDistanceM = currentDistanceM
                
            

            return rpcDistanceSensor
        }

        internal static func translateFromRpc(_ rpcDistanceSensor: Mavsdk_Rpc_Telemetry_DistanceSensor) -> DistanceSensor {
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

        internal var rpcScaledPressure: Mavsdk_Rpc_Telemetry_ScaledPressure {
            var rpcScaledPressure = Mavsdk_Rpc_Telemetry_ScaledPressure()
            
                
            rpcScaledPressure.timestampUs = timestampUs
                
            
            
                
            rpcScaledPressure.absolutePressureHpa = absolutePressureHpa
                
            
            
                
            rpcScaledPressure.differentialPressureHpa = differentialPressureHpa
                
            
            
                
            rpcScaledPressure.temperatureDeg = temperatureDeg
                
            
            
                
            rpcScaledPressure.differentialPressureTemperatureDeg = differentialPressureTemperatureDeg
                
            

            return rpcScaledPressure
        }

        internal static func translateFromRpc(_ rpcScaledPressure: Mavsdk_Rpc_Telemetry_ScaledPressure) -> ScaledPressure {
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

        internal var rpcImu: Mavsdk_Rpc_Telemetry_Imu {
            var rpcImu = Mavsdk_Rpc_Telemetry_Imu()
            
                
            rpcImu.accelerationFrd = accelerationFrd.rpcAccelerationFrd
                
            
            
                
            rpcImu.angularVelocityFrd = angularVelocityFrd.rpcAngularVelocityFrd
                
            
            
                
            rpcImu.magneticFieldFrd = magneticFieldFrd.rpcMagneticFieldFrd
                
            
            
                
            rpcImu.temperatureDegc = temperatureDegc
                
            
            
                
            rpcImu.timestampUs = timestampUs
                
            

            return rpcImu
        }

        internal static func translateFromRpc(_ rpcImu: Mavsdk_Rpc_Telemetry_Imu) -> Imu {
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
     Gps global origin type.
     */
    public struct GpsGlobalOrigin: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let altitudeM: Float

        

        /**
         Initializes a new `GpsGlobalOrigin`.

         
         - Parameters:
            
            - latitudeDeg:  Latitude of the origin
            
            - longitudeDeg:  Longitude of the origin
            
            - altitudeM:  Altitude AMSL (above mean sea level) in metres
            
         
         */
        public init(latitudeDeg: Double, longitudeDeg: Double, altitudeM: Float) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.altitudeM = altitudeM
        }

        internal var rpcGpsGlobalOrigin: Mavsdk_Rpc_Telemetry_GpsGlobalOrigin {
            var rpcGpsGlobalOrigin = Mavsdk_Rpc_Telemetry_GpsGlobalOrigin()
            
                
            rpcGpsGlobalOrigin.latitudeDeg = latitudeDeg
                
            
            
                
            rpcGpsGlobalOrigin.longitudeDeg = longitudeDeg
                
            
            
                
            rpcGpsGlobalOrigin.altitudeM = altitudeM
                
            

            return rpcGpsGlobalOrigin
        }

        internal static func translateFromRpc(_ rpcGpsGlobalOrigin: Mavsdk_Rpc_Telemetry_GpsGlobalOrigin) -> GpsGlobalOrigin {
            return GpsGlobalOrigin(latitudeDeg: rpcGpsGlobalOrigin.latitudeDeg, longitudeDeg: rpcGpsGlobalOrigin.longitudeDeg, altitudeM: rpcGpsGlobalOrigin.altitudeM)
        }

        public static func == (lhs: GpsGlobalOrigin, rhs: GpsGlobalOrigin) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.altitudeM == rhs.altitudeM
        }
    }

    /**
     Result type.
     */
    public struct TelemetryResult: Equatable {
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
                case .unsupported:
                    return .unsupported
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
                case .unsupported:
                    return .unsupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `TelemetryResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
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



    /**
     Subscribe to 'position' updates.
     */
    public lazy var position: Observable<Position> = createPositionObservable()



    private func createPositionObservable() -> Observable<Position> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribePositionRequest()

            

            let serverStreamingCall = self.service.subscribePosition(request, handler: { (response) in

                
                     
                let position = Position.translateFromRpc(response.position)
                

                
                observer.onNext(position)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'home position' updates.
     */
    public lazy var home: Observable<Position> = createHomeObservable()



    private func createHomeObservable() -> Observable<Position> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeHomeRequest()

            

            let serverStreamingCall = self.service.subscribeHome(request, handler: { (response) in

                
                     
                let home = Position.translateFromRpc(response.home)
                

                
                observer.onNext(home)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to in-air updates.
     */
    public lazy var inAir: Observable<Bool> = createInAirObservable()



    private func createInAirObservable() -> Observable<Bool> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeInAirRequest()

            

            let serverStreamingCall = self.service.subscribeInAir(request, handler: { (response) in

                
                     
                let inAir = response.isInAir
                    
                

                
                observer.onNext(inAir)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to landed state updates
     */
    public lazy var landedState: Observable<LandedState> = createLandedStateObservable()



    private func createLandedStateObservable() -> Observable<LandedState> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeLandedStateRequest()

            

            let serverStreamingCall = self.service.subscribeLandedState(request, handler: { (response) in

                
                     
                let landedState = LandedState.translateFromRpc(response.landedState)
                

                
                observer.onNext(landedState)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to armed updates.
     */
    public lazy var armed: Observable<Bool> = createArmedObservable()



    private func createArmedObservable() -> Observable<Bool> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeArmedRequest()

            

            let serverStreamingCall = self.service.subscribeArmed(request, handler: { (response) in

                
                     
                let armed = response.isArmed
                    
                

                
                observer.onNext(armed)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     subscribe to vtol state Updates
     */
    public lazy var vtolState: Observable<VtolState> = createVtolStateObservable()



    private func createVtolStateObservable() -> Observable<VtolState> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeVtolStateRequest()

            

            let serverStreamingCall = self.service.subscribeVtolState(request, handler: { (response) in

                
                     
                let vtolState = VtolState.translateFromRpc(response.vtolState)
                

                
                observer.onNext(vtolState)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'attitude' updates (quaternion).
     */
    public lazy var attitudeQuaternion: Observable<Quaternion> = createAttitudeQuaternionObservable()



    private func createAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeAttitudeQuaternionRequest()

            

            let serverStreamingCall = self.service.subscribeAttitudeQuaternion(request, handler: { (response) in

                
                     
                let attitudeQuaternion = Quaternion.translateFromRpc(response.attitudeQuaternion)
                

                
                observer.onNext(attitudeQuaternion)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'attitude' updates (Euler).
     */
    public lazy var attitudeEuler: Observable<EulerAngle> = createAttitudeEulerObservable()



    private func createAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeAttitudeEulerRequest()

            

            let serverStreamingCall = self.service.subscribeAttitudeEuler(request, handler: { (response) in

                
                     
                let attitudeEuler = EulerAngle.translateFromRpc(response.attitudeEuler)
                

                
                observer.onNext(attitudeEuler)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'attitude' updates (angular velocity)
     */
    public lazy var attitudeAngularVelocityBody: Observable<AngularVelocityBody> = createAttitudeAngularVelocityBodyObservable()



    private func createAttitudeAngularVelocityBodyObservable() -> Observable<AngularVelocityBody> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeAttitudeAngularVelocityBodyRequest()

            

            let serverStreamingCall = self.service.subscribeAttitudeAngularVelocityBody(request, handler: { (response) in

                
                     
                let attitudeAngularVelocityBody = AngularVelocityBody.translateFromRpc(response.attitudeAngularVelocityBody)
                

                
                observer.onNext(attitudeAngularVelocityBody)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'camera attitude' updates (quaternion).
     */
    public lazy var cameraAttitudeQuaternion: Observable<Quaternion> = createCameraAttitudeQuaternionObservable()



    private func createCameraAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeCameraAttitudeQuaternionRequest()

            

            let serverStreamingCall = self.service.subscribeCameraAttitudeQuaternion(request, handler: { (response) in

                
                     
                let cameraAttitudeQuaternion = Quaternion.translateFromRpc(response.attitudeQuaternion)
                

                
                observer.onNext(cameraAttitudeQuaternion)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'camera attitude' updates (Euler).
     */
    public lazy var cameraAttitudeEuler: Observable<EulerAngle> = createCameraAttitudeEulerObservable()



    private func createCameraAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeCameraAttitudeEulerRequest()

            

            let serverStreamingCall = self.service.subscribeCameraAttitudeEuler(request, handler: { (response) in

                
                     
                let cameraAttitudeEuler = EulerAngle.translateFromRpc(response.attitudeEuler)
                

                
                observer.onNext(cameraAttitudeEuler)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'ground speed' updates (NED).
     */
    public lazy var velocityNed: Observable<VelocityNed> = createVelocityNedObservable()



    private func createVelocityNedObservable() -> Observable<VelocityNed> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeVelocityNedRequest()

            

            let serverStreamingCall = self.service.subscribeVelocityNed(request, handler: { (response) in

                
                     
                let velocityNed = VelocityNed.translateFromRpc(response.velocityNed)
                

                
                observer.onNext(velocityNed)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'GPS info' updates.
     */
    public lazy var gpsInfo: Observable<GpsInfo> = createGpsInfoObservable()



    private func createGpsInfoObservable() -> Observable<GpsInfo> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeGpsInfoRequest()

            

            let serverStreamingCall = self.service.subscribeGpsInfo(request, handler: { (response) in

                
                     
                let gpsInfo = GpsInfo.translateFromRpc(response.gpsInfo)
                

                
                observer.onNext(gpsInfo)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'Raw GPS' updates.
     */
    public lazy var rawGps: Observable<RawGps> = createRawGpsObservable()



    private func createRawGpsObservable() -> Observable<RawGps> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeRawGpsRequest()

            

            let serverStreamingCall = self.service.subscribeRawGps(request, handler: { (response) in

                
                     
                let rawGps = RawGps.translateFromRpc(response.rawGps)
                

                
                observer.onNext(rawGps)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'battery' updates.
     */
    public lazy var battery: Observable<Battery> = createBatteryObservable()



    private func createBatteryObservable() -> Observable<Battery> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeBatteryRequest()

            

            let serverStreamingCall = self.service.subscribeBattery(request, handler: { (response) in

                
                     
                let battery = Battery.translateFromRpc(response.battery)
                

                
                observer.onNext(battery)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'flight mode' updates.
     */
    public lazy var flightMode: Observable<FlightMode> = createFlightModeObservable()



    private func createFlightModeObservable() -> Observable<FlightMode> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeFlightModeRequest()

            

            let serverStreamingCall = self.service.subscribeFlightMode(request, handler: { (response) in

                
                     
                let flightMode = FlightMode.translateFromRpc(response.flightMode)
                

                
                observer.onNext(flightMode)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'health' updates.
     */
    public lazy var health: Observable<Health> = createHealthObservable()



    private func createHealthObservable() -> Observable<Health> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeHealthRequest()

            

            let serverStreamingCall = self.service.subscribeHealth(request, handler: { (response) in

                
                     
                let health = Health.translateFromRpc(response.health)
                

                
                observer.onNext(health)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'RC status' updates.
     */
    public lazy var rcStatus: Observable<RcStatus> = createRcStatusObservable()



    private func createRcStatusObservable() -> Observable<RcStatus> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeRcStatusRequest()

            

            let serverStreamingCall = self.service.subscribeRcStatus(request, handler: { (response) in

                
                     
                let rcStatus = RcStatus.translateFromRpc(response.rcStatus)
                

                
                observer.onNext(rcStatus)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'status text' updates.
     */
    public lazy var statusText: Observable<StatusText> = createStatusTextObservable()



    private func createStatusTextObservable() -> Observable<StatusText> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeStatusTextRequest()

            

            let serverStreamingCall = self.service.subscribeStatusText(request, handler: { (response) in

                
                     
                let statusText = StatusText.translateFromRpc(response.statusText)
                

                
                observer.onNext(statusText)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'actuator control target' updates.
     */
    public lazy var actuatorControlTarget: Observable<ActuatorControlTarget> = createActuatorControlTargetObservable()



    private func createActuatorControlTargetObservable() -> Observable<ActuatorControlTarget> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeActuatorControlTargetRequest()

            

            let serverStreamingCall = self.service.subscribeActuatorControlTarget(request, handler: { (response) in

                
                     
                let actuatorControlTarget = ActuatorControlTarget.translateFromRpc(response.actuatorControlTarget)
                

                
                observer.onNext(actuatorControlTarget)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'actuator output status' updates.
     */
    public lazy var actuatorOutputStatus: Observable<ActuatorOutputStatus> = createActuatorOutputStatusObservable()



    private func createActuatorOutputStatusObservable() -> Observable<ActuatorOutputStatus> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeActuatorOutputStatusRequest()

            

            let serverStreamingCall = self.service.subscribeActuatorOutputStatus(request, handler: { (response) in

                
                     
                let actuatorOutputStatus = ActuatorOutputStatus.translateFromRpc(response.actuatorOutputStatus)
                

                
                observer.onNext(actuatorOutputStatus)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'odometry' updates.
     */
    public lazy var odometry: Observable<Odometry> = createOdometryObservable()



    private func createOdometryObservable() -> Observable<Odometry> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeOdometryRequest()

            

            let serverStreamingCall = self.service.subscribeOdometry(request, handler: { (response) in

                
                     
                let odometry = Odometry.translateFromRpc(response.odometry)
                

                
                observer.onNext(odometry)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'position velocity' updates.
     */
    public lazy var positionVelocityNed: Observable<PositionVelocityNed> = createPositionVelocityNedObservable()



    private func createPositionVelocityNedObservable() -> Observable<PositionVelocityNed> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribePositionVelocityNedRequest()

            

            let serverStreamingCall = self.service.subscribePositionVelocityNed(request, handler: { (response) in

                
                     
                let positionVelocityNed = PositionVelocityNed.translateFromRpc(response.positionVelocityNed)
                

                
                observer.onNext(positionVelocityNed)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'ground truth' updates.
     */
    public lazy var groundTruth: Observable<GroundTruth> = createGroundTruthObservable()



    private func createGroundTruthObservable() -> Observable<GroundTruth> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeGroundTruthRequest()

            

            let serverStreamingCall = self.service.subscribeGroundTruth(request, handler: { (response) in

                
                     
                let groundTruth = GroundTruth.translateFromRpc(response.groundTruth)
                

                
                observer.onNext(groundTruth)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'fixedwing metrics' updates.
     */
    public lazy var fixedwingMetrics: Observable<FixedwingMetrics> = createFixedwingMetricsObservable()



    private func createFixedwingMetricsObservable() -> Observable<FixedwingMetrics> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeFixedwingMetricsRequest()

            

            let serverStreamingCall = self.service.subscribeFixedwingMetrics(request, handler: { (response) in

                
                     
                let fixedwingMetrics = FixedwingMetrics.translateFromRpc(response.fixedwingMetrics)
                

                
                observer.onNext(fixedwingMetrics)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'IMU' updates (in SI units in NED body frame).
     */
    public lazy var imu: Observable<Imu> = createImuObservable()



    private func createImuObservable() -> Observable<Imu> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeImuRequest()

            

            let serverStreamingCall = self.service.subscribeImu(request, handler: { (response) in

                
                     
                let imu = Imu.translateFromRpc(response.imu)
                

                
                observer.onNext(imu)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'Scaled IMU' updates.
     */
    public lazy var scaledImu: Observable<Imu> = createScaledImuObservable()



    private func createScaledImuObservable() -> Observable<Imu> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeScaledImuRequest()

            

            let serverStreamingCall = self.service.subscribeScaledImu(request, handler: { (response) in

                
                     
                let scaledImu = Imu.translateFromRpc(response.imu)
                

                
                observer.onNext(scaledImu)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'Raw IMU' updates.
     */
    public lazy var rawImu: Observable<Imu> = createRawImuObservable()



    private func createRawImuObservable() -> Observable<Imu> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeRawImuRequest()

            

            let serverStreamingCall = self.service.subscribeRawImu(request, handler: { (response) in

                
                     
                let rawImu = Imu.translateFromRpc(response.imu)
                

                
                observer.onNext(rawImu)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'HealthAllOk' updates.
     */
    public lazy var healthAllOk: Observable<Bool> = createHealthAllOkObservable()



    private func createHealthAllOkObservable() -> Observable<Bool> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeHealthAllOkRequest()

            

            let serverStreamingCall = self.service.subscribeHealthAllOk(request, handler: { (response) in

                
                     
                let healthAllOk = response.isHealthAllOk
                    
                

                
                observer.onNext(healthAllOk)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'unix epoch time' updates.
     */
    public lazy var unixEpochTime: Observable<UInt64> = createUnixEpochTimeObservable()



    private func createUnixEpochTimeObservable() -> Observable<UInt64> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeUnixEpochTimeRequest()

            

            let serverStreamingCall = self.service.subscribeUnixEpochTime(request, handler: { (response) in

                
                     
                let unixEpochTime = response.timeUs
                    
                

                
                observer.onNext(unixEpochTime)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'Distance Sensor' updates.
     */
    public lazy var distanceSensor: Observable<DistanceSensor> = createDistanceSensorObservable()



    private func createDistanceSensorObservable() -> Observable<DistanceSensor> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeDistanceSensorRequest()

            

            let serverStreamingCall = self.service.subscribeDistanceSensor(request, handler: { (response) in

                
                     
                let distanceSensor = DistanceSensor.translateFromRpc(response.distanceSensor)
                

                
                observer.onNext(distanceSensor)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'Scaled Pressure' updates.
     */
    public lazy var scaledPressure: Observable<ScaledPressure> = createScaledPressureObservable()



    private func createScaledPressureObservable() -> Observable<ScaledPressure> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeScaledPressureRequest()

            

            let serverStreamingCall = self.service.subscribeScaledPressure(request, handler: { (response) in

                
                     
                let scaledPressure = ScaledPressure.translateFromRpc(response.scaledPressure)
                

                
                observer.onNext(scaledPressure)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to 'Heading' updates.
     */
    public lazy var heading: Observable<Heading> = createHeadingObservable()



    private func createHeadingObservable() -> Observable<Heading> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Telemetry_SubscribeHeadingRequest()

            

            let serverStreamingCall = self.service.subscribeHeading(request, handler: { (response) in

                
                     
                let heading = Heading.translateFromRpc(response.headingDeg)
                

                
                observer.onNext(heading)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTelemetryError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Set rate to 'position' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRatePosition(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRatePositionRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRatePosition(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'home position' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateHome(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateHomeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateHome(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to in-air updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateInAir(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateInAirRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateInAir(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to landed state updates

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateLandedState(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateLandedStateRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateLandedState(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to VTOL state updates

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateVtolState(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateVtolStateRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateVtolState(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'attitude' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateAttitude(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateAttitudeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateAttitude(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate of camera attitude updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateCameraAttitude(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateCameraAttitudeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateCameraAttitude(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'ground speed' updates (NED).

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateVelocityNed(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateVelocityNedRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateVelocityNed(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'GPS info' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateGpsInfo(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateGpsInfoRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateGpsInfo(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'battery' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateBattery(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateBatteryRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateBattery(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'RC status' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateRcStatus(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateRcStatusRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateRcStatus(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'actuator control target' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateActuatorControlTarget(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateActuatorControlTargetRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateActuatorControlTarget(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'actuator output status' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateActuatorOutputStatus(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateActuatorOutputStatusRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateActuatorOutputStatus(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'odometry' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateOdometry(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateOdometryRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateOdometry(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'position velocity' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRatePositionVelocityNed(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRatePositionVelocityNedRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRatePositionVelocityNed(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'ground truth' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateGroundTruth(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateGroundTruthRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateGroundTruth(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'fixedwing metrics' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateFixedwingMetrics(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateFixedwingMetricsRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateFixedwingMetrics(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'IMU' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateImu(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateImuRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateImu(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'Scaled IMU' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateScaledImu(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateScaledImuRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateScaledImu(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'Raw IMU' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateRawImu(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateRawImuRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateRawImu(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'unix epoch time' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateUnixEpochTime(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateUnixEpochTimeRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateUnixEpochTime(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set rate to 'Distance Sensor' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateDistanceSensor(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Telemetry_SetRateDistanceSensorRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateDistanceSensor(request)

                let result = try response.response.wait().telemetryResult
                if (result.result == Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the GPS location of where the estimator has been initialized.

     
     */
    public func getGpsGlobalOrigin() -> Single<GpsGlobalOrigin> {
        return Single<GpsGlobalOrigin>.create { single in
            let request = Mavsdk_Rpc_Telemetry_GetGpsGlobalOriginRequest()

            

            do {
                let response = self.service.getGpsGlobalOrigin(request)

                
                let result = try response.response.wait().telemetryResult
                if (result.result != Mavsdk_Rpc_Telemetry_TelemetryResult.Result.success) {
                    single(.failure(TelemetryError(code: TelemetryResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let gpsGlobalOrigin = try GpsGlobalOrigin.translateFromRpc(response.response.wait().gpsGlobalOrigin)
                
                single(.success(gpsGlobalOrigin))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}