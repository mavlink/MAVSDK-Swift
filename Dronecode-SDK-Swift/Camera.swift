import Foundation
import SwiftGRPC
import RxSwift

/**
 Possible results returned for camera commands.
 */
public struct CameraResult: Equatable {
    /// The result enum.
    public let result: Result
    /// The result as a human readable string.
    public let resultString: String
    
    /**
     Initialize a camera result.
 
     - Parameters:
        - result: The result enum.
        - resultString: The human readable string for a result.
     */
    public init(result: Result, resultString: String) {
        self.result = result
        self.resultString = resultString
    }
    
    internal var rpcCameraResult: DronecodeSdk_Rpc_Camera_CameraResult {
        var rpcCameraResult = DronecodeSdk_Rpc_Camera_CameraResult()
        
        rpcCameraResult.result = result.rpcResult
        rpcCameraResult.resultStr = resultString
        
        return rpcCameraResult
    }
    
    internal static func translateFromRPC(_ rpcCameraResult: DronecodeSdk_Rpc_Camera_CameraResult) -> CameraResult {
        return CameraResult(result: Result.translateFromRPC(rpcCameraResult.result),
                            resultString: rpcCameraResult.resultStr)
    }
    
    public static func == (lhs: CameraResult, rhs: CameraResult) -> Bool {
        return lhs.result == rhs.result
            && lhs.resultString == rhs.resultString
    }
}

/**
 The camera result enum.
 */
public enum Result {
    /// The result is unknown.
    case unknown
    /// Camera command executed successfully.
    case success
    /// Camera command is in progress.
    case inProgress
    /// Camera is busy and rejected command.
    case busy
    /// Camera has denied the command.
    case denied
    /// An error has occurred while executing the command.
    case error
    /// Camera has not responded in time and the command has timed out.
    case timeout
    /// The command has wrong arguments.
    case wrongArgument
    
    internal var rpcResult: DronecodeSdk_Rpc_Camera_CameraResult.Result {
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
        }
    }
    
    internal static func translateFromRPC(_ rpcResult: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> Result {
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
        case .UNRECOGNIZED(_):
            return .unknown
        }
    }
}

/**
 Camera mode type.
 */
public enum CameraMode {
    /// Unknown mode.
    case unknown
    /// Photo mode.
    case photo
    /// Video mode.
    case video
    
    internal var rpcCameraMode: DronecodeSdk_Rpc_Camera_CameraMode {
        switch self {
        case .photo:
            return .photo
        case .video:
            return .video
        default:
            return .unknown
        }
    }
    
    internal static func translateFromRPC(_ rpcCameraMode: DronecodeSdk_Rpc_Camera_CameraMode) -> CameraMode {
        switch rpcCameraMode {
        case .photo:
            return .photo
        case .video:
            return .video
        default:
            return .unknown
        }
    }
}

/**
 Information about a picture just captured.
 */
public struct CaptureInfo: Equatable {
    /// Position when image was captured.
    public let position: Position
    /// Camera attitude of image captured as quaternion.
    public let attitudeQuaternion: Quaternion
    /// Camera attitude of image captured as Euler angle.
    public let attitudeEulerAngle: EulerAngle
    /// Time UTC of image captured in UTC in microseconds.
    public let timeUTC: UInt64
    /// True if capture was successful.
    public let isSuccess: Bool
    /// Zero-based index of this image since armed.
    public let index: Int
    /// Download URL for captured image.
    public let fileURL: String
    
    /**
     Initialize `CaptureInfo`.
     
     - Parameters:
       - position: Position.
       - attitudeQuaternion: Attitude as quaternion.
       - attitudeEulerAngle: Attitude as Euler angle.
       - timeUTC: Time in UTC in microseconds.
       - isSuccess: True if capture was successful.
       - index: Zero based index of this image since armed.
       - fileURL: Download URL for captured image.
     */
    public init(position: Position, attitudeQuaternion: Quaternion, attitudeEulerAngle: EulerAngle, timeUTC: UInt64, isSuccess: Bool, index: Int32, fileURL: String) {
        self.position = position
        self.attitudeQuaternion = attitudeQuaternion
        self.attitudeEulerAngle = attitudeEulerAngle
        self.timeUTC = timeUTC
        self.isSuccess = isSuccess
        self.index = Int(index)
        self.fileURL = fileURL
    }
    
