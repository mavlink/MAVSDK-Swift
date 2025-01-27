import Foundation
import RxSwift
import GRPC
import NIO

/**
 Provides handling of camera interface
 */
public class CameraServer {
    private let service: Mavsdk_Rpc_CameraServer_CameraServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `CameraServer` plugin.

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
        let service = Mavsdk_Rpc_CameraServer_CameraServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_CameraServer_CameraServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeCameraServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct CameraServerError: Error {
        public let code: CameraServer.CameraServerResult.Result
        public let description: String
    }
    

    /**
     Possible feedback results for camera respond command.
     */
    public enum CameraFeedback: Equatable {
        ///  Unknown.
        case unknown
        ///  Ok.
        case ok
        ///  Busy.
        case busy
        ///  Failed.
        case failed
        case UNRECOGNIZED(Int)

        internal var rpcCameraFeedback: Mavsdk_Rpc_CameraServer_CameraFeedback {
            switch self {
            case .unknown:
                return .unknown
            case .ok:
                return .ok
            case .busy:
                return .busy
            case .failed:
                return .failed
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcCameraFeedback: Mavsdk_Rpc_CameraServer_CameraFeedback) -> CameraFeedback {
            switch rpcCameraFeedback {
            case .unknown:
                return .unknown
            case .ok:
                return .ok
            case .busy:
                return .busy
            case .failed:
                return .failed
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    /**
     Camera mode type.
     */
    public enum Mode: Equatable {
        ///  Unknown mode.
        case unknown
        ///  Photo mode.
        case photo
        ///  Video mode.
        case video
        case UNRECOGNIZED(Int)

        internal var rpcMode: Mavsdk_Rpc_CameraServer_Mode {
            switch self {
            case .unknown:
                return .unknown
            case .photo:
                return .photo
            case .video:
                return .video
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcMode: Mavsdk_Rpc_CameraServer_Mode) -> Mode {
            switch rpcMode {
            case .unknown:
                return .unknown
            case .photo:
                return .photo
            case .video:
                return .video
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Type to represent a camera information.
     */
    public struct Information: Equatable {
        public let vendorName: String
        public let modelName: String
        public let firmwareVersion: String
        public let focalLengthMm: Float
        public let horizontalSensorSizeMm: Float
        public let verticalSensorSizeMm: Float
        public let horizontalResolutionPx: UInt32
        public let verticalResolutionPx: UInt32
        public let lensID: UInt32
        public let definitionFileVersion: UInt32
        public let definitionFileUri: String
        public let imageInVideoModeSupported: Bool
        public let videoInImageModeSupported: Bool

        

        /**
         Initializes a new `Information`.

         
         - Parameters:
            
            - vendorName:  Name of the camera vendor
            
            - modelName:  Name of the camera model
            
            - firmwareVersion:  Camera firmware version in major[.minor[.patch[.dev]]] format
            
            - focalLengthMm:  Focal length
            
            - horizontalSensorSizeMm:  Horizontal sensor size
            
            - verticalSensorSizeMm:  Vertical sensor size
            
            - horizontalResolutionPx:  Horizontal image resolution in pixels
            
            - verticalResolutionPx:  Vertical image resolution in pixels
            
            - lensID:  Lens ID
            
            - definitionFileVersion:  Camera definition file version (iteration)
            
            - definitionFileUri:  Camera definition URI (http or mavlink ftp)
            
            - imageInVideoModeSupported:  Camera supports taking images while in video mode
            
            - videoInImageModeSupported:  Camera supports recording video while in image mode
            
         
         */
        public init(vendorName: String, modelName: String, firmwareVersion: String, focalLengthMm: Float, horizontalSensorSizeMm: Float, verticalSensorSizeMm: Float, horizontalResolutionPx: UInt32, verticalResolutionPx: UInt32, lensID: UInt32, definitionFileVersion: UInt32, definitionFileUri: String, imageInVideoModeSupported: Bool, videoInImageModeSupported: Bool) {
            self.vendorName = vendorName
            self.modelName = modelName
            self.firmwareVersion = firmwareVersion
            self.focalLengthMm = focalLengthMm
            self.horizontalSensorSizeMm = horizontalSensorSizeMm
            self.verticalSensorSizeMm = verticalSensorSizeMm
            self.horizontalResolutionPx = horizontalResolutionPx
            self.verticalResolutionPx = verticalResolutionPx
            self.lensID = lensID
            self.definitionFileVersion = definitionFileVersion
            self.definitionFileUri = definitionFileUri
            self.imageInVideoModeSupported = imageInVideoModeSupported
            self.videoInImageModeSupported = videoInImageModeSupported
        }

        internal var rpcInformation: Mavsdk_Rpc_CameraServer_Information {
            var rpcInformation = Mavsdk_Rpc_CameraServer_Information()
            
                
            rpcInformation.vendorName = vendorName
                
            
            
                
            rpcInformation.modelName = modelName
                
            
            
                
            rpcInformation.firmwareVersion = firmwareVersion
                
            
            
                
            rpcInformation.focalLengthMm = focalLengthMm
                
            
            
                
            rpcInformation.horizontalSensorSizeMm = horizontalSensorSizeMm
                
            
            
                
            rpcInformation.verticalSensorSizeMm = verticalSensorSizeMm
                
            
            
                
            rpcInformation.horizontalResolutionPx = horizontalResolutionPx
                
            
            
                
            rpcInformation.verticalResolutionPx = verticalResolutionPx
                
            
            
                
            rpcInformation.lensID = lensID
                
            
            
                
            rpcInformation.definitionFileVersion = definitionFileVersion
                
            
            
                
            rpcInformation.definitionFileUri = definitionFileUri
                
            
            
                
            rpcInformation.imageInVideoModeSupported = imageInVideoModeSupported
                
            
            
                
            rpcInformation.videoInImageModeSupported = videoInImageModeSupported
                
            

            return rpcInformation
        }

        internal static func translateFromRpc(_ rpcInformation: Mavsdk_Rpc_CameraServer_Information) -> Information {
            return Information(vendorName: rpcInformation.vendorName, modelName: rpcInformation.modelName, firmwareVersion: rpcInformation.firmwareVersion, focalLengthMm: rpcInformation.focalLengthMm, horizontalSensorSizeMm: rpcInformation.horizontalSensorSizeMm, verticalSensorSizeMm: rpcInformation.verticalSensorSizeMm, horizontalResolutionPx: rpcInformation.horizontalResolutionPx, verticalResolutionPx: rpcInformation.verticalResolutionPx, lensID: rpcInformation.lensID, definitionFileVersion: rpcInformation.definitionFileVersion, definitionFileUri: rpcInformation.definitionFileUri, imageInVideoModeSupported: rpcInformation.imageInVideoModeSupported, videoInImageModeSupported: rpcInformation.videoInImageModeSupported)
        }

        public static func == (lhs: Information, rhs: Information) -> Bool {
            return lhs.vendorName == rhs.vendorName
                && lhs.modelName == rhs.modelName
                && lhs.firmwareVersion == rhs.firmwareVersion
                && lhs.focalLengthMm == rhs.focalLengthMm
                && lhs.horizontalSensorSizeMm == rhs.horizontalSensorSizeMm
                && lhs.verticalSensorSizeMm == rhs.verticalSensorSizeMm
                && lhs.horizontalResolutionPx == rhs.horizontalResolutionPx
                && lhs.verticalResolutionPx == rhs.verticalResolutionPx
                && lhs.lensID == rhs.lensID
                && lhs.definitionFileVersion == rhs.definitionFileVersion
                && lhs.definitionFileUri == rhs.definitionFileUri
                && lhs.imageInVideoModeSupported == rhs.imageInVideoModeSupported
                && lhs.videoInImageModeSupported == rhs.videoInImageModeSupported
        }
    }

    /**
     Type to represent video streaming settings
     */
    public struct VideoStreaming: Equatable {
        public let hasRtspServer: Bool
        public let rtspUri: String

        

        /**
         Initializes a new `VideoStreaming`.

         
         - Parameters:
            
            - hasRtspServer:  True if the capture was successful
            
            - rtspUri:  RTSP URI (e.g. rtsp://192.168.1.42:8554/live)
            
         
         */
        public init(hasRtspServer: Bool, rtspUri: String) {
            self.hasRtspServer = hasRtspServer
            self.rtspUri = rtspUri
        }

        internal var rpcVideoStreaming: Mavsdk_Rpc_CameraServer_VideoStreaming {
            var rpcVideoStreaming = Mavsdk_Rpc_CameraServer_VideoStreaming()
            
                
            rpcVideoStreaming.hasRtspServer_p = hasRtspServer
                
            
            
                
            rpcVideoStreaming.rtspUri = rtspUri
                
            

            return rpcVideoStreaming
        }

        internal static func translateFromRpc(_ rpcVideoStreaming: Mavsdk_Rpc_CameraServer_VideoStreaming) -> VideoStreaming {
            return VideoStreaming(hasRtspServer: rpcVideoStreaming.hasRtspServer_p, rtspUri: rpcVideoStreaming.rtspUri)
        }

        public static func == (lhs: VideoStreaming, rhs: VideoStreaming) -> Bool {
            return lhs.hasRtspServer == rhs.hasRtspServer
                && lhs.rtspUri == rhs.rtspUri
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

        internal var rpcPosition: Mavsdk_Rpc_CameraServer_Position {
            var rpcPosition = Mavsdk_Rpc_CameraServer_Position()
            
                
            rpcPosition.latitudeDeg = latitudeDeg
                
            
            
                
            rpcPosition.longitudeDeg = longitudeDeg
                
            
            
                
            rpcPosition.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcPosition.relativeAltitudeM = relativeAltitudeM
                
            

            return rpcPosition
        }

        internal static func translateFromRpc(_ rpcPosition: Mavsdk_Rpc_CameraServer_Position) -> Position {
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

        internal var rpcQuaternion: Mavsdk_Rpc_CameraServer_Quaternion {
            var rpcQuaternion = Mavsdk_Rpc_CameraServer_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: Mavsdk_Rpc_CameraServer_Quaternion) -> Quaternion {
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
     Information about a picture just captured.
     */
    public struct CaptureInfo: Equatable {
        public let position: Position
        public let attitudeQuaternion: Quaternion
        public let timeUtcUs: UInt64
        public let isSuccess: Bool
        public let index: Int32
        public let fileURL: String

        

        /**
         Initializes a new `CaptureInfo`.

         
         - Parameters:
            
            - position:  Location where the picture was taken
            
            - attitudeQuaternion:  Attitude of the camera when the picture was taken (quaternion)
            
            - timeUtcUs:  Timestamp in UTC (since UNIX epoch) in microseconds
            
            - isSuccess:  True if the capture was successful
            
            - index:  Index from TakePhotoResponse
            
            - fileURL:  Download URL of this image
            
         
         */
        public init(position: Position, attitudeQuaternion: Quaternion, timeUtcUs: UInt64, isSuccess: Bool, index: Int32, fileURL: String) {
            self.position = position
            self.attitudeQuaternion = attitudeQuaternion
            self.timeUtcUs = timeUtcUs
            self.isSuccess = isSuccess
            self.index = index
            self.fileURL = fileURL
        }

        internal var rpcCaptureInfo: Mavsdk_Rpc_CameraServer_CaptureInfo {
            var rpcCaptureInfo = Mavsdk_Rpc_CameraServer_CaptureInfo()
            
                
            rpcCaptureInfo.position = position.rpcPosition
                
            
            
                
            rpcCaptureInfo.attitudeQuaternion = attitudeQuaternion.rpcQuaternion
                
            
            
                
            rpcCaptureInfo.timeUtcUs = timeUtcUs
                
            
            
                
            rpcCaptureInfo.isSuccess = isSuccess
                
            
            
                
            rpcCaptureInfo.index = index
                
            
            
                
            rpcCaptureInfo.fileURL = fileURL
                
            

            return rpcCaptureInfo
        }

        internal static func translateFromRpc(_ rpcCaptureInfo: Mavsdk_Rpc_CameraServer_CaptureInfo) -> CaptureInfo {
            return CaptureInfo(position: Position.translateFromRpc(rpcCaptureInfo.position), attitudeQuaternion: Quaternion.translateFromRpc(rpcCaptureInfo.attitudeQuaternion), timeUtcUs: rpcCaptureInfo.timeUtcUs, isSuccess: rpcCaptureInfo.isSuccess, index: rpcCaptureInfo.index, fileURL: rpcCaptureInfo.fileURL)
        }

        public static func == (lhs: CaptureInfo, rhs: CaptureInfo) -> Bool {
            return lhs.position == rhs.position
                && lhs.attitudeQuaternion == rhs.attitudeQuaternion
                && lhs.timeUtcUs == rhs.timeUtcUs
                && lhs.isSuccess == rhs.isSuccess
                && lhs.index == rhs.index
                && lhs.fileURL == rhs.fileURL
        }
    }

    /**
     Result type.
     */
    public struct CameraServerResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for action requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Command executed successfully.
            case success
            ///  Command in progress.
            case inProgress
            ///  Camera is busy and rejected command.
            case busy
            ///  Camera denied the command.
            case denied
            ///  An error has occurred while executing the command.
            case error
            ///  Command timed out.
            case timeout
            ///  Command has wrong argument(s).
            case wrongArgument
            ///  No system connected.
            case noSystem
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_CameraServer_CameraServerResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .inProgress:
                    return .inProgress
                case .busy:
                    return .busy
                case .denied:
                    return .denied
                case .error:
                    return .error
                case .timeout:
                    return .timeout
                case .wrongArgument:
                    return .wrongArgument
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_CameraServer_CameraServerResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .inProgress:
                    return .inProgress
                case .busy:
                    return .busy
                case .denied:
                    return .denied
                case .error:
                    return .error
                case .timeout:
                    return .timeout
                case .wrongArgument:
                    return .wrongArgument
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `CameraServerResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcCameraServerResult: Mavsdk_Rpc_CameraServer_CameraServerResult {
            var rpcCameraServerResult = Mavsdk_Rpc_CameraServer_CameraServerResult()
            
                
            rpcCameraServerResult.result = result.rpcResult
                
            
            
                
            rpcCameraServerResult.resultStr = resultStr
                
            

            return rpcCameraServerResult
        }

        internal static func translateFromRpc(_ rpcCameraServerResult: Mavsdk_Rpc_CameraServer_CameraServerResult) -> CameraServerResult {
            return CameraServerResult(result: Result.translateFromRpc(rpcCameraServerResult.result), resultStr: rpcCameraServerResult.resultStr)
        }

        public static func == (lhs: CameraServerResult, rhs: CameraServerResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }

    /**
     Information about the camera storage.
     */
    public struct StorageInformation: Equatable {
        public let usedStorageMib: Float
        public let availableStorageMib: Float
        public let totalStorageMib: Float
        public let storageStatus: StorageStatus
        public let storageID: UInt32
        public let storageType: StorageType
        public let readSpeedMibS: Float
        public let writeSpeedMibS: Float

        
        

        /**
         Storage status type.
         */
        public enum StorageStatus: Equatable {
            ///  Storage not available.
            case notAvailable
            ///  Storage is not formatted (i.e. has no recognized file system).
            case unformatted
            ///  Storage is formatted (i.e. has recognized a file system).
            case formatted
            ///  Storage status is not supported.
            case notSupported
            case UNRECOGNIZED(Int)

            internal var rpcStorageStatus: Mavsdk_Rpc_CameraServer_StorageInformation.StorageStatus {
                switch self {
                case .notAvailable:
                    return .notAvailable
                case .unformatted:
                    return .unformatted
                case .formatted:
                    return .formatted
                case .notSupported:
                    return .notSupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcStorageStatus: Mavsdk_Rpc_CameraServer_StorageInformation.StorageStatus) -> StorageStatus {
                switch rpcStorageStatus {
                case .notAvailable:
                    return .notAvailable
                case .unformatted:
                    return .unformatted
                case .formatted:
                    return .formatted
                case .notSupported:
                    return .notSupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        
        

        /**
         Storage type.
         */
        public enum StorageType: Equatable {
            ///  Storage type unknown.
            case unknown
            ///  Storage type USB stick.
            case usbStick
            ///  Storage type SD card.
            case sd
            ///  Storage type MicroSD card.
            case microsd
            ///  Storage type HD mass storage.
            case hd
            ///  Storage type other, not listed.
            case other
            case UNRECOGNIZED(Int)

            internal var rpcStorageType: Mavsdk_Rpc_CameraServer_StorageInformation.StorageType {
                switch self {
                case .unknown:
                    return .unknown
                case .usbStick:
                    return .usbStick
                case .sd:
                    return .sd
                case .microsd:
                    return .microsd
                case .hd:
                    return .hd
                case .other:
                    return .other
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcStorageType: Mavsdk_Rpc_CameraServer_StorageInformation.StorageType) -> StorageType {
                switch rpcStorageType {
                case .unknown:
                    return .unknown
                case .usbStick:
                    return .usbStick
                case .sd:
                    return .sd
                case .microsd:
                    return .microsd
                case .hd:
                    return .hd
                case .other:
                    return .other
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `StorageInformation`.

         
         - Parameters:
            
            - usedStorageMib:  Used storage (in MiB)
            
            - availableStorageMib:  Available storage (in MiB)
            
            - totalStorageMib:  Total storage (in MiB)
            
            - storageStatus:  Storage status
            
            - storageID:  Storage ID starting at 1
            
            - storageType:  Storage type
            
            - readSpeedMibS:  Read speed [MiB/s]
            
            - writeSpeedMibS:  Write speed [MiB/s]
            
         
         */
        public init(usedStorageMib: Float, availableStorageMib: Float, totalStorageMib: Float, storageStatus: StorageStatus, storageID: UInt32, storageType: StorageType, readSpeedMibS: Float, writeSpeedMibS: Float) {
            self.usedStorageMib = usedStorageMib
            self.availableStorageMib = availableStorageMib
            self.totalStorageMib = totalStorageMib
            self.storageStatus = storageStatus
            self.storageID = storageID
            self.storageType = storageType
            self.readSpeedMibS = readSpeedMibS
            self.writeSpeedMibS = writeSpeedMibS
        }

        internal var rpcStorageInformation: Mavsdk_Rpc_CameraServer_StorageInformation {
            var rpcStorageInformation = Mavsdk_Rpc_CameraServer_StorageInformation()
            
                
            rpcStorageInformation.usedStorageMib = usedStorageMib
                
            
            
                
            rpcStorageInformation.availableStorageMib = availableStorageMib
                
            
            
                
            rpcStorageInformation.totalStorageMib = totalStorageMib
                
            
            
                
            rpcStorageInformation.storageStatus = storageStatus.rpcStorageStatus
                
            
            
                
            rpcStorageInformation.storageID = storageID
                
            
            
                
            rpcStorageInformation.storageType = storageType.rpcStorageType
                
            
            
                
            rpcStorageInformation.readSpeedMibS = readSpeedMibS
                
            
            
                
            rpcStorageInformation.writeSpeedMibS = writeSpeedMibS
                
            

            return rpcStorageInformation
        }

        internal static func translateFromRpc(_ rpcStorageInformation: Mavsdk_Rpc_CameraServer_StorageInformation) -> StorageInformation {
            return StorageInformation(usedStorageMib: rpcStorageInformation.usedStorageMib, availableStorageMib: rpcStorageInformation.availableStorageMib, totalStorageMib: rpcStorageInformation.totalStorageMib, storageStatus: StorageStatus.translateFromRpc(rpcStorageInformation.storageStatus), storageID: rpcStorageInformation.storageID, storageType: StorageType.translateFromRpc(rpcStorageInformation.storageType), readSpeedMibS: rpcStorageInformation.readSpeedMibS, writeSpeedMibS: rpcStorageInformation.writeSpeedMibS)
        }

        public static func == (lhs: StorageInformation, rhs: StorageInformation) -> Bool {
            return lhs.usedStorageMib == rhs.usedStorageMib
                && lhs.availableStorageMib == rhs.availableStorageMib
                && lhs.totalStorageMib == rhs.totalStorageMib
                && lhs.storageStatus == rhs.storageStatus
                && lhs.storageID == rhs.storageID
                && lhs.storageType == rhs.storageType
                && lhs.readSpeedMibS == rhs.readSpeedMibS
                && lhs.writeSpeedMibS == rhs.writeSpeedMibS
        }
    }

    /**
     
     */
    public struct CaptureStatus: Equatable {
        public let imageIntervalS: Float
        public let recordingTimeS: Float
        public let availableCapacityMib: Float
        public let imageStatus: ImageStatus
        public let videoStatus: VideoStatus
        public let imageCount: Int32

        
        

        /**
         
         */
        public enum ImageStatus: Equatable {
            ///  idle.
            case idle
            ///  capture in progress.
            case captureInProgress
            ///  interval set but idle.
            case intervalIdle
            ///  interval set and capture in progress).
            case intervalInProgress
            case UNRECOGNIZED(Int)

            internal var rpcImageStatus: Mavsdk_Rpc_CameraServer_CaptureStatus.ImageStatus {
                switch self {
                case .idle:
                    return .idle
                case .captureInProgress:
                    return .captureInProgress
                case .intervalIdle:
                    return .intervalIdle
                case .intervalInProgress:
                    return .intervalInProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcImageStatus: Mavsdk_Rpc_CameraServer_CaptureStatus.ImageStatus) -> ImageStatus {
                switch rpcImageStatus {
                case .idle:
                    return .idle
                case .captureInProgress:
                    return .captureInProgress
                case .intervalIdle:
                    return .intervalIdle
                case .intervalInProgress:
                    return .intervalInProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        
        

        /**
         
         */
        public enum VideoStatus: Equatable {
            ///  idle.
            case idle
            ///  capture in progress.
            case captureInProgress
            case UNRECOGNIZED(Int)

            internal var rpcVideoStatus: Mavsdk_Rpc_CameraServer_CaptureStatus.VideoStatus {
                switch self {
                case .idle:
                    return .idle
                case .captureInProgress:
                    return .captureInProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcVideoStatus: Mavsdk_Rpc_CameraServer_CaptureStatus.VideoStatus) -> VideoStatus {
                switch rpcVideoStatus {
                case .idle:
                    return .idle
                case .captureInProgress:
                    return .captureInProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `CaptureStatus`.

         
         - Parameters:
            
            - imageIntervalS:  Image capture interval (in s)
            
            - recordingTimeS:  Elapsed time since recording started (in s)
            
            - availableCapacityMib:  Available storage capacity. (in MiB)
            
            - imageStatus:  Current status of image capturing
            
            - videoStatus:  Current status of video capturing
            
            - imageCount:  Total number of images captured ('forever', or until reset using MAV_CMD_STORAGE_FORMAT)
            
         
         */
        public init(imageIntervalS: Float, recordingTimeS: Float, availableCapacityMib: Float, imageStatus: ImageStatus, videoStatus: VideoStatus, imageCount: Int32) {
            self.imageIntervalS = imageIntervalS
            self.recordingTimeS = recordingTimeS
            self.availableCapacityMib = availableCapacityMib
            self.imageStatus = imageStatus
            self.videoStatus = videoStatus
            self.imageCount = imageCount
        }

        internal var rpcCaptureStatus: Mavsdk_Rpc_CameraServer_CaptureStatus {
            var rpcCaptureStatus = Mavsdk_Rpc_CameraServer_CaptureStatus()
            
                
            rpcCaptureStatus.imageIntervalS = imageIntervalS
                
            
            
                
            rpcCaptureStatus.recordingTimeS = recordingTimeS
                
            
            
                
            rpcCaptureStatus.availableCapacityMib = availableCapacityMib
                
            
            
                
            rpcCaptureStatus.imageStatus = imageStatus.rpcImageStatus
                
            
            
                
            rpcCaptureStatus.videoStatus = videoStatus.rpcVideoStatus
                
            
            
                
            rpcCaptureStatus.imageCount = imageCount
                
            

            return rpcCaptureStatus
        }

        internal static func translateFromRpc(_ rpcCaptureStatus: Mavsdk_Rpc_CameraServer_CaptureStatus) -> CaptureStatus {
            return CaptureStatus(imageIntervalS: rpcCaptureStatus.imageIntervalS, recordingTimeS: rpcCaptureStatus.recordingTimeS, availableCapacityMib: rpcCaptureStatus.availableCapacityMib, imageStatus: ImageStatus.translateFromRpc(rpcCaptureStatus.imageStatus), videoStatus: VideoStatus.translateFromRpc(rpcCaptureStatus.videoStatus), imageCount: rpcCaptureStatus.imageCount)
        }

        public static func == (lhs: CaptureStatus, rhs: CaptureStatus) -> Bool {
            return lhs.imageIntervalS == rhs.imageIntervalS
                && lhs.recordingTimeS == rhs.recordingTimeS
                && lhs.availableCapacityMib == rhs.availableCapacityMib
                && lhs.imageStatus == rhs.imageStatus
                && lhs.videoStatus == rhs.videoStatus
                && lhs.imageCount == rhs.imageCount
        }
    }

    /**
     Point description type
     */
    public struct TrackPoint: Equatable {
        public let pointX: Float
        public let pointY: Float
        public let radius: Float

        

        /**
         Initializes a new `TrackPoint`.

         
         - Parameters:
            
            - pointX:  Point to track x value (normalized 0..1, 0 is left, 1 is right).
            
            - pointY:  Point to track y value (normalized 0..1, 0 is top, 1 is bottom).
            
            - radius:  Point to track y value (normalized 0..1, 0 is top, 1 is bottom).
            
         
         */
        public init(pointX: Float, pointY: Float, radius: Float) {
            self.pointX = pointX
            self.pointY = pointY
            self.radius = radius
        }

        internal var rpcTrackPoint: Mavsdk_Rpc_CameraServer_TrackPoint {
            var rpcTrackPoint = Mavsdk_Rpc_CameraServer_TrackPoint()
            
                
            rpcTrackPoint.pointX = pointX
                
            
            
                
            rpcTrackPoint.pointY = pointY
                
            
            
                
            rpcTrackPoint.radius = radius
                
            

            return rpcTrackPoint
        }

        internal static func translateFromRpc(_ rpcTrackPoint: Mavsdk_Rpc_CameraServer_TrackPoint) -> TrackPoint {
            return TrackPoint(pointX: rpcTrackPoint.pointX, pointY: rpcTrackPoint.pointY, radius: rpcTrackPoint.radius)
        }

        public static func == (lhs: TrackPoint, rhs: TrackPoint) -> Bool {
            return lhs.pointX == rhs.pointX
                && lhs.pointY == rhs.pointY
                && lhs.radius == rhs.radius
        }
    }

    /**
     Rectangle description type
     */
    public struct TrackRectangle: Equatable {
        public let topLeftCornerX: Float
        public let topLeftCornerY: Float
        public let bottomRightCornerX: Float
        public let bottomRightCornerY: Float

        

        /**
         Initializes a new `TrackRectangle`.

         
         - Parameters:
            
            - topLeftCornerX:  Top left corner of rectangle x value (normalized 0..1, 0 is left, 1 is right).
            
            - topLeftCornerY:  Top left corner of rectangle y value (normalized 0..1, 0 is top, 1 is bottom).
            
            - bottomRightCornerX:  Bottom right corner of rectangle x value (normalized 0..1, 0 is left, 1 is right).
            
            - bottomRightCornerY:  Bottom right corner of rectangle y value (normalized 0..1, 0 is top, 1 is bottom).
            
         
         */
        public init(topLeftCornerX: Float, topLeftCornerY: Float, bottomRightCornerX: Float, bottomRightCornerY: Float) {
            self.topLeftCornerX = topLeftCornerX
            self.topLeftCornerY = topLeftCornerY
            self.bottomRightCornerX = bottomRightCornerX
            self.bottomRightCornerY = bottomRightCornerY
        }

        internal var rpcTrackRectangle: Mavsdk_Rpc_CameraServer_TrackRectangle {
            var rpcTrackRectangle = Mavsdk_Rpc_CameraServer_TrackRectangle()
            
                
            rpcTrackRectangle.topLeftCornerX = topLeftCornerX
                
            
            
                
            rpcTrackRectangle.topLeftCornerY = topLeftCornerY
                
            
            
                
            rpcTrackRectangle.bottomRightCornerX = bottomRightCornerX
                
            
            
                
            rpcTrackRectangle.bottomRightCornerY = bottomRightCornerY
                
            

            return rpcTrackRectangle
        }

        internal static func translateFromRpc(_ rpcTrackRectangle: Mavsdk_Rpc_CameraServer_TrackRectangle) -> TrackRectangle {
            return TrackRectangle(topLeftCornerX: rpcTrackRectangle.topLeftCornerX, topLeftCornerY: rpcTrackRectangle.topLeftCornerY, bottomRightCornerX: rpcTrackRectangle.bottomRightCornerX, bottomRightCornerY: rpcTrackRectangle.bottomRightCornerY)
        }

        public static func == (lhs: TrackRectangle, rhs: TrackRectangle) -> Bool {
            return lhs.topLeftCornerX == rhs.topLeftCornerX
                && lhs.topLeftCornerY == rhs.topLeftCornerY
                && lhs.bottomRightCornerX == rhs.bottomRightCornerX
                && lhs.bottomRightCornerY == rhs.bottomRightCornerY
        }
    }


    /**
     Sets the camera information. This must be called as soon as the camera server is created.

     - Parameter information: information about the camera
     
     */
    public func setInformation(information: Information) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_SetInformationRequest()

            
                
            request.information = information.rpcInformation
                
            

            do {
                
                let response = self.service.setInformation(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Sets video streaming settings.

     - Parameter videoStreaming: information about the video stream
     
     */
    public func setVideoStreaming(videoStreaming: VideoStreaming) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_SetVideoStreamingRequest()

            
                
            request.videoStreaming = videoStreaming.rpcVideoStreaming
                
            

            do {
                
                let response = self.service.setVideoStreaming(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Sets image capture in progress status flags. This should be set to true when the camera is busy taking a photo and false when it is done.

     - Parameter inProgress: true if capture is in progress or false for idle.
     
     */
    public func setInProgress(inProgress: Bool) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_SetInProgressRequest()

            
                
            request.inProgress = inProgress
                
            

            do {
                
                let response = self.service.setInProgress(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to image capture requests. Each request received should respond to using RespondTakePhoto.
     */

    public lazy var takePhoto: Observable<Int32> = createTakePhotoObservable()




    private func createTakePhotoObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeTakePhotoRequest()

            

            let serverStreamingCall = self.service.subscribeTakePhoto(request, handler: { (response) in

                
                     
                let takePhoto = response.index
                    
                

                
                observer.onNext(takePhoto)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to an image capture request from SubscribeTakePhoto.

     - Parameters:
        - takePhotoFeedback: the feedback
        - captureInfo: the capture information
     
     */
    public func respondTakePhoto(takePhotoFeedback: CameraFeedback, captureInfo: CaptureInfo) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondTakePhotoRequest()

            
                
            request.takePhotoFeedback = takePhotoFeedback.rpcCameraFeedback
                
            
                
            request.captureInfo = captureInfo.rpcCaptureInfo
                
            

            do {
                
                let response = self.service.respondTakePhoto(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to start video requests. Each request received should respond to using RespondStartVideo
     */

    public lazy var startVideo: Observable<Int32> = createStartVideoObservable()




    private func createStartVideoObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeStartVideoRequest()

            

            let serverStreamingCall = self.service.subscribeStartVideo(request, handler: { (response) in

                
                     
                let startVideo = response.streamID
                    
                

                
                observer.onNext(startVideo)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Subscribe to stop video requests. Each request received should respond using StopVideoResponse

     - Parameter startVideoFeedback: the feedback
     
     */
    public func respondStartVideo(startVideoFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondStartVideoRequest()

            
                
            request.startVideoFeedback = startVideoFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondStartVideo(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to stop video requests. Each request received should response to using RespondStopVideo
     */

    public lazy var stopVideo: Observable<Int32> = createStopVideoObservable()




    private func createStopVideoObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeStopVideoRequest()

            

            let serverStreamingCall = self.service.subscribeStopVideo(request, handler: { (response) in

                
                     
                let stopVideo = response.streamID
                    
                

                
                observer.onNext(stopVideo)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to stop video request from SubscribeStopVideo.

     - Parameter stopVideoFeedback: the feedback
     
     */
    public func respondStopVideo(stopVideoFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondStopVideoRequest()

            
                
            request.stopVideoFeedback = stopVideoFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondStopVideo(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to start video streaming requests. Each request received should response to using RespondStartVideoStreaming
     */

    public lazy var startVideoStreaming: Observable<Int32> = createStartVideoStreamingObservable()




    private func createStartVideoStreamingObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeStartVideoStreamingRequest()

            

            let serverStreamingCall = self.service.subscribeStartVideoStreaming(request, handler: { (response) in

                
                     
                let startVideoStreaming = response.streamID
                    
                

                
                observer.onNext(startVideoStreaming)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to start video streaming from SubscribeStartVideoStreaming.

     - Parameter startVideoStreamingFeedback: the feedback
     
     */
    public func respondStartVideoStreaming(startVideoStreamingFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondStartVideoStreamingRequest()

            
                
            request.startVideoStreamingFeedback = startVideoStreamingFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondStartVideoStreaming(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to stop video streaming requests. Each request received should response to using RespondStopVideoStreaming
     */

    public lazy var stopVideoStreaming: Observable<Int32> = createStopVideoStreamingObservable()




    private func createStopVideoStreamingObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeStopVideoStreamingRequest()

            

            let serverStreamingCall = self.service.subscribeStopVideoStreaming(request, handler: { (response) in

                
                     
                let stopVideoStreaming = response.streamID
                    
                

                
                observer.onNext(stopVideoStreaming)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to stop video streaming from SubscribeStopVideoStreaming.

     - Parameter stopVideoStreamingFeedback: the feedback
     
     */
    public func respondStopVideoStreaming(stopVideoStreamingFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondStopVideoStreamingRequest()

            
                
            request.stopVideoStreamingFeedback = stopVideoStreamingFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondStopVideoStreaming(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to set camera mode requests. Each request received should response to using RespondSetMode
     */

    public lazy var setMode: Observable<Mode> = createSetModeObservable()




    private func createSetModeObservable() -> Observable<Mode> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeSetModeRequest()

            

            let serverStreamingCall = self.service.subscribeSetMode(request, handler: { (response) in

                
                     
                let setMode = Mode.translateFromRpc(response.mode)
                

                
                observer.onNext(setMode)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to set camera mode from SubscribeSetMode.

     - Parameter setModeFeedback: the feedback
     
     */
    public func respondSetMode(setModeFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondSetModeRequest()

            
                
            request.setModeFeedback = setModeFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondSetMode(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to camera storage information requests. Each request received should response to using RespondStorageInformation
     */

    public lazy var storageInformation: Observable<Int32> = createStorageInformationObservable()




    private func createStorageInformationObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeStorageInformationRequest()

            

            let serverStreamingCall = self.service.subscribeStorageInformation(request, handler: { (response) in

                
                     
                let storageInformation = response.storageID
                    
                

                
                observer.onNext(storageInformation)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to camera storage information from SubscribeStorageInformation.

     - Parameters:
        - storageInformationFeedback: the feedback
        - storageInformation: the storage information
     
     */
    public func respondStorageInformation(storageInformationFeedback: CameraFeedback, storageInformation: StorageInformation) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondStorageInformationRequest()

            
                
            request.storageInformationFeedback = storageInformationFeedback.rpcCameraFeedback
                
            
                
            request.storageInformation = storageInformation.rpcStorageInformation
                
            

            do {
                
                let response = self.service.respondStorageInformation(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to camera capture status requests. Each request received should response to using RespondCaptureStatus
     */

    public lazy var captureStatus: Observable<Int32> = createCaptureStatusObservable()




    private func createCaptureStatusObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeCaptureStatusRequest()

            

            let serverStreamingCall = self.service.subscribeCaptureStatus(request, handler: { (response) in

                
                     
                let captureStatus = response.reserved
                    
                

                
                observer.onNext(captureStatus)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to camera capture status from SubscribeCaptureStatus.

     - Parameters:
        - captureStatusFeedback: the feedback
        - captureStatus: the capture status
     
     */
    public func respondCaptureStatus(captureStatusFeedback: CameraFeedback, captureStatus: CaptureStatus) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondCaptureStatusRequest()

            
                
            request.captureStatusFeedback = captureStatusFeedback.rpcCameraFeedback
                
            
                
            request.captureStatus = captureStatus.rpcCaptureStatus
                
            

            do {
                
                let response = self.service.respondCaptureStatus(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to format storage requests. Each request received should response to using RespondFormatStorage
     */

    public lazy var formatStorage: Observable<Int32> = createFormatStorageObservable()




    private func createFormatStorageObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeFormatStorageRequest()

            

            let serverStreamingCall = self.service.subscribeFormatStorage(request, handler: { (response) in

                
                     
                let formatStorage = response.storageID
                    
                

                
                observer.onNext(formatStorage)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to format storage from SubscribeFormatStorage.

     - Parameter formatStorageFeedback: the feedback
     
     */
    public func respondFormatStorage(formatStorageFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondFormatStorageRequest()

            
                
            request.formatStorageFeedback = formatStorageFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondFormatStorage(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to reset settings requests. Each request received should response to using RespondResetSettings
     */

    public lazy var resetSettings: Observable<Int32> = createResetSettingsObservable()




    private func createResetSettingsObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeResetSettingsRequest()

            

            let serverStreamingCall = self.service.subscribeResetSettings(request, handler: { (response) in

                
                     
                let resetSettings = response.reserved
                    
                

                
                observer.onNext(resetSettings)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to reset settings from SubscribeResetSettings.

     - Parameter resetSettingsFeedback: the feedback
     
     */
    public func respondResetSettings(resetSettingsFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondResetSettingsRequest()

            
                
            request.resetSettingsFeedback = resetSettingsFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondResetSettings(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to zoom in start command
     */

    public lazy var zoomInStart: Observable<Int32> = createZoomInStartObservable()




    private func createZoomInStartObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeZoomInStartRequest()

            

            let serverStreamingCall = self.service.subscribeZoomInStart(request, handler: { (response) in

                
                     
                let zoomInStart = response.reserved
                    
                

                
                observer.onNext(zoomInStart)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to zoom in start.

     - Parameter zoomInStartFeedback: the feedback
     
     */
    public func respondZoomInStart(zoomInStartFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondZoomInStartRequest()

            
                
            request.zoomInStartFeedback = zoomInStartFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondZoomInStart(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to zoom out start command
     */

    public lazy var zoomOutStart: Observable<Int32> = createZoomOutStartObservable()




    private func createZoomOutStartObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeZoomOutStartRequest()

            

            let serverStreamingCall = self.service.subscribeZoomOutStart(request, handler: { (response) in

                
                     
                let zoomOutStart = response.reserved
                    
                

                
                observer.onNext(zoomOutStart)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to zoom out start.

     - Parameter zoomOutStartFeedback: the feedback
     
     */
    public func respondZoomOutStart(zoomOutStartFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondZoomOutStartRequest()

            
                
            request.zoomOutStartFeedback = zoomOutStartFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondZoomOutStart(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to zoom stop command
     */

    public lazy var zoomStop: Observable<Int32> = createZoomStopObservable()




    private func createZoomStopObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeZoomStopRequest()

            

            let serverStreamingCall = self.service.subscribeZoomStop(request, handler: { (response) in

                
                     
                let zoomStop = response.reserved
                    
                

                
                observer.onNext(zoomStop)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to zoom stop.

     - Parameter zoomStopFeedback: the feedback
     
     */
    public func respondZoomStop(zoomStopFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondZoomStopRequest()

            
                
            request.zoomStopFeedback = zoomStopFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondZoomStop(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to zoom range command
     */

    public lazy var zoomRange: Observable<Float> = createZoomRangeObservable()




    private func createZoomRangeObservable() -> Observable<Float> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeZoomRangeRequest()

            

            let serverStreamingCall = self.service.subscribeZoomRange(request, handler: { (response) in

                
                     
                let zoomRange = response.factor
                    
                

                
                observer.onNext(zoomRange)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to zoom range.

     - Parameter zoomRangeFeedback: the feedback
     
     */
    public func respondZoomRange(zoomRangeFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondZoomRangeRequest()

            
                
            request.zoomRangeFeedback = zoomRangeFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondZoomRange(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set/update the current rectangle tracking status.

     - Parameter trackedRectangle: The tracked rectangle
     
     */
    public func setTrackingRectangleStatus(trackedRectangle: TrackRectangle) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_SetTrackingRectangleStatusRequest()

            
                
            request.trackedRectangle = trackedRectangle.rpcTrackRectangle
                
            

            do {
                
                let _ = try self.service.setTrackingRectangleStatus(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the current tracking status to off.

     
     */
    public func setTrackingOffStatus() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_CameraServer_SetTrackingOffStatusRequest()

            

            do {
                
                let _ = try self.service.setTrackingOffStatus(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to incoming tracking point command.
     */

    public lazy var trackingPointCommand: Observable<TrackPoint> = createTrackingPointCommandObservable()




    private func createTrackingPointCommandObservable() -> Observable<TrackPoint> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeTrackingPointCommandRequest()

            

            let serverStreamingCall = self.service.subscribeTrackingPointCommand(request, handler: { (response) in

                
                     
                let trackingPointCommand = TrackPoint.translateFromRpc(response.trackPoint)
                

                
                observer.onNext(trackingPointCommand)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to incoming tracking rectangle command.
     */

    public lazy var trackingRectangleCommand: Observable<TrackRectangle> = createTrackingRectangleCommandObservable()




    private func createTrackingRectangleCommandObservable() -> Observable<TrackRectangle> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeTrackingRectangleCommandRequest()

            

            let serverStreamingCall = self.service.subscribeTrackingRectangleCommand(request, handler: { (response) in

                
                     
                let trackingRectangleCommand = TrackRectangle.translateFromRpc(response.trackRectangle)
                

                
                observer.onNext(trackingRectangleCommand)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to incoming tracking off command.
     */

    public lazy var trackingOffCommand: Observable<Int32> = createTrackingOffCommandObservable()




    private func createTrackingOffCommandObservable() -> Observable<Int32> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_CameraServer_SubscribeTrackingOffCommandRequest()

            

            let serverStreamingCall = self.service.subscribeTrackingOffCommand(request, handler: { (response) in

                
                     
                let trackingOffCommand = response.dummy
                    
                

                
                observer.onNext(trackingOffCommand)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to an incoming tracking point command.

     - Parameter stopVideoFeedback: the feedback
     
     */
    public func respondTrackingPointCommand(stopVideoFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondTrackingPointCommandRequest()

            
                
            request.stopVideoFeedback = stopVideoFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondTrackingPointCommand(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Respond to an incoming tracking rectangle command.

     - Parameter stopVideoFeedback: the feedback
     
     */
    public func respondTrackingRectangleCommand(stopVideoFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondTrackingRectangleCommandRequest()

            
                
            request.stopVideoFeedback = stopVideoFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondTrackingRectangleCommand(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Respond to an incoming tracking off command.

     - Parameter stopVideoFeedback: the feedback
     
     */
    public func respondTrackingOffCommand(stopVideoFeedback: CameraFeedback) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_CameraServer_RespondTrackingOffCommandRequest()

            
                
            request.stopVideoFeedback = stopVideoFeedback.rpcCameraFeedback
                
            

            do {
                
                let response = self.service.respondTrackingOffCommand(request)

                let result = try response.response.wait().cameraServerResult
                if (result.result == Mavsdk_Rpc_CameraServer_CameraServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraServerError(code: CameraServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}