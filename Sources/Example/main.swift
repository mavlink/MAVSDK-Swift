import Foundation
import Mavsdk
import RxSwift

func isValidIP(_ s: String) -> Bool {
    let parts = s.components(separatedBy: ".")
    let nums = parts.compactMap { Int($0) }
    return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
}

print("Starting...")

if (CommandLine.argc != 2) {
    print("Error: expecting the mavsdk_server IP address as an argument!")
    exit(1)
}

if (!isValidIP(CommandLine.arguments[1])) {
    print("Error: Invalid IPv4 entered as mavsdk_server address!")
    exit(1)
}

let address = CommandLine.arguments[1]
let drone = Drone(address: address, port: 50051)

_ = drone.telemetry.battery.subscribe(onNext: { battery in print(battery) })
_ = drone.telemetry.position.subscribe(onNext: { position in print(position) })
_ = drone.core.connectionState.subscribe(onNext: { state in print(state) })

_ = drone.action.arm()
    .andThen(drone.action.takeoff())
    .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
    .andThen(drone.action.land()).subscribe()

RunLoop.main.run()