    internal var rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo {
        var rpcCaptureInfo = DronecodeSdk_Rpc_Camera_CaptureInfo()
        
        rpcCaptureInfo.position = position.rpcCameraPosition
        rpcCaptureInfo.attitudeQuaternion = attitudeQuaternion.rpcCameraQuaternion
        rpcCaptureInfo.attitudeEulerAngle = attitudeEulerAngle.rpcCameraEulerAngle
        rpcCaptureInfo.timeUtcUs = timeUTC
        rpcCaptureInfo.isSuccess = isSuccess
        rpcCaptureInfo.index = Int32(index)
        rpcCaptureInfo.fileURL = fileURL
        
        return rpcCaptureInfo
    }
    
    internal static func translateFromRPC(_ rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo) -> CaptureInfo {
        let position = Position(latitudeDeg: rpcCaptureInfo.position.latitudeDeg, longitudeDeg: rpcCaptureInfo.position.longitudeDeg, absoluteAltitudeM: rpcCaptureInfo.position.absoluteAltitudeM, relativeAltitudeM: rpcCaptureInfo.position.relativeAltitudeM)
        return CaptureInfo(position: position,
                           attitudeQuaternion: Quaternion.translateFromRPC(rpcCaptureInfo.attitudeQuaternion),
                           attitudeEulerAngle: EulerAngle.translateFromRPC(rpcCaptureInfo.attitudeEulerAngle),
                           timeUTC: rpcCaptureInfo.timeUtcUs,
                           isSuccess: rpcCaptureInfo.isSuccess,
                           index: rpcCaptureInfo.index,
                           fileURL: rpcCaptureInfo.fileURL)
    }
    
    public static func == (lhs: CaptureInfo, rhs: CaptureInfo) -> Bool {
        return lhs.position == rhs.position
            && lhs.attitudeQuaternion == rhs.attitudeQuaternion
            && lhs.attitudeEulerAngle == rhs.attitudeEulerAngle
            && lhs.timeUTC == rhs.timeUTC
            && lhs.isSuccess == rhs.isSuccess
            && lhs.index == rhs.index
            && lhs.fileURL == rhs.fileURL
    }
}

/**
 Type for video stream settings.
 */
public struct VideoStreamSettings: Equatable {
    /// Frames per second.
    public let frameRateHz: Float
    /// Horizontal resolution in pixels.
    public let horizontalResolutionPix: Int
    /// Vertical resolution in pixels.
    public let verticalResolutionPix: Int
    /// Bit rate in bits per second.
    public let bitRateBS: Int
    /// Video image rotation clockwise (0-359 degrees).
    public let rotationDegree: Int
    /// Video stream URI.
    public let uri: String
    
    /**
     Initialize `VideoStreamSettings`.
     
     - Parameters:
       - frameRateHz: Frames per second.
       - horizontalResolutionPix: Horizontal resolution in pixels.
       - verticalResolutionPix: Vertical resolution in pixels.
       - bitRateBS: Bit rate in bits per second.
       - rotationDegree: Video image rotation clockwise (0-359 degrees).
       - uri: Video stream URI.
     */
    public init(frameRateHz: Float, horizontalResolutionPix: UInt32, verticalResolutionPix: UInt32, bitRateBS: UInt32, rotationDegree: UInt32, uri: String) {
        self.frameRateHz = frameRateHz
        self.horizontalResolutionPix = Int(horizontalResolutionPix)
        self.verticalResolutionPix = Int(verticalResolutionPix)
        self.bitRateBS = Int(bitRateBS)
        self.rotationDegree = Int(rotationDegree)
        self.uri = uri
    }
    
