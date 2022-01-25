import Foundation
import RxSwift
import GRPC
import NIO

/**
 Enable to calibrate sensors of a drone such as gyro, accelerometer, and magnetometer.
 */
public class Calibration {
    private let service: Mavsdk_Rpc_Calibration_CalibrationServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Calibration` plugin.

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
        let service = Mavsdk_Rpc_Calibration_CalibrationServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Calibration_CalibrationServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
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
    


    /**
     Result type.
     */
    public struct CalibrationResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for calibration commands
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  The calibration succeeded.
            case success
            ///  Intermediate message showing progress or instructions on the next steps.
            case next
            ///  Calibration failed.
            case failed
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command refused by vehicle.
            case commandDenied
            ///  Command timed out.
            case timeout
            ///  Calibration process was cancelled.
            case cancelled
            ///  Calibration process failed since the vehicle is armed.
            case failedArmed
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Calibration_CalibrationResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .next:
                    return .next
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
                case .failedArmed:
                    return .failedArmed
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
                case .next:
                    return .next
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
                case .failedArmed:
                    return .failedArmed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `CalibrationResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
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

    /**
     Progress data coming from calibration.

     Can be a progress percentage, or an instruction text.
     */
    public struct ProgressData: Equatable {
        public let hasProgress: Bool
        public let progress: Float
        public let hasStatusText: Bool
        public let statusText: String

        

        /**
         Initializes a new `ProgressData`.

         
         - Parameters:
            
            - hasProgress:  Whether this ProgressData contains a 'progress' status or not
            
            - progress:  Progress (percentage)
            
            - hasStatusText:  Whether this ProgressData contains a 'status_text' or not
            
            - statusText:  Instruction text
            
         
         */
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





    /**
     Perform gyro calibration.
     */

    public func calibrateGyro() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateGyroRequest()

            

            _ = self.service.subscribeCalibrateGyro(request, handler: { (response) in

                
                     
                let calibrateGyro = ProgressData.translateFromRpc(response.progressData)
                

                
                let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(calibrateGyro)
                default:
                    observer.onError(CalibrationError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }




    /**
     Perform accelerometer calibration.
     */

    public func calibrateAccelerometer() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateAccelerometerRequest()

            

            _ = self.service.subscribeCalibrateAccelerometer(request, handler: { (response) in

                
                     
                let calibrateAccelerometer = ProgressData.translateFromRpc(response.progressData)
                

                
                let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(calibrateAccelerometer)
                default:
                    observer.onError(CalibrationError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }




    /**
     Perform magnetometer calibration.
     */

    public func calibrateMagnetometer() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateMagnetometerRequest()

            

            _ = self.service.subscribeCalibrateMagnetometer(request, handler: { (response) in

                
                     
                let calibrateMagnetometer = ProgressData.translateFromRpc(response.progressData)
                

                
                let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(calibrateMagnetometer)
                default:
                    observer.onError(CalibrationError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }




    /**
     Perform board level horizon calibration.
     */

    public func calibrateLevelHorizon() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateLevelHorizonRequest()

            

            _ = self.service.subscribeCalibrateLevelHorizon(request, handler: { (response) in

                
                     
                let calibrateLevelHorizon = ProgressData.translateFromRpc(response.progressData)
                

                
                let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(calibrateLevelHorizon)
                default:
                    observer.onError(CalibrationError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }




    /**
     Perform gimbal accelerometer calibration.
     */

    public func calibrateGimbalAccelerometer() -> Observable<ProgressData> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Calibration_SubscribeCalibrateGimbalAccelerometerRequest()

            

            _ = self.service.subscribeCalibrateGimbalAccelerometer(request, handler: { (response) in

                
                     
                let calibrateGimbalAccelerometer = ProgressData.translateFromRpc(response.progressData)
                

                
                let result = CalibrationResult.translateFromRpc(response.calibrationResult)

                switch (result.result) {
                case .success:
                    observer.onCompleted()
                case .next:
                    observer.onNext(calibrateGimbalAccelerometer)
                default:
                    observer.onError(CalibrationError(code: result.result, description: result.resultStr))
                }
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeCalibrationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Cancel ongoing calibration process.

     
     */
    public func cancel() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Calibration_CancelRequest()

            

            do {
                
                let response = self.service.cancel(request)

                let result = try response.response.wait().calibrationResult
                if (result.result == Mavsdk_Rpc_Calibration_CalibrationResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(CalibrationError(code: CalibrationResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}