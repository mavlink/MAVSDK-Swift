import Foundation
import RxSwift
import SwiftGRPC

public class Passthrough {
    private let service: Mavsdk_Rpc_Passthrough_PassthroughServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Passthrough_PassthroughServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Passthrough_PassthroughServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimePassthroughError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct PassthroughError: Error {
        public let code: Passthrough.PassthroughResult.Result
        public let description: String
    }
    


    public struct MavlinkMessage: Equatable {
        public let checksum: UInt32
        public let magic: UInt32
        public let len: UInt32
        public let incompatFlags: UInt32
        public let compatFlags: UInt32
        public let seq: UInt32
        public let sysid: UInt32
        public let compid: UInt32
        public let msgid: UInt32
        public let payload64: [UInt64]
        public let ck: [UInt32]

        

        public init(checksum: UInt32, magic: UInt32, len: UInt32, incompatFlags: UInt32, compatFlags: UInt32, seq: UInt32, sysid: UInt32, compid: UInt32, msgid: UInt32, payload64: [UInt64], ck: [UInt32]) {
            self.checksum = checksum
            self.magic = magic
            self.len = len
            self.incompatFlags = incompatFlags
            self.compatFlags = compatFlags
            self.seq = seq
            self.sysid = sysid
            self.compid = compid
            self.msgid = msgid
            self.payload64 = payload64
            self.ck = ck
        }

        internal var rpcMavlinkMessage: Mavsdk_Rpc_Passthrough_MavlinkMessage {
            var rpcMavlinkMessage = Mavsdk_Rpc_Passthrough_MavlinkMessage()
            
                
            rpcMavlinkMessage.checksum = checksum
                
            
            
                
            rpcMavlinkMessage.magic = magic
                
            
            
                
            rpcMavlinkMessage.len = len
                
            
            
                
            rpcMavlinkMessage.incompatFlags = incompatFlags
                
            
            
                
            rpcMavlinkMessage.compatFlags = compatFlags
                
            
            
                
            rpcMavlinkMessage.seq = seq
                
            
            
                
            rpcMavlinkMessage.sysid = sysid
                
            
            
                
            rpcMavlinkMessage.compid = compid
                
            
            
                
            rpcMavlinkMessage.msgid = msgid
                
            
            
                
            rpcMavlinkMessage.payload64 = payload64
                
            
            
                
            rpcMavlinkMessage.ck = ck
                
            

            return rpcMavlinkMessage
        }

        internal static func translateFromRpc(_ rpcMavlinkMessage: Mavsdk_Rpc_Passthrough_MavlinkMessage) -> MavlinkMessage {
            return MavlinkMessage(checksum: rpcMavlinkMessage.checksum, magic: rpcMavlinkMessage.magic, len: rpcMavlinkMessage.len, incompatFlags: rpcMavlinkMessage.incompatFlags, compatFlags: rpcMavlinkMessage.compatFlags, seq: rpcMavlinkMessage.seq, sysid: rpcMavlinkMessage.sysid, compid: rpcMavlinkMessage.compid, msgid: rpcMavlinkMessage.msgid, payload64: rpcMavlinkMessage.payload64, ck: rpcMavlinkMessage.ck)
        }

        public static func == (lhs: MavlinkMessage, rhs: MavlinkMessage) -> Bool {
            return lhs.checksum == rhs.checksum
                && lhs.magic == rhs.magic
                && lhs.len == rhs.len
                && lhs.incompatFlags == rhs.incompatFlags
                && lhs.compatFlags == rhs.compatFlags
                && lhs.seq == rhs.seq
                && lhs.sysid == rhs.sysid
                && lhs.compid == rhs.compid
                && lhs.msgid == rhs.msgid
                && lhs.payload64 == rhs.payload64
                && lhs.ck == rhs.ck
        }
    }

    public struct CommandInt: Equatable {
        public let targetSystemID: UInt32
        public let targetComponentID: UInt32
        public let command: UInt64
        public let current: Bool
        public let autocontinue: Bool
        public let params: ParamsInt

        

        public init(targetSystemID: UInt32, targetComponentID: UInt32, command: UInt64, current: Bool, autocontinue: Bool, params: ParamsInt) {
            self.targetSystemID = targetSystemID
            self.targetComponentID = targetComponentID
            self.command = command
            self.current = current
            self.autocontinue = autocontinue
            self.params = params
        }

        internal var rpcCommandInt: Mavsdk_Rpc_Passthrough_CommandInt {
            var rpcCommandInt = Mavsdk_Rpc_Passthrough_CommandInt()
            
                
            rpcCommandInt.targetSystemID = targetSystemID
                
            
            
                
            rpcCommandInt.targetComponentID = targetComponentID
                
            
            
                
            rpcCommandInt.command = command
                
            
            
                
            rpcCommandInt.current = current
                
            
            
                
            rpcCommandInt.autocontinue = autocontinue
                
            
            
                
            rpcCommandInt.params = params.rpcParamsInt
                
            

            return rpcCommandInt
        }

