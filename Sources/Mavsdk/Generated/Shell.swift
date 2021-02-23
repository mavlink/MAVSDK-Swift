import Foundation
import RxSwift
import GRPC
import NIO

/**
 *
 Allow to communicate with the vehicle's system shell.
 */
public class Shell {
    private let service: Mavsdk_Rpc_Shell_ShellServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Shell` plugin.

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
        let service = Mavsdk_Rpc_Shell_ShellServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Shell_ShellServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeShellError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ShellError: Error {
        public let code: Shell.ShellResult.Result
        public let description: String
    }
    


    /**
     Result type.
     */
    public struct ShellResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for shell requests
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Response was not received.
            case noResponse
            ///  Shell busy (transfer in progress).
            case busy
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Shell_ShellResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .noResponse:
                    return .noResponse
                case .busy:
                    return .busy
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Shell_ShellResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .noResponse:
                    return .noResponse
                case .busy:
                    return .busy
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ShellResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcShellResult: Mavsdk_Rpc_Shell_ShellResult {
            var rpcShellResult = Mavsdk_Rpc_Shell_ShellResult()
            
                
            rpcShellResult.result = result.rpcResult
                
            
            
                
            rpcShellResult.resultStr = resultStr
                
            

            return rpcShellResult
        }

        internal static func translateFromRpc(_ rpcShellResult: Mavsdk_Rpc_Shell_ShellResult) -> ShellResult {
            return ShellResult(result: Result.translateFromRpc(rpcShellResult.result), resultStr: rpcShellResult.resultStr)
        }

        public static func == (lhs: ShellResult, rhs: ShellResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Send a command line.

     - Parameter command: The command line to send
     
     */
    public func send(command: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Shell_SendRequest()

            
                
            request.command = command
                
            

            do {
                
                let response = self.service.send(request)

                let result = try response.response.wait().shellResult
                if (result.result == Mavsdk_Rpc_Shell_ShellResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ShellError(code: ShellResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Receive feedback from a sent command line.

     This subscription needs to be made before a command line is sent, otherwise, no response will be sent.
     */
    public lazy var receive: Observable<String> = createReceiveObservable()



    private func createReceiveObservable() -> Observable<String> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Shell_SubscribeReceiveRequest()

            

            _ = self.service.subscribeReceive(request, handler: { (response) in

                
                     
                let receive = response.data
                    
                

                
                observer.onNext(receive)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeShellError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}