import Foundation
import SwiftGRPC
import RxSwift

/**
 Position type in global coordinates.
 */
public struct Position: Equatable {
    /// Latitude in degrees (range: -90 to +90).
    public let latitudeDeg: Double
    /// Longitude in degrees (range: -180 to 180).
    public let longitudeDeg: Double
    /// Altitude AMSL (above mean sea level) in metres.
    public let absoluteAltitudeM: Float
    /// Altitude relative to takeoff altitude in metres.
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

/**
 Various health flags.
 */
public struct Health: Equatable {
    /// true if the gyrometer is calibrated.
    public let isGyrometerCalibrationOk: Bool
    /// true if the accelerometer is calibrated.
    public let isAccelerometerCalibrationOk: Bool
    /// true if the magnetometer is calibrated.
    public let isMagnetometerCalibrationOk: Bool
    /// true if the vehicle has a valid level calibration.
    public let isLevelCalibrationOk: Bool
    /// true if the local position estimate is good enough to fly in a position control mode.
    public let isLocalPositionOk: Bool
    /// true if the global position estimate is good enough to fly in a position controlled mode
    public let isGlobalPositionOk: Bool
    /// true if the home position has been initialized properly.
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

/**
 Get the current battery status.
 */
public struct Battery: Equatable {
    public let remainingPercent: Float
    public let voltageV: Float
    
    public static func == (lhs: Battery, rhs: Battery) -> Bool {
        return lhs.remainingPercent == rhs.remainingPercent
            && lhs.voltageV == rhs.voltageV
    }
}

/**
 Euler angle type.
 
 All rotations and axis systems follow the right-hand rule.
 The Euler angles follow the convention of a 3-2-1 intrinsic Tait-Bryan rotation sequence.
 For more info see https://en.wikipedia.org/wiki/Euler_angles
 */
public struct EulerAngle: Equatable {
    /// Roll angle in degrees, positive is banking to the right.
    public let pitchDeg: Float
    /// Pitch angle in degrees, positive is pitching nose up.
    public let rollDeg: Float
    /// Yaw angle in degrees, positive is clock-wise seen from above.
    public let yawDeg: Float
    
    public static func == (lhs: EulerAngle, rhs: EulerAngle) -> Bool {
        return lhs.pitchDeg == rhs.pitchDeg
            && lhs.rollDeg == rhs.rollDeg
            && lhs.yawDeg == rhs.yawDeg
    }
    
    internal var rpcCameraEulerAngle: DronecodeSdk_Rpc_Camera_EulerAngle {
        var rpcEulerAngle = DronecodeSdk_Rpc_Camera_EulerAngle()
        rpcEulerAngle.pitchDeg = pitchDeg
        rpcEulerAngle.rollDeg = rollDeg
        rpcEulerAngle.yawDeg = yawDeg
        
        return rpcEulerAngle
    }
    
    internal static func translateFromRPC(_ rpcEulerAngle: DronecodeSdk_Rpc_Camera_EulerAngle) -> EulerAngle {
        return EulerAngle(pitchDeg: rpcEulerAngle.pitchDeg, rollDeg: rpcEulerAngle.rollDeg, yawDeg: rpcEulerAngle.yawDeg)
    }

}

/**
 Quaternion type.
 
 All rotations and axis systems follow the right-hand rule.
 The Hamilton quaternion product definition is used.
 A zero-rotation quaternion is represented by (1,0,0,0).
 The quaternion could also be written as w + xi + yj + zk.
 
 For more info see: https://en.wikipedia.org/wiki/Quaternion
 */
public struct Quaternion: Equatable {
    /// Quaternion entry 0 also denoted as a.
    public let w: Float
    /// Quaternion entry 1 also denoted as b.
    public let x: Float
    /// Quaternion entry 2 also denoted as c.
    public let y: Float
    /// Quaternion entry 3 also denoted as d.
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

/**
 GPS fix type.
 
 - Todo: fix name
 */
public enum eDroneCoreGPSInfoFix: Int {
    /// No GPS.
    case noGps // = 0
    /// No fix.
    case noFix // = 1
    /// 2D fix.
    case fix2D // = 2
    /// 3D fix.
    case fix3D // = 3
    /// DGPS fix.
    case fixDgps // = 4
    /// RTK floating.
    case rtkFloat // = 5
    /// RTK fixed.
    case rtkFixed // = 6
}

/**
 GPS information type.
 */
public struct GPSInfo: Equatable {
    /// Number of visible satellites used for solution.
    public let numSatellites: Int32
    /// Fix type.
    public let fixType: eDroneCoreGPSInfoFix
    