        internal static func translateFromRpc(_ rpcCommandInt: Mavsdk_Rpc_Passthrough_CommandInt) -> CommandInt {
            return CommandInt(targetSystemID: rpcCommandInt.targetSystemID, targetComponentID: rpcCommandInt.targetComponentID, command: rpcCommandInt.command, current: rpcCommandInt.current, autocontinue: rpcCommandInt.autocontinue, params: ParamsInt.translateFromRpc(rpcCommandInt.params))
        }

        public static func == (lhs: CommandInt, rhs: CommandInt) -> Bool {
            return lhs.targetSystemID == rhs.targetSystemID
                && lhs.targetComponentID == rhs.targetComponentID
                && lhs.command == rhs.command
                && lhs.current == rhs.current
                && lhs.autocontinue == rhs.autocontinue
                && lhs.params == rhs.params
        }
    }

    public struct ParamsInt: Equatable {
        public let param1: Float
        public let param2: Float
        public let param3: Float
        public let param4: Float
        public let x: Int32
        public let y: Int32
        public let z: Float

        

        public init(param1: Float, param2: Float, param3: Float, param4: Float, x: Int32, y: Int32, z: Float) {
            self.param1 = param1
            self.param2 = param2
            self.param3 = param3
            self.param4 = param4
            self.x = x
            self.y = y
            self.z = z
        }

        internal var rpcParamsInt: Mavsdk_Rpc_Passthrough_ParamsInt {
            var rpcParamsInt = Mavsdk_Rpc_Passthrough_ParamsInt()
            
                
            rpcParamsInt.param1 = param1
                
            
            
                
            rpcParamsInt.param2 = param2
                
            
            
                
            rpcParamsInt.param3 = param3
                
            
            
                
            rpcParamsInt.param4 = param4
                
            
            
                
            rpcParamsInt.x = x
                
            
            
                
            rpcParamsInt.y = y
                
            
            
                
            rpcParamsInt.z = z
                
            

            return rpcParamsInt
        }

        internal static func translateFromRpc(_ rpcParamsInt: Mavsdk_Rpc_Passthrough_ParamsInt) -> ParamsInt {
            return ParamsInt(param1: rpcParamsInt.param1, param2: rpcParamsInt.param2, param3: rpcParamsInt.param3, param4: rpcParamsInt.param4, x: rpcParamsInt.x, y: rpcParamsInt.y, z: rpcParamsInt.z)
        }

        public static func == (lhs: ParamsInt, rhs: ParamsInt) -> Bool {
            return lhs.param1 == rhs.param1
                && lhs.param2 == rhs.param2
                && lhs.param3 == rhs.param3
                && lhs.param4 == rhs.param4
                && lhs.x == rhs.x
                && lhs.y == rhs.y
                && lhs.z == rhs.z
        }
    }

    public struct CommandLong: Equatable {
        public let targetSystemID: UInt32
        public let targetComponentID: UInt32
        public let command: UInt64
        public let confirmation: UInt32
        public let params: ParamsLong

        

        public init(targetSystemID: UInt32, targetComponentID: UInt32, command: UInt64, confirmation: UInt32, params: ParamsLong) {
            self.targetSystemID = targetSystemID
            self.targetComponentID = targetComponentID
            self.command = command
            self.confirmation = confirmation
            self.params = params
        }

        internal var rpcCommandLong: Mavsdk_Rpc_Passthrough_CommandLong {
            var rpcCommandLong = Mavsdk_Rpc_Passthrough_CommandLong()
            
                
            rpcCommandLong.targetSystemID = targetSystemID
                
            
            
                
            rpcCommandLong.targetComponentID = targetComponentID
                
            
            
                
            rpcCommandLong.command = command
                
            
            
                
            rpcCommandLong.confirmation = confirmation
                
            
            
                
            rpcCommandLong.params = params.rpcParamsLong
                
            

            return rpcCommandLong
        }

        internal static func translateFromRpc(_ rpcCommandLong: Mavsdk_Rpc_Passthrough_CommandLong) -> CommandLong {
            return CommandLong(targetSystemID: rpcCommandLong.targetSystemID, targetComponentID: rpcCommandLong.targetComponentID, command: rpcCommandLong.command, confirmation: rpcCommandLong.confirmation, params: ParamsLong.translateFromRpc(rpcCommandLong.params))
        }

        public static func == (lhs: CommandLong, rhs: CommandLong) -> Bool {
            return lhs.targetSystemID == rhs.targetSystemID
                && lhs.targetComponentID == rhs.targetComponentID
                && lhs.command == rhs.command
                && lhs.confirmation == rhs.confirmation
                && lhs.params == rhs.params
        }
    }

    public struct ParamsLong: Equatable {
        public let param1: Float
        public let param2: Float
        public let param3: Float
        public let param4: Float
        public let param5: Float
        public let param6: Float
        public let param7: Float

        

        public init(param1: Float, param2: Float, param3: Float, param4: Float, param5: Float, param6: Float, param7: Float) {
            self.param1 = param1
            self.param2 = param2
            self.param3 = param3
            self.param4 = param4
            self.param5 = param5
            self.param6 = param6
            self.param7 = param7
        }

