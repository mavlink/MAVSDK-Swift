import Foundation
import RxSwift
import GRPC
import NIO

/**
 Can be used to manage cameras that implement the MAVLink
 Camera Protocol: https://mavlink.io/en/protocol/camera.html.

 Currently only a single camera is supported.
 When multiple cameras are supported the plugin will need to be
 instantiated separately for every camera and the camera selected using
 `select_camera`.
 */
public class Camera {
    private let service: Mavsdk_Rpc_Camera_CameraServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Camera` plugin.

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
        let service = Mavsdk_Rpc_Camera_CameraServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Camera_CameraServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeCameraError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct CameraError: Error {
        public let code: Camera.CameraResult.Result
        public let description: String
    }
    

    /**
     Camera mode type.
     */
    public enum Mode: Equatable {
        ///  Unknown.
        case unknown
        ///  Photo mode.
        case photo
        ///  Video mode.
        case video
        case UNRECOGNIZED(Int)

        internal var rpcMode: Mavsdk_Rpc_Camera_Mode {
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

        internal static func translateFromRpc(_ rpcMode: Mavsdk_Rpc_Camera_Mode) -> Mode {
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
     Photos range type.
     */
    public enum PhotosRange: Equatable {
        ///  All the photos present on the camera.
        case all
        ///  Photos taken since MAVSDK got connected.
        case sinceConnection
        case UNRECOGNIZED(Int)

        internal var rpcPhotosRange: Mavsdk_Rpc_Camera_PhotosRange {
            switch self {
            case .all:
                return .all
            case .sinceConnection:
                return .sinceConnection
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcPhotosRange: Mavsdk_Rpc_Camera_PhotosRange) -> PhotosRange {
            switch rpcPhotosRange {
            case .all:
                return .all
            case .sinceConnection:
                return .sinceConnection
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Type to represent a setting option.
     */
    public struct Option: Equatable {
        public let optionID: String
        public let optionDescription: String

        

        /**
         Initializes a new `Option`.

         
         - Parameters:
            
            - optionID:  Name of the option (machine readable)
            
            - optionDescription:  Description of the option (human readable)
            
         
         */
        public init(optionID: String, optionDescription: String) {
            self.optionID = optionID
            self.optionDescription = optionDescription
        }

        internal var rpcOption: Mavsdk_Rpc_Camera_Option {
            var rpcOption = Mavsdk_Rpc_Camera_Option()
            
                
            rpcOption.optionID = optionID
                
            
            
                
            rpcOption.optionDescription = optionDescription
                
            

            return rpcOption
        }

        internal static func translateFromRpc(_ rpcOption: Mavsdk_Rpc_Camera_Option) -> Option {
            return Option(optionID: rpcOption.optionID, optionDescription: rpcOption.optionDescription)
        }

        public static func == (lhs: Option, rhs: Option) -> Bool {
            return lhs.optionID == rhs.optionID
                && lhs.optionDescription == rhs.optionDescription
        }
    }

    /**
     Type to represent a setting with a selected option.
     */
    public struct Setting: Equatable {
        public let settingID: String
        public let settingDescription: String
        public let option: Option
        public let isRange: Bool

        

        /**
         Initializes a new `Setting`.

         
         - Parameters:
            
            - settingID:  Name of a setting (machine readable)
            
            - settingDescription:  Description of the setting (human readable). This field is meant to be read from the drone, ignore it when setting.
            
            - option:  Selected option
            
            - isRange:  If option is given as a range. This field is meant to be read from the drone, ignore it when setting.
            
         
         */
        public init(settingID: String, settingDescription: String, option: Option, isRange: Bool) {
            self.settingID = settingID
            self.settingDescription = settingDescription
            self.option = option
            self.isRange = isRange
        }

        internal var rpcSetting: Mavsdk_Rpc_Camera_Setting {
            var rpcSetting = Mavsdk_Rpc_Camera_Setting()
            
                
            rpcSetting.settingID = settingID
                
            
            
                
            rpcSetting.settingDescription = settingDescription
                
            
            
                
            rpcSetting.option = option.rpcOption
                
            
            
                
            rpcSetting.isRange = isRange
                
            

            return rpcSetting
        }

        internal static func translateFromRpc(_ rpcSetting: Mavsdk_Rpc_Camera_Setting) -> Setting {
            return Setting(settingID: rpcSetting.settingID, settingDescription: rpcSetting.settingDescription, option: Option.translateFromRpc(rpcSetting.option), isRange: rpcSetting.isRange)
        }

        public static func == (lhs: Setting, rhs: Setting) -> Bool {
            return lhs.settingID == rhs.settingID
                && lhs.settingDescription == rhs.settingDescription
                && lhs.option == rhs.option
                && lhs.isRange == rhs.isRange
        }
    }

    /**
     Type to represent a setting with a list of options to choose from.
     */
    public struct SettingOptions: Equatable {
        public let componentID: Int32
        public let settingID: String
        public let settingDescription: String
        public let options: [Option]
        public let isRange: Bool

        

        /**
         Initializes a new `SettingOptions`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - settingID:  Name of the setting (machine readable)
            
            - settingDescription:  Description of the setting (human readable)
            
            - options:  List of options or if range [min, max] or [min, max, interval]
            
            - isRange:  If option is given as a range
            
         
         */
        public init(componentID: Int32, settingID: String, settingDescription: String, options: [Option], isRange: Bool) {
            self.componentID = componentID
            self.settingID = settingID
            self.settingDescription = settingDescription
            self.options = options
            self.isRange = isRange
        }

        internal var rpcSettingOptions: Mavsdk_Rpc_Camera_SettingOptions {
            var rpcSettingOptions = Mavsdk_Rpc_Camera_SettingOptions()
            
                
            rpcSettingOptions.componentID = componentID
                
            
            
                
            rpcSettingOptions.settingID = settingID
                
            
            
                
            rpcSettingOptions.settingDescription = settingDescription
                
            
            
                
            rpcSettingOptions.options = options.map{ $0.rpcOption }
                
            
            
                
            rpcSettingOptions.isRange = isRange
                
            

            return rpcSettingOptions
        }

        internal static func translateFromRpc(_ rpcSettingOptions: Mavsdk_Rpc_Camera_SettingOptions) -> SettingOptions {
            return SettingOptions(componentID: rpcSettingOptions.componentID, settingID: rpcSettingOptions.settingID, settingDescription: rpcSettingOptions.settingDescription, options: rpcSettingOptions.options.map{ Option.translateFromRpc($0) }, isRange: rpcSettingOptions.isRange)
        }

        public static func == (lhs: SettingOptions, rhs: SettingOptions) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.settingID == rhs.settingID
                && lhs.settingDescription == rhs.settingDescription
                && lhs.options == rhs.options
                && lhs.isRange == rhs.isRange
        }
    }

    /**
     Type for video stream settings.
     */
    public struct VideoStreamSettings: Equatable {
        public let frameRateHz: Float
        public let horizontalResolutionPix: UInt32
        public let verticalResolutionPix: UInt32
        public let bitRateBS: UInt32
        public let rotationDeg: UInt32
        public let uri: String
        public let horizontalFovDeg: Float

        

        /**
         Initializes a new `VideoStreamSettings`.

         
         - Parameters:
            
            - frameRateHz:  Frames per second
            
            - horizontalResolutionPix:  Horizontal resolution (in pixels)
            
            - verticalResolutionPix:  Vertical resolution (in pixels)
            
            - bitRateBS:  Bit rate (in bits per second)
            
            - rotationDeg:  Video image rotation (clockwise, 0-359 degrees)
            
            - uri:  Video stream URI
            
            - horizontalFovDeg:  Horizontal fov in degrees
            
         
         */
        public init(frameRateHz: Float, horizontalResolutionPix: UInt32, verticalResolutionPix: UInt32, bitRateBS: UInt32, rotationDeg: UInt32, uri: String, horizontalFovDeg: Float) {
            self.frameRateHz = frameRateHz
            self.horizontalResolutionPix = horizontalResolutionPix
            self.verticalResolutionPix = verticalResolutionPix
            self.bitRateBS = bitRateBS
            self.rotationDeg = rotationDeg
            self.uri = uri
            self.horizontalFovDeg = horizontalFovDeg
        }

        internal var rpcVideoStreamSettings: Mavsdk_Rpc_Camera_VideoStreamSettings {
            var rpcVideoStreamSettings = Mavsdk_Rpc_Camera_VideoStreamSettings()
            
                
            rpcVideoStreamSettings.frameRateHz = frameRateHz
                
            
            
                
            rpcVideoStreamSettings.horizontalResolutionPix = horizontalResolutionPix
                
            
            
                
            rpcVideoStreamSettings.verticalResolutionPix = verticalResolutionPix
                
            
            
                
            rpcVideoStreamSettings.bitRateBS = bitRateBS
                
            
            
                
            rpcVideoStreamSettings.rotationDeg = rotationDeg
                
            
            
                
            rpcVideoStreamSettings.uri = uri
                
            
            
                
            rpcVideoStreamSettings.horizontalFovDeg = horizontalFovDeg
                
            

            return rpcVideoStreamSettings
        }

        internal static func translateFromRpc(_ rpcVideoStreamSettings: Mavsdk_Rpc_Camera_VideoStreamSettings) -> VideoStreamSettings {
            return VideoStreamSettings(frameRateHz: rpcVideoStreamSettings.frameRateHz, horizontalResolutionPix: rpcVideoStreamSettings.horizontalResolutionPix, verticalResolutionPix: rpcVideoStreamSettings.verticalResolutionPix, bitRateBS: rpcVideoStreamSettings.bitRateBS, rotationDeg: rpcVideoStreamSettings.rotationDeg, uri: rpcVideoStreamSettings.uri, horizontalFovDeg: rpcVideoStreamSettings.horizontalFovDeg)
        }

        public static func == (lhs: VideoStreamSettings, rhs: VideoStreamSettings) -> Bool {
            return lhs.frameRateHz == rhs.frameRateHz
                && lhs.horizontalResolutionPix == rhs.horizontalResolutionPix
                && lhs.verticalResolutionPix == rhs.verticalResolutionPix
                && lhs.bitRateBS == rhs.bitRateBS
                && lhs.rotationDeg == rhs.rotationDeg
                && lhs.uri == rhs.uri
                && lhs.horizontalFovDeg == rhs.horizontalFovDeg
        }
    }

    /**
     Information about the video stream.
     */
    public struct VideoStreamInfo: Equatable {
        public let streamID: Int32
        public let settings: VideoStreamSettings
        public let status: VideoStreamStatus
        public let spectrum: VideoStreamSpectrum

        
        

        /**
         Video stream status type.
         */
        public enum VideoStreamStatus: Equatable {
            ///  Video stream is not running.
            case notRunning
            ///  Video stream is running.
            case inProgress
            case UNRECOGNIZED(Int)

            internal var rpcVideoStreamStatus: Mavsdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus {
                switch self {
                case .notRunning:
                    return .notRunning
                case .inProgress:
                    return .inProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcVideoStreamStatus: Mavsdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus) -> VideoStreamStatus {
                switch rpcVideoStreamStatus {
                case .notRunning:
                    return .notRunning
                case .inProgress:
                    return .inProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        
        

        /**
         Video stream light spectrum type
         */
        public enum VideoStreamSpectrum: Equatable {
            ///  Unknown.
            case unknown
            ///  Visible light.
            case visibleLight
            ///  Infrared.
            case infrared
            case UNRECOGNIZED(Int)

            internal var rpcVideoStreamSpectrum: Mavsdk_Rpc_Camera_VideoStreamInfo.VideoStreamSpectrum {
                switch self {
                case .unknown:
                    return .unknown
                case .visibleLight:
                    return .visibleLight
                case .infrared:
                    return .infrared
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcVideoStreamSpectrum: Mavsdk_Rpc_Camera_VideoStreamInfo.VideoStreamSpectrum) -> VideoStreamSpectrum {
                switch rpcVideoStreamSpectrum {
                case .unknown:
                    return .unknown
                case .visibleLight:
                    return .visibleLight
                case .infrared:
                    return .infrared
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `VideoStreamInfo`.

         
         - Parameters:
            
            - streamID:  Stream ID
            
            - settings:  Video stream settings
            
            - status:  Current status of video streaming
            
            - spectrum:  Light-spectrum of the video stream
            
         
         */
        public init(streamID: Int32, settings: VideoStreamSettings, status: VideoStreamStatus, spectrum: VideoStreamSpectrum) {
            self.streamID = streamID
            self.settings = settings
            self.status = status
            self.spectrum = spectrum
        }

        internal var rpcVideoStreamInfo: Mavsdk_Rpc_Camera_VideoStreamInfo {
            var rpcVideoStreamInfo = Mavsdk_Rpc_Camera_VideoStreamInfo()
            
                
            rpcVideoStreamInfo.streamID = streamID
                
            
            
                
            rpcVideoStreamInfo.settings = settings.rpcVideoStreamSettings
                
            
            
                
            rpcVideoStreamInfo.status = status.rpcVideoStreamStatus
                
            
            
                
            rpcVideoStreamInfo.spectrum = spectrum.rpcVideoStreamSpectrum
                
            

            return rpcVideoStreamInfo
        }

        internal static func translateFromRpc(_ rpcVideoStreamInfo: Mavsdk_Rpc_Camera_VideoStreamInfo) -> VideoStreamInfo {
            return VideoStreamInfo(streamID: rpcVideoStreamInfo.streamID, settings: VideoStreamSettings.translateFromRpc(rpcVideoStreamInfo.settings), status: VideoStreamStatus.translateFromRpc(rpcVideoStreamInfo.status), spectrum: VideoStreamSpectrum.translateFromRpc(rpcVideoStreamInfo.spectrum))
        }

        public static func == (lhs: VideoStreamInfo, rhs: VideoStreamInfo) -> Bool {
            return lhs.streamID == rhs.streamID
                && lhs.settings == rhs.settings
                && lhs.status == rhs.status
                && lhs.spectrum == rhs.spectrum
        }
    }

    /**
     
     */
    public struct ModeUpdate: Equatable {
        public let componentID: Int32
        public let mode: Mode

        

        /**
         Initializes a new `ModeUpdate`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - mode:  Camera mode
            
         
         */
        public init(componentID: Int32, mode: Mode) {
            self.componentID = componentID
            self.mode = mode
        }

        internal var rpcModeUpdate: Mavsdk_Rpc_Camera_ModeUpdate {
            var rpcModeUpdate = Mavsdk_Rpc_Camera_ModeUpdate()
            
                
            rpcModeUpdate.componentID = componentID
                
            
            
                
            rpcModeUpdate.mode = mode.rpcMode
                
            

            return rpcModeUpdate
        }

        internal static func translateFromRpc(_ rpcModeUpdate: Mavsdk_Rpc_Camera_ModeUpdate) -> ModeUpdate {
            return ModeUpdate(componentID: rpcModeUpdate.componentID, mode: Mode.translateFromRpc(rpcModeUpdate.mode))
        }

        public static func == (lhs: ModeUpdate, rhs: ModeUpdate) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.mode == rhs.mode
        }
    }

    /**
     
     */
    public struct VideoStreamUpdate: Equatable {
        public let componentID: Int32
        public let videoStreamInfo: VideoStreamInfo

        

        /**
         Initializes a new `VideoStreamUpdate`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - videoStreamInfo:  Video stream info
            
         
         */
        public init(componentID: Int32, videoStreamInfo: VideoStreamInfo) {
            self.componentID = componentID
            self.videoStreamInfo = videoStreamInfo
        }

        internal var rpcVideoStreamUpdate: Mavsdk_Rpc_Camera_VideoStreamUpdate {
            var rpcVideoStreamUpdate = Mavsdk_Rpc_Camera_VideoStreamUpdate()
            
                
            rpcVideoStreamUpdate.componentID = componentID
                
            
            
                
            rpcVideoStreamUpdate.videoStreamInfo = videoStreamInfo.rpcVideoStreamInfo
                
            

            return rpcVideoStreamUpdate
        }

        internal static func translateFromRpc(_ rpcVideoStreamUpdate: Mavsdk_Rpc_Camera_VideoStreamUpdate) -> VideoStreamUpdate {
            return VideoStreamUpdate(componentID: rpcVideoStreamUpdate.componentID, videoStreamInfo: VideoStreamInfo.translateFromRpc(rpcVideoStreamUpdate.videoStreamInfo))
        }

        public static func == (lhs: VideoStreamUpdate, rhs: VideoStreamUpdate) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.videoStreamInfo == rhs.videoStreamInfo
        }
    }

    /**
     Information about the camera's storage status.
     */
    public struct Storage: Equatable {
        public let componentID: Int32
        public let videoOn: Bool
        public let photoIntervalOn: Bool
        public let usedStorageMib: Float
        public let availableStorageMib: Float
        public let totalStorageMib: Float
        public let recordingTimeS: Float
        public let mediaFolderName: String
        public let storageStatus: StorageStatus
        public let storageID: UInt32
        public let storageType: StorageType

        
        

        /**
         Storage status type.
         */
        public enum StorageStatus: Equatable {
            ///  Status not available.
            case notAvailable
            ///  Storage is not formatted (i.e. has no recognized file system).
            case unformatted
            ///  Storage is formatted (i.e. has recognized a file system).
            case formatted
            ///  Storage status is not supported.
            case notSupported
            case UNRECOGNIZED(Int)

            internal var rpcStorageStatus: Mavsdk_Rpc_Camera_Storage.StorageStatus {
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

            internal static func translateFromRpc(_ rpcStorageStatus: Mavsdk_Rpc_Camera_Storage.StorageStatus) -> StorageStatus {
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

            internal var rpcStorageType: Mavsdk_Rpc_Camera_Storage.StorageType {
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

            internal static func translateFromRpc(_ rpcStorageType: Mavsdk_Rpc_Camera_Storage.StorageType) -> StorageType {
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
         Initializes a new `Storage`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - videoOn:  Whether video recording is currently in process
            
            - photoIntervalOn:  Whether a photo interval is currently in process
            
            - usedStorageMib:  Used storage (in MiB)
            
            - availableStorageMib:  Available storage (in MiB)
            
            - totalStorageMib:  Total storage (in MiB)
            
            - recordingTimeS:  Elapsed time since starting the video recording (in seconds)
            
            - mediaFolderName:  Current folder name where media are saved
            
            - storageStatus:  Storage status
            
            - storageID:  Storage ID starting at 1
            
            - storageType:  Storage type
            
         
         */
        public init(componentID: Int32, videoOn: Bool, photoIntervalOn: Bool, usedStorageMib: Float, availableStorageMib: Float, totalStorageMib: Float, recordingTimeS: Float, mediaFolderName: String, storageStatus: StorageStatus, storageID: UInt32, storageType: StorageType) {
            self.componentID = componentID
            self.videoOn = videoOn
            self.photoIntervalOn = photoIntervalOn
            self.usedStorageMib = usedStorageMib
            self.availableStorageMib = availableStorageMib
            self.totalStorageMib = totalStorageMib
            self.recordingTimeS = recordingTimeS
            self.mediaFolderName = mediaFolderName
            self.storageStatus = storageStatus
            self.storageID = storageID
            self.storageType = storageType
        }

        internal var rpcStorage: Mavsdk_Rpc_Camera_Storage {
            var rpcStorage = Mavsdk_Rpc_Camera_Storage()
            
                
            rpcStorage.componentID = componentID
                
            
            
                
            rpcStorage.videoOn = videoOn
                
            
            
                
            rpcStorage.photoIntervalOn = photoIntervalOn
                
            
            
                
            rpcStorage.usedStorageMib = usedStorageMib
                
            
            
                
            rpcStorage.availableStorageMib = availableStorageMib
                
            
            
                
            rpcStorage.totalStorageMib = totalStorageMib
                
            
            
                
            rpcStorage.recordingTimeS = recordingTimeS
                
            
            
                
            rpcStorage.mediaFolderName = mediaFolderName
                
            
            
                
            rpcStorage.storageStatus = storageStatus.rpcStorageStatus
                
            
            
                
            rpcStorage.storageID = storageID
                
            
            
                
            rpcStorage.storageType = storageType.rpcStorageType
                
            

            return rpcStorage
        }

        internal static func translateFromRpc(_ rpcStorage: Mavsdk_Rpc_Camera_Storage) -> Storage {
            return Storage(componentID: rpcStorage.componentID, videoOn: rpcStorage.videoOn, photoIntervalOn: rpcStorage.photoIntervalOn, usedStorageMib: rpcStorage.usedStorageMib, availableStorageMib: rpcStorage.availableStorageMib, totalStorageMib: rpcStorage.totalStorageMib, recordingTimeS: rpcStorage.recordingTimeS, mediaFolderName: rpcStorage.mediaFolderName, storageStatus: StorageStatus.translateFromRpc(rpcStorage.storageStatus), storageID: rpcStorage.storageID, storageType: StorageType.translateFromRpc(rpcStorage.storageType))
        }

        public static func == (lhs: Storage, rhs: Storage) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.videoOn == rhs.videoOn
                && lhs.photoIntervalOn == rhs.photoIntervalOn
                && lhs.usedStorageMib == rhs.usedStorageMib
                && lhs.availableStorageMib == rhs.availableStorageMib
                && lhs.totalStorageMib == rhs.totalStorageMib
                && lhs.recordingTimeS == rhs.recordingTimeS
                && lhs.mediaFolderName == rhs.mediaFolderName
                && lhs.storageStatus == rhs.storageStatus
                && lhs.storageID == rhs.storageID
                && lhs.storageType == rhs.storageType
        }
    }

    /**
     
     */
    public struct StorageUpdate: Equatable {
        public let componentID: Int32
        public let storage: Storage

        

        /**
         Initializes a new `StorageUpdate`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - storage:  Storage
            
         
         */
        public init(componentID: Int32, storage: Storage) {
            self.componentID = componentID
            self.storage = storage
        }

        internal var rpcStorageUpdate: Mavsdk_Rpc_Camera_StorageUpdate {
            var rpcStorageUpdate = Mavsdk_Rpc_Camera_StorageUpdate()
            
                
            rpcStorageUpdate.componentID = componentID
                
            
            
                
            rpcStorageUpdate.storage = storage.rpcStorage
                
            

            return rpcStorageUpdate
        }

        internal static func translateFromRpc(_ rpcStorageUpdate: Mavsdk_Rpc_Camera_StorageUpdate) -> StorageUpdate {
            return StorageUpdate(componentID: rpcStorageUpdate.componentID, storage: Storage.translateFromRpc(rpcStorageUpdate.storage))
        }

        public static func == (lhs: StorageUpdate, rhs: StorageUpdate) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.storage == rhs.storage
        }
    }

    /**
     
     */
    public struct CurrentSettingsUpdate: Equatable {
        public let componentID: Int32
        public let currentSettings: [Setting]

        

        /**
         Initializes a new `CurrentSettingsUpdate`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - currentSettings:  List of current settings
            
         
         */
        public init(componentID: Int32, currentSettings: [Setting]) {
            self.componentID = componentID
            self.currentSettings = currentSettings
        }

        internal var rpcCurrentSettingsUpdate: Mavsdk_Rpc_Camera_CurrentSettingsUpdate {
            var rpcCurrentSettingsUpdate = Mavsdk_Rpc_Camera_CurrentSettingsUpdate()
            
                
            rpcCurrentSettingsUpdate.componentID = componentID
                
            
            
                
            rpcCurrentSettingsUpdate.currentSettings = currentSettings.map{ $0.rpcSetting }
                
            

            return rpcCurrentSettingsUpdate
        }

        internal static func translateFromRpc(_ rpcCurrentSettingsUpdate: Mavsdk_Rpc_Camera_CurrentSettingsUpdate) -> CurrentSettingsUpdate {
            return CurrentSettingsUpdate(componentID: rpcCurrentSettingsUpdate.componentID, currentSettings: rpcCurrentSettingsUpdate.currentSettings.map{ Setting.translateFromRpc($0) })
        }

        public static func == (lhs: CurrentSettingsUpdate, rhs: CurrentSettingsUpdate) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.currentSettings == rhs.currentSettings
        }
    }

    /**
     
     */
    public struct PossibleSettingOptionsUpdate: Equatable {
        public let componentID: Int32
        public let settingOptions: [SettingOptions]

        

        /**
         Initializes a new `PossibleSettingOptionsUpdate`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - settingOptions:  List of settings that can be changed
            
         
         */
        public init(componentID: Int32, settingOptions: [SettingOptions]) {
            self.componentID = componentID
            self.settingOptions = settingOptions
        }

        internal var rpcPossibleSettingOptionsUpdate: Mavsdk_Rpc_Camera_PossibleSettingOptionsUpdate {
            var rpcPossibleSettingOptionsUpdate = Mavsdk_Rpc_Camera_PossibleSettingOptionsUpdate()
            
                
            rpcPossibleSettingOptionsUpdate.componentID = componentID
                
            
            
                
            rpcPossibleSettingOptionsUpdate.settingOptions = settingOptions.map{ $0.rpcSettingOptions }
                
            

            return rpcPossibleSettingOptionsUpdate
        }

        internal static func translateFromRpc(_ rpcPossibleSettingOptionsUpdate: Mavsdk_Rpc_Camera_PossibleSettingOptionsUpdate) -> PossibleSettingOptionsUpdate {
            return PossibleSettingOptionsUpdate(componentID: rpcPossibleSettingOptionsUpdate.componentID, settingOptions: rpcPossibleSettingOptionsUpdate.settingOptions.map{ SettingOptions.translateFromRpc($0) })
        }

        public static func == (lhs: PossibleSettingOptionsUpdate, rhs: PossibleSettingOptionsUpdate) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.settingOptions == rhs.settingOptions
        }
    }

    /**
     Result type.
     */
    public struct CameraResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for camera commands
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
            ///  Definition file protocol not supported.
            case protocolUnsupported
            ///  Not available (yet).
            case unavailable
            ///  Camera with camera ID not found.
            case cameraIDInvalid
            ///  Camera action not supported.
            case actionUnsupported
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Camera_CameraResult.Result {
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
                case .protocolUnsupported:
                    return .protocolUnsupported
                case .unavailable:
                    return .unavailable
                case .cameraIDInvalid:
                    return .cameraIDInvalid
                case .actionUnsupported:
                    return .actionUnsupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Camera_CameraResult.Result) -> Result {
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
                case .protocolUnsupported:
                    return .protocolUnsupported
                case .unavailable:
                    return .unavailable
                case .cameraIDInvalid:
                    return .cameraIDInvalid
                case .actionUnsupported:
                    return .actionUnsupported
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `CameraResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcCameraResult: Mavsdk_Rpc_Camera_CameraResult {
            var rpcCameraResult = Mavsdk_Rpc_Camera_CameraResult()
            
                
            rpcCameraResult.result = result.rpcResult
                
            
            
                
            rpcCameraResult.resultStr = resultStr
                
            

            return rpcCameraResult
        }

