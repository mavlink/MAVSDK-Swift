import Foundation
import gRPC
import RxSwift

public struct Position: Equatable {
    public let latitudeDeg: Double
    public let longitudeDeg: Double
    public let absoluteAltitudeM: Float
    public let relativeAltitudeM: Float
    
    internal static func createCameraRPC(_ position: Position) -> Dronecore_Rpc_Camera_Position {
        var rpcPosition = Dronecore_Rpc_Camera_Position()
        rpcPosition.latitudeDeg = position.latitudeDeg
        rpcPosition.longitudeDeg = position.longitudeDeg
        rpcPosition.absoluteAltitudeM = position.absoluteAltitudeM
        rpcPosition.relativeAltitudeM = position.relativeAltitudeM
        
        return rpcPosition
    }
    
    internal static func createCameraFromRPC(_ rpcCameraPosition: Dronecore_Rpc_Camera_Position) -> Position {
        return Position(latitudeDeg: rpcCameraPosition.latitudeDeg, longitudeDeg: rpcCameraPosition.longitudeDeg, absoluteAltitudeM: rpcCameraPosition.absoluteAltitudeM, relativeAltitudeM: rpcCameraPosition.relativeAltitudeM)
    }

    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.latitudeDeg == rhs.latitudeDeg
            && lhs.longitudeDeg == rhs.longitudeDeg
            && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
            && lhs.relativeAltitudeM == rhs.relativeAltitudeM
    }
}

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

public struct Battery: Equatable {
    public let remainingPercent: Float
    public let voltageV: Float
    
    public static func == (lhs: Battery, rhs: Battery) -> Bool {
        return lhs.remainingPercent == rhs.remainingPercent
            && lhs.voltageV == rhs.voltageV
    }
}

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

public class Telemetry {
    private let service: Dronecore_Rpc_Telemetry_TelemetryServiceService
    private let scheduler: SchedulerType
    
    public lazy var positionObservable: Observable<Position> = createPositionObservable()
    public lazy var healthObservable: Observable<Health> = createHealthObservable()
    public lazy var batteryObservable: Observable<Battery> = createBatteryObservable()
    public lazy var attitudeEulerObservable: Observable<EulerAngle> = createAttitudeEulerObservable()
    public lazy var cameraAttitudeEulerObservable: Observable<EulerAngle> = createCameraAttitudeEulerObservable()

    public convenience init(address: String, port: Int) {
        let service = Dronecore_Rpc_Telemetry_TelemetryServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Dronecore_Rpc_Telemetry_TelemetryServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
    private func createPositionObservable() -> Observable<Position> {
        return Observable.create { observer in
            let positionRequest = Dronecore_Rpc_Telemetry_SubscribePositionRequest()

            do {
                let call = try self.service.subscribeposition(positionRequest, completion: nil)
                while let response = try? call.receive() {
                    let position = Position(latitudeDeg: response.position.latitudeDeg, longitudeDeg: response.position.longitudeDeg, absoluteAltitudeM: response.position.absoluteAltitudeM, relativeAltitudeM: response.position.relativeAltitudeM)

                    observer.onNext(position)
                }
            } catch {
                observer.onError("Failed to subscribe to discovery stream")
            }

            return Disposables.create()
        }.subscribeOn(self.scheduler)
    }
    
    private func createAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let attitudeRequest = Dronecore_Rpc_Telemetry_SubscribeAttitudeEulerRequest()
            
            do {
                let call = try self.service.subscribeattitudeeuler(attitudeRequest, completion: nil)
                while let response = try? call.receive() {
                    
                    let attitude = EulerAngle(pitchDeg: response.attitudeEuler.pitchDeg, rollDeg: response.attitudeEuler.rollDeg, yawDeg: response.attitudeEuler.yawDeg)
                    
                    observer.onNext(attitude)
                }
            } catch {
                observer.onError("Failed to subscribe to discovery stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createCameraAttitudeEulerObservable() -> Observable<EulerAngle> {
        return Observable.create { observer in
            let cameraAttitudeRequest = Dronecore_Rpc_Telemetry_SubscribeCameraAttitudeEulerRequest()
            
            do {
                let call = try self.service.subscribecameraattitudeeuler(cameraAttitudeRequest, completion: nil)
                while let response = try? call.receive() {
                    
                    let attitude = EulerAngle(pitchDeg: response.attitudeEuler.pitchDeg, rollDeg: response.attitudeEuler.rollDeg, yawDeg: response.attitudeEuler.yawDeg)
                    
                    observer.onNext(attitude)
                }
            } catch {
                observer.onError("Failed to subscribe to discovery stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createBatteryObservable() -> Observable<Battery> {
        return Observable.create { observer in
            let batteryRequest = Dronecore_Rpc_Telemetry_SubscribeBatteryRequest()
            
            do {
                let call = try self.service.subscribebattery(batteryRequest, completion: nil)
                while let response = try? call.receive() {
                    let battery = Battery(remainingPercent: response.battery.remainingPercent, voltageV: response.battery.voltageV)
                    
                    observer.onNext(battery)
                }
            } catch {
                observer.onError("Failed to subscribe to discovery stream")
            }
            
            return Disposables.create()
            }.subscribeOn(self.scheduler)
    }
    
    private func createHealthObservable() -> Observable<Health> {
        return Observable.create { observer in
            let healthRequest = Dronecore_Rpc_Telemetry_SubscribeHealthRequest()

            do {
                let call = try self.service.subscribehealth(healthRequest, completion: nil)
                while let response = try? call.receive() {
                    let health = Health(isGyrometerCalibrationOk: response.health.isGyrometerCalibrationOk, isAccelerometerCalibrationOk: response.health.isAccelerometerCalibrationOk, isMagnetometerCalibrationOk: response.health.isMagnetometerCalibrationOk, isLevelCalibrationOk: response.health.isLevelCalibrationOk, isLocalPositionOk: response.health.isLocalPositionOk, isGlobalPositionOk: response.health.isGlobalPositionOk, isHomePositionOk: response.health.isHomePositionOk)

                    observer.onNext(health)
                }
            } catch {
                observer.onError("Failed to subscribe to health stream")
            }

            return Disposables.create()
        }.subscribeOn(self.scheduler)
    }
}
