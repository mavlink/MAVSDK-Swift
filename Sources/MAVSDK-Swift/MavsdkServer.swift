#if os(iOS)
import Foundation
import RxSwift

import mavsdk_server

public class MavsdkServer {
    private var mavsdkServerHandle: OpaquePointer? = Optional.none

    public init() {}

    /**
     Run `mavsdk_server`, connecting to the drone.

     - Parameter systemAddress: The address on which `mavsdk_server` will listen for a MAVLink system. Note that this is about the MAVLink connection between `mavsdk_server` and the drone.
     - Parameter mavsdkServerPort: The port on which `mavsdk_server` will listen for a `Drone` object to connect. Note that this is about the connection between MAVSDK-Swift and `mavsdk_server`, and has nothing to do with MAVLink itself.
     */
    public func run(systemAddress: String = "udp://:14540", mavsdkServerPort: Int = 0) -> Int {
        self.mavsdkServerHandle = mavsdk_server_run(systemAddress, Int32(mavsdkServerPort))
        return Int(mavsdk_server.mavsdk_server_get_port(self.mavsdkServerHandle))
    }

    /**
    - Returns: The port on which `mavsdk_server` listens for connections
     */
    public func getPort() -> Int {
        return Int(mavsdk_server_get_port(self.mavsdkServerHandle))
    }

    /**
     Attach to the running `mavsdk_server`, effectively blocking until it stops
     */
    public func attach() {
        mavsdk_server_attach(self.mavsdkServerHandle!)
    }

    /**
     Stop `mavsdk_server`.
     */
    public func stop() {
        mavsdk_server_stop(self.mavsdkServerHandle!)
    }
}
#endif
