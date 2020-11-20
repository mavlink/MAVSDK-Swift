import Foundation
import RxSwift
import GRPC
import NIO

public class Failure {
    private let service: Mavsdk_Rpc_Failure_FailureServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_Failure_FailureServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Failure_FailureServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeFailureError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct FailureError: Error {
        public let code: Failure.FailureResult.Result
        public let description: String
    }
    

    public enum FailureUnit: Equatable {
        case sensorGyro
        case sensorAccel
        case sensorMag
        case sensorBaro
        case sensorGps
        case sensorOpticalFlow
        case sensorVio
        case sensorDistanceSensor
        case sensorAirspeed
        case systemBattery
        case systemMotor
        case systemServo
        case systemAvoidance
        case systemRcSignal
        case systemMavlinkSignal
        case UNRECOGNIZED(Int)

        internal var rpcFailureUnit: Mavsdk_Rpc_Failure_FailureUnit {
            switch self {
            case .sensorGyro:
                return .sensorGyro
            case .sensorAccel:
                return .sensorAccel
            case .sensorMag:
                return .sensorMag
            case .sensorBaro:
                return .sensorBaro
            case .sensorGps:
                return .sensorGps
            case .sensorOpticalFlow:
                return .sensorOpticalFlow
            case .sensorVio:
                return .sensorVio
            case .sensorDistanceSensor:
                return .sensorDistanceSensor
            case .sensorAirspeed:
                return .sensorAirspeed
            case .systemBattery:
                return .systemBattery
            case .systemMotor:
                return .systemMotor
            case .systemServo:
                return .systemServo
            case .systemAvoidance:
                return .systemAvoidance
            case .systemRcSignal:
                return .systemRcSignal
            case .systemMavlinkSignal:
                return .systemMavlinkSignal
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcFailureUnit: Mavsdk_Rpc_Failure_FailureUnit) -> FailureUnit {
            switch rpcFailureUnit {
            case .sensorGyro:
                return .sensorGyro
            case .sensorAccel:
                return .sensorAccel
            case .sensorMag:
                return .sensorMag
            case .sensorBaro:
                return .sensorBaro
            case .sensorGps:
                return .sensorGps
            case .sensorOpticalFlow:
                return .sensorOpticalFlow
            case .sensorVio:
                return .sensorVio
            case .sensorDistanceSensor:
                return .sensorDistanceSensor
            case .sensorAirspeed:
                return .sensorAirspeed
            case .systemBattery:
                return .systemBattery
            case .systemMotor:
                return .systemMotor
            case .systemServo:
                return .systemServo
            case .systemAvoidance:
                return .systemAvoidance
            case .systemRcSignal:
                return .systemRcSignal
            case .systemMavlinkSignal:
                return .systemMavlinkSignal
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }

    public enum FailureType: Equatable {
        case ok
        case off
        case stuck
        case garbage
        case wrong
        case slow
        case delayed
        case intermittent
        case UNRECOGNIZED(Int)

        internal var rpcFailureType: Mavsdk_Rpc_Failure_FailureType {
            switch self {
            case .ok:
                return .ok
            case .off:
                return .off
            case .stuck:
                return .stuck
            case .garbage:
                return .garbage
            case .wrong:
                return .wrong
            case .slow:
                return .slow
            case .delayed:
                return .delayed
            case .intermittent:
                return .intermittent
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcFailureType: Mavsdk_Rpc_Failure_FailureType) -> FailureType {
            switch rpcFailureType {
            case .ok:
                return .ok
            case .off:
                return .off
            case .stuck:
                return .stuck
            case .garbage:
                return .garbage
            case .wrong:
                return .wrong
            case .slow:
                return .slow
            case .delayed:
                return .delayed
            case .intermittent:
                return .intermittent
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    public struct FailureResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case noSystem
            case connectionError
            case unsupported
            case denied
            case disabled
            case timeout
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Failure_FailureResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .unsupported:
                    return .unsupported
                case .denied:
                    return .denied
                case .disabled:
                    return .disabled
                case .timeout:
                    return .timeout
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Failure_FailureResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .unsupported:
                    return .unsupported
                case .denied:
                    return .denied
                case .disabled:
                    return .disabled
                case .timeout:
                    return .timeout
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcFailureResult: Mavsdk_Rpc_Failure_FailureResult {
            var rpcFailureResult = Mavsdk_Rpc_Failure_FailureResult()
            
                
            rpcFailureResult.result = result.rpcResult
                
            
            
                
            rpcFailureResult.resultStr = resultStr
                
            

            return rpcFailureResult
        }

        internal static func translateFromRpc(_ rpcFailureResult: Mavsdk_Rpc_Failure_FailureResult) -> FailureResult {
            return FailureResult(result: Result.translateFromRpc(rpcFailureResult.result), resultStr: rpcFailureResult.resultStr)
        }

        public static func == (lhs: FailureResult, rhs: FailureResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func inject(failureUnit: FailureUnit, failureType: FailureType, instance: Int32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Failure_InjectRequest()

            
                
            request.failureUnit = failureUnit.rpcFailureUnit
                
            
                
            request.failureType = failureType.rpcFailureType
                
            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.inject(request)

                let result = try response.response.wait().failureResult
                if (result.result == Mavsdk_Rpc_Failure_FailureResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(FailureError(code: FailureResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}