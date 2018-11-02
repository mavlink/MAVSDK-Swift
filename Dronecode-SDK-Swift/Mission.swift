import Foundation
import SwiftGRPC
import RxSwift

/**
 The struct represents a mission item. A mission consist of an array of mission items.
 */
public struct MissionItem : Equatable {
    
    /// Latitude of the waypoint in degrees.
    public let latitudeDeg: Double

    /// Longitude of the waypoint in degrees.
    public let longitudeDeg: Double
    
    /// Altitude relative to takeoff position in metres.
    public let relativeAltitudeM: Float
    
    /// Speed in meters/second to be used after this mission item.
    public let speedMPS: Float
    
    /// Whether drone should fly through waypoint (`true`) or stop at waypoint (`false`).
    public let isFlyThrough: Bool
    
    /// The new pitch angle of the gimbal in degrees (0: horizontal, positive up, -90: vertical downward facing).
    public let gimbalPitchDeg: Float
    
    /// The new yaw angle of the gimbal in degrees (0: forward, positive clock-wise, 90: to the right).
    public let gimbalYawDeg: Float
    
    /// Loiter time in seconds.
    public let loiterTimeS: Float
    
    /// `CameraAction` to perform at waypoint.
    public let cameraAction: CameraAction

    /**
     Create a mission item.
     
     To ignore a `Float` or `Double` parameter, set it to `Float.NAN` respectively `Double.NAN`.
     
     - Parameters:
       - latitudeDeg: Latitude of the waypoint in degrees.
       - longitudeDeg: Longitude of the waypoint in degrees.
       - relativeAltitudeM: Altitude relative to takeoff position in metres.
       - speedMPS: Speed in meters/second to be used after this mission item.
       - isFlyThrough: Whether drone should fly through waypoint (`true`) or stop at waypoint (`false`).
       - gimbalPitchDeg: The new pitch angle of the gimbal in degrees (0: horizontal, positive up, -90: vertical downward facing).
       - gimbalYawDeg: The new yaw angle of the gimbal in degrees (0: forward, positive clock-wise, 90: to the right).
       - loiterTimeS: Loiter time in seconds.
       - cameraAction: `CameraAction` to perform at waypoint.
     */
    public init(latitudeDeg: Double, longitudeDeg: Double, relativeAltitudeM: Float, speedMPS: Float, isFlyThrough: Bool, gimbalPitchDeg: Float, gimbalYawDeg: Float, loiterTimeS: Float, cameraAction: CameraAction) {
        self.latitudeDeg = latitudeDeg
        self.longitudeDeg = longitudeDeg
        self.relativeAltitudeM = relativeAltitudeM
        self.speedMPS = speedMPS
        self.isFlyThrough = isFlyThrough
        self.gimbalPitchDeg = gimbalPitchDeg
        self.gimbalYawDeg = gimbalYawDeg
        self.loiterTimeS = loiterTimeS
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
        rpcMissionItem.loiterTimeS = loiterTimeS
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
            && lhs.loiterTimeS == rhs.loiterTimeS
            && lhs.cameraAction == rhs.cameraAction
    }
}

/**
 Mission progress type.
 */
public struct MissionProgress : Equatable {
    /// Current mission item (0 based).
    public let currentItemIndex: Int
    /// Total number of mission items.
    public let missionCount: Int
    
    /**
     Initialize `MissionProgress`.
     
     - Parameters:
       - currentItemIndex: Current mission item (0 based).
       - missionCount: Total number of mission items.
     */
    public init(currentItemIndex: Int32, missionCount: Int32) {
        self.currentItemIndex = Int(currentItemIndex)
        self.missionCount = Int(missionCount)
    }
    
    public static func == (lhs: MissionProgress, rhs: MissionProgress) -> Bool {
        return lhs.currentItemIndex == rhs.currentItemIndex
            && lhs.missionCount == rhs.missionCount
    }
}

/**
 Possible camera actions at a mission item.
 */