    internal var rpcVideoStreamSettings: DronecodeSdk_Rpc_Camera_VideoStreamSettings {
        var rpcVideoStreamSettings = DronecodeSdk_Rpc_Camera_VideoStreamSettings()
        
        rpcVideoStreamSettings.frameRateHz = frameRateHz
        rpcVideoStreamSettings.horizontalResolutionPix = UInt32(horizontalResolutionPix)
        rpcVideoStreamSettings.verticalResolutionPix = UInt32(verticalResolutionPix)
        rpcVideoStreamSettings.bitRateBS = UInt32(bitRateBS)
        rpcVideoStreamSettings.rotationDeg = UInt32(rotationDegree)
        rpcVideoStreamSettings.uri = uri
        
        return rpcVideoStreamSettings
    }
    
    internal static func translateFromRPC(_ rpcVideoStreamSettings: DronecodeSdk_Rpc_Camera_VideoStreamSettings) -> VideoStreamSettings {
        return VideoStreamSettings(frameRateHz: rpcVideoStreamSettings.frameRateHz, horizontalResolutionPix: rpcVideoStreamSettings.horizontalResolutionPix, verticalResolutionPix: rpcVideoStreamSettings.verticalResolutionPix, bitRateBS: rpcVideoStreamSettings.bitRateBS, rotationDegree: rpcVideoStreamSettings.rotationDeg, uri: rpcVideoStreamSettings.uri)
    }
    
    public static func == (lhs: VideoStreamSettings, rhs: VideoStreamSettings) -> Bool {
        return lhs.frameRateHz == rhs.frameRateHz
            && lhs.horizontalResolutionPix == rhs.horizontalResolutionPix
            && lhs.verticalResolutionPix == rhs.verticalResolutionPix
            && lhs.bitRateBS == rhs.bitRateBS
            && lhs.rotationDegree == rhs.rotationDegree
            && lhs.uri == rhs.uri
    }
}

/**
 Video stream information.
 */
public struct VideoStreamInfo: Equatable {
    /// Video stream settings.
    public let videoStreamSettings: VideoStreamSettings
    /// Video stream status.
    public let videoStreamStatus: VideoStreamStatus
    
    /**
     Initialize `VideoStreamInfo`.
     
     - Parameters:
       - videoStreamSettings: Video stream settings.
       - videoStreamStatus: Video stream status.
     */
    public init(videoStreamSettings: VideoStreamSettings, videoStreamStatus: VideoStreamStatus) {
        self.videoStreamSettings = videoStreamSettings
        self.videoStreamStatus = videoStreamStatus
    }
    
    internal var rpcVideoStreamInfo: DronecodeSdk_Rpc_Camera_VideoStreamInfo {
        var rpcVideoStreamInfo = DronecodeSdk_Rpc_Camera_VideoStreamInfo()
        
        rpcVideoStreamInfo.videoStreamSettings = videoStreamSettings.rpcVideoStreamSettings
        rpcVideoStreamInfo.videoStreamStatus = videoStreamStatus.rpcVideoStreamStatus
        
        return rpcVideoStreamInfo
    }
    
    internal static func translateFromRPC(_ rpcVideoStreamInfo: DronecodeSdk_Rpc_Camera_VideoStreamInfo) -> VideoStreamInfo {
        return VideoStreamInfo(videoStreamSettings: VideoStreamSettings.translateFromRPC(rpcVideoStreamInfo.videoStreamSettings),
                               videoStreamStatus: VideoStreamStatus.translateFromRPC(rpcVideoStreamInfo.videoStreamStatus))
    }
    
    public static func == (lhs: VideoStreamInfo, rhs: VideoStreamInfo) -> Bool {
        return lhs.videoStreamSettings == rhs.videoStreamSettings
            && lhs.videoStreamStatus == rhs.videoStreamStatus
    }
}

/**
 Video stream status.
 */
public enum VideoStreamStatus {
    /// Not running.
    case notRunning
    /// In Progress.
    case inProgress
    /// Unknown.
    case unknown
    
    internal var rpcVideoStreamStatus: DronecodeSdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus {
        switch self {
        case .inProgress:
            return .inProgress
        case .notRunning:
            return .notRunning
        default:
            return .UNRECOGNIZED(self.hashValue)
        }
    }
    
