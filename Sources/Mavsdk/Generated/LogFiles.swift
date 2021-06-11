import Foundation
import RxSwift
import GRPC
import NIO

/**
 Allow to download log files from the vehicle after a flight is complete.
 For log streaming during flight check the logging plugin.
 */
public class LogFiles {
    private let service: Mavsdk_Rpc_LogFiles_LogFilesServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `LogFiles` plugin.

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
        let service = Mavsdk_Rpc_LogFiles_LogFilesServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_LogFiles_LogFilesServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
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
    


    /**
     Progress data coming when downloading a log file.
     */
    public struct ProgressData: Equatable {
        public let progress: Float

        

        /**
         Initializes a new `ProgressData`.

         
         - Parameter progress:  Progress from 0 to 1
         
         */
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

    /**
     Log file entry type.
     */
    public struct Entry: Equatable {
        public let id: UInt32
        public let date: String
        public let sizeBytes: UInt32

        

        /**
         Initializes a new `Entry`.

         
         - Parameters:
            
            - id:  ID of the log file, to specify a file to be downloaded
            
            - date:  Date of the log file in UTC in ISO 8601 format "yyyy-mm-ddThh:mm:ssZ"
            
            - sizeBytes:  Size of file in bytes
            
         
         */
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

    /**
     Result type.
     */
    public struct LogFilesResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for calibration commands
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  Progress update.
            case next
            ///  No log files found.
            case noLogfiles
            ///  A timeout happened.
            case timeout
            ///  Invalid argument.
            case invalidArgument
            ///  File open failed.
            case fileOpenFailed
            ///  No system is connected.
            case noSystem
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
                case .noSystem:
                    return .noSystem
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
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `LogFilesResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
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


    /**
     Get List of log files.

     
     */
    public func getEntries() -> Single<[Entry]> {
        return Single<[Entry]>.create { single in
            let request = Mavsdk_Rpc_LogFiles_GetEntriesRequest()

            

            do {
                let response = self.service.getEntries(request)

                
                let result = try response.response.wait().logFilesResult
                if (result.result != Mavsdk_Rpc_LogFiles_LogFilesResult.Result.success) {
                    single(.error(LogFilesError(code: LogFilesResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let entries = try response.response.wait().entries.map{ Entry.translateFromRpc($0) }
                
                single(.success(entries))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }




    /**
     Download log file.
     */

    public func downloadLogFile(entry: Entry, path: String) -> Observable<ProgressData> {
        return Observable.create { observer in
            var request = Mavsdk_Rpc_LogFiles_SubscribeDownloadLogFileRequest()

            
                
            request.entry = entry.rpcEntry
                
            
                
            request.path = path
                
            

            _ = self.service.subscribeDownloadLogFile(request, handler: { (response) in

                
                     
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
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeLogFilesError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}