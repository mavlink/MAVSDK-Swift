import Foundation
import MAVSDK_Swift
import MavsdkServer
import RxSwift

let mavsdkServer = MavsdkServer()
let port = mavsdkServer.run()
print("MavsdkServer is now running on port \(port)")

let drone = Drone(port: Int32(port))

_ = drone.telemetry.battery.subscribe(onNext: { battery in print(battery) })
_ = drone.telemetry.position.subscribe(onNext: { position in print(position) })
_ = drone.core.connectionState.subscribe(onNext: { state in print(state) })

_ = drone.action.arm()
    .andThen(drone.action.takeoff())
    .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
    .andThen(drone.action.land()).subscribe()

RunLoop.main.run()
