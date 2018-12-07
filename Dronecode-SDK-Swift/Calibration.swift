import Foundation
import RxSwift
import SwiftGRPC

public class Calibration {
    private let service: DronecodeSdk_Rpc_Calibration_CalibrationServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Calibration_CalibrationServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Calibration_CalibrationServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public enum Result {
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

        internal var rpcResult: DronecodeSdk_Rpc_Calibration_CalibrationResult.Result {
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
            }
        }

        internal static func translateFromRPC(_ rpcResult: DronecodeSdk_Rpc_Calibration_CalibrationResult.Result) -> Result {
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
            case .UNRECOGNIZED(_):
                return .cancelled
            }
        }
    }


    public struct CalibrationResult: Equatable {
        public let result: Result
        public let resultStr: String

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcCalibrationResult: DronecodeSdk_Rpc_Calibration_CalibrationResult {
            var rpcCalibrationResult = DronecodeSdk_Rpc_Calibration_CalibrationResult()
            rpcCalibrationResult.result = result.rpcResult
            rpcCalibrationResult.resultStr = resultStr

            return rpcCalibrationResult
        }

        internal static func translateFromRPC(_ rpcCalibrationResult: DronecodeSdk_Rpc_Calibration_CalibrationResult) -> CalibrationResult {
            return CalibrationResult(result: Result.translateFromRPC(rpcCalibrationResult.result), resultStr: rpcCalibrationResult.resultStr)
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

        internal var rpcProgressData: DronecodeSdk_Rpc_Calibration_ProgressData {
            var rpcProgressData = DronecodeSdk_Rpc_Calibration_ProgressData()
            rpcProgressData.hasProgress_p = hasProgress
            rpcProgressData.progress = progress
            rpcProgressData.hasStatusText_p = hasStatusText
            rpcProgressData.statusText = statusText

            return rpcProgressData
        }

        internal static func translateFromRPC(_ rpcProgressData: DronecodeSdk_Rpc_Calibration_ProgressData) -> ProgressData {
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
            let calibrateGyroRequest = DronecodeSdk_Rpc_Calibration_SubscribeCalibrateGyroRequest()

            do {
                let call = try self.service.subscribeCalibrateGyro(calibrateGyroRequest, completion: { (callResult) in 
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage ?? "Error: callResult.statusMessage")
                    }
                })

                DispatchQueue.init(label: "DronecodeCalibrateGyroReceiver").async {
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        let calibrationResult =  CalibrationResult.translateFromRPC(response.calibrationResult)

                        let progressData = ProgressData.translateFromRPC(response.progressData)

                        switch (calibrationResult.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(progressData)
                        default:
                            observer.onError(calibrationResult.resultStr)
                        }
                    }

                    observer.onError("Broken pipe")
                }

                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to calibrateGyro stream. \(error)")
                return Disposables.create()
            }
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    public lazy var calibrateAccelerometer: Observable<ProgressData> = createCalibrateAccelerometerObservable()

    private func createCalibrateAccelerometerObservable() -> Observable<ProgressData> {
        return Observable.create { observer in
            let calibrateAccelerometerRequest = DronecodeSdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest()

            do {
                let call = try self.service.subscribeCalibrateAccelerometer(calibrateAccelerometerRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage ?? "Error: callResult.statusMessage")
                    }
                })

                DispatchQueue.init(label: "DronecodeCalibrateAccelerometerReceiver").async {
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        let calibrationResult =  CalibrationResult.translateFromRPC(response.calibrationResult)

                        let progressData = ProgressData.translateFromRPC(response.progressData)

                        switch (calibrationResult.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(progressData)
                        default:
                            observer.onError(calibrationResult.resultStr)
                        }
                    }

                    observer.onError("Broken pipe")
                }

                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to calibrateAccelerometer stream. \(error)")
                return Disposables.create()
            }
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    public lazy var calibrateMagnetometer: Observable<ProgressData> = createCalibrateMagnetometerObservable()

    private func createCalibrateMagnetometerObservable() -> Observable<ProgressData> {
        return Observable.create { observer in
            let calibrateMagnetometerRequest = DronecodeSdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest()
            do {
                let call = try self.service.subscribeCalibrateMagnetometer(calibrateMagnetometerRequest, completion: { (callResult) in 
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage ?? "Error: callResult.statusMessage")
                    }
                })

                DispatchQueue.init(label: "DronecodeCalibrateMagnetometerReceiver").async {
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        let calibrationResult =  CalibrationResult.translateFromRPC(response.calibrationResult)

                        let progressData = ProgressData.translateFromRPC(response.progressData)

                        switch (calibrationResult.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(progressData)
                        default:
                            observer.onError(calibrationResult.resultStr)
                        }
                    }

                    observer.onError("Broken pipe")
                }

                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to calibrateMagnetometer stream. \(error)")
                return Disposables.create()
            }
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    public lazy var calibrateGimbalAccelerometer: Observable<ProgressData> = createCalibrateGimbalAccelerometerObservable()

    private func createCalibrateGimbalAccelerometerObservable() -> Observable<ProgressData> {
        return Observable.create { observer in
            let calibrateGimbalAccelerometerRequest = DronecodeSdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest()

            do {
                let call = try self.service.subscribeCalibrateGimbalAccelerometer(calibrateGimbalAccelerometerRequest, completion: { (callResult) in 
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage ?? "Error: callResult.statusMessage")
                    }
                })

                DispatchQueue.init(label: "DronecodeCalibrateGimbalAccelerometerReceiver").async {
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        let calibrationResult =  CalibrationResult.translateFromRPC(response.calibrationResult)

                        let progressData = ProgressData.translateFromRPC(response.progressData)

                        switch (calibrationResult.result) {
                        case .success:
                            observer.onCompleted()
                        case .instruction, .inProgress:
                            observer.onNext(progressData)
                        default:
                            observer.onError(calibrationResult.resultStr)
                        }
                    }

                    observer.onError("Broken pipe")
                }

                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to calibrateGimbalAccelerometer stream. \(error)")
                return Disposables.create()
            }
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
}
