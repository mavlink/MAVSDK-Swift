import Foundation
import RxSwift
import SwiftGRPC

public class Mocap {
    private let service: Mavsdk_Rpc_Mocap_MocapServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Mocap_MocapServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Mocap_MocapServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeMocapError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct MocapError: Error {
        public let code: Mocap.MocapResult.Result
        public let description: String
    }
    


    public struct PositionBody: Equatable {
        public let xM: Float
        public let yM: Float
        public let zM: Float

        

        public init(xM: Float, yM: Float, zM: Float) {
            self.xM = xM
            self.yM = yM
            self.zM = zM
        }

        internal var rpcPositionBody: Mavsdk_Rpc_Mocap_PositionBody {
            var rpcPositionBody = Mavsdk_Rpc_Mocap_PositionBody()
            
                
            rpcPositionBody.xM = xM
                
            
            
                
            rpcPositionBody.yM = yM
                
            
            
                
            rpcPositionBody.zM = zM
                
            

            return rpcPositionBody
        }

        internal static func translateFromRpc(_ rpcPositionBody: Mavsdk_Rpc_Mocap_PositionBody) -> PositionBody {
            return PositionBody(xM: rpcPositionBody.xM, yM: rpcPositionBody.yM, zM: rpcPositionBody.zM)
        }

        public static func == (lhs: PositionBody, rhs: PositionBody) -> Bool {
            return lhs.xM == rhs.xM
                && lhs.yM == rhs.yM
                && lhs.zM == rhs.zM
        }
    }

    public struct AngleBody: Equatable {
        public let rollRad: Float
        public let pitchRad: Float
        public let yawRad: Float

        

        public init(rollRad: Float, pitchRad: Float, yawRad: Float) {
            self.rollRad = rollRad
            self.pitchRad = pitchRad
            self.yawRad = yawRad
        }

        internal var rpcAngleBody: Mavsdk_Rpc_Mocap_AngleBody {
            var rpcAngleBody = Mavsdk_Rpc_Mocap_AngleBody()
            
                
            rpcAngleBody.rollRad = rollRad
                
            
            
                
            rpcAngleBody.pitchRad = pitchRad
                
            
            
                
            rpcAngleBody.yawRad = yawRad
                
            

            return rpcAngleBody
        }

        internal static func translateFromRpc(_ rpcAngleBody: Mavsdk_Rpc_Mocap_AngleBody) -> AngleBody {
            return AngleBody(rollRad: rpcAngleBody.rollRad, pitchRad: rpcAngleBody.pitchRad, yawRad: rpcAngleBody.yawRad)
        }

        public static func == (lhs: AngleBody, rhs: AngleBody) -> Bool {
            return lhs.rollRad == rhs.rollRad
                && lhs.pitchRad == rhs.pitchRad
                && lhs.yawRad == rhs.yawRad
        }
    }

    public struct SpeedBody: Equatable {
        public let xMS: Float
        public let yMS: Float
        public let zMS: Float

        

        public init(xMS: Float, yMS: Float, zMS: Float) {
            self.xMS = xMS
            self.yMS = yMS
            self.zMS = zMS
        }

        internal var rpcSpeedBody: Mavsdk_Rpc_Mocap_SpeedBody {
            var rpcSpeedBody = Mavsdk_Rpc_Mocap_SpeedBody()
            
                
            rpcSpeedBody.xMS = xMS
                
            
            
                
            rpcSpeedBody.yMS = yMS
                
            
            
                
            rpcSpeedBody.zMS = zMS
                
            

            return rpcSpeedBody
        }

        internal static func translateFromRpc(_ rpcSpeedBody: Mavsdk_Rpc_Mocap_SpeedBody) -> SpeedBody {
            return SpeedBody(xMS: rpcSpeedBody.xMS, yMS: rpcSpeedBody.yMS, zMS: rpcSpeedBody.zMS)
        }

        public static func == (lhs: SpeedBody, rhs: SpeedBody) -> Bool {
            return lhs.xMS == rhs.xMS
                && lhs.yMS == rhs.yMS
                && lhs.zMS == rhs.zMS
        }
    }

    public struct AngularVelocityBody: Equatable {
        public let rollRadS: Float
        public let pitchRadS: Float
        public let yawRadS: Float

        

        public init(rollRadS: Float, pitchRadS: Float, yawRadS: Float) {
            self.rollRadS = rollRadS
            self.pitchRadS = pitchRadS
            self.yawRadS = yawRadS
        }

