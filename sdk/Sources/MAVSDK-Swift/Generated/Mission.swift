import Foundation
import RxSwift
import GRPC
import NIO

public class Mission {
    private let service: Mavsdk_Rpc_Mission_MissionServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_Mission_MissionServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Mission_MissionServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeMissionError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct MissionError: Error {
        public let code: Mission.MissionResult.Result
        public let description: String
    }
    


    public struct MissionItem: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let relativeAltitudeM: Float
        public let speedMS: Float
        public let isFlyThrough: Bool
        public let gimbalPitchDeg: Float
        public let gimbalYawDeg: Float
        public let cameraAction: CameraAction
        public let loiterTimeS: Float
        public let cameraPhotoIntervalS: Double

        
        

        public enum CameraAction: Equatable {
            case none
            case takePhoto
            case startPhotoInterval
            case stopPhotoInterval
            case startVideo
            case stopVideo
            case UNRECOGNIZED(Int)

            internal var rpcCameraAction: Mavsdk_Rpc_Mission_MissionItem.CameraAction {
                switch self {
                case .none:
                    return .none
                case .takePhoto:
                    return .takePhoto
                case .startPhotoInterval:
                    return .startPhotoInterval
                case .stopPhotoInterval:
                    return .stopPhotoInterval
                case .startVideo:
                    return .startVideo
                case .stopVideo:
                    return .stopVideo
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcCameraAction: Mavsdk_Rpc_Mission_MissionItem.CameraAction) -> CameraAction {
                switch rpcCameraAction {
                case .none:
                    return .none
                case .takePhoto:
                    return .takePhoto
                case .startPhotoInterval:
                    return .startPhotoInterval
                case .stopPhotoInterval:
                    return .stopPhotoInterval
                case .startVideo:
                    return .startVideo
                case .stopVideo:
                    return .stopVideo
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(latitudeDeg: Double, longitudeDeg: Double, relativeAltitudeM: Float, speedMS: Float, isFlyThrough: Bool, gimbalPitchDeg: Float, gimbalYawDeg: Float, cameraAction: CameraAction, loiterTimeS: Float, cameraPhotoIntervalS: Double) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.relativeAltitudeM = relativeAltitudeM
            self.speedMS = speedMS
            self.isFlyThrough = isFlyThrough
            self.gimbalPitchDeg = gimbalPitchDeg
            self.gimbalYawDeg = gimbalYawDeg
            self.cameraAction = cameraAction
            self.loiterTimeS = loiterTimeS
            self.cameraPhotoIntervalS = cameraPhotoIntervalS
        }

        internal var rpcMissionItem: Mavsdk_Rpc_Mission_MissionItem {
            var rpcMissionItem = Mavsdk_Rpc_Mission_MissionItem()
            
                
            rpcMissionItem.latitudeDeg = latitudeDeg
                
            
            
                
            rpcMissionItem.longitudeDeg = longitudeDeg
                
            
            
                
            rpcMissionItem.relativeAltitudeM = relativeAltitudeM
                
            
            
                
            rpcMissionItem.speedMS = speedMS
                
            
            
                
            rpcMissionItem.isFlyThrough = isFlyThrough
                
            
            
                
            rpcMissionItem.gimbalPitchDeg = gimbalPitchDeg
                
            
            
                
            rpcMissionItem.gimbalYawDeg = gimbalYawDeg
                
            
            
                
            rpcMissionItem.cameraAction = cameraAction.rpcCameraAction
                
            
            
                
            rpcMissionItem.loiterTimeS = loiterTimeS
                
            
            
                
            rpcMissionItem.cameraPhotoIntervalS = cameraPhotoIntervalS
                
            

            return rpcMissionItem
        }

        internal static func translateFromRpc(_ rpcMissionItem: Mavsdk_Rpc_Mission_MissionItem) -> MissionItem {
            return MissionItem(latitudeDeg: rpcMissionItem.latitudeDeg, longitudeDeg: rpcMissionItem.longitudeDeg, relativeAltitudeM: rpcMissionItem.relativeAltitudeM, speedMS: rpcMissionItem.speedMS, isFlyThrough: rpcMissionItem.isFlyThrough, gimbalPitchDeg: rpcMissionItem.gimbalPitchDeg, gimbalYawDeg: rpcMissionItem.gimbalYawDeg, cameraAction: CameraAction.translateFromRpc(rpcMissionItem.cameraAction), loiterTimeS: rpcMissionItem.loiterTimeS, cameraPhotoIntervalS: rpcMissionItem.cameraPhotoIntervalS)
        }

        public static func == (lhs: MissionItem, rhs: MissionItem) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.relativeAltitudeM == rhs.relativeAltitudeM
                && lhs.speedMS == rhs.speedMS
                && lhs.isFlyThrough == rhs.isFlyThrough
                && lhs.gimbalPitchDeg == rhs.gimbalPitchDeg
                && lhs.gimbalYawDeg == rhs.gimbalYawDeg
                && lhs.cameraAction == rhs.cameraAction
                && lhs.loiterTimeS == rhs.loiterTimeS
                && lhs.cameraPhotoIntervalS == rhs.cameraPhotoIntervalS
        }
    }

