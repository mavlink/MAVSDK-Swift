import Foundation
import SwiftGRPC
import RxSwift

public struct MissionItem : Equatable {
    public let latitudeDeg: Double
    public let longitudeDeg: Double
    public let relativeAltitudeM: Float
    public let speedMPS: Float
    public let isFlyThrough: Bool
    public let gimbalPitchDeg: Float
    public let gimbalYawDeg: Float
    public let loiteTimeS: Float
    public let cameraAction: CameraAction

/**
The struct represents a waypoint item. A mission consist of an array of waypoint items.
     
- Parameters:
     - latitudeDeg: latitude of the waypoint
     - longitudeDeg: longtitude of the waypoint
     - relativeAltitudeM: altitude relative to the takeoff altitude
     - speedMPS: speed in meters per second
     - isFlyThrough: if enabled, the aircraft will fly through the waypoint and stop at waypoint
     - gimbalPitchDeg: gimbal pitch. Valid range [-90.0, 0.0]
     - gimbalYawDeg: gimbal yaw relative to the aircraft yaw. Valid range [0.0, 360.0]
     - cameraAction: camera action type
*/
    public init(latitudeDeg: Double, longitudeDeg: Double, relativeAltitudeM: Float, speedMPS: Float, isFlyThrough: Bool, gimbalPitchDeg: Float, gimbalYawDeg: Float, loiterTimeS: Float, cameraAction: CameraAction) {
        self.latitudeDeg = latitudeDeg
        self.longitudeDeg = longitudeDeg
        self.relativeAltitudeM = relativeAltitudeM
        self.speedMPS = speedMPS
        self.isFlyThrough = isFlyThrough
        self.gimbalPitchDeg = gimbalPitchDeg
        self.gimbalYawDeg = gimbalYawDeg
        self.loiteTimeS = loiterTimeS
        self.cameraAction = cameraAction
    }
    
    internal var rpcMissionItem: DronecodeSdk_Rpc_Mission_MissionItem {
        var rpcMissionItem = DronecodeSdk_Rpc_Mission_MissionItem()
        
        rpcMissionItem.latitudeDeg = latitudeDeg
        rpcMissionItem.longitudeDeg = longitudeDeg
        rpcMissionItem.relativeAltitudeM = relativeAltitudeM
        rpcMissionItem.speedMS = speedMPS
        rpcMissionItem.isFlyThrough = isFlyThrough
        rpcMissionItem.gimbalPitchDeg = gimbalPitchDeg
        rpcMissionItem.gimbalYawDeg = gimbalYawDeg
        rpcMissionItem.loiterTimeS = loiteTimeS
        rpcMissionItem.cameraAction = cameraAction.rpcCameraAction
        
        return rpcMissionItem
    }
    
    internal static func translateFromRPC(_ rpcMissionItem: DronecodeSdk_Rpc_Mission_MissionItem) -> MissionItem {
        return MissionItem(latitudeDeg: rpcMissionItem.latitudeDeg,
                           longitudeDeg: rpcMissionItem.longitudeDeg,
                           relativeAltitudeM: rpcMissionItem.relativeAltitudeM,
                           speedMPS: rpcMissionItem.speedMS,
                           isFlyThrough: rpcMissionItem.isFlyThrough,
                           gimbalPitchDeg: rpcMissionItem.gimbalPitchDeg,
                           gimbalYawDeg: rpcMissionItem.gimbalYawDeg,
                           loiterTimeS: rpcMissionItem.loiterTimeS,
                           cameraAction: CameraAction.translateFromRPC(rpcMissionItem.cameraAction))
    }

    public static func == (lhs: MissionItem, rhs: MissionItem) -> Bool {
        return lhs.latitudeDeg == rhs.latitudeDeg
            && lhs.longitudeDeg == rhs.longitudeDeg
            && lhs.relativeAltitudeM == rhs.relativeAltitudeM
            && lhs.speedMPS == rhs.speedMPS
            && lhs.isFlyThrough == rhs.isFlyThrough
            && lhs.gimbalPitchDeg == rhs.gimbalPitchDeg
            && lhs.gimbalYawDeg == rhs.gimbalYawDeg
            && lhs.loiteTimeS == rhs.loiteTimeS
            && lhs.cameraAction == rhs.cameraAction
    }
}

public struct MissionProgress : Equatable {
    public let currentItemIndex: Int
    public let missionCount: Int
    
    public init(currentItemIndex: Int32, missionCount: Int32) {
        self.currentItemIndex = Int(currentItemIndex)
        self.missionCount = Int(missionCount)
    }
    
    public static func == (lhs: MissionProgress, rhs: MissionProgress) -> Bool {
        return lhs.currentItemIndex == rhs.currentItemIndex
            && lhs.missionCount == rhs.missionCount
    }
}

public enum CameraAction {
    case none
    case takePhoto
    case startPhotoInterval
    case stopPhotoInterval
    case startVideo
    case stopVideo
    
    internal var rpcCameraAction: DronecodeSdk_Rpc_Mission_MissionItem.CameraAction {
        switch (self) {
        case .none:
            return DronecodeSdk_Rpc_Mission_MissionItem.CameraAction.none
        case .takePhoto:
            return DronecodeSdk_Rpc_Mission_MissionItem.CameraAction.takePhoto
        case .startPhotoInterval:
            return DronecodeSdk_Rpc_Mission_MissionItem.CameraAction.startPhotoInterval
        case .stopPhotoInterval:
            return DronecodeSdk_Rpc_Mission_MissionItem.CameraAction.stopPhotoInterval
        case .startVideo:
            return DronecodeSdk_Rpc_Mission_MissionItem.CameraAction.startVideo
        case .stopVideo:
            return DronecodeSdk_Rpc_Mission_MissionItem.CameraAction.stopVideo
        }
    }
    
