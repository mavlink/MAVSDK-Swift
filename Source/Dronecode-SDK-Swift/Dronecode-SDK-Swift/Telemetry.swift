import Foundation
import gRPC
import RxSwift

public struct Position: Equatable {
    public var latitudeDeg: Double
    public var longitudeDeg: Double
    public var absoluteAltitudeM: Float
    public var relativeAltitudeM: Float

    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.latitudeDeg == rhs.latitudeDeg
            && lhs.longitudeDeg == rhs.longitudeDeg
            && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
            && lhs.relativeAltitudeM == rhs.relativeAltitudeM
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
}
