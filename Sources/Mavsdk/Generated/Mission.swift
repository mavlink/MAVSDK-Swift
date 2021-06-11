import Foundation
import RxSwift
import GRPC
import NIO

/**
 Enable waypoint missions.
 */
public class Mission {
    private let service: Mavsdk_Rpc_Mission_MissionServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Mission` plugin.

     Normally never created manually, but used from the `Drone` helper class instead.

     - Parameters:
        - address: The address of the `MavsdkServer` instance to connect to
        - port: The port of the `MavsdkServer` instance to connect to
        - scheduler: The scheduler to be used by `Observable`s
     */
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
    


    /**
     Type representing a mission item.

     A MissionItem can contain a position and/or actions.
     Mission items are building blocks to assemble a mission,
     which can be sent to (or received from) a system.
     They cannot be used independently.
     */
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
        public let acceptanceRadiusM: Float

        
        

        /**
         Possible camera actions at a mission item.
         */
        public enum CameraAction: Equatable {
            ///  No action.
            case none
            ///  Take a single photo.
            case takePhoto
            ///  Start capturing photos at regular intervals.
            case startPhotoInterval
            ///  Stop capturing photos at regular intervals.
            case stopPhotoInterval
            ///  Start capturing video.
            case startVideo
            ///  Stop capturing video.
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
        

        /**
         Initializes a new `MissionItem`.

         
         - Parameters:
            
            - latitudeDeg:  Latitude in degrees (range: -90 to +90)
            
            - longitudeDeg:  Longitude in degrees (range: -180 to +180)
            
            - relativeAltitudeM:  Altitude relative to takeoff altitude in metres
            
            - speedMS:  Speed to use after this mission item (in metres/second)
            
            - isFlyThrough:  True will make the drone fly through without stopping, while false will make the drone stop on the waypoint
            
            - gimbalPitchDeg:  Gimbal pitch (in degrees)
            
            - gimbalYawDeg:  Gimbal yaw (in degrees)
            
            - cameraAction:  Camera action to trigger at this mission item
            
            - loiterTimeS:  Loiter time (in seconds)
            
            - cameraPhotoIntervalS:  Camera photo interval to use after this mission item (in seconds)
            
            - acceptanceRadiusM:  Radius for completing a mission item (in metres)
            
         
         */
        public init(latitudeDeg: Double, longitudeDeg: Double, relativeAltitudeM: Float, speedMS: Float, isFlyThrough: Bool, gimbalPitchDeg: Float, gimbalYawDeg: Float, cameraAction: CameraAction, loiterTimeS: Float, cameraPhotoIntervalS: Double, acceptanceRadiusM: Float) {
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
            self.acceptanceRadiusM = acceptanceRadiusM
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
                
            
            
                
            rpcMissionItem.acceptanceRadiusM = acceptanceRadiusM
                
            

            return rpcMissionItem
        }

        internal static func translateFromRpc(_ rpcMissionItem: Mavsdk_Rpc_Mission_MissionItem) -> MissionItem {
            return MissionItem(latitudeDeg: rpcMissionItem.latitudeDeg, longitudeDeg: rpcMissionItem.longitudeDeg, relativeAltitudeM: rpcMissionItem.relativeAltitudeM, speedMS: rpcMissionItem.speedMS, isFlyThrough: rpcMissionItem.isFlyThrough, gimbalPitchDeg: rpcMissionItem.gimbalPitchDeg, gimbalYawDeg: rpcMissionItem.gimbalYawDeg, cameraAction: CameraAction.translateFromRpc(rpcMissionItem.cameraAction), loiterTimeS: rpcMissionItem.loiterTimeS, cameraPhotoIntervalS: rpcMissionItem.cameraPhotoIntervalS, acceptanceRadiusM: rpcMissionItem.acceptanceRadiusM)
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
                && lhs.acceptanceRadiusM == rhs.acceptanceRadiusM
        }
    }

    /**
     Mission plan type
     */
    public struct MissionPlan: Equatable {
        public let missionItems: [MissionItem]

        

        /**
         Initializes a new `MissionPlan`.

         
         - Parameter missionItems:  The mission items
         
         */
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

    /**
     Mission progress type.
     */
    public struct MissionProgress: Equatable {
        public let current: Int32
        public let total: Int32

        

        /**
         Initializes a new `MissionProgress`.

         
         - Parameters:
            
            - current:  Current mission item index (0-based), if equal to total, the mission is finished
            
            - total:  Total number of mission items
            
         
         */
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

    /**
     Result type.
     */
    public struct MissionResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for action requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  Error.
            case error
            ///  Too many mission items in the mission.
            case tooManyMissionItems
            ///  Vehicle is busy.
            case busy
            ///  Request timed out.
            case timeout
            ///  Invalid argument.
            case invalidArgument
            ///  Mission downloaded from the system is not supported.
            case unsupported
            ///  No mission available on the system.
            case noMissionAvailable
            ///  Unsupported mission command.
            case unsupportedMissionCmd
            ///  Mission transfer (upload or download) has been cancelled.
            case transferCancelled
            ///  No system connected.
            case noSystem
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
                case .unsupportedMissionCmd:
                    return .unsupportedMissionCmd
                case .transferCancelled:
                    return .transferCancelled
                case .noSystem:
                    return .noSystem
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
                case .unsupportedMissionCmd:
                    return .unsupportedMissionCmd
                case .transferCancelled:
                    return .transferCancelled
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `MissionResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
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


    /**
     Upload a list of mission items to the system.

     The mission items are uploaded to a drone. Once uploaded the mission can be started and
     executed even if the connection is lost.

     - Parameter missionPlan: The mission plan
     
     */
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

    /**
     Cancel an ongoing mission upload.

     
     */
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

    /**
     Download a list of mission items from the system (asynchronous).

     Will fail if any of the downloaded mission items are not supported
     by the MAVSDK API.

     
     */
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

    /**
     Cancel an ongoing mission download.

     
     */
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

    /**
     Start the mission.

     A mission must be uploaded to the vehicle before this can be called.

     
     */
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

    /**
     Pause the mission.

     Pausing the mission puts the vehicle into
     [HOLD mode](https://docs.px4.io/en/flight_modes/hold.html).
     A multicopter should just hover at the spot while a fixedwing vehicle should loiter
     around the location where it paused.

     
     */
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

    /**
     Clear the mission saved on the vehicle.

     
     */
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

    /**
     Sets the mission item index to go to.

     By setting the current index to 0, the mission is restarted from the beginning. If it is set
     to a specific index of a mission item, the mission will be set to this item.

     Note that this is not necessarily true for general missions using MAVLink if loop counters
     are used.

     - Parameter index: Index of the mission item to be set as the next one (0-based)
     
     */
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

    /**
     Check if the mission has been finished.

     
     */
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


    /**
     Subscribe to mission progress updates.
     */
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

    /**
     Get whether to trigger Return-to-Launch (RTL) after mission is complete.

     Before getting this option, it needs to be set, or a mission
     needs to be downloaded.

     
     */
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

    /**
     Set whether to trigger Return-to-Launch (RTL) after the mission is complete.

     This will only take effect for the next mission upload, meaning that
     the mission may have to be uploaded again.

     - Parameter enable: If true, trigger an RTL at the end of the mission
     
     */
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
}