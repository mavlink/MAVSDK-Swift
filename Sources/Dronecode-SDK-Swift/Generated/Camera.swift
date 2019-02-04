import Foundation
import RxSwift
import SwiftGRPC

public class Camera {
    private let service: DronecodeSdk_Rpc_Camera_CameraServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = DronecodeSdk_Rpc_Camera_CameraServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Camera_CameraServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    struct RuntimeCameraError: Error {
        let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    struct CameraError: Error {
        let code: Camera.CameraResult.Result
        let description: String
    }
    

    public enum CameraMode: Equatable {
        case unknown
        case photo
        case video
        case UNRECOGNIZED(Int)

        internal var rpcCameraMode: DronecodeSdk_Rpc_Camera_CameraMode {
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

        internal static func translateFromRpc(_ rpcCameraMode: DronecodeSdk_Rpc_Camera_CameraMode) -> CameraMode {
            switch rpcCameraMode {
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


    public struct CameraResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case inProgress
            case busy
            case denied
            case error
            case timeout
            case wrongArgument
            case UNRECOGNIZED(Int)

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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: DronecodeSdk_Rpc_Camera_CameraResult.Result) -> Result {
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcCameraResult: DronecodeSdk_Rpc_Camera_CameraResult {
            var rpcCameraResult = DronecodeSdk_Rpc_Camera_CameraResult()
            
                
            rpcCameraResult.result = result.rpcResult
                
            
            
                
            rpcCameraResult.resultStr = resultStr
                
            

            return rpcCameraResult
        }

        internal static func translateFromRpc(_ rpcCameraResult: DronecodeSdk_Rpc_Camera_CameraResult) -> CameraResult {
            return CameraResult(result: Result.translateFromRpc(rpcCameraResult.result), resultStr: rpcCameraResult.resultStr)
        }

        public static func == (lhs: CameraResult, rhs: CameraResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }

    public struct CaptureInfo: Equatable {
        public let position: Position
        public let attitudeQuaternion: Quaternion
        public let attitudeEulerAngle: EulerAngle
        public let timeUtcUs: UInt64
        public let isSuccess: Bool
        public let index: Int32
        public let fileURL: String

        

        public init(position: Position, attitudeQuaternion: Quaternion, attitudeEulerAngle: EulerAngle, timeUtcUs: UInt64, isSuccess: Bool, index: Int32, fileURL: String) {
            self.position = position
            self.attitudeQuaternion = attitudeQuaternion
            self.attitudeEulerAngle = attitudeEulerAngle
            self.timeUtcUs = timeUtcUs
            self.isSuccess = isSuccess
            self.index = index
            self.fileURL = fileURL
        }

        internal var rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo {
            var rpcCaptureInfo = DronecodeSdk_Rpc_Camera_CaptureInfo()
            
                
            rpcCaptureInfo.position = position.rpcPosition
                
            
            
                
            rpcCaptureInfo.attitudeQuaternion = attitudeQuaternion.rpcQuaternion
                
            
            
                
            rpcCaptureInfo.attitudeEulerAngle = attitudeEulerAngle.rpcEulerAngle
                
            
            
                
            rpcCaptureInfo.timeUtcUs = timeUtcUs
                
            
            
                
            rpcCaptureInfo.isSuccess = isSuccess
                
            
            
                
            rpcCaptureInfo.index = index
                
            
            
                
            rpcCaptureInfo.fileURL = fileURL
                
            

            return rpcCaptureInfo
        }

        internal static func translateFromRpc(_ rpcCaptureInfo: DronecodeSdk_Rpc_Camera_CaptureInfo) -> CaptureInfo {
            return CaptureInfo(position: Position.translateFromRpc(rpcCaptureInfo.position), attitudeQuaternion: Quaternion.translateFromRpc(rpcCaptureInfo.attitudeQuaternion), attitudeEulerAngle: EulerAngle.translateFromRpc(rpcCaptureInfo.attitudeEulerAngle), timeUtcUs: rpcCaptureInfo.timeUtcUs, isSuccess: rpcCaptureInfo.isSuccess, index: rpcCaptureInfo.index, fileURL: rpcCaptureInfo.fileURL)
        }

        public static func == (lhs: CaptureInfo, rhs: CaptureInfo) -> Bool {
            return lhs.position == rhs.position
                && lhs.attitudeQuaternion == rhs.attitudeQuaternion
                && lhs.attitudeEulerAngle == rhs.attitudeEulerAngle
                && lhs.timeUtcUs == rhs.timeUtcUs
                && lhs.isSuccess == rhs.isSuccess
                && lhs.index == rhs.index
                && lhs.fileURL == rhs.fileURL
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

        internal var rpcPosition: DronecodeSdk_Rpc_Camera_Position {
            var rpcPosition = DronecodeSdk_Rpc_Camera_Position()
            
                
            rpcPosition.latitudeDeg = latitudeDeg
                
            
            
                
            rpcPosition.longitudeDeg = longitudeDeg
                
            
            
                
            rpcPosition.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcPosition.relativeAltitudeM = relativeAltitudeM
                
            

            return rpcPosition
        }

        internal static func translateFromRpc(_ rpcPosition: DronecodeSdk_Rpc_Camera_Position) -> Position {
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

        internal var rpcQuaternion: DronecodeSdk_Rpc_Camera_Quaternion {
            var rpcQuaternion = DronecodeSdk_Rpc_Camera_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: DronecodeSdk_Rpc_Camera_Quaternion) -> Quaternion {
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

        internal var rpcEulerAngle: DronecodeSdk_Rpc_Camera_EulerAngle {
            var rpcEulerAngle = DronecodeSdk_Rpc_Camera_EulerAngle()
            
                
            rpcEulerAngle.rollDeg = rollDeg
                
            
            
                
            rpcEulerAngle.pitchDeg = pitchDeg
                
            
            
                
            rpcEulerAngle.yawDeg = yawDeg
                
            

            return rpcEulerAngle
        }

        internal static func translateFromRpc(_ rpcEulerAngle: DronecodeSdk_Rpc_Camera_EulerAngle) -> EulerAngle {
            return EulerAngle(rollDeg: rpcEulerAngle.rollDeg, pitchDeg: rpcEulerAngle.pitchDeg, yawDeg: rpcEulerAngle.yawDeg)
        }

        public static func == (lhs: EulerAngle, rhs: EulerAngle) -> Bool {
            return lhs.rollDeg == rhs.rollDeg
                && lhs.pitchDeg == rhs.pitchDeg
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    public struct VideoStreamSettings: Equatable {
        public let frameRateHz: Float
        public let horizontalResolutionPix: UInt32
        public let verticalResolutionPix: UInt32
        public let bitRateBS: UInt32
        public let rotationDeg: UInt32
        public let uri: String

        

        public init(frameRateHz: Float, horizontalResolutionPix: UInt32, verticalResolutionPix: UInt32, bitRateBS: UInt32, rotationDeg: UInt32, uri: String) {
            self.frameRateHz = frameRateHz
            self.horizontalResolutionPix = horizontalResolutionPix
            self.verticalResolutionPix = verticalResolutionPix
            self.bitRateBS = bitRateBS
            self.rotationDeg = rotationDeg
            self.uri = uri
        }

        internal var rpcVideoStreamSettings: DronecodeSdk_Rpc_Camera_VideoStreamSettings {
            var rpcVideoStreamSettings = DronecodeSdk_Rpc_Camera_VideoStreamSettings()
            
                
            rpcVideoStreamSettings.frameRateHz = frameRateHz
                
            
            
                
            rpcVideoStreamSettings.horizontalResolutionPix = horizontalResolutionPix
                
            
            
                
            rpcVideoStreamSettings.verticalResolutionPix = verticalResolutionPix
                
            
            
                
            rpcVideoStreamSettings.bitRateBS = bitRateBS
                
            
            
                
            rpcVideoStreamSettings.rotationDeg = rotationDeg
                
            
            
                
            rpcVideoStreamSettings.uri = uri
                
            

            return rpcVideoStreamSettings
        }

        internal static func translateFromRpc(_ rpcVideoStreamSettings: DronecodeSdk_Rpc_Camera_VideoStreamSettings) -> VideoStreamSettings {
            return VideoStreamSettings(frameRateHz: rpcVideoStreamSettings.frameRateHz, horizontalResolutionPix: rpcVideoStreamSettings.horizontalResolutionPix, verticalResolutionPix: rpcVideoStreamSettings.verticalResolutionPix, bitRateBS: rpcVideoStreamSettings.bitRateBS, rotationDeg: rpcVideoStreamSettings.rotationDeg, uri: rpcVideoStreamSettings.uri)
        }

        public static func == (lhs: VideoStreamSettings, rhs: VideoStreamSettings) -> Bool {
            return lhs.frameRateHz == rhs.frameRateHz
                && lhs.horizontalResolutionPix == rhs.horizontalResolutionPix
                && lhs.verticalResolutionPix == rhs.verticalResolutionPix
                && lhs.bitRateBS == rhs.bitRateBS
                && lhs.rotationDeg == rhs.rotationDeg
                && lhs.uri == rhs.uri
        }
    }

    public struct VideoStreamInfo: Equatable {
        public let videoStreamSettings: VideoStreamSettings
        public let videoStreamStatus: VideoStreamStatus

        
        

        public enum VideoStreamStatus: Equatable {
            case notRunning
            case inProgress
            case UNRECOGNIZED(Int)

            internal var rpcVideoStreamStatus: DronecodeSdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus {
                switch self {
                case .notRunning:
                    return .notRunning
                case .inProgress:
                    return .inProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcVideoStreamStatus: DronecodeSdk_Rpc_Camera_VideoStreamInfo.VideoStreamStatus) -> VideoStreamStatus {
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

        internal static func translateFromRpc(_ rpcVideoStreamInfo: DronecodeSdk_Rpc_Camera_VideoStreamInfo) -> VideoStreamInfo {
            return VideoStreamInfo(videoStreamSettings: VideoStreamSettings.translateFromRpc(rpcVideoStreamInfo.videoStreamSettings), videoStreamStatus: VideoStreamStatus.translateFromRpc(rpcVideoStreamInfo.videoStreamStatus))
        }

        public static func == (lhs: VideoStreamInfo, rhs: VideoStreamInfo) -> Bool {
            return lhs.videoStreamSettings == rhs.videoStreamSettings
                && lhs.videoStreamStatus == rhs.videoStreamStatus
        }
    }

    public struct CameraStatus: Equatable {
        public let videoOn: Bool
        public let photoIntervalOn: Bool
        public let usedStorageMib: Float
        public let availableStorageMib: Float
        public let totalStorageMib: Float
        public let recordingTimeS: Float
        public let mediaFolderName: String
        public let storageStatus: StorageStatus

        
        

        public enum StorageStatus: Equatable {
            case notAvailable
            case unformatted
            case formatted
            case UNRECOGNIZED(Int)

            internal var rpcStorageStatus: DronecodeSdk_Rpc_Camera_CameraStatus.StorageStatus {
                switch self {
                case .notAvailable:
                    return .notAvailable
                case .unformatted:
                    return .unformatted
                case .formatted:
                    return .formatted
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcStorageStatus: DronecodeSdk_Rpc_Camera_CameraStatus.StorageStatus) -> StorageStatus {
                switch rpcStorageStatus {
                case .notAvailable:
                    return .notAvailable
                case .unformatted:
                    return .unformatted
                case .formatted:
                    return .formatted
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(videoOn: Bool, photoIntervalOn: Bool, usedStorageMib: Float, availableStorageMib: Float, totalStorageMib: Float, recordingTimeS: Float, mediaFolderName: String, storageStatus: StorageStatus) {
            self.videoOn = videoOn
            self.photoIntervalOn = photoIntervalOn
            self.usedStorageMib = usedStorageMib
            self.availableStorageMib = availableStorageMib
            self.totalStorageMib = totalStorageMib
            self.recordingTimeS = recordingTimeS
            self.mediaFolderName = mediaFolderName
            self.storageStatus = storageStatus
        }

        internal var rpcCameraStatus: DronecodeSdk_Rpc_Camera_CameraStatus {
            var rpcCameraStatus = DronecodeSdk_Rpc_Camera_CameraStatus()
            
                
            rpcCameraStatus.videoOn = videoOn
                
            
            
                
            rpcCameraStatus.photoIntervalOn = photoIntervalOn
                
            
            
                
            rpcCameraStatus.usedStorageMib = usedStorageMib
                
            
            
                
            rpcCameraStatus.availableStorageMib = availableStorageMib
                
            
            
                
            rpcCameraStatus.totalStorageMib = totalStorageMib
                
            
            
                
            rpcCameraStatus.recordingTimeS = recordingTimeS
                
            
            
                
            rpcCameraStatus.mediaFolderName = mediaFolderName
                
            
            
                
            rpcCameraStatus.storageStatus = storageStatus.rpcStorageStatus
                
            

            return rpcCameraStatus
        }

        internal static func translateFromRpc(_ rpcCameraStatus: DronecodeSdk_Rpc_Camera_CameraStatus) -> CameraStatus {
            return CameraStatus(videoOn: rpcCameraStatus.videoOn, photoIntervalOn: rpcCameraStatus.photoIntervalOn, usedStorageMib: rpcCameraStatus.usedStorageMib, availableStorageMib: rpcCameraStatus.availableStorageMib, totalStorageMib: rpcCameraStatus.totalStorageMib, recordingTimeS: rpcCameraStatus.recordingTimeS, mediaFolderName: rpcCameraStatus.mediaFolderName, storageStatus: StorageStatus.translateFromRpc(rpcCameraStatus.storageStatus))
        }

        public static func == (lhs: CameraStatus, rhs: CameraStatus) -> Bool {
            return lhs.videoOn == rhs.videoOn
                && lhs.photoIntervalOn == rhs.photoIntervalOn
                && lhs.usedStorageMib == rhs.usedStorageMib
                && lhs.availableStorageMib == rhs.availableStorageMib
                && lhs.totalStorageMib == rhs.totalStorageMib
                && lhs.recordingTimeS == rhs.recordingTimeS
                && lhs.mediaFolderName == rhs.mediaFolderName
                && lhs.storageStatus == rhs.storageStatus
        }
    }

    public struct Setting: Equatable {
        public let settingID: String
        public let settingDescription: String
        public let option: Option

        

        public init(settingID: String, settingDescription: String, option: Option) {
            self.settingID = settingID
            self.settingDescription = settingDescription
            self.option = option
        }

        internal var rpcSetting: DronecodeSdk_Rpc_Camera_Setting {
            var rpcSetting = DronecodeSdk_Rpc_Camera_Setting()
            
                
            rpcSetting.settingID = settingID
                
            
            
                
            rpcSetting.settingDescription = settingDescription
                
            
            
                
            rpcSetting.option = option.rpcOption
                
            

            return rpcSetting
        }

        internal static func translateFromRpc(_ rpcSetting: DronecodeSdk_Rpc_Camera_Setting) -> Setting {
            return Setting(settingID: rpcSetting.settingID, settingDescription: rpcSetting.settingDescription, option: Option.translateFromRpc(rpcSetting.option))
        }

        public static func == (lhs: Setting, rhs: Setting) -> Bool {
            return lhs.settingID == rhs.settingID
                && lhs.settingDescription == rhs.settingDescription
                && lhs.option == rhs.option
        }
    }

    public struct Option: Equatable {
        public let optionID: String
        public let optionDescription: String

        

        public init(optionID: String, optionDescription: String) {
            self.optionID = optionID
            self.optionDescription = optionDescription
        }

        internal var rpcOption: DronecodeSdk_Rpc_Camera_Option {
            var rpcOption = DronecodeSdk_Rpc_Camera_Option()
            
                
            rpcOption.optionID = optionID
                
            
            
                
            rpcOption.optionDescription = optionDescription
                
            

            return rpcOption
        }

        internal static func translateFromRpc(_ rpcOption: DronecodeSdk_Rpc_Camera_Option) -> Option {
            return Option(optionID: rpcOption.optionID, optionDescription: rpcOption.optionDescription)
        }

        public static func == (lhs: Option, rhs: Option) -> Bool {
            return lhs.optionID == rhs.optionID
                && lhs.optionDescription == rhs.optionDescription
        }
    }

    public struct SettingOptions: Equatable {
        public let settingID: String
        public let settingDescription: String
        public let options: [Option]

        

        public init(settingID: String, settingDescription: String, options: [Option]) {
            self.settingID = settingID
            self.settingDescription = settingDescription
            self.options = options
        }

        internal var rpcSettingOptions: DronecodeSdk_Rpc_Camera_SettingOptions {
            var rpcSettingOptions = DronecodeSdk_Rpc_Camera_SettingOptions()
            
                
            rpcSettingOptions.settingID = settingID
                
            
            
                
            rpcSettingOptions.settingDescription = settingDescription
                
            
            
            rpcSettingOptions.options = options.map{ $0.rpcOption }
            

            return rpcSettingOptions
        }

        internal static func translateFromRpc(_ rpcSettingOptions: DronecodeSdk_Rpc_Camera_SettingOptions) -> SettingOptions {
            return SettingOptions(settingID: rpcSettingOptions.settingID, settingDescription: rpcSettingOptions.settingDescription, options: rpcSettingOptions.options.map{ Option.translateFromRpc($0) })
        }

        public static func == (lhs: SettingOptions, rhs: SettingOptions) -> Bool {
            return lhs.settingID == rhs.settingID
                && lhs.settingDescription == rhs.settingDescription
                && lhs.options == rhs.options
        }
    }


    public func takePhoto() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Camera_TakePhotoRequest()

            

            do {
                
                let response = try self.service.takePhoto(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func startPhotoInterval(intervalS: Float) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Camera_StartPhotoIntervalRequest()

            
                
            request.intervalS = intervalS
                
            

            do {
                
                let response = try self.service.startPhotoInterval(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func stopPhotoInterval() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Camera_StopPhotoIntervalRequest()

            

            do {
                
                let response = try self.service.stopPhotoInterval(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func startVideo() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Camera_StartVideoRequest()

            

            do {
                
                let response = try self.service.startVideo(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func stopVideo() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Camera_StopVideoRequest()

            

            do {
                
                let response = try self.service.stopVideo(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func startVideoStreaming() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Camera_StartVideoStreamingRequest()

            

            do {
                
                let response = try self.service.startVideoStreaming(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func stopVideoStreaming() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Camera_StopVideoStreamingRequest()

            

            do {
                
                let response = try self.service.stopVideoStreaming(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setMode(cameraMode: CameraMode) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Camera_SetModeRequest()

            
                
            request.cameraMode = cameraMode.rpcCameraMode
                
            

            do {
                
                let response = try self.service.setMode(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public lazy var mode: Observable<CameraMode> = createModeObservable()

    private func createModeObservable() -> Observable<CameraMode> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Camera_SubscribeModeRequest()

            

            do {
                let call = try self.service.subscribeMode(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCameraError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
                            
                        let mode = CameraMode.translateFromRpc(response.cameraMode)
                        

                        
                        observer.onNext(mode)
                        
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
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public func setVideoStreamSettings(videoStreamSettings: VideoStreamSettings) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Camera_SetVideoStreamSettingsRequest()

            
                
            request.videoStreamSettings = videoStreamSettings.rpcVideoStreamSettings
                
            

            do {
                
                let _ = try self.service.setVideoStreamSettings(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public lazy var videoStreamInfo: Observable<VideoStreamInfo> = createVideoStreamInfoObservable()

    private func createVideoStreamInfoObservable() -> Observable<VideoStreamInfo> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Camera_SubscribeVideoStreamInfoRequest()

            

            do {
                let call = try self.service.subscribeVideoStreamInfo(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCameraError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
                            
                        let videoStreamInfo = VideoStreamInfo.translateFromRpc(response.videoStreamInfo)
                        

                        
                        observer.onNext(videoStreamInfo)
                        
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
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var captureInfo: Observable<CaptureInfo> = createCaptureInfoObservable()

    private func createCaptureInfoObservable() -> Observable<CaptureInfo> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Camera_SubscribeCaptureInfoRequest()

            

            do {
                let call = try self.service.subscribeCaptureInfo(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCameraError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
                            
                        let captureInfo = CaptureInfo.translateFromRpc(response.captureInfo)
                        

                        
                        observer.onNext(captureInfo)
                        
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
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var cameraStatus: Observable<CameraStatus> = createCameraStatusObservable()

    private func createCameraStatusObservable() -> Observable<CameraStatus> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Camera_SubscribeCameraStatusRequest()

            

            do {
                let call = try self.service.subscribeCameraStatus(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCameraError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
                            
                        let cameraStatus = CameraStatus.translateFromRpc(response.cameraStatus)
                        

                        
                        observer.onNext(cameraStatus)
                        
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
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var currentSettings: Observable<[Setting]> = createCurrentSettingsObservable()

    private func createCurrentSettingsObservable() -> Observable<[Setting]> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Camera_SubscribeCurrentSettingsRequest()

            

            do {
                let call = try self.service.subscribeCurrentSettings(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCameraError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
    		    let currentSettings = response.currentSettings.map{ Setting.translateFromRpc($0) }
                        

                        
                        observer.onNext(currentSettings)
                        
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
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var possibleSettingOptions: Observable<[SettingOptions]> = createPossibleSettingOptionsObservable()

    private func createPossibleSettingOptionsObservable() -> Observable<[SettingOptions]> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Camera_SubscribePossibleSettingOptionsRequest()

            

            do {
                let call = try self.service.subscribePossibleSettingOptions(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCameraError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
    		    let possibleSettingOptions = response.settingOptions.map{ SettingOptions.translateFromRpc($0) }
                        

                        
                        observer.onNext(possibleSettingOptions)
                        
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
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public func setSetting(setting: Setting) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Camera_SetSettingRequest()

            
                
            request.setting = setting.rpcSetting
                
            

            do {
                
                let response = try self.service.setSetting(request)

                if (response.cameraResult.result == DronecodeSdk_Rpc_Camera_CameraResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CameraError(code: CameraResult.Result.translateFromRpc(response.cameraResult.result), description: response.cameraResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}