import Foundation
import RxSwift

public class Drone {
    private let scheduler: SchedulerType

    public let action: Action
    public let calibration: Calibration
    public let camera: Camera
    public let core: Core
    public let followMe: FollowMe
    public let ftp: Ftp
    public let geofence: Geofence
    public let gimbal: Gimbal
    public let info: Info
    public let logFiles: LogFiles
    public let manualControl: ManualControl
    public let mission: Mission
    public let missionRaw: MissionRaw
    public let mocap: Mocap
    public let offboard: Offboard
    public let param: Param
    public let shell: Shell
    public let telemetry: Telemetry
    public let tune: Tune

    public init(address: String = "localhost",
                port: Int32 = 50051,
                scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        self.scheduler = MainScheduler.instance

        self.action = Action(address: address, port: port, scheduler: scheduler)
        self.calibration = Calibration(address: address, port: port, scheduler: scheduler)
        self.camera = Camera(address: address, port: port, scheduler: scheduler)
        self.core = Core(address: address, port: port, scheduler: scheduler)
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
        self.shell = Shell(address: address, port: port, scheduler: scheduler)
        self.telemetry = Telemetry(address: address, port: port, scheduler: scheduler)
        self.tune = Tune(address: address, port: port, scheduler: scheduler)
    }

#if os(iOS)
    @available(*, unavailable, message: "Please start mavsdk_server with the MavsdkServer class")
    public func setMavlinkPort(mavlinkPort: String) {
        fatalError("This method does not exist anymore. Please use MavsdkServer(systemAddress) instead.")
    }

    @available(*, unavailable)
    public lazy var startMavlink = createStartMavlinkCompletable()

    @available(iOS, deprecated)
    private func createStartMavlinkCompletable() -> Completable {
        fatalError("This method does not exist anymore. Please use MavsdkServer.run() instead.")
    }
#endif
}
