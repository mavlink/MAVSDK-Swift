import Foundation
import RxSwift
import GRPC
import NIO

/**
 Provide log streaming data.
 */
public class LogStreaming {
    private let service: Mavsdk_Rpc_LogStreaming_LogStreamingServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `LogStreaming` plugin.

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
        let service = Mavsdk_Rpc_LogStreaming_LogStreamingServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_LogStreaming_LogStreamingServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeLogStreamingError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct LogStreamingError: Error {
        public let code: LogStreaming.LogStreamingResult.Result
        public let description: String
    }
    


    /**
     Raw logging data type
     */
    public struct LogStreamingRaw: Equatable {
        public let dataBase64: String

        

        /**
         Initializes a new `LogStreamingRaw`.

         
         - Parameter dataBase64:  Ulog file stream data encoded as base64
         
         */
        public init(dataBase64: String) {
            self.dataBase64 = dataBase64
        }

        internal var rpcLogStreamingRaw: Mavsdk_Rpc_LogStreaming_LogStreamingRaw {
            var rpcLogStreamingRaw = Mavsdk_Rpc_LogStreaming_LogStreamingRaw()
            
                
            rpcLogStreamingRaw.dataBase64 = dataBase64
                
            

            return rpcLogStreamingRaw
        }

        internal static func translateFromRpc(_ rpcLogStreamingRaw: Mavsdk_Rpc_LogStreaming_LogStreamingRaw) -> LogStreamingRaw {
            return LogStreamingRaw(dataBase64: rpcLogStreamingRaw.dataBase64)
        }

        public static func == (lhs: LogStreamingRaw, rhs: LogStreamingRaw) -> Bool {
            return lhs.dataBase64 == rhs.dataBase64
        }
    }

    /**
     Result type.
     */
    public struct LogStreamingResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for logging requests
         */
        public enum Result: Equatable {
            ///  Request succeeded.
            case success
            ///  No system connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  System busy.
            case busy
            ///  Command denied.
            case commandDenied
            ///  Timeout.
            case timeout
            ///  Unsupported.
            case unsupported
            ///  Unknown error.
            case unknown
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_LogStreaming_LogStreamingResult.Result {
                switch self {
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .busy:
                    return .busy
                case .commandDenied:
                    return .commandDenied
                case .timeout:
                    return .timeout
                case .unsupported:
                    return .unsupported
                case .unknown:
                    return .unknown
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_LogStreaming_LogStreamingResult.Result) -> Result {
                switch rpcResult {
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .busy:
                    return .busy
                case .commandDenied:
                    return .commandDenied
                case .timeout:
                    return .timeout
                case .unsupported:
                    return .unsupported
                case .unknown:
                    return .unknown
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `LogStreamingResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcLogStreamingResult: Mavsdk_Rpc_LogStreaming_LogStreamingResult {
            var rpcLogStreamingResult = Mavsdk_Rpc_LogStreaming_LogStreamingResult()
            
                
            rpcLogStreamingResult.result = result.rpcResult
                
            
            
                
            rpcLogStreamingResult.resultStr = resultStr
                
            

            return rpcLogStreamingResult
        }

        internal static func translateFromRpc(_ rpcLogStreamingResult: Mavsdk_Rpc_LogStreaming_LogStreamingResult) -> LogStreamingResult {
            return LogStreamingResult(result: Result.translateFromRpc(rpcLogStreamingResult.result), resultStr: rpcLogStreamingResult.resultStr)
        }

        public static func == (lhs: LogStreamingResult, rhs: LogStreamingResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Start streaming logging data.

     
     */
    public func startLogStreaming() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_LogStreaming_StartLogStreamingRequest()

            

            do {
                
                let response = self.service.startLogStreaming(request)

                let result = try response.response.wait().logStreamingResult
                if (result.result == Mavsdk_Rpc_LogStreaming_LogStreamingResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(LogStreamingError(code: LogStreamingResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Stop streaming logging data.

     
     */
    public func stopLogStreaming() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_LogStreaming_StopLogStreamingRequest()

            

            do {
                
                let response = self.service.stopLogStreaming(request)

                let result = try response.response.wait().logStreamingResult
                if (result.result == Mavsdk_Rpc_LogStreaming_LogStreamingResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(LogStreamingError(code: LogStreamingResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to logging messages
     */
    public lazy var logStreamingRaw: Observable<LogStreamingRaw> = createLogStreamingRawObservable()



    private func createLogStreamingRawObservable() -> Observable<LogStreamingRaw> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_LogStreaming_SubscribeLogStreamingRawRequest()

            

            let serverStreamingCall = self.service.subscribeLogStreamingRaw(request, handler: { (response) in

                
                     
                let logStreamingRaw = LogStreamingRaw.translateFromRpc(response.loggingRaw)
                

                
                observer.onNext(logStreamingRaw)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeLogStreamingError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}