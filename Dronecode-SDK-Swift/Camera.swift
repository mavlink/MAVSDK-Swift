import Foundation
import SwiftGRPC
import RxSwift

// MARK: - CameraResult
public struct CameraResult: Equatable {
    public let result: Result
    public let resultString: String
    
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

// MARK: - Result
public enum Result {
    case unknown
    case success
    case inProgress
    case busy
    case denied
    case error
    case timeout
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

// MARK: - CameraMode
public enum CameraMode {
    case unknown
    case photo
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

// MARK: - CaptureInfo
public struct CaptureInfo: Equatable {
    public let position: Position
    public let quaternion: Quaternion
    public let eulerAngle: EulerAngle
    public let timeUTC: UInt64
    public let isSuccess: Bool
    public let index: Int
    public let fileURL: String
    
    public init(position: Position, quaternion: Quaternion, eulerAngle: EulerAngle, timeUTC: UInt64, isSuccess: Bool, index: Int32, fileURL: String) {
        self.position = position
        self.quaternion = quaternion
        self.eulerAngle = eulerAngle
        self.timeUTC = timeUTC
        self.isSuccess = isSuccess
        self.index = Int(index)
        self.fileURL = fileURL
    }
    
    internal var rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo {
        var rpcCaptureInfo = DronecodeSdk_Rpc_Camera_CaptureInfo()
        
        rpcCaptureInfo.position = position.rpcCameraPosition
        rpcCaptureInfo.attitudeQuaternion = quaternion.rpcCameraQuaternion
        rpcCaptureInfo.attitudeEulerAngle = eulerAngle.rpcCameraEulerAngle
        rpcCaptureInfo.timeUtcUs = timeUTC
        rpcCaptureInfo.isSuccess = isSuccess
        rpcCaptureInfo.index = Int32(index)
        rpcCaptureInfo.fileURL = fileURL
        
        return rpcCaptureInfo
    }
    
    internal static func translateFromRPC(_ rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo) -> CaptureInfo {
        let position = Position(latitudeDeg: rpcCaptureInfo.position.latitudeDeg, longitudeDeg: rpcCaptureInfo.position.longitudeDeg, absoluteAltitudeM: rpcCaptureInfo.position.absoluteAltitudeM, relativeAltitudeM: rpcCaptureInfo.position.relativeAltitudeM)
        return CaptureInfo(position: position,
                           quaternion: Quaternion.translateFromRPC(rpcCaptureInfo.attitudeQuaternion),
                           eulerAngle: EulerAngle.translateFromRPC(rpcCaptureInfo.attitudeEulerAngle),
                           timeUTC: rpcCaptureInfo.timeUtcUs,
                           isSuccess: rpcCaptureInfo.isSuccess,
                           index: rpcCaptureInfo.index,
                           fileURL: rpcCaptureInfo.fileURL)
    }
    
    public static func == (lhs: CaptureInfo, rhs: CaptureInfo) -> Bool {
        return lhs.position == rhs.position
            && lhs.quaternion == rhs.quaternion
            && lhs.eulerAngle == rhs.eulerAngle
            && lhs.timeUTC == rhs.timeUTC
            && lhs.isSuccess == rhs.isSuccess
            && lhs.index == rhs.index
            && lhs.fileURL == rhs.fileURL
    }
}

// MARK: - Position

// MARK: - Quaternion

// MARK: - VideoStreamSettings
public struct VideoStreamSettings: Equatable {
    public let frameRateHz: Float
    public let horizontalResolutionPix: Int
    public let verticalResolutionPix: Int
    public let bitRateBS: Int
    public let rotationDegree: Int
    public let uri: String
    
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


// MARK: - VideoStreamInfo
public struct VideoStreamInfo: Equatable {
    public let videoStreamSettings: VideoStreamSettings
    public let videoStreamStatus: VideoStreamStatus
    
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

// MARK: - VideoStreamStatus
public enum VideoStreamStatus {
    case notRunning
    case inProgress
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

// MARK: - CameraStatus
public struct CameraStatus: Equatable {
    public let videoOn: Bool
    public let recordingTimeS: Float
    public let photoIntervalOn: Bool
    public let mediaFolderName: String
    public let usedStorageMib: Float
    public let availableStorageMib: Float
    public let totalStorageMib: Float
    public let storageStatus: StorageStatus
    
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

// MARK: - StorageStatus
public enum StorageStatus {
    case notAvailable
    case unformatted
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

// MARK: - Setting
public struct Setting: Equatable {
    public let id: String
    public let description: String?
    public let option: Option
    
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

// MARK: - Option
public struct Option: Equatable {
    public let id: String
    public let description: String?
    
