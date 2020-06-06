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
    public func run(systemAddress: String = "udp://:14540", mavsdkServerPort: Int = 0) {
        self.mavsdkServerHandle = mavsdk_server.runBackend(systemAddress, Int32(mavsdkServerPort))
    }

    /**
    - Returns: The port on which `mavsdk_server` listens for connections
     */
    public func getPort() -> Int {
        return Int(mavsdk_server.getPort(self.mavsdkServerHandle))
    }

    /**
     Attach to the running `mavsdk_server`, effectively blocking until it stops
     */
    public func attach() {
        mavsdk_server.attach(self.mavsdkServerHandle!)
    }

    /**
     Stop `mavsdk_server`.
     */
    public func stop() {
        mavsdk_server.stopBackend(self.mavsdkServerHandle!)
    }
}
#endif
