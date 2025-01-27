import Foundation
import RxSwift
import GRPC
import NIO

/**
 Allows users to send winch actions, as well as receive status information from winch systems.
 */
public class Winch {
    private let service: Mavsdk_Rpc_Winch_WinchServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Winch` plugin.

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
        let service = Mavsdk_Rpc_Winch_WinchServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Winch_WinchServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeWinchError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct WinchError: Error {
        public let code: Winch.WinchResult.Result
        public let description: String
    }
    

    /**
     Winch Action type.
     */
    public enum WinchAction: Equatable {
        ///  Allow motor to freewheel.
        case relaxed
        ///  Wind or unwind specified length of line, optionally using specified rate.
        case relativeLengthControl
        ///  Wind or unwind line at specified rate.
        case rateControl
        ///  Perform the locking sequence to relieve motor while in the fully retracted position.
        case lock
        ///  Sequence of drop, slow down, touch down, reel up, lock.
        case deliver
        ///  Engage motor and hold current position.
        case hold
        ///  Return the reel to the fully retracted position.
        case retract
        ///  Load the reel with line. The winch will calculate the total loaded length and stop when the tension exceeds a threshold.
        case loadLine
        ///  Spool out the entire length of the line.
        case abandonLine
        ///  Spools out just enough to present the hook to the user to load the payload.
        case loadPayload
        case UNRECOGNIZED(Int)

        internal var rpcWinchAction: Mavsdk_Rpc_Winch_WinchAction {
            switch self {
            case .relaxed:
                return .relaxed
            case .relativeLengthControl:
                return .relativeLengthControl
            case .rateControl:
                return .rateControl
            case .lock:
                return .lock
            case .deliver:
                return .deliver
            case .hold:
                return .hold
            case .retract:
                return .retract
            case .loadLine:
                return .loadLine
            case .abandonLine:
                return .abandonLine
            case .loadPayload:
                return .loadPayload
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcWinchAction: Mavsdk_Rpc_Winch_WinchAction) -> WinchAction {
            switch rpcWinchAction {
            case .relaxed:
                return .relaxed
            case .relativeLengthControl:
                return .relativeLengthControl
            case .rateControl:
                return .rateControl
            case .lock:
                return .lock
            case .deliver:
                return .deliver
            case .hold:
                return .hold
            case .retract:
                return .retract
            case .loadLine:
                return .loadLine
            case .abandonLine:
                return .abandonLine
            case .loadPayload:
                return .loadPayload
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Winch Status Flags.

     The status flags are defined in mavlink
     https://mavlink.io/en/messages/common.html#MAV_WINCH_STATUS_FLAG.

     Multiple status fields can be set simultaneously. Mavlink does
     not specify which states are mutually exclusive.
     */
    public struct StatusFlags: Equatable {
        public let healthy: Bool
        public let fullyRetracted: Bool
        public let moving: Bool
        public let clutchEngaged: Bool
        public let locked: Bool
        public let dropping: Bool
        public let arresting: Bool
        public let groundSense: Bool
        public let retracting: Bool
        public let redeliver: Bool
        public let abandonLine: Bool
        public let locking: Bool
        public let loadLine: Bool
        public let loadPayload: Bool

        

        /**
         Initializes a new `StatusFlags`.

         
         - Parameters:
            
            - healthy:  Winch is healthy
            
            - fullyRetracted:  Winch line is fully retracted
            
            - moving:  Winch motor is moving
            
            - clutchEngaged:  Winch clutch is engaged allowing motor to move freely
            
            - locked:  Winch is locked by locking mechanism
            
            - dropping:  Winch is gravity dropping payload
            
            - arresting:  Winch is arresting payload descent
            
            - groundSense:  Winch is using torque measurements to sense the ground
            
            - retracting:  Winch is returning to the fully retracted position
            
            - redeliver:  Winch is redelivering the payload. This is a failover state if the line tension goes above a threshold during RETRACTING.
            
            - abandonLine:  Winch is abandoning the line and possibly payload. Winch unspools the entire calculated line length. This is a failover state from REDELIVER if the number of attempts exceeds a threshold.
            
            - locking:  Winch is engaging the locking mechanism
            
            - loadLine:  Winch is spooling on line
            
            - loadPayload:  Winch is loading a payload
            
         
         */
        public init(healthy: Bool, fullyRetracted: Bool, moving: Bool, clutchEngaged: Bool, locked: Bool, dropping: Bool, arresting: Bool, groundSense: Bool, retracting: Bool, redeliver: Bool, abandonLine: Bool, locking: Bool, loadLine: Bool, loadPayload: Bool) {
            self.healthy = healthy
            self.fullyRetracted = fullyRetracted
            self.moving = moving
            self.clutchEngaged = clutchEngaged
            self.locked = locked
            self.dropping = dropping
            self.arresting = arresting
            self.groundSense = groundSense
            self.retracting = retracting
            self.redeliver = redeliver
            self.abandonLine = abandonLine
            self.locking = locking
            self.loadLine = loadLine
            self.loadPayload = loadPayload
        }

        internal var rpcStatusFlags: Mavsdk_Rpc_Winch_StatusFlags {
            var rpcStatusFlags = Mavsdk_Rpc_Winch_StatusFlags()
            
                
            rpcStatusFlags.healthy = healthy
                
            
            
                
            rpcStatusFlags.fullyRetracted = fullyRetracted
                
            
            
                
            rpcStatusFlags.moving = moving
                
            
            
                
            rpcStatusFlags.clutchEngaged = clutchEngaged
                
            
            
                
            rpcStatusFlags.locked = locked
                
            
            
                
            rpcStatusFlags.dropping = dropping
                
            
            
                
            rpcStatusFlags.arresting = arresting
                
            
            
                
            rpcStatusFlags.groundSense = groundSense
                
            
            
                
            rpcStatusFlags.retracting = retracting
                
            
            
                
            rpcStatusFlags.redeliver = redeliver
                
            
            
                
            rpcStatusFlags.abandonLine = abandonLine
                
            
            
                
            rpcStatusFlags.locking = locking
                
            
            
                
            rpcStatusFlags.loadLine = loadLine
                
            
            
                
            rpcStatusFlags.loadPayload = loadPayload
                
            

            return rpcStatusFlags
        }

        internal static func translateFromRpc(_ rpcStatusFlags: Mavsdk_Rpc_Winch_StatusFlags) -> StatusFlags {
            return StatusFlags(healthy: rpcStatusFlags.healthy, fullyRetracted: rpcStatusFlags.fullyRetracted, moving: rpcStatusFlags.moving, clutchEngaged: rpcStatusFlags.clutchEngaged, locked: rpcStatusFlags.locked, dropping: rpcStatusFlags.dropping, arresting: rpcStatusFlags.arresting, groundSense: rpcStatusFlags.groundSense, retracting: rpcStatusFlags.retracting, redeliver: rpcStatusFlags.redeliver, abandonLine: rpcStatusFlags.abandonLine, locking: rpcStatusFlags.locking, loadLine: rpcStatusFlags.loadLine, loadPayload: rpcStatusFlags.loadPayload)
        }

        public static func == (lhs: StatusFlags, rhs: StatusFlags) -> Bool {
            return lhs.healthy == rhs.healthy
                && lhs.fullyRetracted == rhs.fullyRetracted
                && lhs.moving == rhs.moving
                && lhs.clutchEngaged == rhs.clutchEngaged
                && lhs.locked == rhs.locked
                && lhs.dropping == rhs.dropping
                && lhs.arresting == rhs.arresting
                && lhs.groundSense == rhs.groundSense
                && lhs.retracting == rhs.retracting
                && lhs.redeliver == rhs.redeliver
                && lhs.abandonLine == rhs.abandonLine
                && lhs.locking == rhs.locking
                && lhs.loadLine == rhs.loadLine
                && lhs.loadPayload == rhs.loadPayload
        }
    }

    /**
     Status type.
     */
    public struct Status: Equatable {
        public let timeUsec: UInt64
        public let lineLengthM: Float
        public let speedMS: Float
        public let tensionKg: Float
        public let voltageV: Float
        public let currentA: Float
        public let temperatureC: Int32
        public let statusFlags: StatusFlags

        

        /**
         Initializes a new `Status`.

         
         - Parameters:
            
            - timeUsec:  Time in usec
            
            - lineLengthM:  Length of the line in meters
            
            - speedMS:  Speed in meters per second
            
            - tensionKg:  Tension in kilograms
            
            - voltageV:  Voltage in volts
            
            - currentA:  Current in amperes
            
            - temperatureC:  Temperature in Celsius
            
            - statusFlags:  Status flags
            
         
         */
        public init(timeUsec: UInt64, lineLengthM: Float, speedMS: Float, tensionKg: Float, voltageV: Float, currentA: Float, temperatureC: Int32, statusFlags: StatusFlags) {
            self.timeUsec = timeUsec
            self.lineLengthM = lineLengthM
            self.speedMS = speedMS
            self.tensionKg = tensionKg
            self.voltageV = voltageV
            self.currentA = currentA
            self.temperatureC = temperatureC
            self.statusFlags = statusFlags
        }

        internal var rpcStatus: Mavsdk_Rpc_Winch_Status {
            var rpcStatus = Mavsdk_Rpc_Winch_Status()
            
                
            rpcStatus.timeUsec = timeUsec
                
            
            
                
            rpcStatus.lineLengthM = lineLengthM
                
            
            
                
            rpcStatus.speedMS = speedMS
                
            
            
                
            rpcStatus.tensionKg = tensionKg
                
            
            
                
            rpcStatus.voltageV = voltageV
                
            
            
                
            rpcStatus.currentA = currentA
                
            
            
                
            rpcStatus.temperatureC = temperatureC
                
            
            
                
            rpcStatus.statusFlags = statusFlags.rpcStatusFlags
                
            

            return rpcStatus
        }

        internal static func translateFromRpc(_ rpcStatus: Mavsdk_Rpc_Winch_Status) -> Status {
            return Status(timeUsec: rpcStatus.timeUsec, lineLengthM: rpcStatus.lineLengthM, speedMS: rpcStatus.speedMS, tensionKg: rpcStatus.tensionKg, voltageV: rpcStatus.voltageV, currentA: rpcStatus.currentA, temperatureC: rpcStatus.temperatureC, statusFlags: StatusFlags.translateFromRpc(rpcStatus.statusFlags))
        }

        public static func == (lhs: Status, rhs: Status) -> Bool {
            return lhs.timeUsec == rhs.timeUsec
                && lhs.lineLengthM == rhs.lineLengthM
                && lhs.speedMS == rhs.speedMS
                && lhs.tensionKg == rhs.tensionKg
                && lhs.voltageV == rhs.voltageV
                && lhs.currentA == rhs.currentA
                && lhs.temperatureC == rhs.temperatureC
                && lhs.statusFlags == rhs.statusFlags
        }
    }

    /**
     Result type.
     */
    public struct WinchResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for winch action requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request was successful.
            case success
            ///  No system is connected.
            case noSystem
            ///  Temporarily rejected.
            case busy
            ///  Request timed out.
            case timeout
            ///  Action not supported.
            case unsupported
            ///  Action failed.
            case failed
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Winch_WinchResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .unsupported:
                    return .unsupported
                case .failed:
                    return .failed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Winch_WinchResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .unsupported:
                    return .unsupported
                case .failed:
                    return .failed
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `WinchResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcWinchResult: Mavsdk_Rpc_Winch_WinchResult {
            var rpcWinchResult = Mavsdk_Rpc_Winch_WinchResult()
            
                
            rpcWinchResult.result = result.rpcResult
                
            
            
                
            rpcWinchResult.resultStr = resultStr
                
            

            return rpcWinchResult
        }