public enum CameraAction {
    /// No camera action.
    case none
    /// Take single photo.
    case takePhoto
    /// Start capturing photos at regular intervals.
    case startPhotoInterval
    /// Stop capturing photos at regular intervals.
    case stopPhotoInterval
    /// Start capturing video.
    case startVideo
    /// Stop capturing video.
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

/**
 The Mission class enables waypoint missions.
 */
public class Mission {
    private let service: DronecodeSdk_Rpc_Mission_MissionServiceService
    private let scheduler: SchedulerType
    
    /**
     Subscribes to mission progress.
     
     Returns: `MissionProgress` `Observable`
     */
    public lazy var missionProgressObservable: Observable<MissionProgress> = createMissionProgressObservable()
    
    /**
     Helper function to connect `Mission` object to the backend.
     
     - Parameter address: Network address of backend (IP or "localhost").
     - Parameter port: Port number of backend.
     */
    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Mission_MissionServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Mission_MissionServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    /**
     Uploads a vector of mission items to the system.
 
     The mission items are uploaded to a drone. Once uploaded the mission can be started and executed even if a connection is lost.

     - Parameter missionItems: Reference to a `MissionItem` array.
     
     - Returns: a `Completable` indicating success or an error.
    */
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
    
    /**
     Downloads a vector of mission items from the system.
     
     - Note: The method will fail if any of the downloaded mission items are not supported by the Dronecode SDK API.
     
     - Returns: a `Single` containing a `MissionItem` array or an error.
     */
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
    
    /**
     Starts the mission.
     
     - Note: The mission must be uploaded to the vehicle using `uploadMission` before this method is called.
     
     - Returns: a `Completable` indicating success or an error.
     */
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
    
    /**
     Pauses the mission.
     
     Pausing the mission puts the vehicle into [HOLD mode](https://docs.px4.io/en/flight_modes/hold.html).
     A multicopter should just hover at the spot while a fixedwing vehicle should loiter around the location where it paused.
     
     - Returns: a `Completable` indicating success or an error.
     */
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
    
    /**
     Set whether to trigger Return-to-Launch (RTL) after mission is complete.
     
     This enables/disables to command RTL at the end of a mission.
     
     - Note: After setting this option, the mission needs to be re-uploaded.
     
     - Parameter enable: Enables RTL after mission is complete.
     
     - Returns: a `Completable` indicating success or an error.
     */
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
    
    /**
     Get whether to trigger Return-to-Launch (RTL) after mission is complete.
     
     - Note: Before getting this option, it needs to be set, or a mission needs to be downloaded.
     
     - Returns: `Single` containing whether RTL after mission is enabled or error.
     */
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
    
    /**
     Sets the mission item index to go to.
     
     By setting the current index to 0, the mission is restarted from the beginning.
     If it is set to a specific index of a mission item, the mission will be set to this item.
     
     - Note: This is not necessarily true for general missions using MAVLink if loop counters are used.
     
     - Parameter index: Index for mission index to go to next (0 based).
     
     - Returns: a `Completable` indicating success or an error.
     */
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
    
    /**
     Returns the current mission item index.
     
     If the mission is finished, the current mission item will be the total number of mission items (so the last mission item index + 1).
     
     - Returns: a `Single` containing the current mission item index (0 based).
     */
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
    
    /**
     Returns the total number of mission items.
     
     - Returns: a `Single` containing the total number of mission items.
     */
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
    
    /**
     Checks if mission has been finished.
 
     - Returns: `true` if mission is finished and the last mission item has been reached.
     */
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
                let call = try self.service.subscribeMissionProgress(missionProgressRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeMissionProgressReceiver").async {
                    do {
                        while let rpcMissionProgress = try call.receive()?.missionProgress {
                            let missionProgres = MissionProgress(currentItemIndex: rpcMissionProgress.currentItemIndex,
                                                                 missionCount: rpcMissionProgress.missionCount)
                            observer.onNext(missionProgres)
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
                observer.onError("Failed to subscribe to mission progress stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
}
