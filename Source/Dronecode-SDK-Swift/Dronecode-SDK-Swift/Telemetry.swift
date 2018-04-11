import Foundation
import gRPC
import RxSwift

public struct Position: Equatable {
    public let latitudeDeg: Double
    public let longitudeDeg: Double
    public let absoluteAltitudeM: Float
    public let relativeAltitudeM: Float

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

public class Telemetry {
    let service: Dronecore_Rpc_Telemetry_TelemetryServiceService
    let scheduler: SchedulerType

    public convenience init(address: String, port: Int) {
        let service = Dronecore_Rpc_Telemetry_TelemetryServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Dronecore_Rpc_Telemetry_TelemetryServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public func getPositionObservable() -> Observable<Position> {
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

    public func getHealthObservable() -> Observable<Health> {
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