        internal var rpcAngularVelocityBody: Mavsdk_Rpc_Mocap_AngularVelocityBody {
            var rpcAngularVelocityBody = Mavsdk_Rpc_Mocap_AngularVelocityBody()
            
                
            rpcAngularVelocityBody.rollRadS = rollRadS
                
            
            
                
            rpcAngularVelocityBody.pitchRadS = pitchRadS
                
            
            
                
            rpcAngularVelocityBody.yawRadS = yawRadS
                
            

            return rpcAngularVelocityBody
        }

        internal static func translateFromRpc(_ rpcAngularVelocityBody: Mavsdk_Rpc_Mocap_AngularVelocityBody) -> AngularVelocityBody {
            return AngularVelocityBody(rollRadS: rpcAngularVelocityBody.rollRadS, pitchRadS: rpcAngularVelocityBody.pitchRadS, yawRadS: rpcAngularVelocityBody.yawRadS)
        }

        public static func == (lhs: AngularVelocityBody, rhs: AngularVelocityBody) -> Bool {
            return lhs.rollRadS == rhs.rollRadS
                && lhs.pitchRadS == rhs.pitchRadS
                && lhs.yawRadS == rhs.yawRadS
        }
    }

    public struct Covariance: Equatable {
        public let covarianceMatrix: [Float]

        

        public init(covarianceMatrix: [Float]) {
            self.covarianceMatrix = covarianceMatrix
        }

        internal var rpcCovariance: Mavsdk_Rpc_Mocap_Covariance {
            var rpcCovariance = Mavsdk_Rpc_Mocap_Covariance()
            
                
            rpcCovariance.covarianceMatrix = covarianceMatrix
                
            

            return rpcCovariance
        }

        internal static func translateFromRpc(_ rpcCovariance: Mavsdk_Rpc_Mocap_Covariance) -> Covariance {
            return Covariance(covarianceMatrix: rpcCovariance.covarianceMatrix)
        }

        public static func == (lhs: Covariance, rhs: Covariance) -> Bool {
            return lhs.covarianceMatrix == rhs.covarianceMatrix
        }
    }

    public struct Quaternion: Equatable {
        public let w: Float
        public let x: Float
        public let y: Float
        public let z: Float

        

        public init(w: Float, x: Float, y: Float, z: Float) {
            self.w = w
            self.x = x
            self.y = y
            self.z = z
        }

        internal var rpcQuaternion: Mavsdk_Rpc_Mocap_Quaternion {
            var rpcQuaternion = Mavsdk_Rpc_Mocap_Quaternion()
            
                
            rpcQuaternion.w = w
                
            
            
                
            rpcQuaternion.x = x
                
            
            
                
            rpcQuaternion.y = y
                
            
            
                
            rpcQuaternion.z = z
                
            

            return rpcQuaternion
        }

        internal static func translateFromRpc(_ rpcQuaternion: Mavsdk_Rpc_Mocap_Quaternion) -> Quaternion {
            return Quaternion(w: rpcQuaternion.w, x: rpcQuaternion.x, y: rpcQuaternion.y, z: rpcQuaternion.z)
        }

        public static func == (lhs: Quaternion, rhs: Quaternion) -> Bool {
            return lhs.w == rhs.w
                && lhs.x == rhs.x
                && lhs.y == rhs.y
                && lhs.z == rhs.z
        }
    }

    public struct VisionPositionEstimate: Equatable {
        public let timeUsec: UInt64
        public let positionBody: PositionBody
        public let angleBody: AngleBody
        public let poseCovariance: Covariance

        

        public init(timeUsec: UInt64, positionBody: PositionBody, angleBody: AngleBody, poseCovariance: Covariance) {
            self.timeUsec = timeUsec
            self.positionBody = positionBody
            self.angleBody = angleBody
            self.poseCovariance = poseCovariance
        }

        internal var rpcVisionPositionEstimate: Mavsdk_Rpc_Mocap_VisionPositionEstimate {
            var rpcVisionPositionEstimate = Mavsdk_Rpc_Mocap_VisionPositionEstimate()
            
                
            rpcVisionPositionEstimate.timeUsec = timeUsec
                
            
            
                
            rpcVisionPositionEstimate.positionBody = positionBody.rpcPositionBody
                
            
            
                
            rpcVisionPositionEstimate.angleBody = angleBody.rpcAngleBody
                
            
            
                
            rpcVisionPositionEstimate.poseCovariance = poseCovariance.rpcCovariance
                
            

            return rpcVisionPositionEstimate
        }

