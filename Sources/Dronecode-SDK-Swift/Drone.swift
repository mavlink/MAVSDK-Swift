import Foundation
import RxSwift

#if os(iOS)
import backend
#endif

public class Drone {
    private let scheduler: SchedulerType
    private let backendQueue = DispatchQueue(label: "DronecodeSDKBackendQueue")
    private let connectionQueue = DispatchQueue(label: "DronecodeSDKConnectionQueue")

    public let action: Action
    public let calibration: Calibration
    public let camera: Camera
    public let core: Core
    public let gimbal: Gimbal
    public let info: Info
    public let mission: Mission
    public let param: Param
    public let telemetry: Telemetry

    public init(address: String = "localhost",
                port: Int32 = 50051,
                scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.scheduler = MainScheduler.instance

        self.action = Action(address: address, port: port, scheduler: scheduler)
        self.calibration = Calibration(address: address, port: port, scheduler: scheduler)
        self.camera = Camera(address: address, port: port, scheduler: scheduler)
        self.core = Core(address: address, port: port, scheduler: scheduler)
        self.gimbal = Gimbal(address: address, port: port, scheduler: scheduler)
        self.info = Info(address: address, port: port, scheduler: scheduler)
        self.mission = Mission(address: address, port: port, scheduler: scheduler)
        self.param = Param(address: address, port: port, scheduler: scheduler)
        self.telemetry = Telemetry(address: address, port: port, scheduler: scheduler)
    }

#if os(iOS)
    private var mavlinkPort: Int32 = 14540

    /**
     Sets the port on which the mavlink server will be listening for
     a drone. Defaults to 14540.

     Must be set before subscribing to `startMavlink()`.

     - Parameter mavlinkPort: The port on which to listen for the drone.
     */
    public func setMavlinkPort(mavlinkPort: Int32) {
        self.mavlinkPort = mavlinkPort
    }

    /**
     Initializes the backend and start connecting to the drone.

     - Returns: startMavlink `Completable`.
     */
    public lazy var startMavlink = createStartMavlinkCompletable()

    private func createStartMavlinkCompletable() -> Completable {
        return Completable.create { completable in
            let semaphore = DispatchSemaphore(value: 0)

            self.backendQueue.async {
                print("Running backend in background (MAVLink port: \(self.mavlinkPort)")

                runBackend(self.mavlinkPort,
                           { unmanagedSemaphore in
                            let semaphore = Unmanaged<DispatchSemaphore>.fromOpaque(unmanagedSemaphore!).takeRetainedValue();
                            semaphore.signal()
                },
                           Unmanaged.passRetained(semaphore).toOpaque()
                )
                semaphore.signal()
            }
            
            self.connectionQueue.async {
                semaphore.wait()
                completable(.completed)
            }

             return Disposables.create()

        }.asObservable().share(replay: 0, scope: .forever).ignoreElements()
    }
#endif
}
