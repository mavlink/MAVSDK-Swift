import Foundation
import RxSwift

#if os(iOS)
import backend
#endif

public class Drone {
    private let scheduler: SchedulerType
    private let backendQueue = DispatchQueue(label: "DronecodeSDKBackendQueue")

    public let action: Action
    public let core: Core
    public let mission: Mission
    public let telemetry: Telemetry

    public init(address: String = "localhost",
                port: Int32 = 50051,
                scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.scheduler = MainScheduler.instance

        self.action = Action(address: address, port: port, scheduler: scheduler)
        self.core = Core(address: address, port: port, scheduler: scheduler)
        self.mission = Mission(address: address, port: port, scheduler: scheduler)
        self.telemetry = Telemetry(address: address, port: port, scheduler: scheduler)
    }

#if os(iOS)
    /**
     Initializes the backend and start connecting to the drone.

     - Returns: startMavlink `Completable`.
     */
    public func startMavlink(mavlinkPort: Int32 = 14540) -> Completable {
        return Completable.create { completable in
            let semaphore = DispatchSemaphore(value: 0)

            self.backendQueue.async {
                print("Running backend in background (MAVLink port: \(mavlinkPort)")

                runBackend(mavlinkPort,
                           { unmanagedSemaphore in
                            let semaphore = Unmanaged<DispatchSemaphore>.fromOpaque(unmanagedSemaphore!).takeRetainedValue();
                            semaphore.signal()
                },
                           Unmanaged.passRetained(semaphore).toOpaque()
                )
                semaphore.signal()
            }

            let signalDisposable = self.scheduler.schedule(0, action: { _ in
                semaphore.wait()
                completable(.completed)

                return Disposables.create()
            })

            return Disposables.create {
                signalDisposable.dispose()
            }
        }
    }
#endif
}