        internal static func translateFromRpc(_ rpcVisionPositionEstimate: Mavsdk_Rpc_Mocap_VisionPositionEstimate) -> VisionPositionEstimate {
            return VisionPositionEstimate(timeUsec: rpcVisionPositionEstimate.timeUsec, positionBody: PositionBody.translateFromRpc(rpcVisionPositionEstimate.positionBody), angleBody: AngleBody.translateFromRpc(rpcVisionPositionEstimate.angleBody), poseCovariance: Covariance.translateFromRpc(rpcVisionPositionEstimate.poseCovariance))
        }

        public static func == (lhs: VisionPositionEstimate, rhs: VisionPositionEstimate) -> Bool {
            return lhs.timeUsec == rhs.timeUsec
                && lhs.positionBody == rhs.positionBody
                && lhs.angleBody == rhs.angleBody
                && lhs.poseCovariance == rhs.poseCovariance
        }
    }

    public struct AttitudePositionMocap: Equatable {
        public let timeUsec: UInt64
        public let q: Quaternion
        public let positionBody: PositionBody
        public let poseCovariance: Covariance

        

        public init(timeUsec: UInt64, q: Quaternion, positionBody: PositionBody, poseCovariance: Covariance) {
            self.timeUsec = timeUsec
            self.q = q
            self.positionBody = positionBody
            self.poseCovariance = poseCovariance
        }

        internal var rpcAttitudePositionMocap: Mavsdk_Rpc_Mocap_AttitudePositionMocap {
            var rpcAttitudePositionMocap = Mavsdk_Rpc_Mocap_AttitudePositionMocap()
            
                
            rpcAttitudePositionMocap.timeUsec = timeUsec
                
            
            
                
            rpcAttitudePositionMocap.q = q.rpcQuaternion
                
            
            
                
            rpcAttitudePositionMocap.positionBody = positionBody.rpcPositionBody
                
            
            
                
            rpcAttitudePositionMocap.poseCovariance = poseCovariance.rpcCovariance
                
            

            return rpcAttitudePositionMocap
        }

        internal static func translateFromRpc(_ rpcAttitudePositionMocap: Mavsdk_Rpc_Mocap_AttitudePositionMocap) -> AttitudePositionMocap {
            return AttitudePositionMocap(timeUsec: rpcAttitudePositionMocap.timeUsec, q: Quaternion.translateFromRpc(rpcAttitudePositionMocap.q), positionBody: PositionBody.translateFromRpc(rpcAttitudePositionMocap.positionBody), poseCovariance: Covariance.translateFromRpc(rpcAttitudePositionMocap.poseCovariance))
        }

        public static func == (lhs: AttitudePositionMocap, rhs: AttitudePositionMocap) -> Bool {
            return lhs.timeUsec == rhs.timeUsec
                && lhs.q == rhs.q
                && lhs.positionBody == rhs.positionBody
                && lhs.poseCovariance == rhs.poseCovariance
        }
    }

    public struct Odometry: Equatable {
        public let timeUsec: UInt64
        public let frameID: MavFrame
        public let positionBody: PositionBody
        public let q: Quaternion
        public let speedBody: SpeedBody
        public let angularVelocityBody: AngularVelocityBody
        public let poseCovariance: Covariance
        public let velocityCovariance: Covariance

        
        

        public enum MavFrame: Equatable {
            case mocapNed
            case localFrd
            case UNRECOGNIZED(Int)