    internal static func translateFromRPC(_ rpcVideoStreamStatus: DronecodeSdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus) -> VideoStreamStatus {
        switch rpcVideoStreamStatus {
        case .inProgress:
            return .inProgress
        case .notRunning:
            return .notRunning
        default:
            return .unknown
        }
    }
}

/**
 Information about camera status.
 */
public struct CameraStatus: Equatable {
    /// true if video capture is currently running.
    public let videoOn: Bool
    /// Elapsed time since starting a video recording in seconds.
    public let recordingTimeS: Float
    /// true if video timelapse is currently active.
    public let photoIntervalOn: Bool
    /// Current folder name where media is saved.
    public let mediaFolderName: String
    /// Used storage in MiB.
    public let usedStorageMib: Float
    /// Available storage in MiB.
    public let availableStorageMib: Float
    /// Total storage in MiB.
    public let totalStorageMib: Float
    /// Storage status.
    public let storageStatus: StorageStatus
    
    /**
     Initialize camera status.
     
     - Parameters:
     - videoOn: true if video capture is currently running.
     - recordingTimeS: Elapsed time since starting a video recording in seconds.
     - photoIntervalOn: true if video timelapse is currently active.
     - mediaFolderName: Current folder name where media is saved.
     - usedStorageMib: Used storage in MiB.
     - availableStorageMib: Available storage in MiB.
     - totalStorageMib: Total storage in MiB.
     - storageStatus: Storage status.
     */
    public init(videoOn: Bool, recordingTimeS: Float, photoIntervalOn: Bool, mediaFolderName: String, usedStorageMib: Float, availableStorageMib: Float, totalStorageMib: Float, storageStatus: StorageStatus) {
        self.videoOn = videoOn
        self.recordingTimeS = recordingTimeS
        self.photoIntervalOn = photoIntervalOn
        self.mediaFolderName = mediaFolderName
        self.usedStorageMib = usedStorageMib
        self.availableStorageMib = availableStorageMib
        self.totalStorageMib = totalStorageMib
        self.storageStatus = storageStatus
    }
    
    internal var rpcCameraStatus: DronecodeSdk_Rpc_Camera_CameraStatus {
        var rpcCameraStatus = DronecodeSdk_Rpc_Camera_CameraStatus()
        
        rpcCameraStatus.videoOn = videoOn
        rpcCameraStatus.recordingTimeS = recordingTimeS
        rpcCameraStatus.photoIntervalOn = photoIntervalOn
        rpcCameraStatus.mediaFolderName = mediaFolderName
        rpcCameraStatus.usedStorageMib = usedStorageMib
        rpcCameraStatus.availableStorageMib = availableStorageMib
        rpcCameraStatus.totalStorageMib = totalStorageMib
        rpcCameraStatus.storageStatus = storageStatus.rpcStorageStatus
        
        return rpcCameraStatus
    }
    
    internal static func translateFromRPC(_ rpcCameraStatus: DronecodeSdk_Rpc_Camera_CameraStatus) -> CameraStatus {
        return CameraStatus(videoOn: rpcCameraStatus.videoOn,
                            recordingTimeS: rpcCameraStatus.recordingTimeS,
                            photoIntervalOn: rpcCameraStatus.photoIntervalOn,
                            mediaFolderName: rpcCameraStatus.mediaFolderName,
                            usedStorageMib: rpcCameraStatus.usedStorageMib,
                            availableStorageMib: rpcCameraStatus.availableStorageMib,
                            totalStorageMib: rpcCameraStatus.totalStorageMib,
                            storageStatus: StorageStatus.translateFromRPC(rpcCameraStatus.storageStatus))
    }
    
    public static func == (lhs: CameraStatus, rhs: CameraStatus) -> Bool {
        return lhs.videoOn == rhs.videoOn
            && lhs.recordingTimeS == rhs.recordingTimeS
            && lhs.photoIntervalOn == rhs.photoIntervalOn
            && lhs.mediaFolderName == lhs.mediaFolderName
            && lhs.usedStorageMib == rhs.usedStorageMib
            && lhs.availableStorageMib == rhs.availableStorageMib
            && lhs.totalStorageMib == rhs.totalStorageMib
            && lhs.storageStatus == rhs.storageStatus
    }
}