        internal static func translateFromRpc(_ rpcWinchResult: Mavsdk_Rpc_Winch_WinchResult) -> WinchResult {
            return WinchResult(result: Result.translateFromRpc(rpcWinchResult.result), resultStr: rpcWinchResult.resultStr)
        }

        public static func == (lhs: WinchResult, rhs: WinchResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }



    /**
     Subscribe to 'winch status' updates.
     */
    public lazy var status: Observable<Status> = createStatusObservable()



    private func createStatusObservable() -> Observable<Status> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Winch_SubscribeStatusRequest()

            

            let serverStreamingCall = self.service.subscribeStatus(request, handler: { (response) in

                
                     
                let status = Status.translateFromRpc(response.status)
                

                
                observer.onNext(status)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeWinchError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Allow motor to freewheel.

     - Parameter instance:
     
     */
    public func relax(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_RelaxRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.relax(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Wind or unwind specified length of line, optionally using specified rate.

     - Parameters:
        - instance: Instance ID of the winch addressed by this request
        - lengthM: Length of line to unwind or wind
        - rateMS: Rate at which to wind or unwind the line
     
     */
    public func relativeLengthControl(instance: UInt32, lengthM: Float, rateMS: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_RelativeLengthControlRequest()

            
                
            request.instance = instance
                
            
                
            request.lengthM = lengthM
                
            
                
            request.rateMS = rateMS
                
            

            do {
                
                let response = self.service.relativeLengthControl(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Wind or unwind line at specified rate.

     - Parameters:
        - instance:
        - rateMS: Rate at which to wind or unwind the line
     
     */
    public func rateControl(instance: UInt32, rateMS: Float) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_RateControlRequest()

            
                
            request.instance = instance
                
            
                
            request.rateMS = rateMS
                
            

            do {
                
                let response = self.service.rateControl(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Perform the locking sequence to relieve motor while in the fully retracted position.

     - Parameter instance:
     
     */
    public func lock(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_LockRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.lock(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Sequence of drop, slow down, touch down, reel up, lock.

     - Parameter instance:
     
     */
    public func deliver(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_DeliverRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.deliver(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Engage motor and hold current position.

     - Parameter instance:
     
     */
    public func hold(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_HoldRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.hold(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Return the reel to the fully retracted position.

     - Parameter instance:
     
     */
    public func retract(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_RetractRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.retract(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Load the reel with line.

     The winch will calculate the total loaded length and stop when the tension exceeds a threshold.

     - Parameter instance:
     
     */
    public func loadLine(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_LoadLineRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.loadLine(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Spool out the entire length of the line.

     - Parameter instance:
     
     */
    public func abandonLine(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_AbandonLineRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.abandonLine(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Spools out just enough to present the hook to the user to load the payload.

     - Parameter instance:
     
     */
    public func loadPayload(instance: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Winch_LoadPayloadRequest()

            
                
            request.instance = instance
                
            

            do {
                
                let response = self.service.loadPayload(request)

                let result = try response.response.wait().winchResult
                if (result.result == Mavsdk_Rpc_Winch_WinchResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(WinchError(code: WinchResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}