    public static func == (lhs: GPSInfo, rhs: GPSInfo) -> Bool {
        return lhs.numSatellites == rhs.numSatellites
            && lhs.fixType == rhs.fixType
    }
}

/**
 Flight mode.
 
 - Todo: fix name
 */
public enum eDroneCoreFlightMode: Int {
    /// Unknown.
    case unknown // = 0
    /// Ready.
    case ready // = 1
    /// Takeoff.
    case takeoff // = 2
    /// Hold.
    case hold // = 3
    /// Mission.
    case mission // = 4
    /// Return-to-launch.
    case returnToLaunch // = 5
    /// Land.
    case land // = 6
    /// Offboard.
    case offboard // = 7
    /// Follow-me.
    case followMe // = 8
}

/**
 Ground speed type.
 
 The ground speed is represented in the NED (North East Down) frame and in metres/second.
 */
public struct GroundSpeedNED: Equatable {
    /// Velocity in North direction in metres/second.
    public let velocityNorthMS: Float
    /// Velocity in East direction in metres/second.
    public let velocityEastMS: Float
    /// Velocity in Down direction in metres/second.
    public let velocityDownMS: Float
   
    public static func == (lhs: GroundSpeedNED, rhs: GroundSpeedNED) -> Bool {
        return lhs.velocityNorthMS == rhs.velocityNorthMS
            && lhs.velocityEastMS == rhs.velocityEastMS
            && lhs.velocityDownMS == rhs.velocityDownMS
    }
}

/**
 Remote control status type.
 */
public struct RCStatus: Equatable {
    /// true if an RC signal has been available once.
    public let wasAvailableOnce: Bool
    /// true if the RC signal is available now.
    public let isAvailable: Bool
    /// Signal strength as a percentage (range: 0 to 100).
    public let signalStrengthPercent: Float
    
    public static func == (lhs: RCStatus, rhs: RCStatus) -> Bool {
        return lhs.wasAvailableOnce == rhs.wasAvailableOnce
            && lhs.isAvailable == rhs.isAvailable
            && lhs.signalStrengthPercent == rhs.signalStrengthPercent
    }
}

/**
 This class allows users to get vehicle telemetry and state information (e.g. battery, GPS, RC connection, flight mode etc.) and set telemetry update rates.
 */
public class Telemetry {
    private let service: DronecodeSdk_Rpc_Telemetry_TelemetryServiceService
    private let scheduler: SchedulerType
    
    /**
     Subscribe to position updates.
     
     - Returns: A stream of updates.
     */
    public lazy var positionObservable: Observable<Position> = createPositionObservable()
    
    /**
     Subscribe to home position updates.
     
     - Returns: A stream of updates.
     */
    public lazy var homePositionObservable: Observable<Position> = createHomePositionObservable()
    
    /**
     Subscribe to in-air updates.
     
     - Returns: A stream of updates.
     */
    public lazy var inAirObservable: Observable<Bool> = createInAirObservable()
    
    /**
     Subscribe to home position updates.
     
     - Returns: A stream of updates.
     */
    public lazy var armedObservable: Observable<Bool> = createArmedObservable()
    
