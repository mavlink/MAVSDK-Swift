import Foundation
import RxSwift
import SwiftGRPC

public class Mission {
    private let service: DronecodeSdk_Rpc_Mission_MissionServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = DronecodeSdk_Rpc_Mission_MissionServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Mission_MissionServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
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

            internal var rpcCameraAction: DronecodeSdk_Rpc_Mission_MissionItem.CameraAction {
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

            internal static func translateFromRpc(_ rpcCameraAction: DronecodeSdk_Rpc_Mission_MissionItem.CameraAction) -> CameraAction {
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

        internal var rpcMissionItem: DronecodeSdk_Rpc_Mission_MissionItem {
            var rpcMissionItem = DronecodeSdk_Rpc_Mission_MissionItem()
            
                
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

        internal static func translateFromRpc(_ rpcMissionItem: DronecodeSdk_Rpc_Mission_MissionItem) -> MissionItem {
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

    public struct MissionProgress: Equatable {
        public let currentItemIndex: Int32
        public let missionCount: Int32

        

        public init(currentItemIndex: Int32, missionCount: Int32) {
            self.currentItemIndex = currentItemIndex
            self.missionCount = missionCount
        }

        internal var rpcMissionProgress: DronecodeSdk_Rpc_Mission_MissionProgress {
            var rpcMissionProgress = DronecodeSdk_Rpc_Mission_MissionProgress()
            
                
            rpcMissionProgress.currentItemIndex = currentItemIndex
                
            
            
                
            rpcMissionProgress.missionCount = missionCount
                
            

            return rpcMissionProgress
        }

        internal static func translateFromRpc(_ rpcMissionProgress: DronecodeSdk_Rpc_Mission_MissionProgress) -> MissionProgress {
            return MissionProgress(currentItemIndex: rpcMissionProgress.currentItemIndex, missionCount: rpcMissionProgress.missionCount)
        }

        public static func == (lhs: MissionProgress, rhs: MissionProgress) -> Bool {
            return lhs.currentItemIndex == rhs.currentItemIndex
                && lhs.missionCount == rhs.missionCount
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
            case UNRECOGNIZED(Int)

            internal var rpcResult: DronecodeSdk_Rpc_Mission_MissionResult.Result {
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: DronecodeSdk_Rpc_Mission_MissionResult.Result) -> Result {
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcMissionResult: DronecodeSdk_Rpc_Mission_MissionResult {
            var rpcMissionResult = DronecodeSdk_Rpc_Mission_MissionResult()
            
                
            rpcMissionResult.result = result.rpcResult
                
            
            
                
            rpcMissionResult.resultStr = resultStr
                
            

            return rpcMissionResult
        }

        internal static func translateFromRpc(_ rpcMissionResult: DronecodeSdk_Rpc_Mission_MissionResult) -> MissionResult {
            return MissionResult(result: Result.translateFromRpc(rpcMissionResult.result), resultStr: rpcMissionResult.resultStr)
        }

        public static func == (lhs: MissionResult, rhs: MissionResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func uploadMission(missionItems: [MissionItem]) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Mission_UploadMissionRequest()

            
                
            missionItems.forEach({ elem in request.missionItems.append(elem.rpcMissionItem) })
                
            

            do {
                
                let response = try self.service.uploadMission(request)

                if (response.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(response.missionResult.result), description: response.missionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func cancelMissionUpload() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Mission_CancelMissionUploadRequest()

            

            do {
                
                let _ = try self.service.cancelMissionUpload(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func downloadMission() -> Single<[MissionItem]> {
        return Single<[MissionItem]>.create { single in
            let request = DronecodeSdk_Rpc_Mission_DownloadMissionRequest()

            

            do {
                let response = try self.service.downloadMission(request)

                
                if (response.missionResult.result != DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    single(.error(MissionError(code: MissionResult.Result.translateFromRpc(response.missionResult.result), description: response.missionResult.resultStr)))

                    return Disposables.create()
                }
                

                
                let missionItems = response.missionItems.map{ MissionItem.translateFromRpc($0) }
                
                single(.success(missionItems))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func cancelMissionDownload() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Mission_CancelMissionDownloadRequest()

            

            do {
                
                let _ = try self.service.cancelMissionDownload(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func startMission() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Mission_StartMissionRequest()

            

            do {
                
                let response = try self.service.startMission(request)

                if (response.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(response.missionResult.result), description: response.missionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func pauseMission() -> Completable {
        return Completable.create { completable in
            let request = DronecodeSdk_Rpc_Mission_PauseMissionRequest()

            

            do {
                
                let response = try self.service.pauseMission(request)

                if (response.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(response.missionResult.result), description: response.missionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setCurrentMissionItemIndex(index: Int32) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Mission_SetCurrentMissionItemIndexRequest()

            
                
            request.index = index
                
            

            do {
                
                let response = try self.service.setCurrentMissionItemIndex(request)

                if (response.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionError(code: MissionResult.Result.translateFromRpc(response.missionResult.result), description: response.missionResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func isMissionFinished() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = DronecodeSdk_Rpc_Mission_IsMissionFinishedRequest()

            

            do {
                let response = try self.service.isMissionFinished(request)

                

                
                    let isFinished = response.isFinished
                
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
            let request = DronecodeSdk_Rpc_Mission_SubscribeMissionProgressRequest()

            

            do {
                let call = try self.service.subscribeMissionProgress(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeMissionError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
                            
                        let missionProgress = MissionProgress.translateFromRpc(response.missionProgress)
                        

                        
                        observer.onNext(missionProgress)
                        
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
                guard $0 is RuntimeMissionError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public func getReturnToLaunchAfterMission() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = DronecodeSdk_Rpc_Mission_GetReturnToLaunchAfterMissionRequest()

            

            do {
                let response = try self.service.getReturnToLaunchAfterMission(request)

                

                
                    let enable = response.enable
                
                single(.success(enable))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setReturnToLaunchAfterMission(enable: Bool) -> Completable {
        return Completable.create { completable in
            var request = DronecodeSdk_Rpc_Mission_SetReturnToLaunchAfterMissionRequest()

            
                
            request.enable = enable
                
            

            do {
                
                let _ = try self.service.setReturnToLaunchAfterMission(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}