        internal static func translateFromRpc(_ rpcCameraResult: Mavsdk_Rpc_Camera_CameraResult) -> CameraResult {
            return CameraResult(result: Result.translateFromRpc(rpcCameraResult.result), resultStr: rpcCameraResult.resultStr)
        }

        public static func == (lhs: CameraResult, rhs: CameraResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
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

        internal var rpcPosition: Mavsdk_Rpc_Camera_Position {
            var rpcPosition = Mavsdk_Rpc_Camera_Position()
            
                
            rpcPosition.latitudeDeg = latitudeDeg
                
            
            
                
            rpcPosition.longitudeDeg = longitudeDeg
                
            
            
                
            rpcPosition.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcPosition.relativeAltitudeM = relativeAltitudeM
                
            

            return rpcPosition
        }

        internal static func translateFromRpc(_ rpcPosition: Mavsdk_Rpc_Camera_Position) -> Position {
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

        internal var rpcQuaternion: Mavsdk_Rpc_Camera_Quaternion {
            var rpcQuaternion = Mavsdk_Rpc_Camera_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: Mavsdk_Rpc_Camera_Quaternion) -> Quaternion {
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
     The Euler angles follow the convention of a 3-2-1 intrinsic Tait-Bryan rotation sequence.

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

        internal var rpcEulerAngle: Mavsdk_Rpc_Camera_EulerAngle {
            var rpcEulerAngle = Mavsdk_Rpc_Camera_EulerAngle()
            
                
            rpcEulerAngle.rollDeg = rollDeg
                
            
            
                
            rpcEulerAngle.pitchDeg = pitchDeg
                
            
            
                
            rpcEulerAngle.yawDeg = yawDeg
                
            

            return rpcEulerAngle
        }

        internal static func translateFromRpc(_ rpcEulerAngle: Mavsdk_Rpc_Camera_EulerAngle) -> EulerAngle {
            return EulerAngle(rollDeg: rpcEulerAngle.rollDeg, pitchDeg: rpcEulerAngle.pitchDeg, yawDeg: rpcEulerAngle.yawDeg)
        }

        public static func == (lhs: EulerAngle, rhs: EulerAngle) -> Bool {
            return lhs.rollDeg == rhs.rollDeg
                && lhs.pitchDeg == rhs.pitchDeg
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    /**
     Information about a picture just captured.
     */
    public struct CaptureInfo: Equatable {
        public let componentID: Int32
        public let position: Position
        public let attitudeQuaternion: Quaternion
        public let attitudeEulerAngle: EulerAngle
        public let timeUtcUs: UInt64
        public let isSuccess: Bool
        public let index: Int32
        public let fileURL: String

        

        /**
         Initializes a new `CaptureInfo`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - position:  Location where the picture was taken
            
            - attitudeQuaternion:  Attitude of the camera when the picture was taken (quaternion)
            
            - attitudeEulerAngle:  Attitude of the camera when the picture was taken (euler angle)
            
            - timeUtcUs:  Timestamp in UTC (since UNIX epoch) in microseconds
            
            - isSuccess:  True if the capture was successful
            
            - index:  Zero-based index of this image since vehicle was armed
            
            - fileURL:  Download URL of this image
            
         
         */
        public init(componentID: Int32, position: Position, attitudeQuaternion: Quaternion, attitudeEulerAngle: EulerAngle, timeUtcUs: UInt64, isSuccess: Bool, index: Int32, fileURL: String) {
            self.componentID = componentID
            self.position = position
            self.attitudeQuaternion = attitudeQuaternion
            self.attitudeEulerAngle = attitudeEulerAngle
            self.timeUtcUs = timeUtcUs
            self.isSuccess = isSuccess
            self.index = index
            self.fileURL = fileURL
        }

        internal var rpcCaptureInfo: Mavsdk_Rpc_Camera_CaptureInfo {
            var rpcCaptureInfo = Mavsdk_Rpc_Camera_CaptureInfo()
            
                
            rpcCaptureInfo.componentID = componentID
                
            
            
                
            rpcCaptureInfo.position = position.rpcPosition
                
            
            
                
            rpcCaptureInfo.attitudeQuaternion = attitudeQuaternion.rpcQuaternion
                
            
            
                
            rpcCaptureInfo.attitudeEulerAngle = attitudeEulerAngle.rpcEulerAngle
                
            
            
                
            rpcCaptureInfo.timeUtcUs = timeUtcUs
                
            
            
                
            rpcCaptureInfo.isSuccess = isSuccess
                
            
            
                
            rpcCaptureInfo.index = index
                
            
            
                
            rpcCaptureInfo.fileURL = fileURL
                
            

            return rpcCaptureInfo
        }

        internal static func translateFromRpc(_ rpcCaptureInfo: Mavsdk_Rpc_Camera_CaptureInfo) -> CaptureInfo {
            return CaptureInfo(componentID: rpcCaptureInfo.componentID, position: Position.translateFromRpc(rpcCaptureInfo.position), attitudeQuaternion: Quaternion.translateFromRpc(rpcCaptureInfo.attitudeQuaternion), attitudeEulerAngle: EulerAngle.translateFromRpc(rpcCaptureInfo.attitudeEulerAngle), timeUtcUs: rpcCaptureInfo.timeUtcUs, isSuccess: rpcCaptureInfo.isSuccess, index: rpcCaptureInfo.index, fileURL: rpcCaptureInfo.fileURL)
        }

        public static func == (lhs: CaptureInfo, rhs: CaptureInfo) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.position == rhs.position
                && lhs.attitudeQuaternion == rhs.attitudeQuaternion
                && lhs.attitudeEulerAngle == rhs.attitudeEulerAngle
                && lhs.timeUtcUs == rhs.timeUtcUs
                && lhs.isSuccess == rhs.isSuccess
                && lhs.index == rhs.index
                && lhs.fileURL == rhs.fileURL
        }
    }

    /**
     Type to represent a camera information.
     */
    public struct Information: Equatable {
        public let componentID: Int32
        public let vendorName: String
        public let modelName: String
        public let focalLengthMm: Float
        public let horizontalSensorSizeMm: Float
        public let verticalSensorSizeMm: Float
        public let horizontalResolutionPx: UInt32
        public let verticalResolutionPx: UInt32

        

        /**
         Initializes a new `Information`.

         
         - Parameters:
            
            - componentID:  Component ID
            
            - vendorName:  Name of the camera vendor
            
            - modelName:  Name of the camera model
            
            - focalLengthMm:  Focal length
            
            - horizontalSensorSizeMm:  Horizontal sensor size
            
            - verticalSensorSizeMm:  Vertical sensor size
            
            - horizontalResolutionPx:  Horizontal image resolution in pixels
            
            - verticalResolutionPx:  Vertical image resolution in pixels
            
         
         */
        public init(componentID: Int32, vendorName: String, modelName: String, focalLengthMm: Float, horizontalSensorSizeMm: Float, verticalSensorSizeMm: Float, horizontalResolutionPx: UInt32, verticalResolutionPx: UInt32) {
            self.componentID = componentID
            self.vendorName = vendorName
            self.modelName = modelName
            self.focalLengthMm = focalLengthMm
            self.horizontalSensorSizeMm = horizontalSensorSizeMm
            self.verticalSensorSizeMm = verticalSensorSizeMm
            self.horizontalResolutionPx = horizontalResolutionPx
            self.verticalResolutionPx = verticalResolutionPx
        }

        internal var rpcInformation: Mavsdk_Rpc_Camera_Information {
            var rpcInformation = Mavsdk_Rpc_Camera_Information()
            
                
            rpcInformation.componentID = componentID
                
            
            
                
            rpcInformation.vendorName = vendorName
                
            
            
                
            rpcInformation.modelName = modelName
                
            
            
                
            rpcInformation.focalLengthMm = focalLengthMm
                
            
            
                
            rpcInformation.horizontalSensorSizeMm = horizontalSensorSizeMm
                
            
            
                
            rpcInformation.verticalSensorSizeMm = verticalSensorSizeMm
                
            
            
                
            rpcInformation.horizontalResolutionPx = horizontalResolutionPx
                
            
            
                
            rpcInformation.verticalResolutionPx = verticalResolutionPx
                
            

            return rpcInformation
        }

        internal static func translateFromRpc(_ rpcInformation: Mavsdk_Rpc_Camera_Information) -> Information {
            return Information(componentID: rpcInformation.componentID, vendorName: rpcInformation.vendorName, modelName: rpcInformation.modelName, focalLengthMm: rpcInformation.focalLengthMm, horizontalSensorSizeMm: rpcInformation.horizontalSensorSizeMm, verticalSensorSizeMm: rpcInformation.verticalSensorSizeMm, horizontalResolutionPx: rpcInformation.horizontalResolutionPx, verticalResolutionPx: rpcInformation.verticalResolutionPx)
        }

        public static func == (lhs: Information, rhs: Information) -> Bool {
            return lhs.componentID == rhs.componentID
                && lhs.vendorName == rhs.vendorName
                && lhs.modelName == rhs.modelName
                && lhs.focalLengthMm == rhs.focalLengthMm
                && lhs.horizontalSensorSizeMm == rhs.horizontalSensorSizeMm
                && lhs.verticalSensorSizeMm == rhs.verticalSensorSizeMm
                && lhs.horizontalResolutionPx == rhs.horizontalResolutionPx
                && lhs.verticalResolutionPx == rhs.verticalResolutionPx
        }
    }

    /**
     Camera list
     */
    public struct CameraList: Equatable {
        public let cameras: [Information]

        

        /**
         Initializes a new `CameraList`.

         
         - Parameter cameras:  Camera items.
         
         */
        public init(cameras: [Information]) {
            self.cameras = cameras
        }

        internal var rpcCameraList: Mavsdk_Rpc_Camera_CameraList {
            var rpcCameraList = Mavsdk_Rpc_Camera_CameraList()
            
                
            rpcCameraList.cameras = cameras.map{ $0.rpcInformation }
                
            

            return rpcCameraList
        }

        internal static func translateFromRpc(_ rpcCameraList: Mavsdk_Rpc_Camera_CameraList) -> CameraList {
            return CameraList(cameras: rpcCameraList.cameras.map{ Information.translateFromRpc($0) })
        }

        public static func == (lhs: CameraList, rhs: CameraList) -> Bool {
            return lhs.cameras == rhs.cameras
        }
    }


    /**
     Take one photo.

     - Parameter componentID: Component ID
     
     */
    public func takePhoto(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_TakePhotoRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.takePhoto(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start photo timelapse with a given interval.

     - Parameters:
        - componentID: Component ID
        - intervalS: Interval between photos (in seconds)
     
     */
    public func startPhotoInterval(componentID: Int32, intervalS: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_StartPhotoIntervalRequest()

            
                
            request.componentID = componentID
                
            
                
            request.intervalS = intervalS
                
            

            do {
                
                let response = self.service.startPhotoInterval(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop a running photo timelapse.

     - Parameter componentID: Component ID
     
     */
    public func stopPhotoInterval(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_StopPhotoIntervalRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.stopPhotoInterval(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start a video recording.

     - Parameter componentID: Component ID
     
     */
    public func startVideo(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_StartVideoRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.startVideo(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop a running video recording.

     - Parameter componentID: Component ID
     
     */
    public func stopVideo(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_StopVideoRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.stopVideo(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start video streaming.

     - Parameters:
        - componentID: Component ID
        - streamID: video stream id
     
     */
    public func startVideoStreaming(componentID: Int32, streamID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_StartVideoStreamingRequest()

            
                
            request.componentID = componentID
                
            
                
            request.streamID = streamID
                
            

            do {
                
                let response = self.service.startVideoStreaming(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop current video streaming.

     - Parameters:
        - componentID: Component ID
        - streamID: video stream id
     
     */
    public func stopVideoStreaming(componentID: Int32, streamID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_StopVideoStreamingRequest()

            
                
            request.componentID = componentID
                
            
                
            request.streamID = streamID
                
            

            do {
                
                let response = self.service.stopVideoStreaming(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set camera mode.

     - Parameters:
        - componentID: Component ID
        - mode: Camera mode to set
     
     */
    public func setMode(componentID: Int32, mode: Mode) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_SetModeRequest()

            
                
            request.componentID = componentID
                
            
                
            request.mode = mode.rpcMode
                
            

            do {
                
                let response = self.service.setMode(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     List photos available on the camera.

     Note that this might need to be called initially to set the PhotosRange accordingly.
     Once set to 'all' rather than 'since connection', it will try to request the previous
     images over time.

     - Parameters:
        - componentID: Component ID
        - photosRange: Which photos should be listed (all or since connection)
     
     */
    public func listPhotos(componentID: Int32, photosRange: PhotosRange) -> Single<[CaptureInfo]> {
        return Single<[CaptureInfo]>.create { single in
            var request = Mavsdk_Rpc_Camera_ListPhotosRequest()

            
                
            request.componentID = componentID
                
            
                
            request.photosRange = photosRange.rpcPhotosRange
                
            

            do {
                let response = self.service.listPhotos(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.failure(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let captureInfos = try response.response.wait().captureInfos.map{ CaptureInfo.translateFromRpc($0) }
                
                single(.success(captureInfos))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to list of cameras.

     This allows to find out what cameras are connected to the system.
     Based on the camera ID, we can then address a specific camera.
     */

    public lazy var cameraList: Observable<CameraList> = createCameraListObservable()




    private func createCameraListObservable() -> Observable<CameraList> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Camera_SubscribeCameraListRequest()

            

            let serverStreamingCall = self.service.subscribeCameraList(request, handler: { (response) in

                
                     
                let cameraList = CameraList.translateFromRpc(response.cameraList)
                

                
                observer.onNext(cameraList)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to camera mode updates.
     */

    public lazy var mode: Observable<ModeUpdate> = createModeObservable()




    private func createModeObservable() -> Observable<ModeUpdate> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Camera_SubscribeModeRequest()

            

            let serverStreamingCall = self.service.subscribeMode(request, handler: { (response) in

                
                     
                let mode = ModeUpdate.translateFromRpc(response.update)
                

                
                observer.onNext(mode)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get camera mode.

     - Parameter componentID: Component ID
     
     */
    public func getMode(componentID: Int32) -> Single<Mode> {
        return Single<Mode>.create { single in
            var request = Mavsdk_Rpc_Camera_GetModeRequest()

            
                
            request.componentID = componentID
                
            

            do {
                let response = self.service.getMode(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.failure(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let mode = try Mode.translateFromRpc(response.response.wait().mode)
                
                single(.success(mode))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to video stream info updates.
     */

    public lazy var videoStreamInfo: Observable<VideoStreamUpdate> = createVideoStreamInfoObservable()




    private func createVideoStreamInfoObservable() -> Observable<VideoStreamUpdate> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Camera_SubscribeVideoStreamInfoRequest()

            

            let serverStreamingCall = self.service.subscribeVideoStreamInfo(request, handler: { (response) in

                
                     
                let videoStreamInfo = VideoStreamUpdate.translateFromRpc(response.update)
                

                
                observer.onNext(videoStreamInfo)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get video stream info.

     - Parameter componentID: Component ID
     
     */
    public func getVideoStreamInfo(componentID: Int32) -> Single<VideoStreamInfo> {
        return Single<VideoStreamInfo>.create { single in
            var request = Mavsdk_Rpc_Camera_GetVideoStreamInfoRequest()

            
                
            request.componentID = componentID
                
            

            do {
                let response = self.service.getVideoStreamInfo(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.failure(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let videoStreamInfo = try VideoStreamInfo.translateFromRpc(response.response.wait().videoStreamInfo)
                
                single(.success(videoStreamInfo))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to capture info updates.
     */

    public lazy var captureInfo: Observable<CaptureInfo> = createCaptureInfoObservable()




    private func createCaptureInfoObservable() -> Observable<CaptureInfo> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Camera_SubscribeCaptureInfoRequest()

            

            let serverStreamingCall = self.service.subscribeCaptureInfo(request, handler: { (response) in

                
                     
                let captureInfo = CaptureInfo.translateFromRpc(response.captureInfo)
                

                
                observer.onNext(captureInfo)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to camera's storage status updates.
     */

    public lazy var storage: Observable<StorageUpdate> = createStorageObservable()




    private func createStorageObservable() -> Observable<StorageUpdate> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Camera_SubscribeStorageRequest()

            

            let serverStreamingCall = self.service.subscribeStorage(request, handler: { (response) in

                
                     
                let storage = StorageUpdate.translateFromRpc(response.update)
                

                
                observer.onNext(storage)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get camera's storage status.

     - Parameter componentID: Component ID
     
     */
    public func getStorage(componentID: Int32) -> Single<Storage> {
        return Single<Storage>.create { single in
            var request = Mavsdk_Rpc_Camera_GetStorageRequest()

            
                
            request.componentID = componentID
                
            

            do {
                let response = self.service.getStorage(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.failure(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let storage = try Storage.translateFromRpc(response.response.wait().storage)
                
                single(.success(storage))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


    /**
     Get the list of current camera settings.
     */

    public lazy var currentSettings: Observable<CurrentSettingsUpdate> = createCurrentSettingsObservable()




    private func createCurrentSettingsObservable() -> Observable<CurrentSettingsUpdate> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Camera_SubscribeCurrentSettingsRequest()

            

            let serverStreamingCall = self.service.subscribeCurrentSettings(request, handler: { (response) in

                
                     
                let currentSettings = CurrentSettingsUpdate.translateFromRpc(response.update)
                

                
                observer.onNext(currentSettings)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get current settings.

     - Parameter componentID: Component ID
     
     */
    public func getCurrentSettings(componentID: Int32) -> Single<[Setting]> {
        return Single<[Setting]>.create { single in
            var request = Mavsdk_Rpc_Camera_GetCurrentSettingsRequest()

            
                
            request.componentID = componentID
                
            

            do {
                let response = self.service.getCurrentSettings(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.failure(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let currentSettings = try response.response.wait().currentSettings.map{ Setting.translateFromRpc($0) }
                
                single(.success(currentSettings))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


    /**
     Get the list of settings that can be changed.
     */

    public lazy var possibleSettingOptions: Observable<PossibleSettingOptionsUpdate> = createPossibleSettingOptionsObservable()




    private func createPossibleSettingOptionsObservable() -> Observable<PossibleSettingOptionsUpdate> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Camera_SubscribePossibleSettingOptionsRequest()

            

            let serverStreamingCall = self.service.subscribePossibleSettingOptions(request, handler: { (response) in

                
                     
                let possibleSettingOptions = PossibleSettingOptionsUpdate.translateFromRpc(response.update)
                

                
                observer.onNext(possibleSettingOptions)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get possible setting options.

     - Parameter componentID: Component ID
     
     */
    public func getPossibleSettingOptions(componentID: Int32) -> Single<[SettingOptions]> {
        return Single<[SettingOptions]>.create { single in
            var request = Mavsdk_Rpc_Camera_GetPossibleSettingOptionsRequest()

            
                
            request.componentID = componentID
                
            

            do {
                let response = self.service.getPossibleSettingOptions(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.failure(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let settingOptions = try response.response.wait().settingOptions.map{ SettingOptions.translateFromRpc($0) }
                
                single(.success(settingOptions))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set a setting to some value.

     Only setting_id of setting and option_id of option needs to be set.

     - Parameters:
        - componentID: Component ID
        - setting: Desired setting
     
     */
    public func setSetting(componentID: Int32, setting: Setting) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_SetSettingRequest()

            
                
            request.componentID = componentID
                
            
                
            request.setting = setting.rpcSetting
                
            

            do {
                
                let response = self.service.setSetting(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get a setting.

     Only setting_id of setting needs to be set.

     - Parameters:
        - componentID: Component ID (0/all not available)
        - setting: Requested setting
     
     */
    public func getSetting(componentID: Int32, setting: Setting) -> Single<Setting> {
        return Single<Setting>.create { single in
            var request = Mavsdk_Rpc_Camera_GetSettingRequest()

            
                
            request.componentID = componentID
                
            
                
            request.setting = setting.rpcSetting
                
            

            do {
                let response = self.service.getSetting(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.failure(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let setting = try Setting.translateFromRpc(response.response.wait().setting)
                
                single(.success(setting))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    /**
     Format storage (e.g. SD card) in camera.

     This will delete all content of the camera storage!

     - Parameters:
        - componentID: Component ID
        - storageID:Storage identify to be format
     
     */
    public func formatStorage(componentID: Int32, storageID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_FormatStorageRequest()

            
                
            request.componentID = componentID
                
            
                
            request.storageID = storageID
                
            

            do {
                
                let response = self.service.formatStorage(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Reset all settings in camera.

     This will reset all camera settings to default value

     - Parameter componentID: Component ID
     
     */
    public func resetSettings(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_ResetSettingsRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.resetSettings(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start zooming in.

     - Parameter componentID: Component ID
     
     */
    public func zoomInStart(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_ZoomInStartRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.zoomInStart(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start zooming out.

     - Parameter componentID: Component ID
     
     */
    public func zoomOutStart(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_ZoomOutStartRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.zoomOutStart(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop zooming.

     - Parameter componentID: Component ID
     
     */
    public func zoomStop(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_ZoomStopRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.zoomStop(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Zoom to value as proportion of full camera range (percentage between 0.0 and 100.0).

     - Parameters:
        - componentID: Component ID
        - range: Range must be between 0.0 and 100.0
     
     */
    public func zoomRange(componentID: Int32, range: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_ZoomRangeRequest()

            
                
            request.componentID = componentID
                
            
                
            request.range = range
                
            

            do {
                
                let response = self.service.zoomRange(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Track point.

     - Parameters:
        - componentID: Component ID
        - pointX: Point in X axis (0..1, 0 is left, 1 is right)
        - pointY: Point in Y axis (0..1, 0 is top, 1 is bottom)
        - radius: Radius (0 is one pixel, 1 is full image width)
     
     */
    public func trackPoint(componentID: Int32, pointX: Float, pointY: Float, radius: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_TrackPointRequest()

            
                
            request.componentID = componentID
                
            
                
            request.pointX = pointX
                
            
                
            request.pointY = pointY
                
            
                
            request.radius = radius
                
            

            do {
                
                let response = self.service.trackPoint(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Track rectangle.

     - Parameters:
        - componentID: Component ID
        - topLeftX: Top left corner of rectangle x value (normalized 0..1, 0 is left, 1 is right)
        - topLeftY: Top left corner of rectangle y value (normalized 0..1, 0 is top, 1 is bottom)
        - bottomRightX: Bottom right corner of rectangle x value (normalized 0..1, 0 is left, 1 is right)
        - bottomRightY: Bottom right corner of rectangle y value (normalized 0..1, 0 is top, 1 is bottom)
     
     */
    public func trackRectangle(componentID: Int32, topLeftX: Float, topLeftY: Float, bottomRightX: Float, bottomRightY: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_TrackRectangleRequest()

            
                
            request.componentID = componentID
                
            
                
            request.topLeftX = topLeftX
                
            
                
            request.topLeftY = topLeftY
                
            
                
            request.bottomRightX = bottomRightX
                
            
                
            request.bottomRightY = bottomRightY
                
            

            do {
                
                let response = self.service.trackRectangle(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop tracking.

     - Parameter componentID: Component ID
     
     */
    public func trackStop(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_TrackStopRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.trackStop(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start focusing in.

     - Parameter componentID: Component ID
     
     */
    public func focusInStart(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_FocusInStartRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.focusInStart(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start focusing out.

     - Parameter componentID: Component ID
     
     */
    public func focusOutStart(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_FocusOutStartRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.focusOutStart(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop focus.

     - Parameter componentID: Component ID
     
     */
    public func focusStop(componentID: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_FocusStopRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = self.service.focusStop(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Focus with range value of full range (value between 0.0 and 100.0).

     - Parameters:
        - componentID: Component ID
        - range: Range must be between 0.0 - 100.0
     
     */
    public func focusRange(componentID: Int32, range: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_FocusRangeRequest()

            
                
            request.componentID = componentID
                
            
                
            request.range = range
                
            

            do {
                
                let response = self.service.focusRange(request)

                let result = try response.response.wait().cameraResult
                if (result.result == Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}