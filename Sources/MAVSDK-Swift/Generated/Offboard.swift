import Foundation
import RxSwift
import SwiftGRPC

public class Offboard {
    private let service: Mavsdk_Rpc_Offboard_OffboardServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Offboard_OffboardServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Offboard_OffboardServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeOffboardError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct OffboardError: Error {
        public let code: Offboard.OffboardResult.Result
        public let description: String
    }
    


    public struct Attitude: Equatable {
        public let rollDeg: Float
        public let pitchDeg: Float
        public let yawDeg: Float
        public let thrustValue: Float

        

        public init(rollDeg: Float, pitchDeg: Float, yawDeg: Float, thrustValue: Float) {
            self.rollDeg = rollDeg
            self.pitchDeg = pitchDeg
            self.yawDeg = yawDeg
            self.thrustValue = thrustValue
        }

        internal var rpcAttitude: Mavsdk_Rpc_Offboard_Attitude {
            var rpcAttitude = Mavsdk_Rpc_Offboard_Attitude()
            
                
            rpcAttitude.rollDeg = rollDeg
                
            
            
                
            rpcAttitude.pitchDeg = pitchDeg
                
            
            
                
            rpcAttitude.yawDeg = yawDeg
                
            
            
                
            rpcAttitude.thrustValue = thrustValue
                
            

            return rpcAttitude
        }

        internal static func translateFromRpc(_ rpcAttitude: Mavsdk_Rpc_Offboard_Attitude) -> Attitude {
            return Attitude(rollDeg: rpcAttitude.rollDeg, pitchDeg: rpcAttitude.pitchDeg, yawDeg: rpcAttitude.yawDeg, thrustValue: rpcAttitude.thrustValue)
        }

        public static func == (lhs: Attitude, rhs: Attitude) -> Bool {
            return lhs.rollDeg == rhs.rollDeg
                && lhs.pitchDeg == rhs.pitchDeg
                && lhs.yawDeg == rhs.yawDeg
                && lhs.thrustValue == rhs.thrustValue
        }
    }

    public struct ActuatorControlGroup: Equatable {
        public let controls: [Float]

        

        public init(controls: [Float]) {
            self.controls = controls
        }

        internal var rpcActuatorControlGroup: Mavsdk_Rpc_Offboard_ActuatorControlGroup {
            var rpcActuatorControlGroup = Mavsdk_Rpc_Offboard_ActuatorControlGroup()
            
                
            rpcActuatorControlGroup.controls = controls
                
            

            return rpcActuatorControlGroup
        }

        internal static func translateFromRpc(_ rpcActuatorControlGroup: Mavsdk_Rpc_Offboard_ActuatorControlGroup) -> ActuatorControlGroup {
            return ActuatorControlGroup(controls: rpcActuatorControlGroup.controls)
        }

        public static func == (lhs: ActuatorControlGroup, rhs: ActuatorControlGroup) -> Bool {
            return lhs.controls == rhs.controls
        }
    }

    public struct ActuatorControl: Equatable {
        public let groups: [ActuatorControlGroup]

        

        public init(groups: [ActuatorControlGroup]) {
            self.groups = groups
        }

        internal var rpcActuatorControl: Mavsdk_Rpc_Offboard_ActuatorControl {
            var rpcActuatorControl = Mavsdk_Rpc_Offboard_ActuatorControl()
            
                
            rpcActuatorControl.groups = groups.map{ $0.rpcActuatorControlGroup }
                
            

            return rpcActuatorControl
        }

        internal static func translateFromRpc(_ rpcActuatorControl: Mavsdk_Rpc_Offboard_ActuatorControl) -> ActuatorControl {
            return ActuatorControl(groups: rpcActuatorControl.groups.map{ ActuatorControlGroup.translateFromRpc($0) })
        }

        public static func == (lhs: ActuatorControl, rhs: ActuatorControl) -> Bool {
            return lhs.groups == rhs.groups
        }
    }

    public struct AttitudeRate: Equatable {
        public let rollDegS: Float
        public let pitchDegS: Float
        public let yawDegS: Float
        public let thrustValue: Float

        

        public init(rollDegS: Float, pitchDegS: Float, yawDegS: Float, thrustValue: Float) {
            self.rollDegS = rollDegS
            self.pitchDegS = pitchDegS
            self.yawDegS = yawDegS
            self.thrustValue = thrustValue
        }

        internal var rpcAttitudeRate: Mavsdk_Rpc_Offboard_AttitudeRate {
            var rpcAttitudeRate = Mavsdk_Rpc_Offboard_AttitudeRate()
            
                
            rpcAttitudeRate.rollDegS = rollDegS
                
            
            
                
            rpcAttitudeRate.pitchDegS = pitchDegS
                
            
            
                
            rpcAttitudeRate.yawDegS = yawDegS
                
            
            
                
            rpcAttitudeRate.thrustValue = thrustValue
                
            

            return rpcAttitudeRate
        }

