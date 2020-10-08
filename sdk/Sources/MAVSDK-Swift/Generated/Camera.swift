import Foundation
import RxSwift
import GRPC
import NIO

public class Camera {
    private let service: Mavsdk_Rpc_Camera_CameraServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

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
    

    public enum Mode: Equatable {
        case unknown
        case photo
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

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

    public struct EulerAngle: Equatable {
        public let rollDeg: Float
        public let pitchDeg: Float
        public let yawDeg: Float

        

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

        internal var rpcCaptureInfo: Mavsdk_Rpc_Camera_CaptureInfo {
            var rpcCaptureInfo = Mavsdk_Rpc_Camera_CaptureInfo()
            
                
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

        internal var rpcVideoStreamSettings: Mavsdk_Rpc_Camera_VideoStreamSettings {
            var rpcVideoStreamSettings = Mavsdk_Rpc_Camera_VideoStreamSettings()
            
                
            rpcVideoStreamSettings.frameRateHz = frameRateHz
                
            
            
                
            rpcVideoStreamSettings.horizontalResolutionPix = horizontalResolutionPix
                
            
            
                
            rpcVideoStreamSettings.verticalResolutionPix = verticalResolutionPix
                
            
            
                
            rpcVideoStreamSettings.bitRateBS = bitRateBS
                
            
            
                
            rpcVideoStreamSettings.rotationDeg = rotationDeg
                
            
            
                
            rpcVideoStreamSettings.uri = uri
                
            

            return rpcVideoStreamSettings
        }

        internal static func translateFromRpc(_ rpcVideoStreamSettings: Mavsdk_Rpc_Camera_VideoStreamSettings) -> VideoStreamSettings {
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
        public let settings: VideoStreamSettings
        public let status: Status

        
        

        public enum Status: Equatable {
            case notRunning
            case inProgress
            case UNRECOGNIZED(Int)

            internal var rpcStatus: Mavsdk_Rpc_Camera_VideoStreamInfo.Status {
                switch self {
                case .notRunning:
                    return .notRunning
                case .inProgress:
                    return .inProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcStatus: Mavsdk_Rpc_Camera_VideoStreamInfo.Status) -> Status {
                switch rpcStatus {
                case .notRunning:
                    return .notRunning
                case .inProgress:
                    return .inProgress
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(settings: VideoStreamSettings, status: Status) {
            self.settings = settings
            self.status = status
        }

        internal var rpcVideoStreamInfo: Mavsdk_Rpc_Camera_VideoStreamInfo {
            var rpcVideoStreamInfo = Mavsdk_Rpc_Camera_VideoStreamInfo()
            
                
            rpcVideoStreamInfo.settings = settings.rpcVideoStreamSettings
                
            
            
                
            rpcVideoStreamInfo.status = status.rpcStatus
                
            

            return rpcVideoStreamInfo
        }

        internal static func translateFromRpc(_ rpcVideoStreamInfo: Mavsdk_Rpc_Camera_VideoStreamInfo) -> VideoStreamInfo {
            return VideoStreamInfo(settings: VideoStreamSettings.translateFromRpc(rpcVideoStreamInfo.settings), status: Status.translateFromRpc(rpcVideoStreamInfo.status))
        }

        public static func == (lhs: VideoStreamInfo, rhs: VideoStreamInfo) -> Bool {
            return lhs.settings == rhs.settings
                && lhs.status == rhs.status
        }
    }

    public struct Status: Equatable {
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

            internal var rpcStorageStatus: Mavsdk_Rpc_Camera_Status.StorageStatus {
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

            internal static func translateFromRpc(_ rpcStorageStatus: Mavsdk_Rpc_Camera_Status.StorageStatus) -> StorageStatus {
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

        internal var rpcStatus: Mavsdk_Rpc_Camera_Status {
            var rpcStatus = Mavsdk_Rpc_Camera_Status()
            
                
            rpcStatus.videoOn = videoOn
                
            
            
                
            rpcStatus.photoIntervalOn = photoIntervalOn
                
            
            
                
            rpcStatus.usedStorageMib = usedStorageMib
                
            
            
                
            rpcStatus.availableStorageMib = availableStorageMib
                
            
            
                
            rpcStatus.totalStorageMib = totalStorageMib
                
            
            
                
            rpcStatus.recordingTimeS = recordingTimeS
                
            
            
                
            rpcStatus.mediaFolderName = mediaFolderName
                
            
            
                
            rpcStatus.storageStatus = storageStatus.rpcStorageStatus
                
            

            return rpcStatus
        }

        internal static func translateFromRpc(_ rpcStatus: Mavsdk_Rpc_Camera_Status) -> Status {
            return Status(videoOn: rpcStatus.videoOn, photoIntervalOn: rpcStatus.photoIntervalOn, usedStorageMib: rpcStatus.usedStorageMib, availableStorageMib: rpcStatus.availableStorageMib, totalStorageMib: rpcStatus.totalStorageMib, recordingTimeS: rpcStatus.recordingTimeS, mediaFolderName: rpcStatus.mediaFolderName, storageStatus: StorageStatus.translateFromRpc(rpcStatus.storageStatus))
        }

        public static func == (lhs: Status, rhs: Status) -> Bool {
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

    public struct Option: Equatable {
        public let optionID: String
        public let optionDescription: String

        

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

    public struct Setting: Equatable {
        public let settingID: String
        public let settingDescription: String
        public let option: Option
        public let isRange: Bool

        

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

    public struct SettingOptions: Equatable {
        public let settingID: String
        public let settingDescription: String
        public let options: [Option]
        public let isRange: Bool

        

        public init(settingID: String, settingDescription: String, options: [Option], isRange: Bool) {
            self.settingID = settingID
            self.settingDescription = settingDescription
            self.options = options
            self.isRange = isRange
        }

        internal var rpcSettingOptions: Mavsdk_Rpc_Camera_SettingOptions {
            var rpcSettingOptions = Mavsdk_Rpc_Camera_SettingOptions()
            
                
            rpcSettingOptions.settingID = settingID
                
            
            
                
            rpcSettingOptions.settingDescription = settingDescription
                
            
            
                
            rpcSettingOptions.options = options.map{ $0.rpcOption }
                
            
            
                
            rpcSettingOptions.isRange = isRange
                
            

            return rpcSettingOptions
        }

        internal static func translateFromRpc(_ rpcSettingOptions: Mavsdk_Rpc_Camera_SettingOptions) -> SettingOptions {
            return SettingOptions(settingID: rpcSettingOptions.settingID, settingDescription: rpcSettingOptions.settingDescription, options: rpcSettingOptions.options.map{ Option.translateFromRpc($0) }, isRange: rpcSettingOptions.isRange)
        }

        public static func == (lhs: SettingOptions, rhs: SettingOptions) -> Bool {
            return lhs.settingID == rhs.settingID
                && lhs.settingDescription == rhs.settingDescription
                && lhs.options == rhs.options
                && lhs.isRange == rhs.isRange
        }
    }

    public struct Information: Equatable {
        public let vendorName: String
        public let modelName: String

        

        public init(vendorName: String, modelName: String) {
            self.vendorName = vendorName
            self.modelName = modelName
        }

        internal var rpcInformation: Mavsdk_Rpc_Camera_Information {
            var rpcInformation = Mavsdk_Rpc_Camera_Information()
            
                
            rpcInformation.vendorName = vendorName
                
            
            
                
            rpcInformation.modelName = modelName
                
            

            return rpcInformation
        }

        internal static func translateFromRpc(_ rpcInformation: Mavsdk_Rpc_Camera_Information) -> Information {
            return Information(vendorName: rpcInformation.vendorName, modelName: rpcInformation.modelName)
        }

        public static func == (lhs: Information, rhs: Information) -> Bool {
            return lhs.vendorName == rhs.vendorName
                && lhs.modelName == rhs.modelName
        }
    }


    public func takePhoto() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Camera_TakePhotoRequest()

            

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

    public func startPhotoInterval(intervalS: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_StartPhotoIntervalRequest()

            
                
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

    public func stopPhotoInterval() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Camera_StopPhotoIntervalRequest()

            

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

    public func startVideo() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Camera_StartVideoRequest()

            

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

    public func stopVideo() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Camera_StopVideoRequest()

            

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

    public func startVideoStreaming() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Camera_StartVideoStreamingRequest()

            

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

    public func stopVideoStreaming() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Camera_StopVideoStreamingRequest()

            

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

    public func setMode(mode: Mode) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Camera_SetModeRequest()

            
                
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


    public lazy var mode: Observable<Mode> = createModeObservable()


    private func createModeObservable() -> Observable<Mode> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Camera_SubscribeModeRequest()

            

            _ = self.service.subscribeMode(request, handler: { (response) in

                
                     
                let mode = Mode.translateFromRpc(response.mode)
                

                
                observer.onNext(mode)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    public lazy var information: Observable<Information> = createInformationObservable()


    private func createInformationObservable() -> Observable<Information> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Camera_SubscribeInformationRequest()

            

            _ = self.service.subscribeInformation(request, handler: { (response) in

                
                     
                let information = Information.translateFromRpc(response.information)
                

                
                observer.onNext(information)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    public lazy var videoStreamInfo: Observable<VideoStreamInfo> = createVideoStreamInfoObservable()


    private func createVideoStreamInfoObservable() -> Observable<VideoStreamInfo> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Camera_SubscribeVideoStreamInfoRequest()

            

            _ = self.service.subscribeVideoStreamInfo(request, handler: { (response) in

                
                     
                let videoStreamInfo = VideoStreamInfo.translateFromRpc(response.videoStreamInfo)
                

                
                observer.onNext(videoStreamInfo)
                
            })

            return Disposables.create()
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
            let request = Mavsdk_Rpc_Camera_SubscribeCaptureInfoRequest()

            

            _ = self.service.subscribeCaptureInfo(request, handler: { (response) in

                
                     
                let captureInfo = CaptureInfo.translateFromRpc(response.captureInfo)
                

                
                observer.onNext(captureInfo)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeCameraError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    public lazy var status: Observable<Status> = createStatusObservable()


    private func createStatusObservable() -> Observable<Status> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Camera_SubscribeStatusRequest()

            

            _ = self.service.subscribeStatus(request, handler: { (response) in

                
                     
                let status = Status.translateFromRpc(response.cameraStatus)
                

                
                observer.onNext(status)
                
            })

            return Disposables.create()
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
            let request = Mavsdk_Rpc_Camera_SubscribeCurrentSettingsRequest()

            

            _ = self.service.subscribeCurrentSettings(request, handler: { (response) in

                
    	    let currentSettings = response.currentSettings.map{ Setting.translateFromRpc($0) }
                

                
                observer.onNext(currentSettings)
                
            })

            return Disposables.create()
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
            let request = Mavsdk_Rpc_Camera_SubscribePossibleSettingOptionsRequest()

            

            _ = self.service.subscribePossibleSettingOptions(request, handler: { (response) in

                
    	    let possibleSettingOptions = response.settingOptions.map{ SettingOptions.translateFromRpc($0) }
                

                
                observer.onNext(possibleSettingOptions)
                
            })

            return Disposables.create()
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
            var request = Mavsdk_Rpc_Camera_SetSettingRequest()

            
                
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

    public func getSetting(setting: Setting) -> Single<Setting> {
        return Single<Setting>.create { single in
            var request = Mavsdk_Rpc_Camera_GetSettingRequest()

            
                
            request.setting = setting.rpcSetting
                
            

            do {
                let response = self.service.getSetting(request)

                
                let result = try response.response.wait().cameraResult
                if (result.result != Mavsdk_Rpc_Camera_CameraResult.Result.success) {
                    single(.error(CameraError(code: CameraResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let setting = try Setting.translateFromRpc(response.response.wait().setting)
                
                single(.success(setting))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func formatStorage() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Camera_FormatStorageRequest()

            

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
}