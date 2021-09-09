#if !os(Linux)
import Foundation
@_implementationOnly import mavsdk_server

public class MavsdkServer {
    private var mavsdkServerHandle: OpaquePointer?

    public init() {
        mavsdk_server_init(&self.mavsdkServerHandle)
    }

    deinit {
        mavsdk_server_destroy(self.mavsdkServerHandle)
    }

    /**
     Run `mavsdk_server`, connecting to the drone.

     - Parameter systemAddress: The address on which `mavsdk_server` will listen for a MAVLink system. Note that this is about the MAVLink connection between `mavsdk_server` and the drone.
     - Parameter mavsdkServerPort: The port on which `mavsdk_server` will listen for a `Drone` object to connect. Note that this is about the connection between `Mavsdk` and `mavsdk_server`, and has nothing to do with MAVLink itself.
     - Returns: True if `mavsdk_server` detected a drone and is running, false if it failed or was stopped while connecting
     */
    public func run(systemAddress: String = "udp://:14540", mavsdkServerPort: Int = 0) -> Bool {
        return (mavsdk_server_run(self.mavsdkServerHandle, systemAddress, Int32(mavsdkServerPort)) != 0)
    }

    /**
    - Returns: The port on which `mavsdk_server` listens for connections
     */
    public func getPort() -> Int {
        return Int(mavsdk_server_get_port(self.mavsdkServerHandle!))
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
        mavsdk_server_stop(mavsdkServerHandle)
    }
}
#endif
