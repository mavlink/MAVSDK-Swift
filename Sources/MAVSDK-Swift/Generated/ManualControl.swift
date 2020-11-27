import Foundation
import RxSwift
import GRPC
import NIO

/**
 Enable manual control using e.g. a joystick or gamepad.
 */
public class ManualControl {
    private let service: Mavsdk_Rpc_ManualControl_ManualControlServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `ManualControl` plugin.

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
        let service = Mavsdk_Rpc_ManualControl_ManualControlServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ManualControl_ManualControlServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeManualControlError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ManualControlError: Error {
        public let code: ManualControl.ManualControlResult.Result
        public let description: String
    }
    


    /**
     Result type.
     */
    public struct ManualControlResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for manual control requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request was successful.
            case success
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command refused by vehicle.
            case commandDenied
            ///  Request timed out.
            case timeout
            ///  Input out of range.
            case inputOutOfRange
            ///  No Input set.
            case inputNotSet
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_ManualControl_ManualControlResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
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
                case .inputOutOfRange:
                    return .inputOutOfRange
                case .inputNotSet:
                    return .inputNotSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_ManualControl_ManualControlResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
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
                case .inputOutOfRange:
                    return .inputOutOfRange
                case .inputNotSet:
                    return .inputNotSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ManualControlResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcManualControlResult: Mavsdk_Rpc_ManualControl_ManualControlResult {
            var rpcManualControlResult = Mavsdk_Rpc_ManualControl_ManualControlResult()
            
                
            rpcManualControlResult.result = result.rpcResult
                
            
            
                
            rpcManualControlResult.resultStr = resultStr
                
            

            return rpcManualControlResult
        }

        internal static func translateFromRpc(_ rpcManualControlResult: Mavsdk_Rpc_ManualControl_ManualControlResult) -> ManualControlResult {
            return ManualControlResult(result: Result.translateFromRpc(rpcManualControlResult.result), resultStr: rpcManualControlResult.resultStr)
        }

        public static func == (lhs: ManualControlResult, rhs: ManualControlResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Start position control using e.g. joystick input.

     Requires manual control input to be sent regularly already.
     Requires a valid position using e.g. GPS, external vision, or optical flow.

     
     */
    public func startPositionControl() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_ManualControl_StartPositionControlRequest()

            

            do {
                
                let response = self.service.startPositionControl(request)

                let result = try response.response.wait().manualControlResult
                if (result.result == Mavsdk_Rpc_ManualControl_ManualControlResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ManualControlError(code: ManualControlResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Start altitude control

     Requires manual control input to be sent regularly already.
     Does not require a  valid position e.g. GPS.

     
     */
    public func startAltitudeControl() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_ManualControl_StartAltitudeControlRequest()

            

            do {
                
                let response = self.service.startAltitudeControl(request)

                let result = try response.response.wait().manualControlResult
                if (result.result == Mavsdk_Rpc_ManualControl_ManualControlResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ManualControlError(code: ManualControlResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set manual control input

     The manual control input needs to be sent at a rate high enough to prevent
     triggering of RC loss, a good minimum rate is 10 Hz.

     - Parameters:
        - x: value between -1. to 1. negative -> backwards, positive -> forwards
        - y: value between -1. to 1. negative -> left, positive -> right
        - z: value between -1. to 1. negative -> down, positive -> up (usually for now, for multicopter 0 to 1 is expected)
        - r: value between -1. to 1. negative -> turn anti-clockwise (towards the left), positive -> turn clockwise (towards the right)
     
     */
    public func setManualControlInput(x: Float, y: Float, z: Float, r: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ManualControl_SetManualControlInputRequest()

            
                
            request.x = x
                
            
                
            request.y = y
                
            
                
            request.z = z
                
            
                
            request.r = r
                
            

            do {
                
                let response = self.service.setManualControlInput(request)

                let result = try response.response.wait().manualControlResult
                if (result.result == Mavsdk_Rpc_ManualControl_ManualControlResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(ManualControlError(code: ManualControlResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}