    /**
     Subscribe to attitude updates in quaternion.
     
     - Returns: A stream of updates.
     */
    public lazy var attitudeQuaternionObservable: Observable<Quaternion> = createAttitudeQuaternionObservable()
    
    /**
     Subscribe to attitude updates in Euler angle.
     
     - Returns: A stream of updates.
     */
    public lazy var attitudeEulerObservable: Observable<EulerAngle> = createAttitudeEulerObservable()
    
    /**
     Subscribe to the camera attitude updates in quaternion.
     
     - Returns: A stream of updates.
     */
    public lazy var cameraAttitudeQuaternionObservable: Observable<Quaternion> = createCameraAttitudeQuaternionObservable()
    
    /**
     Subscribe to camera attitude updates in Euler angle.
     
     - Returns: A stream of updates.
     */
    public lazy var cameraAttitudeEulerObservable: Observable<EulerAngle> = createCameraAttitudeEulerObservable()
    
    /**
     Subscribe to GPS info updates.
     
     - Returns: A stream of updates.
     */
    public lazy var GPSInfoObservable: Observable<GPSInfo> = createGPSInfoObservable()
    
    /**
     Subscribe to GPS info updates.
     
     - Returns: A stream of updates.
     */
    public lazy var batteryObservable: Observable<Battery> = createBatteryObservable()
    
    /**
     Subscribe to health updates.
     
     - Returns: A stream of updates.
     */
    public lazy var healthObservable: Observable<Health> = createHealthObservable()
    
    /**
     Subscribe to flight mode updates.
     
     - Returns: A stream of updates.
     */
    public lazy var flightModeObservable: Observable<eDroneCoreFlightMode> = createFlightModeObservable()
    
    /**
     Subscribe to ground speed updates in NED.
     
     - Returns: A stream of updates.
     */
    public lazy var groundSpeedNEDObservable: Observable<GroundSpeedNED> = createGroundSpeedNEDObservable()
    
    /**
     Subscribe to RC status updates.
     
     - Returns: A stream of updates.
     */
    public lazy var rcStatusObservable: Observable<RCStatus> = createRCStatusObservable()