/**
 Storage status type.
 */
public enum StorageStatus {
    /// Storage status not available.
    case notAvailable
    /// Storage is not formatted (has no recognized file system).
    case unformatted
    /// Storage is formatted (has recognized a file system).
    case formatted
    
    internal var rpcStorageStatus: DronecodeSdk_Rpc_Camera_CameraStatus.StorageStatus {
        switch self {
        case .notAvailable:
            return .notAvailable
        case .unformatted:
            return .unformatted
        case .formatted:
            return .formatted
        }
    }
    
    internal static func translateFromRPC(_ rpcStorageStatus: DronecodeSdk_Rpc_Camera_CameraStatus.StorageStatus) -> StorageStatus {
        switch rpcStorageStatus {
        case .notAvailable:
            return .notAvailable
        case .unformatted:
            return .unformatted
        case .formatted:
            return .formatted
        case .UNRECOGNIZED(_):
            return .notAvailable
        }
    }
}

/**
 Type to represent a setting with a selected option.
 */
public struct Setting: Equatable {
    /// Name of the setting (machine readable).
    public let id: String
    /// Description of the setting (human readable).
    public let description: String?
    /// Selected option.
    public let option: Option
    
    /**
     Initialize setting.
 
     - Parameters:
       - id: Name of the setting.
       - description: Description of the setting.
       - option: Selected option.
     */
    public init(id: String, description: String? = nil, option: Option) {
        self.id = id
        self.description = description
        self.option = option
    }
    
    internal static func translateFromRPC(_ rpcSetting: DronecodeSdk_Rpc_Camera_Setting) -> Setting {
        return Setting(id: rpcSetting.settingID,
                       description: rpcSetting.settingDescription,
                       option: Option.translateFromRPC(rpcSetting.option))
    }
    
    internal var rpcSetting: DronecodeSdk_Rpc_Camera_Setting {
        var rpcSetting = DronecodeSdk_Rpc_Camera_Setting()
        
        rpcSetting.settingID = id
        
        if let description = description {
            rpcSetting.settingDescription = description
        }
        
        rpcSetting.option = option.rpcOption
        
        return rpcSetting
    }
    
    public static func == (lhs: Setting, rhs: Setting) -> Bool {
        return lhs.id == rhs.id
//            && lhs.description == rhs.description
            && lhs.option == rhs.option
    }
}

/**
 Type to represent a setting option.
 
 This can be e.g. a color mode option such as "enhanced" or a shutter speed value like "1/50".
 */
public struct Option: Equatable {
    /// Name of the option (machine readable).
    public let id: String
    /// Description of the description (human readable).
    public let description: String?
    
    /**
     Initialize a setting option from `String`.
     
     - Parameters:
       - id: Name of the option.
       - description: Description of the option.
     */
    public init(id: String, description: String? = nil) {
        self.id = id
        self.description = description
    }
    
    /**
     Initialize a setting option from `AnyObject`.
     
     - Parameters:
     - id: Name of the option.
     - description: Description of the option.
     */
    public init(id: AnyObject, description: AnyObject? = nil) {
        self.id = String(describing: id)
        self.description = String(describing: description)
    }
    
    internal static func translateFromRPC(_ rpcOption: DronecodeSdk_Rpc_Camera_Option) -> Option {
        return Option(id: rpcOption.optionID,
                      description: rpcOption.optionDescription)
    }
    
    internal var rpcOption: DronecodeSdk_Rpc_Camera_Option {
        var rpcOption = DronecodeSdk_Rpc_Camera_Option()
        rpcOption.optionID = id
        
        if let description = description {
            rpcOption.optionDescription = description
        }

        return rpcOption
    }
    
    public static func == (lhs: Option, rhs: Option) -> Bool {
        return lhs.id == rhs.id
        && lhs.description == rhs.description
    }
}