    internal static func translateFromRPC(_ rpcCameraAction: DronecodeSdk_Rpc_Mission_MissionItem.CameraAction) -> CameraAction {
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
        case .UNRECOGNIZED:
            return .none
        }
    }
}

public class Mission {
    private let service: DronecodeSdk_Rpc_Mission_MissionServiceService
    private let scheduler: SchedulerType
    
    public lazy var missionProgressObservable: Observable<MissionProgress> = createMissionProgressObservable()

    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Mission_MissionServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Mission_MissionServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public func uploadMission(missionItems: [MissionItem]) -> Completable {
        return Completable.create { completable in
            var uploadMissionRequest = DronecodeSdk_Rpc_Mission_UploadMissionRequest()
            uploadMissionRequest.mission.missionItem = missionItems.map{ $0.rpcMissionItem }

            do {
                let uploadMissionResponse = try self.service.uploadMission(uploadMissionRequest)
                if (uploadMissionResponse.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot upload mission: \(uploadMissionResponse.missionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func downloadMission() -> Single<[MissionItem]> {
        return Single<[MissionItem]>.create { single in
            let downloadMissionRequest = DronecodeSdk_Rpc_Mission_DownloadMissionRequest()
            
            do {
                let downloadMissionResponse = try self.service.downloadMission(downloadMissionRequest)
                if (downloadMissionResponse.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    let missionItems = downloadMissionResponse.mission.missionItem.map{ MissionItem.translateFromRPC($0) }
                    
                    single(.success(missionItems))
                }
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    public func startMission() -> Completable {
        return Completable.create { completable in
            let startMissionRequest = DronecodeSdk_Rpc_Mission_StartMissionRequest()

            do {
                let startMissionResponse = try self.service.startMission(startMissionRequest)
                if (startMissionResponse.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot start mission: \(startMissionResponse.missionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func pauseMission() -> Completable {
        return Completable.create { completable in
            let pauseMissionRequest = DronecodeSdk_Rpc_Mission_PauseMissionRequest()
            
            do {
                let pauseMissionResponse = try self.service.pauseMission(pauseMissionRequest)
                if (pauseMissionResponse.missionResult.result == DronecodeSdk_Rpc_Mission_MissionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot pause mission: \(pauseMissionResponse.missionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
        
    public func setReturnToLaunchAfterMission(_ enable: Bool) -> Completable {
        return Completable.create { completable in
            var setRTLAfterMissionRequest = DronecodeSdk_Rpc_Mission_SetReturnToLaunchAfterMissionRequest()
            setRTLAfterMissionRequest.enable = enable
            
            do {
                let _ = try self.service.setReturnToLaunchAfterMission(setRTLAfterMissionRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func getReturnToLaunchAfterMission() -> Single<Bool> {
        return Single<Bool>.create { single in
            let rtlAfterMissionRequest = DronecodeSdk_Rpc_Mission_GetReturnToLaunchAfterMissionRequest()
            do {
                let rtlAfterMissionResponse = try self.service.getReturnToLaunchAfterMission(rtlAfterMissionRequest)
                single(.success(rtlAfterMissionResponse.enable))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func setCurrentMissionItemIndex(_ index: Int) -> Completable {
        return Completable.create { completable in
            var setCurrentMissionItemIndexRequest = DronecodeSdk_Rpc_Mission_SetCurrentMissionItemIndexRequest()
            setCurrentMissionItemIndexRequest.index = Int32(index)
            
            do {
                let _ = try self.service.setCurrentMissionItemIndex(setCurrentMissionItemIndexRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func getCurrentMissionItemIndex() -> Single<Int> {
        return Single<Int>.create { single in
            let getCurrentMissionItemIndexRequest = DronecodeSdk_Rpc_Mission_GetCurrentMissionItemIndexRequest()
            
            do {
                let getCurrentMissionItemIndexResponse = try self.service.getCurrentMissionItemIndex(getCurrentMissionItemIndexRequest)
                single(.success(Int(getCurrentMissionItemIndexResponse.index)))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func getMissionCount() -> Single<Int> {
        return Single<Int>.create { single in
            let getMissionCountRequest = DronecodeSdk_Rpc_Mission_GetMissionCountRequest()
            
            do {
                let getMissionCountResponse = try self.service.getMissionCount(getMissionCountRequest)
                single(.success(Int(getMissionCountResponse.count)))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    public func isMissionFinished() -> Single<Bool> {
        return Single<Bool>.create { single in
            let isMissionFinishedRequest = DronecodeSdk_Rpc_Mission_IsMissionFinishedRequest()
            do {
                let isMissionFinishedResponse = try self.service.isMissionFinished(isMissionFinishedRequest)
                single(.success(isMissionFinishedResponse.isFinished))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    private func createMissionProgressObservable() -> Observable<MissionProgress> {
        return Observable.create { observer in
            let missionProgressRequest = DronecodeSdk_Rpc_Mission_SubscribeMissionProgressRequest()
            
            do {
                let call = try self.service.subscribeMissionProgress(missionProgressRequest, completion: nil)
                while let response = try call.receive() {
                    let missionProgres = MissionProgress(currentItemIndex: response.missionProgress.currentItemIndex , missionCount: response.missionProgress.missionCount)
                    observer.onNext(missionProgres)
                }
            } catch {
                observer.onError("Failed to subscribe to discovery stream")
            }
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
}
