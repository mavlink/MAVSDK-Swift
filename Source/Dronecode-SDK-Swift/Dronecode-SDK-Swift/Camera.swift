import Foundation
import SwiftGRPC
import RxSwift


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

public enum VideoStreamInfo {
    case notRunning
    case inProgress
    case unknown
    
    internal var rpcVideoStreamInfo: DronecodeSdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus {
        switch self {
        case .inProgress:
            return .inProgress
        case .notRunning:
            return .notRunning
        default:
            return .UNRECOGNIZED(self.hashValue)
        }
    }
    
    internal static func translateFromRPC(_ rpcVideoStreamInfo: DronecodeSdk_Rpc_Camera_VideoStreamInfo) -> VideoStreamInfo {
        switch rpcVideoStreamInfo.videoStreamStatus {
        case .inProgress:
            return .inProgress
        case .notRunning:
            return .notRunning
        default:
            return .unknown
        }
    }
}

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

public struct CaptureInfo: Equatable {
    public let position: Position
    public let quaternion: Quaternion
    public let timeUTC: UInt64
    public let isSuccess: Bool
    public let index: Int
    public let fileURL: String
    
    public init(position: Position, quaternion: Quaternion, timeUTC: UInt64, isSuccess: Bool, index: Int32, fileURL: String) {
        self.position = position
        self.quaternion = quaternion
        self.timeUTC = timeUTC
        self.isSuccess = isSuccess
        self.index = Int(index)
        self.fileURL = fileURL
    }
    
    internal var rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo {
        var rpcCaptureInfo = DronecodeSdk_Rpc_Camera_CaptureInfo()
        
        rpcCaptureInfo.position = position.rpcCameraPosition
        rpcCaptureInfo.quaternion = quaternion.rpcCameraQuaternion
        rpcCaptureInfo.timeUtcUs = timeUTC
        rpcCaptureInfo.isSuccess = isSuccess
        rpcCaptureInfo.index = Int32(index)
        rpcCaptureInfo.fileURL = fileURL
        
        return rpcCaptureInfo
    }
    
    internal static func translateFromRPC(_ rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo) -> CaptureInfo {
        let position = Position(latitudeDeg: rpcCaptureInfo.position.latitudeDeg, longitudeDeg: rpcCaptureInfo.position.longitudeDeg, absoluteAltitudeM: rpcCaptureInfo.position.absoluteAltitudeM, relativeAltitudeM: rpcCaptureInfo.position.relativeAltitudeM)
        return CaptureInfo(position: position,
                           quaternion: Quaternion.translateFromRPC(rpcCaptureInfo.quaternion),
                           timeUTC: rpcCaptureInfo.timeUtcUs,
                           isSuccess: rpcCaptureInfo.isSuccess,
                           index: rpcCaptureInfo.index,
                           fileURL: rpcCaptureInfo.fileURL)
    }

    public static func == (lhs: CaptureInfo, rhs: CaptureInfo) -> Bool {
        return lhs.position == rhs.position
            && lhs.quaternion == rhs.quaternion
            && lhs.timeUTC == rhs.timeUTC
            && lhs.isSuccess == rhs.isSuccess
            && lhs.index == rhs.index
            && lhs.fileURL == rhs.fileURL
    }
}

public struct Setting: Equatable {
    public let id: String
    public let option: Option
    
    init(id: String, option: Option) {
        self.id = id
        self.option = option
    }
    
    internal static func translateFromRPC(_ rpcSetting: DronecodeSdk_Rpc_Camera_Setting) -> Setting {
        return Setting(id: rpcSetting.settingID, option: Option(id: rpcSetting.option.optionID))
    }
    
    internal var rpcSettings: DronecodeSdk_Rpc_Camera_Setting {
        var rpcSetting = DronecodeSdk_Rpc_Camera_Setting()
        
        rpcSetting.settingID = id
        rpcSetting.option = DronecodeSdk_Rpc_Camera_Option()
        rpcSetting.option.optionID = option.id
        
        return rpcSetting
    }
    
    public static func == (lhs: Setting, rhs: Setting) -> Bool {
        return lhs.id == rhs.id
        && lhs.option == rhs.option
    }
}

public struct Option: Equatable {
    public let id: String

    init(id: String) {
        self.id = id
    }

    internal static func translateFromRPC(_ rpcOption: DronecodeSdk_Rpc_Camera_Option) -> Option {
        return Option(id: rpcOption.optionID)
    }
    
    internal var rpcOption: DronecodeSdk_Rpc_Camera_Option {
        var rpcOption = DronecodeSdk_Rpc_Camera_Option()
        
        rpcOption.optionID = id

        return rpcOption
    }
    
    public static func == (lhs: Option, rhs: Option) -> Bool {
        return lhs.id == rhs.id
    }
}

public class Camera {
    let service: DronecodeSdk_Rpc_Camera_CameraServiceService
    let scheduler: SchedulerType

    public lazy var cameraModeObservable: Observable<CameraMode> = createCameraModeObservable()
    public lazy var videoStreamInfoObservable: Observable<VideoStreamInfo> = createVideoStreamInfoObservable()
    public lazy var captureInfoObservable: Observable<CaptureInfo> = createCaptureInfoObservable()
    
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
    }
    
    private func createCameraModeObservable() -> Observable<CameraMode> {
        return Observable.create { observer in
            let cameraModeRequest = DronecodeSdk_Rpc_Camera_SubscribeModeRequest()
            
            do {
                let call = try self.service.subscribeMode(cameraModeRequest, completion: nil)
                while let response = try? call.receive() {
                    let cameraMode = CameraMode.translateFromRPC(response!.cameraMode)
                    observer.onNext(cameraMode)
                }
            } catch {
                observer.onError("Failed to subscribe to camera mode stream. \(error)")
            }
            return Disposables.create()
        }
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
    }
    
    private func createVideoStreamInfoObservable() -> Observable<VideoStreamInfo> {
        return Observable.create { observer in
            let videoStreamInfoRequest = DronecodeSdk_Rpc_Camera_SubscribeVideoStreamInfoRequest()
            
            do {
                let call = try self.service.subscribeVideoStreamInfo(videoStreamInfoRequest, completion: nil)
                while let response = try? call.receive() {
                    let videoStreamInfo = VideoStreamInfo.translateFromRPC(response!.videoStreamInfo)
                    observer.onNext(videoStreamInfo)
                }
            } catch {
                observer.onError("Failed to subscribe to video stream info. \(error)")
            }
            
            return Disposables.create()
        }
    }

    public func createCaptureInfoObservable() -> Observable<CaptureInfo> {
        return Observable.create { observer in
            let captureInfoRequest = DronecodeSdk_Rpc_Camera_SubscribeCaptureInfoRequest()
            
            do {
                let call = try self.service.subscribeCaptureInfo(captureInfoRequest, completion: nil)
                while let response = try? call.receive() {
                    let captureInfo = CaptureInfo.translateFromRPC(response!.captureInfo)
                    observer.onNext(captureInfo)
                }
            } catch {
                observer.onError("Faile to subscribe to capture info. \(error)")
            }
            
            return Disposables.create()
        }
    }
}