            internal var rpcMavFrame: Mavsdk_Rpc_Mocap_Odometry.MavFrame {
                switch self {
                case .mocapNed:
                    return .mocapNed
                case .localFrd:
                    return .localFrd
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcMavFrame: Mavsdk_Rpc_Mocap_Odometry.MavFrame) -> MavFrame {
                switch rpcMavFrame {
                case .mocapNed:
                    return .mocapNed
                case .localFrd:
                    return .localFrd
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(timeUsec: UInt64, frameID: MavFrame, positionBody: PositionBody, q: Quaternion, speedBody: SpeedBody, angularVelocityBody: AngularVelocityBody, poseCovariance: Covariance, velocityCovariance: Covariance) {
            self.timeUsec = timeUsec
            self.frameID = frameID
            self.positionBody = positionBody
            self.q = q
            self.speedBody = speedBody
            self.angularVelocityBody = angularVelocityBody
            self.poseCovariance = poseCovariance
            self.velocityCovariance = velocityCovariance
        }

        internal var rpcOdometry: Mavsdk_Rpc_Mocap_Odometry {
            var rpcOdometry = Mavsdk_Rpc_Mocap_Odometry()
            
                
            rpcOdometry.timeUsec = timeUsec
                
            
            
                
            rpcOdometry.frameID = frameID.rpcMavFrame
                
            
            
                
            rpcOdometry.positionBody = positionBody.rpcPositionBody
                
            
            
                
            rpcOdometry.q = q.rpcQuaternion
                
            
            
                
            rpcOdometry.speedBody = speedBody.rpcSpeedBody
                
            
            
                
            rpcOdometry.angularVelocityBody = angularVelocityBody.rpcAngularVelocityBody
                
            
            
                
            rpcOdometry.poseCovariance = poseCovariance.rpcCovariance
                
            
            
                
            rpcOdometry.velocityCovariance = velocityCovariance.rpcCovariance
                
            

            return rpcOdometry
        }

        internal static func translateFromRpc(_ rpcOdometry: Mavsdk_Rpc_Mocap_Odometry) -> Odometry {
            return Odometry(timeUsec: rpcOdometry.timeUsec, frameID: MavFrame.translateFromRpc(rpcOdometry.frameID), positionBody: PositionBody.translateFromRpc(rpcOdometry.positionBody), q: Quaternion.translateFromRpc(rpcOdometry.q), speedBody: SpeedBody.translateFromRpc(rpcOdometry.speedBody), angularVelocityBody: AngularVelocityBody.translateFromRpc(rpcOdometry.angularVelocityBody), poseCovariance: Covariance.translateFromRpc(rpcOdometry.poseCovariance), velocityCovariance: Covariance.translateFromRpc(rpcOdometry.velocityCovariance))
        }

        public static func == (lhs: Odometry, rhs: Odometry) -> Bool {
            return lhs.timeUsec == rhs.timeUsec
                && lhs.frameID == rhs.frameID
                && lhs.positionBody == rhs.positionBody
                && lhs.q == rhs.q
                && lhs.speedBody == rhs.speedBody
                && lhs.angularVelocityBody == rhs.angularVelocityBody
                && lhs.poseCovariance == rhs.poseCovariance
                && lhs.velocityCovariance == rhs.velocityCovariance
        }
    }

    public struct MocapResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case noSystem
            case connectionError
            case invalidRequestData
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Mocap_MocapResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .invalidRequestData:
                    return .invalidRequestData
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Mocap_MocapResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .invalidRequestData:
                    return .invalidRequestData
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcMocapResult: Mavsdk_Rpc_Mocap_MocapResult {
            var rpcMocapResult = Mavsdk_Rpc_Mocap_MocapResult()
            
                
            rpcMocapResult.result = result.rpcResult
                
            
            
                
            rpcMocapResult.resultStr = resultStr
                
            

            return rpcMocapResult
        }

        internal static func translateFromRpc(_ rpcMocapResult: Mavsdk_Rpc_Mocap_MocapResult) -> MocapResult {
            return MocapResult(result: Result.translateFromRpc(rpcMocapResult.result), resultStr: rpcMocapResult.resultStr)
        }

        public static func == (lhs: MocapResult, rhs: MocapResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func setVisionPositionEstimate(visionPositionEstimate: VisionPositionEstimate) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Mocap_SetVisionPositionEstimateRequest()

            
                
            request.visionPositionEstimate = visionPositionEstimate.rpcVisionPositionEstimate
                
            

            do {
                
                let response = try self.service.setVisionPositionEstimate(request)

                if (response.mocapResult.result == Mavsdk_Rpc_Mocap_MocapResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MocapError(code: MocapResult.Result.translateFromRpc(response.mocapResult.result), description: response.mocapResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setAttitudePositionMocap(attitudePositionMocap: AttitudePositionMocap) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Mocap_SetAttitudePositionMocapRequest()

            
                
            request.attitudePositionMocap = attitudePositionMocap.rpcAttitudePositionMocap
                
            

            do {
                
                let response = try self.service.setAttitudePositionMocap(request)

                if (response.mocapResult.result == Mavsdk_Rpc_Mocap_MocapResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MocapError(code: MocapResult.Result.translateFromRpc(response.mocapResult.result), description: response.mocapResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    public func setOdometry(odometry: Odometry) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Mocap_SetOdometryRequest()

            
                
            request.odometry = odometry.rpcOdometry
                
            

            do {
                
                let response = try self.service.setOdometry(request)

                if (response.mocapResult.result == Mavsdk_Rpc_Mocap_MocapResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(MocapError(code: MocapResult.Result.translateFromRpc(response.mocapResult.result), description: response.mocapResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}