    public struct MissionPlan: Equatable {
        public let missionItems: [MissionItem]

        

        public init(missionItems: [MissionItem]) {
            self.missionItems = missionItems
        }

        internal var rpcMissionPlan: Mavsdk_Rpc_Mission_MissionPlan {
            var rpcMissionPlan = Mavsdk_Rpc_Mission_MissionPlan()
            
                
            rpcMissionPlan.missionItems = missionItems.map{ $0.rpcMissionItem }
                
            

            return rpcMissionPlan
        }

        internal static func translateFromRpc(_ rpcMissionPlan: Mavsdk_Rpc_Mission_MissionPlan) -> MissionPlan {
            return MissionPlan(missionItems: rpcMissionPlan.missionItems.map{ MissionItem.translateFromRpc($0) })
        }

        public static func == (lhs: MissionPlan, rhs: MissionPlan) -> Bool {
            return lhs.missionItems == rhs.missionItems
        }
    }

    public struct MissionProgress: Equatable {
        public let current: Int32
        public let total: Int32

        

        public init(current: Int32, total: Int32) {
            self.current = current
            self.total = total
        }

        internal var rpcMissionProgress: Mavsdk_Rpc_Mission_MissionProgress {
            var rpcMissionProgress = Mavsdk_Rpc_Mission_MissionProgress()
            
                
            rpcMissionProgress.current = current
                
            
            
                
            rpcMissionProgress.total = total
                
            

            return rpcMissionProgress
        }

        internal static func translateFromRpc(_ rpcMissionProgress: Mavsdk_Rpc_Mission_MissionProgress) -> MissionProgress {
            return MissionProgress(current: rpcMissionProgress.current, total: rpcMissionProgress.total)
        }

        public static func == (lhs: MissionProgress, rhs: MissionProgress) -> Bool {
            return lhs.current == rhs.current
                && lhs.total == rhs.total
        }
    }

    public struct MissionResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case error
            case tooManyMissionItems
            case busy
            case timeout
            case invalidArgument
            case unsupported
            case noMissionAvailable
            case failedToOpenQgcPlan
            case failedToParseQgcPlan
            case unsupportedMissionCmd
            case transferCancelled
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Mission_MissionResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .error:
                    return .error
                case .tooManyMissionItems:
                    return .tooManyMissionItems
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .invalidArgument:
                    return .invalidArgument
                case .unsupported:
                    return .unsupported
                case .noMissionAvailable:
                    return .noMissionAvailable
                case .failedToOpenQgcPlan:
                    return .failedToOpenQgcPlan
                case .failedToParseQgcPlan:
                    return .failedToParseQgcPlan
                case .unsupportedMissionCmd:
                    return .unsupportedMissionCmd
                case .transferCancelled:
                    return .transferCancelled
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Mission_MissionResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .error:
                    return .error
                case .tooManyMissionItems:
                    return .tooManyMissionItems
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .invalidArgument:
                    return .invalidArgument
                case .unsupported:
                    return .unsupported
                case .noMissionAvailable:
                    return .noMissionAvailable
                case .failedToOpenQgcPlan:
                    return .failedToOpenQgcPlan
                case .failedToParseQgcPlan:
                    return .failedToParseQgcPlan
                case .unsupportedMissionCmd:
                    return .unsupportedMissionCmd
                case .transferCancelled:
                    return .transferCancelled
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcMissionResult: Mavsdk_Rpc_Mission_MissionResult {
            var rpcMissionResult = Mavsdk_Rpc_Mission_MissionResult()
            
                
            rpcMissionResult.result = result.rpcResult
                
            
            
                
            rpcMissionResult.resultStr = resultStr
                
            

            return rpcMissionResult
        }

