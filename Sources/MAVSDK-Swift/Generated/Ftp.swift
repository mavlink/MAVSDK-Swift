import Foundation
import RxSwift
import SwiftGRPC

public class Ftp {
    private let service: Mavsdk_Rpc_Ftp_FtpServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Ftp_FtpServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Ftp_FtpServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
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
    


    public struct ProgressData: Equatable {
        public let bytesTransferred: UInt32
        public let totalBytes: UInt32

        

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

    public struct FtpResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case next
            case timeout
            case busy
            case fileIoError
            case fileExists
            case fileDoesNotExist
            case fileProtected
            case invalidParameter
            case unsupported
            case protocolError
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

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


    public func reset() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Ftp_ResetRequest()

            

            do {
                
                let response = try self.service.reset(request)

                if (response.ftpResult.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }



    public func download(remoteFilePath: String, localDir: String) -> Observable<ProgressData> {
        return Observable.create { observer in
            var request = Mavsdk_Rpc_Ftp_SubscribeDownloadRequest()

            
                
            request.remoteFilePath = remoteFilePath
                
            
                
            request.localDir = localDir
                
            

            do {
                let call = try self.service.subscribeDownload(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeFtpError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
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
                guard $0 is RuntimeFtpError else { throw $0 }
            }
        }
        .share(replay: 1)
    }



    public func upload(localFilePath: String, remoteDir: String) -> Observable<ProgressData> {
        return Observable.create { observer in
            var request = Mavsdk_Rpc_Ftp_SubscribeUploadRequest()

            
                
            request.localFilePath = localFilePath
                
            
                
            request.remoteDir = remoteDir
                
            

            do {
                let call = try self.service.subscribeUpload(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeFtpError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
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
                guard $0 is RuntimeFtpError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public func listDirectory(remoteDir: String) -> Single<[String]> {
        return Single<[String]>.create { single in
            var request = Mavsdk_Rpc_Ftp_ListDirectoryRequest()

            
                
            request.remoteDir = remoteDir
                
            

            do {
                let response = try self.service.listDirectory(request)

                
                if (response.ftpResult.result != Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    single(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))

                    return Disposables.create()
                }
                

                let paths = response.paths
                
                single(.success(paths))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func createDirectory(remoteDir: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_CreateDirectoryRequest()

            
                
            request.remoteDir = remoteDir
                
            

            do {
                
                let response = try self.service.createDirectory(request)

                if (response.ftpResult.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func removeDirectory(remoteDir: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_RemoveDirectoryRequest()

            
                
            request.remoteDir = remoteDir
                
            

            do {
                
                let response = try self.service.removeDirectory(request)

                if (response.ftpResult.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func removeFile(remoteFilePath: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_RemoveFileRequest()

            
                
            request.remoteFilePath = remoteFilePath
                
            

            do {
                
                let response = try self.service.removeFile(request)

                if (response.ftpResult.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func rename(remoteFromPath: String, remoteToPath: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_RenameRequest()

            
                
            request.remoteFromPath = remoteFromPath
                
            
                
            request.remoteToPath = remoteToPath
                
            

            do {
                
                let response = try self.service.rename(request)

                if (response.ftpResult.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func areFilesIdentical(localFilePath: String, remoteFilePath: String) -> Single<Bool> {
        return Single<Bool>.create { single in
            var request = Mavsdk_Rpc_Ftp_AreFilesIdenticalRequest()

            
                
            request.localFilePath = localFilePath
                
            
                
            request.remoteFilePath = remoteFilePath
                
            

            do {
                let response = try self.service.areFilesIdentical(request)

                
                if (response.ftpResult.result != Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    single(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))

                    return Disposables.create()
                }
                

                let areIdentical = response.areIdentical
                
                single(.success(areIdentical))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setRootDirectory(rootDir: String) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_SetRootDirectoryRequest()

            
                
            request.rootDir = rootDir
                
            

            do {
                
                let response = try self.service.setRootDirectory(request)

                if (response.ftpResult.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setTargetComponentID(componentID: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Ftp_SetTargetComponentIdRequest()

            
                
            request.componentID = componentID
                
            

            do {
                
                let response = try self.service.setTargetComponentId(request)

                if (response.ftpResult.result == Mavsdk_Rpc_Ftp_FtpResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FtpError(code: FtpResult.Result.translateFromRpc(response.ftpResult.result), description: response.ftpResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getOurComponentID() -> Single<UInt32> {
        return Single<UInt32>.create { single in
            let request = Mavsdk_Rpc_Ftp_GetOurComponentIdRequest()

            

            do {
                let response = try self.service.getOurComponentId(request)

                

                let componentID = response.componentID
                
                single(.success(componentID))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }
}
