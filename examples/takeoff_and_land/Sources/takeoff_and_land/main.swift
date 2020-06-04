import Foundation
import MAVSDK_Swift
import RxSwift

print("Starting...")

let drone = Drone(address: "192.168.1.216", port: 50051)

_ = drone.telemetry.battery.subscribe(onNext: { battery in print(battery) })
_ = drone.telemetry.position.subscribe(onNext: { position in print(position)})
_ = drone.core.connectionState.subscribe(onNext: { state in print(state)})

_ = drone.action.arm()
    .andThen(drone.action.takeoff())
    .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
    .andThen(drone.action.land()).subscribe()

RunLoop.main.run()
print("Goodbye!")