        internal static func translateFromRpc(_ rpcMissionResult: Mavsdk_Rpc_Mission_MissionResult) -> MissionResult {
            return MissionResult(result: Result.translateFromRpc(rpcMissionResult.result), resultStr: rpcMissionResult.resultStr)
        }

        public static func == (lhs: MissionResult, rhs: MissionResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func uploadMission(missionPlan: MissionPlan) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Mission_UploadMissionRequest()

            
                
            request.missionPlan = missionPlan.rpcMissionPlan
                
            

            do {
                
                let response = self.service.uploadMission(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func cancelMissionUpload() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Mission_CancelMissionUploadRequest()

            

            do {
                
                let response = self.service.cancelMissionUpload(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func downloadMission() -> Single<MissionPlan> {
        return Single<MissionPlan>.create { single in
            let request = Mavsdk_Rpc_Mission_DownloadMissionRequest()

            

            do {
                let response = self.service.downloadMission(request)

                
                let result = try response.response.wait().missionResult
                if (result.result != Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    single(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let missionPlan = try MissionPlan.translateFromRpc(response.response.wait().missionPlan)
                
                single(.success(missionPlan))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func cancelMissionDownload() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Mission_CancelMissionDownloadRequest()

            

            do {
                
                let response = self.service.cancelMissionDownload(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func startMission() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Mission_StartMissionRequest()

            

            do {
                
                let response = self.service.startMission(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func pauseMission() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Mission_PauseMissionRequest()

            

            do {
                
                let response = self.service.pauseMission(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func clearMission() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Mission_ClearMissionRequest()

            

            do {
                
                let response = self.service.clearMission(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setCurrentMissionItem(index: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Mission_SetCurrentMissionItemRequest()

            
                
            request.index = index
                
            

            do {
                
                let response = self.service.setCurrentMissionItem(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func isMissionFinished() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = Mavsdk_Rpc_Mission_IsMissionFinishedRequest()

            

            do {
                let response = self.service.isMissionFinished(request)

                
                let result = try response.response.wait().missionResult
                if (result.result != Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    single(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let isFinished = try response.response.wait().isFinished
                
                single(.success(isFinished))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }


    public lazy var missionProgress: Observable<MissionProgress> = createMissionProgressObservable()


    private func createMissionProgressObservable() -> Observable<MissionProgress> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Mission_SubscribeMissionProgressRequest()

            

            _ = self.service.subscribeMissionProgress(request, handler: { (response) in

                
                     
                let missionProgress = MissionProgress.translateFromRpc(response.missionProgress)
                

                
                observer.onNext(missionProgress)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeMissionError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public func getReturnToLaunchAfterMission() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = Mavsdk_Rpc_Mission_GetReturnToLaunchAfterMissionRequest()

            

            do {
                let response = self.service.getReturnToLaunchAfterMission(request)

                
                let result = try response.response.wait().missionResult
                if (result.result != Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    single(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let enable = try response.response.wait().enable
                
                single(.success(enable))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setReturnToLaunchAfterMission(enable: Bool) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Mission_SetReturnToLaunchAfterMissionRequest()

            
                
            request.enable = enable
                
            

            do {
                
                let response = self.service.setReturnToLaunchAfterMission(request)

                let result = try response.response.wait().missionResult
                if (result.result == Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func importQgroundcontrolMission(qgcPlanPath: String) -> Single<MissionPlan> {
        return Single<MissionPlan>.create { single in
            var request = Mavsdk_Rpc_Mission_ImportQgroundcontrolMissionRequest()

            
                
            request.qgcPlanPath = qgcPlanPath
                
            

            do {
                let response = self.service.importQgroundcontrolMission(request)

                
                let result = try response.response.wait().missionResult
                if (result.result != Mavsdk_Rpc_Mission_MissionResult.Result.success) {
                    single(.error(MissionError(code: MissionResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let missionPlan = try MissionPlan.translateFromRpc(response.response.wait().missionPlan)
                
                single(.success(missionPlan))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }
}