        internal static func translateFromRpc(_ rpcAttitudeRate: Mavsdk_Rpc_Offboard_AttitudeRate) -> AttitudeRate {
            return AttitudeRate(rollDegS: rpcAttitudeRate.rollDegS, pitchDegS: rpcAttitudeRate.pitchDegS, yawDegS: rpcAttitudeRate.yawDegS, thrustValue: rpcAttitudeRate.thrustValue)
        }

        public static func == (lhs: AttitudeRate, rhs: AttitudeRate) -> Bool {
            return lhs.rollDegS == rhs.rollDegS
                && lhs.pitchDegS == rhs.pitchDegS
                && lhs.yawDegS == rhs.yawDegS
                && lhs.thrustValue == rhs.thrustValue
        }
    }

    public struct PositionNedYaw: Equatable {
        public let northM: Float
        public let eastM: Float
        public let downM: Float
        public let yawDeg: Float

        

        public init(northM: Float, eastM: Float, downM: Float, yawDeg: Float) {
            self.northM = northM
            self.eastM = eastM
            self.downM = downM
            self.yawDeg = yawDeg
        }

        internal var rpcPositionNedYaw: Mavsdk_Rpc_Offboard_PositionNedYaw {
            var rpcPositionNedYaw = Mavsdk_Rpc_Offboard_PositionNedYaw()
            
                
            rpcPositionNedYaw.northM = northM
                
            
            
                
            rpcPositionNedYaw.eastM = eastM
                
            
            
                
            rpcPositionNedYaw.downM = downM
                
            
            
                
            rpcPositionNedYaw.yawDeg = yawDeg
                
            

            return rpcPositionNedYaw
        }

        internal static func translateFromRpc(_ rpcPositionNedYaw: Mavsdk_Rpc_Offboard_PositionNedYaw) -> PositionNedYaw {
            return PositionNedYaw(northM: rpcPositionNedYaw.northM, eastM: rpcPositionNedYaw.eastM, downM: rpcPositionNedYaw.downM, yawDeg: rpcPositionNedYaw.yawDeg)
        }

