import Foundation
import SwiftGRPC
import RxSwift

// MARK: - Position
public struct Position: Equatable {
    public let latitudeDeg: Double
    public let longitudeDeg: Double
    public let absoluteAltitudeM: Float
    public let relativeAltitudeM: Float
    
    internal var rpcCameraPosition: DronecodeSdk_Rpc_Camera_Position {
        var rpcPosition = DronecodeSdk_Rpc_Camera_Position()
        rpcPosition.latitudeDeg = latitudeDeg
        rpcPosition.longitudeDeg = longitudeDeg
        rpcPosition.absoluteAltitudeM = absoluteAltitudeM
        rpcPosition.relativeAltitudeM = relativeAltitudeM
        
        return rpcPosition
    }

    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.latitudeDeg == rhs.latitudeDeg
            && lhs.longitudeDeg == rhs.longitudeDeg
            && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
            && lhs.relativeAltitudeM == rhs.relativeAltitudeM
    }
}

// MARK: - Health
public struct Health: Equatable {
    public let isGyrometerCalibrationOk: Bool
    public let isAccelerometerCalibrationOk: Bool
    public let isMagnetometerCalibrationOk: Bool
    public let isLevelCalibrationOk: Bool
    public let isLocalPositionOk: Bool
    public let isGlobalPositionOk: Bool
    public let isHomePositionOk: Bool

    public static func == (lhs: Health, rhs: Health) -> Bool {
        return lhs.isGyrometerCalibrationOk == rhs.isGyrometerCalibrationOk
            && lhs.isAccelerometerCalibrationOk == rhs.isAccelerometerCalibrationOk
            && lhs.isMagnetometerCalibrationOk == rhs.isMagnetometerCalibrationOk
            && lhs.isLevelCalibrationOk == rhs.isLevelCalibrationOk
            && lhs.isLocalPositionOk == rhs.isLocalPositionOk
            && lhs.isGlobalPositionOk == rhs.isGlobalPositionOk
            && lhs.isHomePositionOk == rhs.isHomePositionOk
    }
}

// MARK: - Battery
public struct Battery: Equatable {
    public let remainingPercent: Float
    public let voltageV: Float
    
    public static func == (lhs: Battery, rhs: Battery) -> Bool {
        return lhs.remainingPercent == rhs.remainingPercent
            && lhs.voltageV == rhs.voltageV
    }
}

// MARK: - EulerAngle
public struct EulerAngle: Equatable {
    public let pitchDeg: Float
    public let rollDeg: Float
    public let yawDeg: Float
    
    public static func == (lhs: EulerAngle, rhs: EulerAngle) -> Bool {
        return lhs.pitchDeg == rhs.pitchDeg
            && lhs.rollDeg == rhs.rollDeg
            && lhs.yawDeg == rhs.yawDeg
    }
}

// MARK: - Quaternion
public struct Quaternion: Equatable {
    public let w: Float
    public let x: Float
    public let y: Float
    public let z: Float
    
    public static func == (lhs: Quaternion, rhs: Quaternion) -> Bool {
        return lhs.w == rhs.w
            && lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.z == rhs.z
    }
    
    internal var rpcCameraQuaternion: DronecodeSdk_Rpc_Camera_Quaternion {
        var rpcQuaternion = DronecodeSdk_Rpc_Camera_Quaternion()
        rpcQuaternion.x = x
        rpcQuaternion.y = y
        rpcQuaternion.w = w
        rpcQuaternion.z = z

        return rpcQuaternion
    }

    internal static func translateFromRPC(_ rpcQuaternion: DronecodeSdk_Rpc_Camera_Quaternion) -> Quaternion {
        return Quaternion( w: rpcQuaternion.w, x: rpcQuaternion.x, y: rpcQuaternion.y, z: rpcQuaternion.z)
    }
}

// MARK: - GPSInfo
// eDroneCoreGPSInfoFix <=> DronecodeSdk_Rpc_Telemetry_FixType in telemetry.grpc.swift
public enum eDroneCoreGPSInfoFix: Int {
    case noGps // = 0
    case noFix // = 1
    case fix2D // = 2
    case fix3D // = 3
    case fixDgps // = 4
    case rtkFloat // = 5
    case rtkFixed // = 6
}