/**
 Type to represent a setting with a list of options to choose from.
 */
public struct SettingOptions: Equatable {
    /// Name of the setting (machine readable).
    public let settingId: String
    /// Description of the setting (human readable).
    public let settingDescription: String?
    /// Array of options.
    public let options: [Option]
    
    /**
     Initialize `SettingOptions`.
     
     - Parameters:
       - settingId: Name of the setting.
       - settingDescription: Description of the setting.
       - options: Array of options.
     */
    public init(settingId: String, settingDescription: String? = nil, options: [Option]) {
        self.settingId = settingId
        self.options = options
        self.settingDescription = settingDescription
    }
    
    internal var rpcSettingOptions: DronecodeSdk_Rpc_Camera_SettingOptions {
        var rpcSettingOptions = DronecodeSdk_Rpc_Camera_SettingOptions()
        
        rpcSettingOptions.settingID = settingId
        
        if let settingDescription = settingDescription {
            rpcSettingOptions.settingDescription = settingDescription
        }
        
        rpcSettingOptions.options = options.map { $0.rpcOption }
        
        return rpcSettingOptions
    }
    
    internal static func translateFromRPC(_ rpcCameraSettingOptions: DronecodeSdk_Rpc_Camera_SettingOptions) -> SettingOptions {
        return SettingOptions(settingId: rpcCameraSettingOptions.settingID,
                              settingDescription: rpcCameraSettingOptions.settingDescription,
                              options: rpcCameraSettingOptions.options.map { Option.translateFromRPC($0) })
    }
    
    public static func == (lhs: SettingOptions, rhs: SettingOptions) -> Bool {
        return lhs.settingId == rhs.settingId
            && lhs.options == rhs.options
    }
}

/**
 The Camera class can be used to manage cameras that implement the
 MAVLink Camera Protocol: https://mavlink.io/en/protocol/camera.html.
 
 Currently only a single camera is supported.
 When multiple cameras are supported the plugin will need to be instantiated separately for every camera.
 */
public class Camera {
    let service: DronecodeSdk_Rpc_Camera_CameraServiceService
    let scheduler: SchedulerType
    
    /**
     Subscribe to camera mode.
     
     - Returns: a stream of `CameraMode`.
     */
    public lazy var cameraModeObservable: Observable<CameraMode> = createCameraModeObservable()
    
    /**
     Subscribe to video stream info.
     
     - Returns: a stream of `VideoStreamInfo`.
     */
    public lazy var videoStreamInfoObservable: Observable<VideoStreamInfo> = createVideoStreamInfoObservable()
    
    /**
     Subscribe to capture info info.
     
     - Returns: a stream of `CaptureInfo`.
     */
    public lazy var captureInfoObservable: Observable<CaptureInfo> = createCaptureInfoObservable()
    
    /**
     Subscribe to camera status.
     
     - Returns: a stream of camera status.
     */
    public lazy var cameraStatusObservable: Observable<CameraStatus> = createCameraStatusObservable()
    
    /**
     Subscribe to currently selected settings.
     
     - Returns: a stream of a settings array.
     */
    public lazy var currentSettingsObservable: Observable<[Setting]> = createCurrentSettingsObservable()
    
    /**
     Subscribe to all possible setting options.
     
     - Returns: a stream of a setting options array.
     */
    public lazy var possibleSettingOptionsObservable: Observable<[SettingOptions]> = createPossibleSettingOptionsObservable()
    
