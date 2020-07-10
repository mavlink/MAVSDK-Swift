import Foundation
import RxSwift
import GRPC
import NIO

public class MissionRaw {
    private let service: Mavsdk_Rpc_MissionRaw_MissionRawServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_MissionRaw_MissionRawServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_MissionRaw_MissionRawServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeMissionRawError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct MissionRawError: Error {
        public let code: MissionRaw.MissionRawResult.Result
        public let description: String
    }
    


    public struct MissionProgress: Equatable {
        public let current: Int32
        public let total: Int32

        

        public init(current: Int32, total: Int32) {
            self.current = current
            self.total = total
        }

        internal var rpcMissionProgress: Mavsdk_Rpc_MissionRaw_MissionProgress {
            var rpcMissionProgress = Mavsdk_Rpc_MissionRaw_MissionProgress()
            
                
            rpcMissionProgress.current = current
                
            
            
                
            rpcMissionProgress.total = total
                
            

            return rpcMissionProgress
        }

        internal static func translateFromRpc(_ rpcMissionProgress: Mavsdk_Rpc_MissionRaw_MissionProgress) -> MissionProgress {
            return MissionProgress(current: rpcMissionProgress.current, total: rpcMissionProgress.total)
        }

        public static func == (lhs: MissionProgress, rhs: MissionProgress) -> Bool {
            return lhs.current == rhs.current
                && lhs.total == rhs.total
        }
    }

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

        internal var rpcMissionItem: Mavsdk_Rpc_MissionRaw_MissionItem {
            var rpcMissionItem = Mavsdk_Rpc_MissionRaw_MissionItem()
            
                
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

        internal static func translateFromRpc(_ rpcMissionItem: Mavsdk_Rpc_MissionRaw_MissionItem) -> MissionItem {
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

    public struct MissionRawResult: Equatable {
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
            case transferCancelled
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_MissionRaw_MissionRawResult.Result {
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
                case .transferCancelled:
                    return .transferCancelled
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_MissionRaw_MissionRawResult.Result) -> Result {
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

        internal var rpcMissionRawResult: Mavsdk_Rpc_MissionRaw_MissionRawResult {
            var rpcMissionRawResult = Mavsdk_Rpc_MissionRaw_MissionRawResult()
            
                
            rpcMissionRawResult.result = result.rpcResult
                
            
            
                
            rpcMissionRawResult.resultStr = resultStr
                
            

            return rpcMissionRawResult
        }

        internal static func translateFromRpc(_ rpcMissionRawResult: Mavsdk_Rpc_MissionRaw_MissionRawResult) -> MissionRawResult {
            return MissionRawResult(result: Result.translateFromRpc(rpcMissionRawResult.result), resultStr: rpcMissionRawResult.resultStr)
        }

        public static func == (lhs: MissionRawResult, rhs: MissionRawResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func uploadMission(missionItems: [MissionItem]) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_MissionRaw_UploadMissionRequest()

            
                
            missionItems.forEach({ elem in request.missionItems.append(elem.rpcMissionItem) })
                
            

            do {
                
                let response = self.service.uploadMission(request)

                let result = try response.response.wait().missionRawResult
                if (result.result == Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func cancelMissionUpload() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_MissionRaw_CancelMissionUploadRequest()

            

            do {
                
                let response = self.service.cancelMissionUpload(request)

                let result = try response.response.wait().missionRawResult
                if (result.result == Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func downloadMission() -> Single<[MissionItem]> {
        return Single<[MissionItem]>.create { single in
            let request = Mavsdk_Rpc_MissionRaw_DownloadMissionRequest()

            

            do {
                let response = self.service.downloadMission(request)

                
                let result = try response.response.wait().missionRawResult
                if (result.result != Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    single(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let missionItems = try response.response.wait().missionItems.map{ MissionItem.translateFromRpc($0) }
                
                single(.success(missionItems))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func cancelMissionDownload() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_MissionRaw_CancelMissionDownloadRequest()

            

            do {
                
                let response = self.service.cancelMissionDownload(request)

                let result = try response.response.wait().missionRawResult
                if (result.result == Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func startMission() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_MissionRaw_StartMissionRequest()

            

            do {
                
                let response = self.service.startMission(request)

                let result = try response.response.wait().missionRawResult
                if (result.result == Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func pauseMission() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_MissionRaw_PauseMissionRequest()

            

            do {
                
                let response = self.service.pauseMission(request)

                let result = try response.response.wait().missionRawResult
                if (result.result == Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func clearMission() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_MissionRaw_ClearMissionRequest()

            

            do {
                
                let response = self.service.clearMission(request)

                let result = try response.response.wait().missionRawResult
                if (result.result == Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setCurrentMissionItem(index: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_MissionRaw_SetCurrentMissionItemRequest()

            
                
            request.index = index
                
            

            do {
                
                let response = self.service.setCurrentMissionItem(request)

                let result = try response.response.wait().missionRawResult
                if (result.result == Mavsdk_Rpc_MissionRaw_MissionRawResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MissionRawError(code: MissionRawResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    public lazy var missionProgress: Observable<MissionProgress> = createMissionProgressObservable()


    private func createMissionProgressObservable() -> Observable<MissionProgress> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_MissionRaw_SubscribeMissionProgressRequest()

            

            _ = self.service.subscribeMissionProgress(request, handler: { (response) in

                
                     
                let missionProgress = MissionProgress.translateFromRpc(response.missionProgress)
                

                
                observer.onNext(missionProgress)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeMissionRawError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    public lazy var missionChanged: Observable<Bool> = createMissionChangedObservable()


    private func createMissionChangedObservable() -> Observable<Bool> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_MissionRaw_SubscribeMissionChangedRequest()

            

            _ = self.service.subscribeMissionChanged(request, handler: { (response) in

                
                     
                let missionChanged = response.missionChanged
                    
                

                
                observer.onNext(missionChanged)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeMissionRawError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}