    /**
     Helper function to connect `Telemetry` object to the backend.
     
     - Parameter address: Network address of backend (IP or "localhost").
     - Parameter port: Port number of backend.
     */
    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Telemetry_TelemetryServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Telemetry_TelemetryServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
    private func createPositionObservable() -> Observable<Position> {
        return Observable.create { observer in
            let positionRequest = DronecodeSdk_Rpc_Telemetry_SubscribePositionRequest()
            
            do {
                let call = try self.service.subscribePosition(positionRequest, completion: { callResult in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodePositionReceiver").async {
                    do {
                        while let response = try call.receive() {
                            let position = Position(latitudeDeg: response.position.latitudeDeg, longitudeDeg: response.position.longitudeDeg, absoluteAltitudeM: response.position.absoluteAltitudeM, relativeAltitudeM: response.position.relativeAltitudeM)
                            
                            observer.onNext(position)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to position stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createInAirObservable() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let inAirRequest = DronecodeSdk_Rpc_Telemetry_SubscribeInAirRequest()
            
            do {
                let call = try self.service.subscribeInAir(inAirRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeInAirReceiver").async {
                    do {
                        while let isInAir = try call.receive()?.isInAir {
                            observer.onNext(isInAir)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to isInAir stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createArmedObservable() -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            let armedRequest = DronecodeSdk_Rpc_Telemetry_SubscribeArmedRequest()
            
            do {
                let call = try self.service.subscribeArmed(armedRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeIsArmedReceiver").async {
                    do {
                        while let isArmed = try call.receive()?.isArmed {
                            observer.onNext(isArmed)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to isArmed stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createHealthObservable() -> Observable<Health> {
        return Observable.create { observer in
            let healthRequest = DronecodeSdk_Rpc_Telemetry_SubscribeHealthRequest()
            
            do {
                let call = try self.service.subscribeHealth(healthRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeHealthReceiver").async {
                    do {
                        while let rpcHealth = try call.receive()?.health {
                            let health = Health(isGyrometerCalibrationOk: rpcHealth.isGyrometerCalibrationOk,
                                                isAccelerometerCalibrationOk: rpcHealth.isAccelerometerCalibrationOk,
                                                isMagnetometerCalibrationOk: rpcHealth.isMagnetometerCalibrationOk,
                                                isLevelCalibrationOk: rpcHealth.isLevelCalibrationOk,
                                                isLocalPositionOk: rpcHealth.isLocalPositionOk,
                                                isGlobalPositionOk: rpcHealth.isGlobalPositionOk,
                                                isHomePositionOk: rpcHealth.isHomePositionOk)
                            
                            observer.onNext(health)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to health stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createBatteryObservable() -> Observable<Battery> {
        return Observable.create { observer in
            let batteryRequest = DronecodeSdk_Rpc_Telemetry_SubscribeBatteryRequest()
            
            do {
                let call = try self.service.subscribeBattery(batteryRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeBatteryReceiver").async {
                    do {
                        while let rpcBattery = try call.receive()?.battery {
                            let battery = Battery(remainingPercent: rpcBattery.remainingPercent,
                                                  voltageV: rpcBattery.voltageV)
                            
                            observer.onNext(battery)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to battery stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let attitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeAttitudeEulerRequest()
            
            do {
                let call = try self.service.subscribeAttitudeEuler(attitudeRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeAttitudeEulerReceiver").async {
                    do {
                        while let rpcAttitudeEuler = try call.receive()?.attitudeEuler {
                            let attitude = EulerAngle(pitchDeg: rpcAttitudeEuler.pitchDeg,
                                                      rollDeg: rpcAttitudeEuler.rollDeg,
                                                      yawDeg: rpcAttitudeEuler.yawDeg)
                            
                            observer.onNext(attitude)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to attitude euler stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createCameraAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let cameraAttitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeCameraAttitudeEulerRequest()
            
            do {
                let call = try self.service.subscribeCameraAttitudeEuler(cameraAttitudeRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeCameraAttitudeEulerReceiver").async {
                    do {
                        while let rpcAttitudeEuler = try call.receive()?.attitudeEuler {
                            let attitude = EulerAngle(pitchDeg: rpcAttitudeEuler.pitchDeg,
                                                      rollDeg: rpcAttitudeEuler.rollDeg,
                                                      yawDeg: rpcAttitudeEuler.yawDeg)
                            
                            observer.onNext(attitude)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to camera attitude euler stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { observer in
            let attitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeAttitudeQuaternionRequest()
            
            do {
                let call = try self.service.subscribeAttitudeQuaternion(attitudeRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeAttitudeQuaternionReceiver").async {
                    do {
                        while let rpcAttitudeQuaternion = try call.receive()?.attitudeQuaternion {
                            let attitude = Quaternion(w: rpcAttitudeQuaternion.w,
                                                      x: rpcAttitudeQuaternion.x,
                                                      y: rpcAttitudeQuaternion.y,
                                                      z: rpcAttitudeQuaternion.z)
                            
                            observer.onNext(attitude)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to attitude quaternion stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createCameraAttitudeQuaternionObservable() -> Observable<Quaternion> {
        return Observable.create { observer in
            let cameraAttitudeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeCameraAttitudeQuaternionRequest()
            
            do {
                let call = try self.service.subscribeCameraAttitudeQuaternion(cameraAttitudeRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeCameraAttitudeQuaternionReceiver").async {
                    do {
                        while let rpcAttitudeQuaternion = try call.receive()?.attitudeQuaternion {
                            let attitude = Quaternion(w: rpcAttitudeQuaternion.w,
                                                      x: rpcAttitudeQuaternion.x,
                                                      y: rpcAttitudeQuaternion.y,
                                                      z: rpcAttitudeQuaternion.z)
                            
                            observer.onNext(attitude)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to camera attitude quaternion stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createHomePositionObservable() -> Observable<Position> {
        return Observable.create { observer in
            let homeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeHomeRequest()
            
            do {
                let call = try self.service.subscribeHome(homeRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeHomeReceiver").async {
                    do {
                        while let rpcHome = try call.receive()?.home {
                            let position = Position(latitudeDeg: rpcHome.latitudeDeg,
                                                    longitudeDeg: rpcHome.longitudeDeg,
                                                    absoluteAltitudeM: rpcHome.absoluteAltitudeM,
                                                    relativeAltitudeM: rpcHome.relativeAltitudeM)
                            observer.onNext(position)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to home stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createGPSInfoObservable() -> Observable<GPSInfo> {
        return Observable.create { observer in
            let gpsInfoRequest = DronecodeSdk_Rpc_Telemetry_SubscribeGPSInfoRequest()
            
            do {
                let call = try self.service.subscribeGPSInfo(gpsInfoRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeGPSInfoReceiver").async {
                    do {
                        while let rpcGPSInfo = try call.receive()?.gpsInfo {
                            let gpsInfo = GPSInfo(numSatellites: rpcGPSInfo.numSatellites,
                                                  fixType: eDroneCoreGPSInfoFix(rawValue: rpcGPSInfo.fixType.rawValue)!)
                            observer.onNext(gpsInfo)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to GPSInfo stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createFlightModeObservable() -> Observable<eDroneCoreFlightMode> {
        return Observable.create { observer in
            let flightModeRequest = DronecodeSdk_Rpc_Telemetry_SubscribeFlightModeRequest()
            
            do {
                let call = try self.service.subscribeFlightMode(flightModeRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeFlightModeReceiver").async {
                    do {
                        while let rpcFlightMode = try call.receive()?.flightMode {
                            let flightMode = eDroneCoreFlightMode(rawValue: rpcFlightMode.rawValue)!
                            observer.onNext(flightMode)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to flight mode stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createGroundSpeedNEDObservable() -> Observable<GroundSpeedNED> {
        return Observable.create { observer in
            let groundSpeedRequest = DronecodeSdk_Rpc_Telemetry_SubscribeGroundSpeedNEDRequest()
            
            do {
                let call = try self.service.subscribeGroundSpeedNED(groundSpeedRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeGroundSpeedNEDReceiver").async {
                    do {
                        while let rpcGroundSpeedNed = try call.receive()?.groundSpeedNed {
                            let groundSpeed = GroundSpeedNED(velocityNorthMS: rpcGroundSpeedNed.velocityNorthMS,
                                                             velocityEastMS: rpcGroundSpeedNed.velocityEastMS,
                                                             velocityDownMS: rpcGroundSpeedNed.velocityDownMS)
                            observer.onNext(groundSpeed)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to ground speed NED stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    private func createRCStatusObservable() -> Observable<RCStatus> {
        return Observable.create { observer in
            let rcstatusRequest = DronecodeSdk_Rpc_Telemetry_SubscribeRCStatusRequest()
            
            do {
                let call = try self.service.subscribeRCStatus(rcstatusRequest, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(callResult.statusMessage!)
                    }
                })
                
                DispatchQueue.init(label: "DronecodeRCStatusReceiver").async {
                    do {
                        while let rpcRCStatus = try call.receive()?.rcStatus {
                            let rcstatus = RCStatus(wasAvailableOnce: rpcRCStatus.wasAvailableOnce,
                                                    isAvailable: rpcRCStatus.isAvailable,
                                                    signalStrengthPercent: rpcRCStatus.signalStrengthPercent)
                            observer.onNext(rcstatus)
                        }
                        observer.onError("Broken pipe")
                    } catch {
                        observer.onError(error)
                    }
                }
                
                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError("Failed to subscribe to RC status stream. \(error)")
                return Disposables.create()
            }
            }
            .retry()
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
}
