import Foundation
import RxSwift
import GRPC
import NIO

/**
 Implements file transfer functionality using MAVLink FTP.
 */
public class Ftp {
    private let service: Mavsdk_Rpc_Ftp_FtpServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Ftp` plugin.

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
        let service = Mavsdk_Rpc_Ftp_FtpServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Ftp_FtpServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeFtpError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct FtpError: Error {
        public let code: Ftp.FtpResult.Result
        public let description: String
    }
    


    /**
     Progress data type for file transfer.
     */
    public struct ProgressData: Equatable {
        public let bytesTransferred: UInt32
        public let totalBytes: UInt32

        

        /**
         Initializes a new `ProgressData`.

         
         - Parameters:
            
            - bytesTransferred:  The number of bytes already transferred.
            
            - totalBytes:  The total bytes to transfer.
            
         
         */
        public init(bytesTransferred: UInt32, totalBytes: UInt32) {
            self.bytesTransferred = bytesTransferred
            self.totalBytes = totalBytes
        }

        internal var rpcProgressData: Mavsdk_Rpc_Ftp_ProgressData {
            var rpcProgressData = Mavsdk_Rpc_Ftp_ProgressData()
            
                
            rpcProgressData.bytesTransferred = bytesTransferred
                
            
            
                
            rpcProgressData.totalBytes = totalBytes
                
            

            return rpcProgressData
        }

        internal static func translateFromRpc(_ rpcProgressData: Mavsdk_Rpc_Ftp_ProgressData) -> ProgressData {
            return ProgressData(bytesTransferred: rpcProgressData.bytesTransferred, totalBytes: rpcProgressData.totalBytes)
        }

        public static func == (lhs: ProgressData, rhs: ProgressData) -> Bool {
            return lhs.bytesTransferred == rhs.bytesTransferred
                && lhs.totalBytes == rhs.totalBytes
        }
    }

    /**
     Result type.
     */
    public struct FtpResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for FTP commands
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Success.
            case success
            ///  Intermediate message showing progress.
            case next
            ///  Timeout.
            case timeout
            ///  Operation is already in progress.
            case busy
            ///  File IO operation error.
            case fileIoError
            ///  File exists already.
            case fileExists
            ///  File does not exist.
            case fileDoesNotExist
            ///  File is write protected.
            case fileProtected
            ///  Invalid parameter.
            case invalidParameter
            ///  Unsupported command.
            case unsupported
            ///  General protocol error.
            case protocolError
            ///  No system connected.
            case noSystem
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Ftp_FtpResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .next:
                    return .next
                case .timeout:
                    return .timeout
                case .busy:
                    return .busy
                case .fileIoError:
                    return .fileIoError
                case .fileExists:
                    return .fileExists
                case .fileDoesNotExist:
                    return .fileDoesNotExist
                case .fileProtected:
                    return .fileProtected
                case .invalidParameter:
                    return .invalidParameter
                case .unsupported:
                    return .unsupported
                case .protocolError:
                    return .protocolError
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Ftp_FtpResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .next:
                    return .next
                case .timeout:
                    return .timeout
                case .busy:
                    return .busy
                case .fileIoError:
                    return .fileIoError
                case .fileExists:
                    return .fileExists
                case .fileDoesNotExist:
                    return .fileDoesNotExist
                case .fileProtected:
                    return .fileProtected
                case .invalidParameter:
                    return .invalidParameter
                case .unsupported:
                    return .unsupported
                case .protocolError:
                    return .protocolError
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `FtpResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcFtpResult: Mavsdk_Rpc_Ftp_FtpResult {
            var rpcFtpResult = Mavsdk_Rpc_Ftp_FtpResult()
            
                
            rpcFtpResult.result = result.rpcResult
                
            
            
                
            rpcFtpResult.resultStr = resultStr
                
            

            return rpcFtpResult
        }

        internal static func translateFromRpc(_ rpcFtpResult: Mavsdk_Rpc_Ftp_FtpResult) -> FtpResult {
            return FtpResult(result: Result.translateFromRpc(rpcFtpResult.result), resultStr: rpcFtpResult.resultStr)
        }