public struct GPSInfo: Equatable {
    public let numSatellites: Int32
    public let fixType: eDroneCoreGPSInfoFix
    
    public static func == (lhs: GPSInfo, rhs: GPSInfo) -> Bool {
        return lhs.numSatellites == rhs.numSatellites
            && lhs.fixType == rhs.fixType
    }
}

// MARK: - FlightMode
// eDroneCoreFlightMode <=> DronecodeSdk_Rpc_Telemetry_FlightMode in telemetry.grpc.swift
public enum eDroneCoreFlightMode: Int {
    case unknown // = 0
    case ready // = 1
    case takeoff // = 2
    case hold // = 3
    case mission // = 4
    case returnToLaunch // = 5
    case land // = 6
    case offboard // = 7
    case followMe // = 8
}

// MARK: - GroundSpeedNED
public struct GroundSpeedNED: Equatable {
    public let velocityNorthMS: Float
    public let velocityEastMS: Float
    public let velocityDownMS: Float
   
    public static func == (lhs: GroundSpeedNED, rhs: GroundSpeedNED) -> Bool {
        return lhs.velocityNorthMS == rhs.velocityNorthMS
            && lhs.velocityEastMS == rhs.velocityEastMS
            && lhs.velocityDownMS == rhs.velocityDownMS
    }
}

// MARK: - RCStatus
public struct RCStatus: Equatable {
    public let wasAvailableOnce: Bool
    public let isAvailable: Bool
    public let signalStrengthPercent: Float
    
    public static func == (lhs: RCStatus, rhs: RCStatus) -> Bool {
        return lhs.wasAvailableOnce == rhs.wasAvailableOnce
            && lhs.isAvailable == rhs.isAvailable
            && lhs.signalStrengthPercent == rhs.signalStrengthPercent
    }
}

// MARK: - TELEMETRY
public class Telemetry {
    private let service: DronecodeSdk_Rpc_Telemetry_TelemetryServiceService
    private let scheduler: SchedulerType
    
    public lazy var positionObservable: Observable<Position> = createPositionObservable()
    public lazy var homePositionObservable: Observable<Position> = createHomePositionObservable()
    public lazy var inAirObservable: Observable<Bool> = createInAirObservable()
    public lazy var armedObservable: Observable<Bool> = createArmedObservable()
    public lazy var attitudeQuaternionObservable: Observable<Quaternion> = createAttitudeQuaternionObservable()
    public lazy var attitudeEulerObservable: Observable<EulerAngle> = createAttitudeEulerObservable()
    public lazy var cameraAttitudeQuaternionObservable: Observable<Quaternion> = createCameraAttitudeQuaternionObservable()
    public lazy var cameraAttitudeEulerObservable: Observable<EulerAngle> = createCameraAttitudeEulerObservable()
    public lazy var GPSInfoObservable: Observable<GPSInfo> = createGPSInfoObservable()
    public lazy var batteryObservable: Observable<Battery> = createBatteryObservable()
    public lazy var healthObservable: Observable<Health> = createHealthObservable()
    public lazy var flightModeObservable: Observable<eDroneCoreFlightMode> = createFlightModeObservable()
    public lazy var groundSpeedNEDObservable: Observable<GroundSpeedNED> = createGroundSpeedNEDObservable()
    public lazy var rcStatusObservable: Observable<RCStatus> = createRCStatusObservable()

    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Telemetry_TelemetryServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
    // MARK: - Privates functions

    private func createPositionObservable() -> Observable<Position> {
        return Observable.create { observer in
            let positionRequest = DronecodeSdk_Rpc_Telemetry_SubscribePositionRequest()

            do {
                let call = try self.service.subscribePosition(positionRequest, completion: nil)
                while let response = try? call.receive() {
                    let position = Position(latitudeDeg: response!.position.latitudeDeg, longitudeDeg: response!.position.longitudeDeg, absoluteAltitudeM: response!.position.absoluteAltitudeM, relativeAltitudeM: response!.position.relativeAltitudeM)

                    observer.onNext(position)
                }
            } catch {
                observer.onError("Failed to subscribe to position stream")
            }

            return Disposables.create()
        }.subscribeOn(self.scheduler)
    }

