import Foundation
import RxSwift
import GRPC
import NIO

/**
 Acts as a vehicle and receives incoming missions from GCS (in raw MAVLINK format). 
 Provides current mission item state, so the server can progress through missions.
 */
public class MissionRawServer {
    private let service: Mavsdk_Rpc_MissionRawServer_MissionRawServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `MissionRawServer` plugin.

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
        let service = Mavsdk_Rpc_MissionRawServer_MissionRawServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_MissionRawServer_MissionRawServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeMissionRawServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct MissionRawServerError: Error {
        public let code: MissionRawServer.MissionRawServerResult.Result
        public let description: String
    }
    


    /**
     Mission item exactly identical to MAVLink MISSION_ITEM_INT.
     */
    public struct MissionItem: Equatable {
        public let seq: UInt32
        public let frame: UInt32
        public let command: UInt32
        public let current: UInt32
        public let autocontinue: UInt32
        public let param1: Float
        public let param2: Float
        public let param3: Float
        public let param4: Float
        public let x: Int32
        public let y: Int32
        public let z: Float
        public let missionType: UInt32

        

        /**
         Initializes a new `MissionItem`.

         
         - Parameters:
            
            - seq:  Sequence (uint16_t)
            
            - frame:  The coordinate system of the waypoint (actually uint8_t)
            
            - command:  The scheduled action for the waypoint (actually uint16_t)
            
            - current:  false:0, true:1 (actually uint8_t)
            
            - autocontinue:  Autocontinue to next waypoint (actually uint8_t)
            
            - param1:  PARAM1, see MAV_CMD enum
            
            - param2:  PARAM2, see MAV_CMD enum
            
            - param3:  PARAM3, see MAV_CMD enum
            
            - param4:  PARAM4, see MAV_CMD enum
            
            - x:  PARAM5 / local: x position in meters * 1e4, global: latitude in degrees * 10^7
            
            - y:  PARAM6 / y position: local: x position in meters * 1e4, global: longitude in degrees *10^7
            
            - z:  PARAM7 / local: Z coordinate, global: altitude (relative or absolute, depending on frame)
            
            - missionType:  Mission type (actually uint8_t)
            
         
         */
        public init(seq: UInt32, frame: UInt32, command: UInt32, current: UInt32, autocontinue: UInt32, param1: Float, param2: Float, param3: Float, param4: Float, x: Int32, y: Int32, z: Float, missionType: UInt32) {
            self.seq = seq
            self.frame = frame
            self.command = command
            self.current = current
            self.autocontinue = autocontinue
            self.param1 = param1
            self.param2 = param2
            self.param3 = param3
            self.param4 = param4
            self.x = x
            self.y = y
            self.z = z
            self.missionType = missionType
        }

        internal var rpcMissionItem: Mavsdk_Rpc_MissionRawServer_MissionItem {
            var rpcMissionItem = Mavsdk_Rpc_MissionRawServer_MissionItem()
            
                
            rpcMissionItem.seq = seq
                
            
            
                
            rpcMissionItem.frame = frame
                
            
            
                
            rpcMissionItem.command = command
                
            
            
                
            rpcMissionItem.current = current
                
            
            
                
            rpcMissionItem.autocontinue = autocontinue
                
            
            
                
            rpcMissionItem.param1 = param1
                
            
            
                
            rpcMissionItem.param2 = param2
                
            
            
                
            rpcMissionItem.param3 = param3
                
            
            
                
            rpcMissionItem.param4 = param4
                
            
            
                
            rpcMissionItem.x = x
                
            
            
                
            rpcMissionItem.y = y
                
            
            
                
            rpcMissionItem.z = z
                
            
            
                
            rpcMissionItem.missionType = missionType
                
            

            return rpcMissionItem
        }

        internal static func translateFromRpc(_ rpcMissionItem: Mavsdk_Rpc_MissionRawServer_MissionItem) -> MissionItem {
            return MissionItem(seq: rpcMissionItem.seq, frame: rpcMissionItem.frame, command: rpcMissionItem.command, current: rpcMissionItem.current, autocontinue: rpcMissionItem.autocontinue, param1: rpcMissionItem.param1, param2: rpcMissionItem.param2, param3: rpcMissionItem.param3, param4: rpcMissionItem.param4, x: rpcMissionItem.x, y: rpcMissionItem.y, z: rpcMissionItem.z, missionType: rpcMissionItem.missionType)
        }

