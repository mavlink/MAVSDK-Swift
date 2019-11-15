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
    


    public struct ShellMessage: Equatable {
        public let needResponse: Bool
        public let timeoutMs: UInt32
        public let data: String

        

        public init(needResponse: Bool, timeoutMs: UInt32, data: String) {
            self.needResponse = needResponse
            self.timeoutMs = timeoutMs
            self.data = data
        }

        internal var rpcShellMessage: Mavsdk_Rpc_Shell_ShellMessage {
            var rpcShellMessage = Mavsdk_Rpc_Shell_ShellMessage()
            
                
            rpcShellMessage.needResponse = needResponse
                
            
            
                
            rpcShellMessage.timeoutMs = timeoutMs
                
            
            
                
            rpcShellMessage.data = data
                
            

            return rpcShellMessage
        }

        internal static func translateFromRpc(_ rpcShellMessage: Mavsdk_Rpc_Shell_ShellMessage) -> ShellMessage {
            return ShellMessage(needResponse: rpcShellMessage.needResponse, timeoutMs: rpcShellMessage.timeoutMs, data: rpcShellMessage.data)
        }

        public static func == (lhs: ShellMessage, rhs: ShellMessage) -> Bool {
            return lhs.needResponse == rhs.needResponse
                && lhs.timeoutMs == rhs.timeoutMs
                && lhs.data == rhs.data
        }
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


    public func send(shellMessage: ShellMessage) -> Single<String> {
        return Single<String>.create { single in
            var request = Mavsdk_Rpc_Shell_SendRequest()

            
                
            request.shellMessage = shellMessage.rpcShellMessage
                
            

            do {
                let response = try self.service.send(request)

                
                if (response.shellResult.result != Mavsdk_Rpc_Shell_ShellResult.Result.success) {
                    single(.error(ShellError(code: ShellResult.Result.translateFromRpc(response.shellResult.result), description: response.shellResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let responseMessageData = response.responseMessageData
                
                single(.success(responseMessageData))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }
}