    private func createInAirObservable() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let inAirRequest = DronecodeSdk_Rpc_Telemetry_SubscribeInAirRequest()

            do {
                let call = try self.service.subscribeInAir(inAirRequest, completion: nil)
                while let response = try? call.receive() {
                    observer.onNext((response?.isInAir)!)
                }
            } catch {
                observer.onError("Failed to subscribe to inAir stream: \(error)")
            }

            return Disposables.create {}
        }.subscribeOn(self.scheduler)
    }

    private func createArmedObservable() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let armedRequest = DronecodeSdk_Rpc_Telemetry_SubscribeArmedRequest()

            do {
                let call = try self.service.subscribeArmed(armedRequest, completion: nil)
                while let response = try? call.receive() {
                    observer.onNext((response?.isArmed)!)
                }
            } catch {
                observer.onError("Failed to subscribe to armed stream: \(error)")
            }

            return Disposables.create {}
            }.subscribeOn(self.scheduler)
    }
    
    private func createHealthObservable() -> Observable<Health> {
        return Observable.create { observer in
            let healthRequest = DronecodeSdk_Rpc_Telemetry_SubscribeHealthRequest()
            
            do {
                let call = try self.service.subscribeHealth(healthRequest, completion: nil)
                while let response = try? call.receive() {
                    let health = Health(isGyrometerCalibrationOk: (response?.health.isGyrometerCalibrationOk)!, isAccelerometerCalibrationOk: (response?.health.isAccelerometerCalibrationOk)!, isMagnetometerCalibrationOk: (response?.health.isMagnetometerCalibrationOk)!, isLevelCalibrationOk: (response?.health.isLevelCalibrationOk)!, isLocalPositionOk: (response?.health.isLocalPositionOk)!, isGlobalPositionOk: (response?.health.isGlobalPositionOk)!, isHomePositionOk: (response?.health.isHomePositionOk)!)
                    
                    observer.onNext(health)
                }
            } catch {
                observer.onError("Failed to subscribe to health stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createBatteryObservable() -> Observable<Battery> {
        return Observable.create { observer in
            let batteryRequest = DronecodeSdk_Rpc_Telemetry_SubscribeBatteryRequest()
            
            do {
                let call = try self.service.subscribeBattery(batteryRequest, completion: nil)
                while let response = try? call.receive() {
                    let battery = Battery(remainingPercent: (response?.battery.remainingPercent)!, voltageV: (response?.battery.voltageV)!)
                    
                    observer.onNext(battery)
                }
            } catch {
                observer.onError("Failed to subscribe to battery stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let attitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeAttitudeEulerRequest()
            
            do {
                let call = try self.service.subscribeAttitudeEuler(attitudeRequest, completion: nil)
                while let response = try? call.receive() {
                    
                    let attitude = EulerAngle(pitchDeg: (response?.attitudeEuler.pitchDeg)!, rollDeg: (response?.attitudeEuler.rollDeg)!, yawDeg: (response?.attitudeEuler.yawDeg)!)
                    
                    observer.onNext(attitude)
                }
            } catch {
                observer.onError("Failed to subscribe to attitude euler stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createCameraAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let cameraAttitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeCameraAttitudeEulerRequest()
            
            do {
                let call = try self.service.subscribeCameraAttitudeEuler(cameraAttitudeRequest, completion: nil)
                while let response = try? call.receive() {
                    
                    let attitude = EulerAngle(pitchDeg: (response?.attitudeEuler.pitchDeg)!, rollDeg: (response?.attitudeEuler.rollDeg)!, yawDeg: (response?.attitudeEuler.yawDeg)!)
                    
                    observer.onNext(attitude)
                }
            } catch {
                observer.onError("Failed to subscribe to camera attitude euler stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { observer in
            let attitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeAttitudeQuaternionRequest()
            
            do {
                let call = try self.service.subscribeAttitudeQuaternion(attitudeRequest, completion: nil)
                while let response = try? call.receive() {
                    
                    let attitude = Quaternion(w: (response?.attitudeQuaternion.w)!, x: (response?.attitudeQuaternion.x)!, y: (response?.attitudeQuaternion.y)!, z: (response?.attitudeQuaternion.z)!)
                    
                    observer.onNext(attitude)
                }
            } catch {
                observer.onError("Failed to subscribe to attitude quaternion stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createCameraAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { observer in
            let cameraAttitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeCameraAttitudeQuaternionRequest()
            
            do {
                let call = try self.service.subscribeCameraAttitudeQuaternion(cameraAttitudeRequest, completion: nil)
                while let response = try? call.receive() {
                    
                    let attitude = Quaternion(w: (response?.attitudeQuaternion.w)!, x: (response?.attitudeQuaternion.x)!, y: (response?.attitudeQuaternion.y)!, z: (response?.attitudeQuaternion.z)!)
                    
                    observer.onNext(attitude)
                }
            } catch {
                observer.onError("Failed to subscribe to camera attitude quaternion stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createHomePositionObservable() -> Observable<Position> {
        return Observable.create { observer in
            let homeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeHomeRequest()
            
            do {
                let call = try self.service.subscribeHome(homeRequest, completion: nil)
                while let response = try? call.receive() {
                    let position = Position(latitudeDeg: (response?.home.latitudeDeg)!, longitudeDeg: (response?.home.longitudeDeg)!, absoluteAltitudeM: (response?.home.absoluteAltitudeM)!, relativeAltitudeM: (response?.home.relativeAltitudeM)!)
                    observer.onNext(position)
                }
            } catch {
                observer.onError("Failed to subscribe to home stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createGPSInfoObservable() -> Observable<GPSInfo> {
        return Observable.create { observer in
            let gpsInfoRequest = DronecodeSdk_Rpc_Telemetry_SubscribeGPSInfoRequest()
            
            do {
                let call = try self.service.subscribeGPSInfo(gpsInfoRequest, completion: nil)
                while let response = try? call.receive() {
                    let gpsInfo = GPSInfo(numSatellites: (response?.gpsInfo.numSatellites)!, fixType: eDroneCoreGPSInfoFix(rawValue: (response?.gpsInfo.fixType.rawValue)!)!)
                    observer.onNext(gpsInfo)
                }
            } catch {
                observer.onError("Failed to subscribe to GPSInfo stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createFlightModeObservable() -> Observable<eDroneCoreFlightMode> {
        return Observable.create { observer in
            let flightModeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeFlightModeRequest()
            
            do {
                let call = try self.service.subscribeFlightMode(flightModeRequest, completion: nil)
                while let response = try? call.receive() {
                    let flightMode : eDroneCoreFlightMode = eDroneCoreFlightMode(rawValue: response!.flightMode.rawValue)!
                    observer.onNext(flightMode)
                }
            } catch {
                observer.onError("Failed to subscribe to FlightMode stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createGroundSpeedNEDObservable() -> Observable<GroundSpeedNED> {
        return Observable.create { observer in
            let groundSpeedRequest = DronecodeSdk_Rpc_Telemetry_SubscribeGroundSpeedNEDRequest()
            
            do {
                let call = try self.service.subscribeGroundSpeedNED(groundSpeedRequest, completion: nil)
                while let response = try? call.receive() {
                    let groundSpeed : GroundSpeedNED = GroundSpeedNED(velocityNorthMS: response!.groundSpeedNed.velocityNorthMS, velocityEastMS: response!.groundSpeedNed.velocityEastMS, velocityDownMS: response!.groundSpeedNed.velocityDownMS)
                    observer.onNext(groundSpeed)
                }
            } catch {
                observer.onError("Failed to subscribe to Ground Speed NED stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createRCStatusObservable() -> Observable<RCStatus> {
        return Observable.create { observer in
            let rcstatusRequest = DronecodeSdk_Rpc_Telemetry_SubscribeRCStatusRequest()
            
            do {
                let call = try self.service.subscribeRCStatus(rcstatusRequest, completion: nil)
                while let response = try? call.receive() {
                    let rcstatus : RCStatus = RCStatus(wasAvailableOnce: response!.rcStatus.wasAvailableOnce, isAvailable: response!.rcStatus.isAvailable, signalStrengthPercent: response!.rcStatus.signalStrengthPercent)
                    observer.onNext(rcstatus)
                }
            } catch {
                observer.onError("Failed to subscribe to RC Status stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
}