        public static func == (lhs: PositionNedYaw, rhs: PositionNedYaw) -> Bool {
            return lhs.northM == rhs.northM
                && lhs.eastM == rhs.eastM
                && lhs.downM == rhs.downM
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    public struct VelocityBodyYawspeed: Equatable {
        public let forwardMS: Float
        public let rightMS: Float
        public let downMS: Float
        public let yawspeedDegS: Float

        

        public init(forwardMS: Float, rightMS: Float, downMS: Float, yawspeedDegS: Float) {
            self.forwardMS = forwardMS
            self.rightMS = rightMS
            self.downMS = downMS
            self.yawspeedDegS = yawspeedDegS
        }

        internal var rpcVelocityBodyYawspeed: Mavsdk_Rpc_Offboard_VelocityBodyYawspeed {
            var rpcVelocityBodyYawspeed = Mavsdk_Rpc_Offboard_VelocityBodyYawspeed()
            
                
            rpcVelocityBodyYawspeed.forwardMS = forwardMS
                
            
            
                
            rpcVelocityBodyYawspeed.rightMS = rightMS
                
            
            
                
            rpcVelocityBodyYawspeed.downMS = downMS
                
            
            
                
            rpcVelocityBodyYawspeed.yawspeedDegS = yawspeedDegS
                
            

            return rpcVelocityBodyYawspeed
        }

        internal static func translateFromRpc(_ rpcVelocityBodyYawspeed: Mavsdk_Rpc_Offboard_VelocityBodyYawspeed) -> VelocityBodyYawspeed {
            return VelocityBodyYawspeed(forwardMS: rpcVelocityBodyYawspeed.forwardMS, rightMS: rpcVelocityBodyYawspeed.rightMS, downMS: rpcVelocityBodyYawspeed.downMS, yawspeedDegS: rpcVelocityBodyYawspeed.yawspeedDegS)
        }

        public static func == (lhs: VelocityBodyYawspeed, rhs: VelocityBodyYawspeed) -> Bool {
            return lhs.forwardMS == rhs.forwardMS
                && lhs.rightMS == rhs.rightMS
                && lhs.downMS == rhs.downMS
                && lhs.yawspeedDegS == rhs.yawspeedDegS
        }
    }

    public struct VelocityNedYaw: Equatable {
        public let northMS: Float
        public let eastMS: Float
        public let downMS: Float
        public let yawDeg: Float

        

        public init(northMS: Float, eastMS: Float, downMS: Float, yawDeg: Float) {
            self.northMS = northMS
            self.eastMS = eastMS
            self.downMS = downMS
            self.yawDeg = yawDeg
        }

        internal var rpcVelocityNedYaw: Mavsdk_Rpc_Offboard_VelocityNedYaw {
            var rpcVelocityNedYaw = Mavsdk_Rpc_Offboard_VelocityNedYaw()
            
                
            rpcVelocityNedYaw.northMS = northMS
                
            
            
                
            rpcVelocityNedYaw.eastMS = eastMS
                
            
            
                
            rpcVelocityNedYaw.downMS = downMS
                
            
            
                
            rpcVelocityNedYaw.yawDeg = yawDeg
                
            

            return rpcVelocityNedYaw
        }

        internal static func translateFromRpc(_ rpcVelocityNedYaw: Mavsdk_Rpc_Offboard_VelocityNedYaw) -> VelocityNedYaw {
            return VelocityNedYaw(northMS: rpcVelocityNedYaw.northMS, eastMS: rpcVelocityNedYaw.eastMS, downMS: rpcVelocityNedYaw.downMS, yawDeg: rpcVelocityNedYaw.yawDeg)
        }

        public static func == (lhs: VelocityNedYaw, rhs: VelocityNedYaw) -> Bool {
            return lhs.northMS == rhs.northMS
                && lhs.eastMS == rhs.eastMS
                && lhs.downMS == rhs.downMS
                && lhs.yawDeg == rhs.yawDeg
        }
    }

    public struct OffboardResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case noSystem
            case connectionError
            case busy
            case commandDenied
            case timeout
            case noSetpointSet
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Offboard_OffboardResult.Result {
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
                case .noSetpointSet:
                    return .noSetpointSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Offboard_OffboardResult.Result) -> Result {
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
                case .noSetpointSet:
                    return .noSetpointSet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcOffboardResult: Mavsdk_Rpc_Offboard_OffboardResult {
            var rpcOffboardResult = Mavsdk_Rpc_Offboard_OffboardResult()
            
                
            rpcOffboardResult.result = result.rpcResult
                
            
            
                
            rpcOffboardResult.resultStr = resultStr
                
            

            return rpcOffboardResult
        }

        internal static func translateFromRpc(_ rpcOffboardResult: Mavsdk_Rpc_Offboard_OffboardResult) -> OffboardResult {
            return OffboardResult(result: Result.translateFromRpc(rpcOffboardResult.result), resultStr: rpcOffboardResult.resultStr)
        }

        public static func == (lhs: OffboardResult, rhs: OffboardResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func start() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Offboard_StartRequest()

            

            do {
                
                let response = try self.service.start(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func stop() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_Offboard_StopRequest()

            

            do {
                
                let response = try self.service.stop(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func isActive() -> Single<Bool> {
        return Single<Bool>.create { single in
            let request = Mavsdk_Rpc_Offboard_IsActiveRequest()

            

            do {
                let response = try self.service.isActive(request)

                

                let isActive = response.isActive
                
                single(.success(isActive))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setAttitude(attitude: Attitude) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetAttitudeRequest()

            
                
            request.attitude = attitude.rpcAttitude
                
            

            do {
                
                let response = try self.service.setAttitude(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setActuatorControl(actuatorControl: ActuatorControl) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetActuatorControlRequest()

            
                
            request.actuatorControl = actuatorControl.rpcActuatorControl
                
            

            do {
                
                let response = try self.service.setActuatorControl(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setAttitudeRate(attitudeRate: AttitudeRate) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetAttitudeRateRequest()

            
                
            request.attitudeRate = attitudeRate.rpcAttitudeRate
                
            

            do {
                
                let response = try self.service.setAttitudeRate(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setPositionNed(positionNedYaw: PositionNedYaw) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetPositionNedRequest()

            
                
            request.positionNedYaw = positionNedYaw.rpcPositionNedYaw
                
            

            do {
                
                let response = try self.service.setPositionNed(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setVelocityBody(velocityBodyYawspeed: VelocityBodyYawspeed) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetVelocityBodyRequest()

            
                
            request.velocityBodyYawspeed = velocityBodyYawspeed.rpcVelocityBodyYawspeed
                
            

            do {
                
                let response = try self.service.setVelocityBody(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setVelocityNed(velocityNedYaw: VelocityNedYaw) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Offboard_SetVelocityNedRequest()

            
                
            request.velocityNedYaw = velocityNedYaw.rpcVelocityNedYaw
                
            

            do {
                
                let response = try self.service.setVelocityNed(request)

                if (response.offboardResult.result == Mavsdk_Rpc_Offboard_OffboardResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(OffboardError(code: OffboardResult.Result.translateFromRpc(response.offboardResult.result), description: response.offboardResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}