    /**
     Helper function to connect `Camera` object to the backend.
     
     - Parameter address: Network address of backend (IP or "localhost").
     - Parameter port: Port number of backend.
     */
    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Camera_CameraServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        self.init(service: service, scheduler: scheduler)
    }
    
    init(service: DronecodeSdk_Rpc_Camera_CameraServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
    /**
     Take photo
     
     This takes one photo.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func takePhoto() -> Completable {        
        return Completable.create { completable in
            let takePhotoRequest = DronecodeSdk_Rpc_Camera_TakePhotoRequest()
            
            do {
                let takePhotoResponse = try self.service.takePhoto(takePhotoRequest)
                if takePhotoResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot take photo: \(takePhotoResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Start photo interval.
     
     Starts a photo timelapse with a given interval.
     
     - Parameter interval: The interval between photos in seconds.
     - Returns: a `Completable` indicating success or an error.
     */
    public func startPhotoInteval(interval: Float) -> Completable {
        return Completable.create { completable in
            var startPhotoIntervalRequest = DronecodeSdk_Rpc_Camera_StartPhotoIntervalRequest()
            startPhotoIntervalRequest.intervalS = interval
            
            do {
                let startPhotoIntevalResponse = try self.service.startPhotoInterval(startPhotoIntervalRequest)
                if startPhotoIntevalResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot start photo interval: \(startPhotoIntevalResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Stop photo interval.
     
     Stops a photo timelapse, previously started with `startPhotoInteval`.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func stopPhotoInterval() -> Completable {
        return Completable.create { completable in
            let stopPhotoIntervalRequest = DronecodeSdk_Rpc_Camera_StopPhotoIntervalRequest()
            
            do {
                let stopPhotoIntervalResponse = try self.service.stopPhotoInterval(stopPhotoIntervalRequest)
                if stopPhotoIntervalResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot stop photo interval: \(stopPhotoIntervalResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Start video capture.
     
     This starts a video recording.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func startVideo() -> Completable {
        return Completable.create { completable in
            let startVideoRequest = DronecodeSdk_Rpc_Camera_StartVideoRequest()
            
            do {
                let startVideoResponse = try self.service.startVideo(startVideoRequest)
                if startVideoResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot start video: \(startVideoResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Stop video capture.
     
     This stops a video recording, previously started with `startVideo`.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func stopVideo() -> Completable {
        return Completable.create { completable in
            let stopVideoRequest = DronecodeSdk_Rpc_Camera_StopVideoRequest()
            
            do {
                let stopVideoResponse = try self.service.stopVideo(stopVideoRequest)
                if stopVideoResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot stop video: \(stopVideoResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Starts video streaming.
     
     Sends a request to start video streaming.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func startVideoStreaming() -> Completable {
        return Completable.create { completable in
            let startVideoStreamingRequest = DronecodeSdk_Rpc_Camera_StartVideoStreamingRequest()
            
            do {
                let startVideoStreamingResponse = try self.service.startVideoStreaming(startVideoStreamingRequest)
                if startVideoStreamingResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot start video streaming: \(startVideoStreamingResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Stop the current video streaming
     
     Sends a request to stop ongoing video streaming.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func stopVideoStreaming() -> Completable {
        return Completable.create { completable in
            let stopVideoSreamingRequest = DronecodeSdk_Rpc_Camera_StopVideoStreamingRequest()
            
            do {
                let stopVideoStreamingResponse = try self.service.stopVideoStreaming(stopVideoSreamingRequest)
                if stopVideoStreamingResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot stop video streaming: \(stopVideoStreamingResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Setter for camera mode.
     
     - Parameter mode: `CameraMode` to set.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func setMode(mode: CameraMode) -> Completable {
        return Completable.create { completable in
            var setCameraModeRequest = DronecodeSdk_Rpc_Camera_SetModeRequest()
            setCameraModeRequest.cameraMode = mode.rpcCameraMode
            
            do {
                let setCameraModeResponse = try self.service.setMode(setCameraModeRequest)
                if setCameraModeResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot set camera mode: \(setCameraModeResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    private func createCameraModeObservable() -> Observable<CameraMode> {
        return Observable.create { observer in
            let cameraModeRequest = DronecodeSdk_Rpc_Camera_SubscribeModeRequest()
            
            do {
                let call = try self.service.subscribeMode(cameraModeRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeCameraModeReceiver").async {
                    do {
                        while let rpcCameraMode = try call.receive()?.cameraMode {
                            let cameraMode = CameraMode.translateFromRPC(rpcCameraMode)
                            observer.onNext(cameraMode)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to camera mode stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    /**
     Sets video stream settings.
     
     - Parameter settings: video stream settings to set.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func setVideoStreamSettings(settings: VideoStreamSettings) -> Completable {
        return Completable.create { completable in
            var setVideoStreamSettingsRequest = DronecodeSdk_Rpc_Camera_SetVideoStreamSettingsRequest()
            setVideoStreamSettingsRequest.videoStreamSettings = settings.rpcVideoStreamSettings
            
            do {
                let _ = try self.service.setVideoStreamSettings(setVideoStreamSettingsRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    private func createVideoStreamInfoObservable() -> Observable<VideoStreamInfo> {
        return Observable.create { observer in
            let videoStreamInfoRequest = DronecodeSdk_Rpc_Camera_SubscribeVideoStreamInfoRequest()
            
            do {
                let call = try self.service.subscribeVideoStreamInfo(videoStreamInfoRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeVideoStreamInfoReceiver").async {
                    do {
                        while let rpcVideoStreamInfo = try call.receive()?.videoStreamInfo {
                            let videoStreamInfo = VideoStreamInfo.translateFromRPC(rpcVideoStreamInfo)
                            observer.onNext(videoStreamInfo)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to video stream info stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(self.scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createCaptureInfoObservable() -> Observable<CaptureInfo> {
        return Observable.create { observer in
            let captureInfoRequest = DronecodeSdk_Rpc_Camera_SubscribeCaptureInfoRequest()
            
            do {
                let call = try self.service.subscribeCaptureInfo(captureInfoRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeCaptureInfoReceiver").async {
                    do {
                        while let rpcCaptureInfo = try call.receive()?.captureInfo {
                            let captureInfo = CaptureInfo.translateFromRPC(rpcCaptureInfo)
                            observer.onNext(captureInfo)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to capture info stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createCameraStatusObservable() -> Observable<CameraStatus> {
        return Observable.create { observer in
            let cameraStatusRequest = DronecodeSdk_Rpc_Camera_SubscribeCameraStatusRequest()
            
            do {
                let call = try self.service.subscribeCameraStatus(cameraStatusRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeCameraStatusReceiver").async {
                    do {
                        while let rpcCameraStatus = try call.receive()?.cameraStatus {
                            let cameraStatus = CameraStatus.translateFromRPC(rpcCameraStatus)
                            observer.onNext(cameraStatus)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to camera statrus stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createCurrentSettingsObservable() -> Observable<[Setting]> {
        return Observable.create { observer in
            let currentSettingsRequest = DronecodeSdk_Rpc_Camera_SubscribeCurrentSettingsRequest()
            
            do {
                let call = try self.service.subscribeCurrentSettings(currentSettingsRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeCameraCurrentSettingsReceiver").async {
                    do {
                        while let rpcCurrentSettings = try call.receive()?.currentSettings {
                            let currentSettings = rpcCurrentSettings.map { Setting.translateFromRPC($0) }
                            observer.onNext(currentSettings)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to camera current settings stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createPossibleSettingOptionsObservable() -> Observable<[SettingOptions]> {
        return Observable.create { observer in
            let possibleSettingOptionsRequest = DronecodeSdk_Rpc_Camera_SubscribePossibleSettingOptionsRequest()
            
            do {
                let call = try self.service.subscribePossibleSettingOptions(possibleSettingOptionsRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeCameraPossibleSettingsReceiver").async {
                    do {
                        while let rpcSettingOptions = try call.receive()?.settingOptions {
                            let possibleSettingOptions = rpcSettingOptions.map { SettingOptions.translateFromRPC($0) }
                            observer.onNext(possibleSettingOptions)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to camera settings options stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    /**
     Set an option of a setting.
     
     - Parameter setting: Setting with option to set.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func setSetting(setting: Setting) -> Completable {
        return Completable.create { completable in
            var setSettingRequest = DronecodeSdk_Rpc_Camera_SetSettingRequest()
            setSettingRequest.setting = setting.rpcSetting
            
            do {
                let setSettingResponse = try self.service.setSetting(setSettingRequest)
                if setSettingResponse.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot set setting: \(setSettingResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
}