        public static func == (lhs: MissionItem, rhs: MissionItem) -> Bool {
            return lhs.seq == rhs.seq
                && lhs.frame == rhs.frame
                && lhs.command == rhs.command
                && lhs.current == rhs.current
                && lhs.autocontinue == rhs.autocontinue
                && lhs.param1 == rhs.param1
                && lhs.param2 == rhs.param2
                && lhs.param3 == rhs.param3
                && lhs.param4 == rhs.param4
                && lhs.x == rhs.x
                && lhs.y == rhs.y
                && lhs.z == rhs.z
                && lhs.missionType == rhs.missionType
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

        internal var rpcMissionPlan: Mavsdk_Rpc_MissionRawServer_MissionPlan {
            var rpcMissionPlan = Mavsdk_Rpc_MissionRawServer_MissionPlan()
            
                
            rpcMissionPlan.missionItems = missionItems.map{ $0.rpcMissionItem }
                
            

            return rpcMissionPlan
        }

        internal static func translateFromRpc(_ rpcMissionPlan: Mavsdk_Rpc_MissionRawServer_MissionPlan) -> MissionPlan {
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

        internal var rpcMissionProgress: Mavsdk_Rpc_MissionRawServer_MissionProgress {
            var rpcMissionProgress = Mavsdk_Rpc_MissionRawServer_MissionProgress()
            
                
            rpcMissionProgress.current = current
                
            
            
                
            rpcMissionProgress.total = total
                
            

            return rpcMissionProgress
        }

        internal static func translateFromRpc(_ rpcMissionProgress: Mavsdk_Rpc_MissionRawServer_MissionProgress) -> MissionProgress {
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
    public struct MissionRawServerResult: Equatable {
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
            ///  Intermediate message showing progress or instructions on the next steps.
            case next
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult.Result {
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
                case .next:
                    return .next
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult.Result) -> Result {
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
                case .next:
                    return .next
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `MissionRawServerResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcMissionRawServerResult: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult {
            var rpcMissionRawServerResult = Mavsdk_Rpc_MissionRawServer_MissionRawServerResult()
            
                
            rpcMissionRawServerResult.result = result.rpcResult
                
            
            
                
            rpcMissionRawServerResult.resultStr = resultStr
                
            

            return rpcMissionRawServerResult
        }

        internal static func translateFromRpc(_ rpcMissionRawServerResult: Mavsdk_Rpc_MissionRawServer_MissionRawServerResult) -> MissionRawServerResult {
            return MissionRawServerResult(result: Result.translateFromRpc(rpcMissionRawServerResult.result), resultStr: rpcMissionRawServerResult.resultStr)
        }

        public static func == (lhs: MissionRawServerResult, rhs: MissionRawServerResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }



    /**
     Subscribe to when a new mission is uploaded (asynchronous).
     */
    public lazy var incomingMission: Observable<MissionPlan> = createIncomingMissionObservable()



    private func createIncomingMissionObservable() -> Observable<MissionPlan> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_MissionRawServer_SubscribeIncomingMissionRequest()

            

            _ = self.service.subscribeIncomingMission(request, handler: { (response) in

                
                     
                let incomingMission = MissionPlan.translateFromRpc(response.missionPlan)
                

                
                let result = MissionRawServerResult.translateFromRpc(response.missionRawServerResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(incomingMission)
                default:
                    observer.onError(MissionRawServerError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeMissionRawServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to when a new current item is set
     */
    public lazy var currentItemChanged: Observable<MissionItem> = createCurrentItemChangedObservable()



    private func createCurrentItemChangedObservable() -> Observable<MissionItem> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_MissionRawServer_SubscribeCurrentItemChangedRequest()

            

            _ = self.service.subscribeCurrentItemChanged(request, handler: { (response) in

                
                     
                let currentItemChanged = MissionItem.translateFromRpc(response.missionItem)
                

                
                observer.onNext(currentItemChanged)
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeMissionRawServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Set Current item as completed

     
     */
    public func setCurrentItemComplete() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_MissionRawServer_SetCurrentItemCompleteRequest()

            

            do {
                
                let _ = try self.service.setCurrentItemComplete(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe when a MISSION_CLEAR_ALL is received
     */
    public lazy var clearAll: Observable<UInt32> = createClearAllObservable()



    private func createClearAllObservable() -> Observable<UInt32> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_MissionRawServer_SubscribeClearAllRequest()

            

            _ = self.service.subscribeClearAll(request, handler: { (response) in

                
                     
                let clearAll = response.clearType_p
                    
                

                
                observer.onNext(clearAll)
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeMissionRawServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}