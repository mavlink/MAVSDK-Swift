import Foundation
import RxSwift
import SwiftGRPC

public class Calibration {
    private let service: Mavsdk_Rpc_Calibration_CalibrationServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Calibration_CalibrationServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Calibration_CalibrationServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeCalibrationError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct CalibrationError: Error {
        public let code: Calibration.CalibrationResult.Result
        public let description: String
    }
    


    public struct CalibrationResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case inProgress
            case instruction
            case failed
            case noSystem
            case connectionError
            case busy
            case commandDenied
            case timeout
            case cancelled
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Calibration_CalibrationResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .inProgress:
                    return .inProgress
                case .instruction:
                    return .instruction
                case .failed:
                    return .failed
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
                case .cancelled:
                    return .cancelled
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Calibration_CalibrationResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .inProgress:
                    return .inProgress
                case .instruction:
                    return .instruction
                case .failed:
                    return .failed
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
                case .cancelled:
                    return .cancelled
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcCalibrationResult: Mavsdk_Rpc_Calibration_CalibrationResult {
            var rpcCalibrationResult = Mavsdk_Rpc_Calibration_CalibrationResult()
            
                
            rpcCalibrationResult.result = result.rpcResult
                
            
            
                
            rpcCalibrationResult.resultStr = resultStr
                
            

            return rpcCalibrationResult
        }

        internal static func translateFromRpc(_ rpcCalibrationResult: Mavsdk_Rpc_Calibration_CalibrationResult) -> CalibrationResult {
            return CalibrationResult(result: Result.translateFromRpc(rpcCalibrationResult.result), resultStr: rpcCalibrationResult.resultStr)
        }

        public static func == (lhs: CalibrationResult, rhs: CalibrationResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }

    public struct ProgressData: Equatable {
        public let hasProgress: Bool
        public let progress: Float
        public let hasStatusText: Bool
        public let statusText: String

        

        public init(hasProgress: Bool, progress: Float, hasStatusText: Bool, statusText: String) {
            self.hasProgress = hasProgress
            self.progress = progress
            self.hasStatusText = hasStatusText
            self.statusText = statusText
        }

        internal var rpcProgressData: Mavsdk_Rpc_Calibration_ProgressData {
            var rpcProgressData = Mavsdk_Rpc_Calibration_ProgressData()
            
                
            rpcProgressData.hasProgress_p = hasProgress
                
            
            
                
            rpcProgressData.progress = progress
                
            
            
                
            rpcProgressData.hasStatusText_p = hasStatusText
                
            
            
                
            rpcProgressData.statusText = statusText
                
            

            return rpcProgressData
        }

        internal static func translateFromRpc(_ rpcProgressData: Mavsdk_Rpc_Calibration_ProgressData) -> ProgressData {
            return ProgressData(hasProgress: rpcProgressData.hasProgress_p, progress: rpcProgressData.progress, hasStatusText: rpcProgressData.hasStatusText_p, statusText: rpcProgressData.statusText)
        }

        public static func == (lhs: ProgressData, rhs: ProgressData) -> Bool {
            return lhs.hasProgress == rhs.hasProgress
                && lhs.progress == rhs.progress
                && lhs.hasStatusText == rhs.hasStatusText
                && lhs.statusText == rhs.statusText
        }
    }


    public lazy var calibrateGyro: Observable<ProgressData> = createCalibrateGyroObservable()

    private func createCalibrateGyroObservable() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest()

            

            do {
                let call = try self.service.subscribeCalibrateGyro(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCalibrationError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let calibrateGyro = ProgressData.translateFromRpc(response.progressData)
                        

                        
                        let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                        switch (result.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(calibrateGyro)
                        default:
                            observer.onError(CalibrationError(code: result.result, description: result.resultStr))
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
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var calibrateAccelerometer: Observable<ProgressData> = createCalibrateAccelerometerObservable()

    private func createCalibrateAccelerometerObservable() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest()

            

            do {
                let call = try self.service.subscribeCalibrateAccelerometer(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCalibrationError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let calibrateAccelerometer = ProgressData.translateFromRpc(response.progressData)
                        

                        
                        let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                        switch (result.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(calibrateAccelerometer)
                        default:
                            observer.onError(CalibrationError(code: result.result, description: result.resultStr))
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
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var calibrateMagnetometer: Observable<ProgressData> = createCalibrateMagnetometerObservable()

    private func createCalibrateMagnetometerObservable() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest()

            

            do {
                let call = try self.service.subscribeCalibrateMagnetometer(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCalibrationError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let calibrateMagnetometer = ProgressData.translateFromRpc(response.progressData)
                        

                        
                        let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                        switch (result.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(calibrateMagnetometer)
                        default:
                            observer.onError(CalibrationError(code: result.result, description: result.resultStr))
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
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public lazy var calibrateGimbalAccelerometer: Observable<ProgressData> = createCalibrateGimbalAccelerometerObservable()

    private func createCalibrateGimbalAccelerometerObservable() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest()

            

            do {
                let call = try self.service.subscribeCalibrateGimbalAccelerometer(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCalibrationError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let calibrateGimbalAccelerometer = ProgressData.translateFromRpc(response.progressData)
                        

                        
                        let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                        switch (result.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(calibrateGimbalAccelerometer)
                        default:
                            observer.onError(CalibrationError(code: result.result, description: result.resultStr))
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
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    public func cancel() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Calibration_CancelRequest()

            

            do {
                
                let _ = try self.service.cancel(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}