import Foundation
import RxSwift
import SwiftGRPC

public class LogFiles {
    private let service: Mavsdk_Rpc_LogFiles_LogFilesServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_LogFiles_LogFilesServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_LogFiles_LogFilesServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeLogFilesError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct LogFilesError: Error {
        public let code: LogFiles.LogFilesResult.Result
        public let description: String
    }
    


    public struct ProgressData: Equatable {
        public let progress: Float

        

        public init(progress: Float) {
            self.progress = progress
        }

        internal var rpcProgressData: Mavsdk_Rpc_LogFiles_ProgressData {
            var rpcProgressData = Mavsdk_Rpc_LogFiles_ProgressData()
            
                
            rpcProgressData.progress = progress
                
            

            return rpcProgressData
        }

        internal static func translateFromRpc(_ rpcProgressData: Mavsdk_Rpc_LogFiles_ProgressData) -> ProgressData {
            return ProgressData(progress: rpcProgressData.progress)
        }

        public static func == (lhs: ProgressData, rhs: ProgressData) -> Bool {
            return lhs.progress == rhs.progress
        }
    }

    public struct Entry: Equatable {
        public let id: UInt32
        public let date: String
        public let sizeBytes: UInt32

        

        public init(id: UInt32, date: String, sizeBytes: UInt32) {
            self.id = id
            self.date = date
            self.sizeBytes = sizeBytes
        }

        internal var rpcEntry: Mavsdk_Rpc_LogFiles_Entry {
            var rpcEntry = Mavsdk_Rpc_LogFiles_Entry()
            
                
            rpcEntry.id = id
                
            
            
                
            rpcEntry.date = date
                
            
            
                
            rpcEntry.sizeBytes = sizeBytes
                
            

            return rpcEntry
        }

        internal static func translateFromRpc(_ rpcEntry: Mavsdk_Rpc_LogFiles_Entry) -> Entry {
            return Entry(id: rpcEntry.id, date: rpcEntry.date, sizeBytes: rpcEntry.sizeBytes)
        }

        public static func == (lhs: Entry, rhs: Entry) -> Bool {
            return lhs.id == rhs.id
                && lhs.date == rhs.date
                && lhs.sizeBytes == rhs.sizeBytes
        }
    }

    public struct LogFilesResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case next
            case noLogfiles
            case timeout
            case invalidArgument
            case fileOpenFailed
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_LogFiles_LogFilesResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .next:
                    return .next
                case .noLogfiles:
                    return .noLogfiles
                case .timeout:
                    return .timeout
                case .invalidArgument:
                    return .invalidArgument
                case .fileOpenFailed:
                    return .fileOpenFailed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_LogFiles_LogFilesResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .next:
                    return .next
                case .noLogfiles:
                    return .noLogfiles
                case .timeout:
                    return .timeout
                case .invalidArgument:
                    return .invalidArgument
                case .fileOpenFailed:
                    return .fileOpenFailed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcLogFilesResult: Mavsdk_Rpc_LogFiles_LogFilesResult {
            var rpcLogFilesResult = Mavsdk_Rpc_LogFiles_LogFilesResult()
            
                
            rpcLogFilesResult.result = result.rpcResult
                
            
            
                
            rpcLogFilesResult.resultStr = resultStr
                
            

            return rpcLogFilesResult
        }

        internal static func translateFromRpc(_ rpcLogFilesResult: Mavsdk_Rpc_LogFiles_LogFilesResult) -> LogFilesResult {
            return LogFilesResult(result: Result.translateFromRpc(rpcLogFilesResult.result), resultStr: rpcLogFilesResult.resultStr)
        }

        public static func == (lhs: LogFilesResult, rhs: LogFilesResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func getEntries() -> Single<[Entry]> {
        return Single<[Entry]>.create { single in
            let request = Mavsdk_Rpc_LogFiles_GetEntriesRequest()

            

            do {
                let response = try self.service.getEntries(request)

                
                if (response.logFilesResult.result != Mavsdk_Rpc_LogFiles_LogFilesResult.Result.success) {
                    single(.error(LogFilesError(code: LogFilesResult.Result.translateFromRpc(response.logFilesResult.result), description: response.logFilesResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let entries = response.entries.map{ Entry.translateFromRpc($0) }
                
                single(.success(entries))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }



    public func downloadLogFile(id: UInt32, path: String) -> Observable<ProgressData> {
        return Observable.create { observer in
            var request = Mavsdk_Rpc_LogFiles_SubscribeDownloadLogFileRequest()

            
                
            request.id = id
                
            
                
            request.path = path
                
            

            do {
                let call = try self.service.subscribeDownloadLogFile(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeLogFilesError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let downloadLogFile = ProgressData.translateFromRpc(response.progress)
                        

                        
                        let result = LogFilesResult.translateFromRpc(response.logFilesResult)

                        switch (result.result) {
                        case .success:
                            observer.onCompleted()
                        case .next:
                            observer.onNext(downloadLogFile)
                        default:
                            observer.onError(LogFilesError(code: result.result, description: result.resultStr))
                        }
                        
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
                guard $0 is RuntimeLogFilesError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}