    public init(id: String, description: String? = nil) {
        self.id = id
        self.description = description
    }
    
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

// MARK: - SettingOptions
public struct SettingOptions: Equatable {
    public let settingId: String
    public let settingDescription: String?
    public let options: [Option]
    
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

public class Camera {
    let service: DronecodeSdk_Rpc_Camera_CameraServiceService
    let scheduler: SchedulerType
    
    public lazy var cameraModeObservable: Observable<CameraMode> = createCameraModeObservable()
    public lazy var videoStreamInfoObservable: Observable<VideoStreamInfo> = createVideoStreamInfoObservable()
    public lazy var captureInfoObservable: Observable<CaptureInfo> = createCaptureInfoObservable()
    public lazy var cameraStatusObservable: Observable<CameraStatus> = createCameraStatusObservable()
    public lazy var currentSettingsObservable: Observable<[Setting]> = createCurrentSettingsObservable()
    public lazy var possibleSettingOptionsObservable: Observable<[SettingOptions]> = createPossibleSettingOptionsObservable()
    
    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Camera_CameraServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        self.init(service: service, scheduler: scheduler)
    }
    
    init(service: DronecodeSdk_Rpc_Camera_CameraServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
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
                let call = try self.service.subscribeMode(cameraModeRequest, completion: nil)
                while let response = try call.receive() {
                    let cameraMode = CameraMode.translateFromRPC(response.cameraMode)
                    observer.onNext(cameraMode)
                }
            } catch {
                observer.onError("Failed to subscribe to camera mode stream. \(error)")
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
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
                let call = try self.service.subscribeVideoStreamInfo(videoStreamInfoRequest, completion: nil)
                while let response = try call.receive() {
                    let videoStreamInfo = VideoStreamInfo.translateFromRPC(response.videoStreamInfo)
                    observer.onNext(videoStreamInfo)
                }
            } catch {
                observer.onError("Failed to subscribe to video stream info. \(error)")
            }
            
            return Disposables.create()
        }
        .subscribeOn(self.scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func createCaptureInfoObservable() -> Observable<CaptureInfo> {
        return Observable.create { observer in
            let captureInfoRequest = DronecodeSdk_Rpc_Camera_SubscribeCaptureInfoRequest()
            
            do {
                let call = try self.service.subscribeCaptureInfo(captureInfoRequest, completion: nil)
                while let response = try call.receive() {
                    let captureInfo = CaptureInfo.translateFromRPC(response.captureInfo)
                    observer.onNext(captureInfo)
                }
            } catch {
                observer.onError("Failed to subscribe to capture info. \(error)")
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func createCameraStatusObservable() -> Observable<CameraStatus> {
        return Observable.create { observer in
            let cameraStatusRequest = DronecodeSdk_Rpc_Camera_SubscribeCameraStatusRequest()
            
            do {
                let call = try self.service.subscribeCameraStatus(cameraStatusRequest, completion: nil)
                while let response = try call.receive() {
                    let cameraStatus = CameraStatus.translateFromRPC(response.cameraStatus)
                    observer.onNext(cameraStatus)
                }
            } catch {
                observer.onError("Failed to subscribe to camera status. \(error)")
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func createCurrentSettingsObservable() -> Observable<[Setting]> {
        return Observable.create { observer in
            let currentSettingsRequest = DronecodeSdk_Rpc_Camera_SubscribeCurrentSettingsRequest()
            
            do {
                let call = try self.service.subscribeCurrentSettings(currentSettingsRequest, completion: nil)
                while let response = try call.receive() {
                    let currentSettings = response.currentSettings.map { Setting.translateFromRPC($0) }
                    observer.onNext(currentSettings)
                }
            } catch {
                observer.onError("Failed to subscribe to current settings. \(error)")
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func createPossibleSettingOptionsObservable() -> Observable<[SettingOptions]> {
        return Observable.create { observer in
            let possibleSettingOptionsRequest = DronecodeSdk_Rpc_Camera_SubscribePossibleSettingOptionsRequest()
            
            do {
                let call = try self.service.subscribePossibleSettingOptions(possibleSettingOptionsRequest, completion: nil)
                while let response = try call.receive() {
                    let possibleSettingOptions = response.settingOptions.map { SettingOptions.translateFromRPC($0) }
                    observer.onNext(possibleSettingOptions)
                }
            } catch {
                observer.onError("Failed to subscribe to possible setting options. \(error)")
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
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