        public static func == (lhs: FtpResult, rhs: FtpResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Resets FTP server in case there are stale open sessions.

     
     */
    public func reset() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Ftp_ResetRequest()

            

            do {
                
                let response = self.service.reset(request)

                let result = try response.response.wait().ftpResult
                if (result.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }




    /**
     Downloads a file to local directory.
     */

    public func download(remoteFilePath: String, localDir: String) -> Observable<ProgressData> {
        return Observable.create { observer in
            var request = Mavsdk_Rpc_Ftp_SubscribeDownloadRequest()

            
                
            request.remoteFilePath = remoteFilePath
                
            
                
            request.localDir = localDir
                
            

            _ = self.service.subscribeDownload(request, handler: { (response) in

                
                     
                let download = ProgressData.translateFromRpc(response.progressData)
                

                
                let result = FtpResult.translateFromRpc(response.ftpResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(download)
                default:
                    observer.onError(FtpError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeFtpError else { throw $0 }
            }
        }
        .share(replay: 1)
    }




    /**
     Uploads local file to remote directory.
     */

    public func upload(localFilePath: String, remoteDir: String) -> Observable<ProgressData> {
        return Observable.create { observer in
            var request = Mavsdk_Rpc_Ftp_SubscribeUploadRequest()

            
                
            request.localFilePath = localFilePath
                
            
                
            request.remoteDir = remoteDir
                
            

            _ = self.service.subscribeUpload(request, handler: { (response) in

                
                     
                let upload = ProgressData.translateFromRpc(response.progressData)
                

                
                let result = FtpResult.translateFromRpc(response.ftpResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(upload)
                default:
                    observer.onError(FtpError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeFtpError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Lists items from a remote directory.

     - Parameter remoteDir: The remote directory to list the contents for.
     
     */
    public func listDirectory(remoteDir: String) -> Single<[String]> {
        return Single<[String]>.create { single in
            var request = Mavsdk_Rpc_Ftp_ListDirectoryRequest()

            
                
            request.remoteDir = remoteDir
                
            

            do {
                let response = self.service.listDirectory(request)

                
                let result = try response.response.wait().ftpResult
                if (result.result != Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    single(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let paths = try response.response.wait().paths
                
                single(.success(paths))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Creates a remote directory.

     - Parameter remoteDir: The remote directory to create.
     
     */
    public func createDirectory(remoteDir: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_CreateDirectoryRequest()

            
                
            request.remoteDir = remoteDir
                
            

            do {
                
                let response = self.service.createDirectory(request)

                let result = try response.response.wait().ftpResult
                if (result.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Removes a remote directory.

     - Parameter remoteDir: The remote directory to remove.
     
     */
    public func removeDirectory(remoteDir: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_RemoveDirectoryRequest()

            
                
            request.remoteDir = remoteDir
                
            

            do {
                
                let response = self.service.removeDirectory(request)

                let result = try response.response.wait().ftpResult
                if (result.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Removes a remote file.

     - Parameter remoteFilePath: The path of the remote file to remove.
     
     */
    public func removeFile(remoteFilePath: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_RemoveFileRequest()

            
                
            request.remoteFilePath = remoteFilePath
                
            

            do {
                
                let response = self.service.removeFile(request)

                let result = try response.response.wait().ftpResult
                if (result.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Renames a remote file or remote directory.

     - Parameters:
        - remoteFromPath: The remote source path.
        - remoteToPath: The remote destination path.
     
     */
    public func rename(remoteFromPath: String, remoteToPath: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_RenameRequest()

            
                
            request.remoteFromPath = remoteFromPath
                
            
                
            request.remoteToPath = remoteToPath
                
            

            do {
                
                let response = self.service.rename(request)

                let result = try response.response.wait().ftpResult
                if (result.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Compares a local file to a remote file using a CRC32 checksum.

     - Parameters:
        - localFilePath: The path of the local file.
        - remoteFilePath: The path of the remote file.
     
     */
    public func areFilesIdentical(localFilePath: String, remoteFilePath: String) -> Single<Bool> {
        return Single<Bool>.create { single in
            var request = Mavsdk_Rpc_Ftp_AreFilesIdenticalRequest()

            
                
            request.localFilePath = localFilePath
                
            
                
            request.remoteFilePath = remoteFilePath
                
            

            do {
                let response = self.service.areFilesIdentical(request)

                
                let result = try response.response.wait().ftpResult
                if (result.result != Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    single(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let areIdentical = try response.response.wait().areIdentical
                
                single(.success(areIdentical))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set root directory for MAVLink FTP server.

     - Parameter rootDir: The root directory to set.
     
     */
    public func setRootDirectory(rootDir: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_SetRootDirectoryRequest()

            
                
            request.rootDir = rootDir
                
            

            do {
                
                let response = self.service.setRootDirectory(request)

                let result = try response.response.wait().ftpResult
                if (result.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set target component ID. By default it is the autopilot.

     - Parameter compid: The component ID to set.
     
     */
    public func setTargetCompid(compid: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_SetTargetCompidRequest()

            
                
            request.compid = compid
                
            

            do {
                
                let response = self.service.setTargetCompid(request)

                let result = try response.response.wait().ftpResult
                if (result.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get our own component ID.

     
     */
    public func getOurCompid() -> Single<UInt32> {
        return Single<UInt32>.create { single in
            let request = Mavsdk_Rpc_Ftp_GetOurCompidRequest()

            

            do {
                let response = self.service.getOurCompid(request)

                

    	    let compid = try response.response.wait().compid
                
                single(.success(compid))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }
}