import Foundation
import SwiftGRPC
import RxSwift


public enum CameraMode {
    case unknown
    case photo
    case video
    
    internal var rpcCameraMode: Dronecore_Rpc_Camera_CameraMode {
        switch self {
        case .photo:
            return .photo
        case .video:
            return .video
        default:
            return .unknown
        }
    }
    
    internal static func translateFromRPC(_ rpcCameraMode: Dronecore_Rpc_Camera_CameraMode) -> CameraMode {
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
    
    internal var rpcVideoStreamInfo: Dronecore_Rpc_Camera_VideoStreamInfo.Status {
        switch self {
        case .inProgress:
            return .inProgress
        case .notRunning:
            return .notRunning
        default:
            return .UNRECOGNIZED(self.hashValue)
        }
    }
    
    internal static func translateFromRPC(_ rpcVideoStreamInfo: Dronecore_Rpc_Camera_VideoStreamInfo) -> VideoStreamInfo {
        switch rpcVideoStreamInfo.status {
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
    
    internal var rpcVideoStreamSettings: Dronecore_Rpc_Camera_VideoStreamSettings {
        var rpcVideoStreamSettings = Dronecore_Rpc_Camera_VideoStreamSettings()
        
        rpcVideoStreamSettings.frameRateHz = frameRateHz
        rpcVideoStreamSettings.horizontalResolutionPix = UInt32(horizontalResolutionPix)
        rpcVideoStreamSettings.verticalResolutionPix = UInt32(verticalResolutionPix)
        rpcVideoStreamSettings.bitRateBS = UInt32(bitRateBS)
        rpcVideoStreamSettings.rotationDeg = UInt32(rotationDegree)
        rpcVideoStreamSettings.uri = uri
        
        return rpcVideoStreamSettings
    }
    
    internal static func translateFromRPC(_ rpcVideoStreamSettings: Dronecore_Rpc_Camera_VideoStreamSettings) -> VideoStreamSettings {
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
    
    internal var rpcCaptureInfo: Dronecore_Rpc_Camera_CaptureInfo {
        var rpcCaptureInfo = Dronecore_Rpc_Camera_CaptureInfo()
        
        rpcCaptureInfo.position = position.rpcCameraPosition
        rpcCaptureInfo.quaternion = quaternion.rpcCameraQuaternion
        rpcCaptureInfo.timeUtcUs = timeUTC
        rpcCaptureInfo.isSuccess = isSuccess
        rpcCaptureInfo.index = Int32(index)
        rpcCaptureInfo.fileURL = fileURL
        
        return rpcCaptureInfo
    }
    
    internal static func translateFromRPC(_ rpcCaptureInfo: Dronecore_Rpc_Camera_CaptureInfo) -> CaptureInfo {
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
    public let description: String
    public let options: [Option]
    
    init(id: String, description: String, options: [Option]) {
        self.id = id
        self.description = description
        self.options = options
    }
    
    internal static func translateFromRPC(_ rpcSetting: Dronecore_Rpc_Camera_Setting) -> Setting {
        return Setting(id: rpcSetting.id, description: rpcSetting.description_p, options: rpcSetting.option.map{ Option.translateFromRPC($0) })
    }
    
    internal var rpcSettings: Dronecore_Rpc_Camera_Setting {
        var rpcSetting = Dronecore_Rpc_Camera_Setting()
        
        rpcSetting.id = id
        rpcSetting.description_p = description
        rpcSetting.option = options.map{ $0.rpcOption }
        
        return rpcSetting
    }
    
    public static func == (lhs: Setting, rhs: Setting) -> Bool {
        return lhs.id == rhs.id
        && lhs.description == rhs.description
        && lhs.options == rhs.options
    }
}

public struct Option: Equatable {
    public let id: String
    public let description: String
    public let possibleValue: [String]
    
    internal static func translateFromRPC(_ rpcOption: Dronecore_Rpc_Camera_Option) -> Option {
        return Option(id: rpcOption.id, description: rpcOption.description_p, possibleValue: rpcOption.possibleValue)
    }
    
    internal var rpcOption: Dronecore_Rpc_Camera_Option {
        var rpcOption = Dronecore_Rpc_Camera_Option()
        
        rpcOption.id = id
        rpcOption.description_p = description
        rpcOption.possibleValue = possibleValue
        
        return rpcOption
    }
    
    public static func == (lhs: Option, rhs: Option) -> Bool {
        return lhs.id == rhs.id
            && lhs.description == rhs.description
            && lhs.possibleValue == rhs.possibleValue
    }
}

public class Camera {
    let service: Dronecore_Rpc_Camera_CameraServiceService
    let scheduler: SchedulerType

    public lazy var cameraModeObservable: Observable<CameraMode> = createCameraModeObservable()
    public lazy var videoStreamInfoObservable: Observable<VideoStreamInfo> = createVideoStreamInfoObservable()
    public lazy var captureInfoObservable: Observable<CaptureInfo> = createCaptureInfoObservable()
    
    public convenience init(address: String, port: Int) {
        let service = Dronecore_Rpc_Camera_CameraServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        self.init(service: service, scheduler: scheduler)
    }
    
    init(service: Dronecore_Rpc_Camera_CameraServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
    public func takePhoto() -> Completable {
        return Completable.create { completable in
            let takePhotoRequest = Dronecore_Rpc_Camera_TakePhotoRequest()
            
            do {
                let takePhotoResponse = try self.service.takephoto(takePhotoRequest)
                if takePhotoResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            var startPhotoIntervalRequest = Dronecore_Rpc_Camera_StartPhotoIntervalRequest()
            startPhotoIntervalRequest.intervalS = interval
            
            do {
                let startPhotoIntevalResponse = try self.service.startphotointerval(startPhotoIntervalRequest)
                if startPhotoIntevalResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            let stopPhotoIntervalRequest = Dronecore_Rpc_Camera_StopPhotoIntervalRequest()
            
            do {
                let stopPhotoIntervalResponse = try self.service.stopphotointerval(stopPhotoIntervalRequest)
                if stopPhotoIntervalResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            let startVideoRequest = Dronecore_Rpc_Camera_StartVideoRequest()
            
            do {
                let startVideoResponse = try self.service.startvideo(startVideoRequest)
                if startVideoResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            let stopVideoRequest = Dronecore_Rpc_Camera_StopVideoRequest()
            
            do {
                let stopVideoResponse = try self.service.stopvideo(stopVideoRequest)
                if stopVideoResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            let startVideoStreamingRequest = Dronecore_Rpc_Camera_StartVideoStreamingRequest()
            
            do {
                let startVideoStreamingResponse = try self.service.startvideostreaming(startVideoStreamingRequest)
                if startVideoStreamingResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            let stopVideoSreamingRequest = Dronecore_Rpc_Camera_StopVideoStreamingRequest()
            
            do {
                let stopVideoStreamingResponse = try self.service.stopvideostreaming(stopVideoSreamingRequest)
                if stopVideoStreamingResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            var setCameraModeRequest = Dronecore_Rpc_Camera_SetModeRequest()
            setCameraModeRequest.cameraMode = mode.rpcCameraMode
            
            do {
                let setCameraModeResponse = try self.service.setmode(setCameraModeRequest)
                if setCameraModeResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
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
            let cameraModeRequest = Dronecore_Rpc_Camera_SubscribeModeRequest()
            
            do {
                let call = try self.service.subscribemode(cameraModeRequest, completion: nil)
                while let response = try? call.receive() {
                    let cameraMode = CameraMode.translateFromRPC(response.cameraMode)
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
            var setVideoStreamSettingsRequest = Dronecore_Rpc_Camera_SetVideoStreamSettingsRequest()
            setVideoStreamSettingsRequest.videoStreamSettings = settings.rpcVideoStreamSettings

            do {
                let _ = try self.service.setvideostreamsettings(setVideoStreamSettingsRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    private func createVideoStreamInfoObservable() -> Observable<VideoStreamInfo> {
        return Observable.create { observer in
            let videoStreamInfoRequest = Dronecore_Rpc_Camera_SubscribeVideoStreamInfoRequest()
            
            do {
                let call = try self.service.subscribevideostreaminfo(videoStreamInfoRequest, completion: nil)
                while let response = try? call.receive() {
                    let videoStreamInfo = VideoStreamInfo.translateFromRPC(response.videoStreamInfo)
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
            let captureInfoRequest = Dronecore_Rpc_Camera_SubscribeCaptureInfoRequest()
            
            do {
                let call = try self.service.subscribecaptureinfo(captureInfoRequest, completion: nil)
                while let response = try? call.receive() {
                    let captureInfo = CaptureInfo.translateFromRPC(response.captureInfo)
                    observer.onNext(captureInfo)
                }
            } catch {
                observer.onError("Faile to subscribe to capture info. \(error)")
            }
            
            return Disposables.create()
        }
    }
    
    public func getPossibleSettings() -> Single<[Setting]> {
        return Single<[Setting]>.create { single in
            let getPossibleSettingsRequest = Dronecore_Rpc_Camera_GetPossibleSettingsRequest()
            
            do {
                let getPossibleSettingsResponse = try self.service.getpossiblesettings(getPossibleSettingsRequest)
                let settings = getPossibleSettingsResponse.setting.map{ Setting.translateFromRPC($0) }
                
                single(.success(settings))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
    public func setOption(option: Option) -> Completable {
        return Completable.create { completable in
            var setOptionRequest = Dronecore_Rpc_Camera_SetOptionRequest()
            setOptionRequest.optionID = option.id
            
            do {
                let setOptionResponse = try self.service.setoption(setOptionRequest)
                if setOptionResponse.cameraResult.result == Dronecore_Rpc_Camera_CameraResult.Result.success {
                    completable(.completed)
                } else {
                    completable(.error("Cannot set options: \(setOptionResponse.cameraResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
}