        internal var rpcParamsLong: Mavsdk_Rpc_Passthrough_ParamsLong {
            var rpcParamsLong = Mavsdk_Rpc_Passthrough_ParamsLong()
            
                
            rpcParamsLong.param1 = param1
                
            
            
                
            rpcParamsLong.param2 = param2
                
            
            
                
            rpcParamsLong.param3 = param3
                
            
            
                
            rpcParamsLong.param4 = param4
                
            
            
                
            rpcParamsLong.param5 = param5
                
            
            
                
            rpcParamsLong.param6 = param6
                
            
            
                
            rpcParamsLong.param7 = param7
                
            

            return rpcParamsLong
        }

        internal static func translateFromRpc(_ rpcParamsLong: Mavsdk_Rpc_Passthrough_ParamsLong) -> ParamsLong {
            return ParamsLong(param1: rpcParamsLong.param1, param2: rpcParamsLong.param2, param3: rpcParamsLong.param3, param4: rpcParamsLong.param4, param5: rpcParamsLong.param5, param6: rpcParamsLong.param6, param7: rpcParamsLong.param7)
        }

        public static func == (lhs: ParamsLong, rhs: ParamsLong) -> Bool {
            return lhs.param1 == rhs.param1
                && lhs.param2 == rhs.param2
                && lhs.param3 == rhs.param3
                && lhs.param4 == rhs.param4
                && lhs.param5 == rhs.param5
                && lhs.param6 == rhs.param6
                && lhs.param7 == rhs.param7
        }
    }

    public struct PassthroughResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case connectionError
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Passthrough_PassthroughResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .connectionError:
                    return .connectionError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Passthrough_PassthroughResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .connectionError:
                    return .connectionError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcPassthroughResult: Mavsdk_Rpc_Passthrough_PassthroughResult {
            var rpcPassthroughResult = Mavsdk_Rpc_Passthrough_PassthroughResult()
            
                
            rpcPassthroughResult.result = result.rpcResult
                
            
            
                
            rpcPassthroughResult.resultStr = resultStr
                
            

            return rpcPassthroughResult
        }

        internal static func translateFromRpc(_ rpcPassthroughResult: Mavsdk_Rpc_Passthrough_PassthroughResult) -> PassthroughResult {
            return PassthroughResult(result: Result.translateFromRpc(rpcPassthroughResult.result), resultStr: rpcPassthroughResult.resultStr)
        }

        public static func == (lhs: PassthroughResult, rhs: PassthroughResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func sendMessage(mavlinkMessage: MavlinkMessage) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Passthrough_SendMessageRequest()

            
                
            request.mavlinkMessage = mavlinkMessage.rpcMavlinkMessage
                
            

            do {
                
                let response = try self.service.sendMessage(request)

                if (response.passthroughResult.result == Mavsdk_Rpc_Passthrough_PassthroughResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(PassthroughError(code: PassthroughResult.Result.translateFromRpc(response.passthroughResult.result), description: response.passthroughResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getOurSysID() -> Single<UInt32> {
        return Single<UInt32>.create { single in
            let request = Mavsdk_Rpc_Passthrough_GetOurSysIdRequest()

            

            do {
                let response = try self.service.getOurSysId(request)

                

                
                    let sysid = response.sysid
                
                single(.success(sysid))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getOurCompID() -> Single<UInt32> {
        return Single<UInt32>.create { single in
            let request = Mavsdk_Rpc_Passthrough_GetOurCompIdRequest()

            

            do {
                let response = try self.service.getOurCompId(request)

                

                
                    let compid = response.compid
                
                single(.success(compid))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getTargetSysID() -> Single<UInt32> {
        return Single<UInt32>.create { single in
            let request = Mavsdk_Rpc_Passthrough_GetTargetSysIdRequest()

            

            do {
                let response = try self.service.getTargetSysId(request)

                

                
                    let targetSysid = response.targetSysid
                
                single(.success(targetSysid))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getTargetCompID() -> Single<UInt32> {
        return Single<UInt32>.create { single in
            let request = Mavsdk_Rpc_Passthrough_GetTargetCompIdRequest()

            

            do {
                let response = try self.service.getTargetCompId(request)

                

                
                    let targetCompid = response.targetCompid
                
                single(.success(targetCompid))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func sendCommandInt(commandInt: CommandInt) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Passthrough_SendCommandIntRequest()

            
                
            request.commandInt = commandInt.rpcCommandInt
                
            

            do {
                
                let response = try self.service.sendCommandInt(request)

                if (response.passthroughResult.result == Mavsdk_Rpc_Passthrough_PassthroughResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(PassthroughError(code: PassthroughResult.Result.translateFromRpc(response.passthroughResult.result), description: response.passthroughResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func sendCommandLong(commandLong: CommandLong) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Passthrough_SendCommandLongRequest()

            
                
            request.commandLong = commandLong.rpcCommandLong
                
            

            do {
                
                let response = try self.service.sendCommandLong(request)

                if (response.passthroughResult.result == Mavsdk_Rpc_Passthrough_PassthroughResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(PassthroughError(code: PassthroughResult.Result.translateFromRpc(response.passthroughResult.result), description: response.passthroughResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}
