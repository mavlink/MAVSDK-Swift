import backend
import Foundation
import SwiftGRPC
import RxSwift

/**
 Plugin info type.
 */
public struct PluginInfo: Equatable {
    /// Name (identifier).
    public let name: String
    /// IP address.
    public let address: String
    /// Port.
    public let port: Int32

    public static func == (lhs: PluginInfo, rhs: PluginInfo) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address && lhs.port == rhs.port
    }
}

/**
 The Core class is responsible for discovering the drone, monitoring the connection to it and
 providing a list of running plugins.
 */
public class Core {
    private let connectionQueue = DispatchQueue(label: "DronecodeSDKConnectionQueue")
    private let backendQueue = DispatchQueue(label: "DronecodeSDKBackendQueue")
    private let service: DronecodeSdk_Rpc_Core_CoreServiceService
    private let scheduler: SchedulerType

    /**
     Subscribes to drone discovery. When an event is emitted in this stream, it means that the
     drone is connected. Disconnection is provided by `timeoutObservable`.

     - Returns: `Observable` of UUID.
     */
    public lazy var discoverObservable: Observable<UInt64> = createDiscoverObservable()
    /**
     Subscribes to running plugins `Observable`.

     - Returns: `PluginInfo` `Observable`.
     */
    public lazy var runningPluginsObservable: Observable<PluginInfo> = createRunningPluginsObservable()
    /**
     Subscribes to timeout events.

     - Returns: `Observable` of timeout event. When an event is emitted in this stream, it means that
     the drone is disconnected. Connection is monitored by `discoverObservable`.
     */
    public lazy var timeoutObservable: Observable<Void> = createTimeoutObservable()

    /**
     Helper function to initialize the `Core` object, necessary to initiate and monitor a connection to the drone.

     - Parameter address: Network address of backend (IP or "localhost").
     - Parameter port: Port number of backend.
     */
    public convenience init(address: String = "localhost", port: Int32 = 50051) {
        let service = DronecodeSdk_Rpc_Core_CoreServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Core_CoreServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler

        gRPC.initialize()
    }

    /**
     Initializes the backend and start connecting to the drone.

     - Returns: connect `Completable`.
     */
    public func connect() -> Completable {
        return Completable.create { completable in
            let semaphore = DispatchSemaphore(value: 0)
            
            self.backendQueue.async {
                print("Running backend in background (MAVLink port: 14540)")

                runBackend(14540,
                           { unmanagedSemaphore in
                                let semaphore = Unmanaged<DispatchSemaphore>.fromOpaque(unmanagedSemaphore!).takeRetainedValue();
                                semaphore.signal()
                            },
                           Unmanaged.passRetained(semaphore).toOpaque()
                )
            }
            
            self.connectionQueue.async {
                semaphore.wait()
                completable(.completed)
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    private func createDiscoverObservable() -> Observable<UInt64> {
        return Observable.create { observer in
            let discoverRequest = DronecodeSdk_Rpc_Core_SubscribeDiscoverRequest()

            do {
                let call = try self.service.subscribeDiscover(discoverRequest, completion: nil)
                while let response = try call.receive() {
                    observer.onNext(response.uuid)
                }
            } catch {
                observer.onError("Failed to subscribe to discovery stream")
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    private func createTimeoutObservable() -> Observable<Void> {
        return Observable.create { observer in
            let timeoutRequest = DronecodeSdk_Rpc_Core_SubscribeTimeoutRequest()

            do {
                let call = try self.service.subscribeTimeout(timeoutRequest, completion: nil)
                while let _ = try call.receive() {
                    observer.onNext(())
                }
            } catch {
                observer.onError("Failed to subscribe to timeout stream")
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    private func createRunningPluginsObservable() -> Observable<PluginInfo> {
        let request = DronecodeSdk_Rpc_Core_ListRunningPluginsRequest()
        let response = try? self.service.listRunningPlugins(request)

        return Observable.create { observer in
            if let pluginInfos = response?.pluginInfo {
                for pluginInfo in pluginInfos {
                    observer.onNext(PluginInfo(name: pluginInfo.name, address: pluginInfo.address, port: pluginInfo.port))
                }
            }

            observer.onCompleted()
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
}
