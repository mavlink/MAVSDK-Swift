import Foundation
import RxSwift
import SwiftGRPC

public class Shell {
    private let service: Mavsdk_Rpc_Shell_ShellServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Shell_ShellServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Shell_ShellServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
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
    


    public struct ShellResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case noSystem
            case connectionError
            case noResponse
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


    public func send(command: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Shell_SendRequest()

            
                
            request.command = command
                
            

            do {
                
                let response = try self.service.send(request)

                if (response.shellResult.result == Mavsdk_Rpc_Shell_ShellResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ShellError(code: ShellResult.Result.translateFromRpc(response.shellResult.result), description: response.shellResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    public lazy var receive: Observable<String> = createReceiveObservable()


    private func createReceiveObservable() -> Observable<String> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Shell_SubscribeReceiveRequest()

            

            do {
                let call = try self.service.subscribeReceive(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeShellError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let receive = response.data
                            
                        

                        
                        observer.onNext(receive)
                        
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
                guard $0 is RuntimeShellError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}