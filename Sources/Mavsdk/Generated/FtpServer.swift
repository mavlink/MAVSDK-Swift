import Foundation
import RxSwift
import GRPC
import NIO

/**
 Provide files or directories to transfer.
 */
public class FtpServer {
    private let service: Mavsdk_Rpc_FtpServer_FtpServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `FtpServer` plugin.

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
        let service = Mavsdk_Rpc_FtpServer_FtpServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_FtpServer_FtpServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeFtpServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct FtpServerError: Error {
        public let code: FtpServer.FtpServerResult.Result
        public let description: String
    }
    


    /**
     Result type.
     */
    public struct FtpServerResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for FTP server requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  Directory does not exist.
            case doesNotExist
            ///  Operations in progress.
            case busy
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_FtpServer_FtpServerResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .doesNotExist:
                    return .doesNotExist
                case .busy:
                    return .busy
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_FtpServer_FtpServerResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .doesNotExist:
                    return .doesNotExist
                case .busy:
                    return .busy
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `FtpServerResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcFtpServerResult: Mavsdk_Rpc_FtpServer_FtpServerResult {
            var rpcFtpServerResult = Mavsdk_Rpc_FtpServer_FtpServerResult()
            
                
            rpcFtpServerResult.result = result.rpcResult
                
            
            
                
            rpcFtpServerResult.resultStr = resultStr
                
            

            return rpcFtpServerResult
        }

        internal static func translateFromRpc(_ rpcFtpServerResult: Mavsdk_Rpc_FtpServer_FtpServerResult) -> FtpServerResult {
            return FtpServerResult(result: Result.translateFromRpc(rpcFtpServerResult.result), resultStr: rpcFtpServerResult.resultStr)
        }

        public static func == (lhs: FtpServerResult, rhs: FtpServerResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Set root directory.

     This is the directory that can then be accessed by a client.
     The directory needs to exist when this is called.
     The permissions are the same as the file permission for the user running the server.
     The root directory can't be changed while an FTP process is in progress.

     - Parameter path: Absolute path of folder
     
     */
    public func setRootDir(path: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_FtpServer_SetRootDirRequest()

            
                
            request.path = path
                
            

            do {
                
                let response = self.service.setRootDir(request)

                let result = try response.response.wait().ftpServerResult
                if (result.result == Mavsdk_Rpc_FtpServer_FtpServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpServerError(code: FtpServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}