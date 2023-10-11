import Foundation
import RxSwift
import MavsdkServer

public class Drone {
    private let scheduler: SchedulerType
    public var mavsdkServer: MavsdkServer?

    public var action: Action!
    public var calibration: Calibration!
    public var camera: Camera!
    public var core: Core!
    public var failure: Failure!
    public var followMe: FollowMe!
    public var ftp: Ftp!
    public var geofence: Geofence!
    public var gimbal: Gimbal!
    public var info: Info!
    public var logFiles: LogFiles!
    public var manualControl: ManualControl!
    public var mission: Mission!
    public var missionRaw: MissionRaw!
    public var mocap: Mocap!
    public var offboard: Offboard!
    public var param: Param!
    public var rtk: Rtk!
    public var shell: Shell!
    public var telemetry: Telemetry!
    public var transponder: Transponder!
    public var tune: Tune!

    public init(scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.scheduler = MainScheduler.instance
    }

    enum ConnectionError: Swift.Error {
        case connectionFailed
        case connectionStopped
    }

    /**
     * Create an instance of MavsdkServer and running with `systemAddress`, which is the address of the drone.
     */
    public func connect(systemAddress: String = "udp://:14540") -> Completable {
        return Completable.create { completable in
            self.mavsdkServer = MavsdkServer()
            let isRunning = self.mavsdkServer!.run(systemAddress: systemAddress)

            if (!isRunning) {
                completable(.error(ConnectionError.connectionFailed))
                return Disposables.create()
            }

            if let mavsdkServer = self.mavsdkServer {
                self.initPlugins(address: "localhost", port: Int32(mavsdkServer.getPort()))
            } else {
                completable(.error(ConnectionError.connectionStopped))
                return Disposables.create()
            }

            completable(.completed)
            return Disposables.create()
        }
    }

    /**
     * Connect MAVSDK to an already-running instance of MavsdkServer, locally or somewhere on the network.
     */
    public func connect(mavsdkServerAddress: String, mavsdkServerPort: Int32 = 50051) -> Completable {
        return Completable.create { completable in
            self.initPlugins(address: mavsdkServerAddress, port: mavsdkServerPort)
            completable(.completed)
            return Disposables.create()
        }
    }

    private func initPlugins(address: String = "localhost", port: Int32 = 50051) {
        self.action = Action(address: address, port: port, scheduler: scheduler)
        self.calibration = Calibration(address: address, port: port, scheduler: scheduler)
        self.camera = Camera(address: address, port: port, scheduler: scheduler)
        self.core = Core(address: address, port: port, scheduler: scheduler)
        self.failure = Failure(address: address, port: port, scheduler: scheduler)
        self.followMe = FollowMe(address: address, port: port, scheduler: scheduler)
        self.ftp = Ftp(address: address, port: port, scheduler: scheduler)
        self.geofence = Geofence(address: address, port: port, scheduler: scheduler)
        self.gimbal = Gimbal(address: address, port: port, scheduler: scheduler)
        self.info = Info(address: address, port: port, scheduler: scheduler)
        self.logFiles = LogFiles(address: address, port: port, scheduler: scheduler)
        self.manualControl = ManualControl(address: address, port: port, scheduler: scheduler)
        self.mission = Mission(address: address, port: port, scheduler: scheduler)
        self.missionRaw = MissionRaw(address: address, port: port, scheduler: scheduler)
        self.mocap = Mocap(address: address, port: port, scheduler: scheduler)
        self.offboard = Offboard(address: address, port: port, scheduler: scheduler)
        self.param = Param(address: address, port: port, scheduler: scheduler)
        self.rtk = Rtk(address: address, port: port, scheduler: scheduler)
        self.shell = Shell(address: address, port: port, scheduler: scheduler)
        self.telemetry = Telemetry(address: address, port: port, scheduler: scheduler)
        self.transponder = Transponder(address: address, port: port, scheduler: scheduler)
        self.tune = Tune(address: address, port: port, scheduler: scheduler)
    }

    public func disconnect() {
        mavsdkServer?.stop()
        mavsdkServer = nil
    }
}
