import backend
import Foundation
import gRPC
import RxSwift

public struct PluginInfo: Equatable {
    public let name: String
    public let address: String
    public let port: Int32

    public static func == (lhs: PluginInfo, rhs: PluginInfo) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address && lhs.port == rhs.port
    }
}

public class Core {
    private let connectionQueue = DispatchQueue(label: "DronecodeSDKConnectionQueue")
    private let backendQueue = DispatchQueue(label: "DronecodeSDKBackendQueue")
    private let service: Dronecore_Rpc_Core_CoreServiceService
    private let scheduler: SchedulerType
    
    public lazy var discoverObservable: Observable<UInt64> = createDiscoverObservable()
    public lazy var runningPluginsObservable: Observable<PluginInfo> = createRunningPluginsObservable()
    public lazy var timeoutObservable: Observable<Void> = createTimeoutObservable()

    public convenience init(address: String = "localhost", port: Int32 = 50051) {
        let service = Dronecore_Rpc_Core_CoreServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Dronecore_Rpc_Core_CoreServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler

        gRPC.initialize()
    }

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
        }.subscribeOn(self.scheduler)
    }
    
    private func createDiscoverObservable() -> Observable<UInt64> {
        return Observable.create { observer in
            let discoverRequest = Dronecore_Rpc_Core_SubscribeDiscoverRequest()

            do {
                let call = try self.service.subscribediscover(discoverRequest, completion: nil)
                while let response = try? call.receive() {
                    observer.onNext(response.uuid)
                }
            } catch {
                observer.onError("Failed to subscribe to discovery stream")
            }

            return Disposables.create()
        }.subscribeOn(self.scheduler)
    }

    private func createTimeoutObservable() -> Observable<Void> {
        return Observable.create { observer in
            let timeoutRequest = Dronecore_Rpc_Core_SubscribeTimeoutRequest()

            do {
                let call = try self.service.subscribetimeout(timeoutRequest, completion: nil)
                while let _ = try? call.receive() {
                    observer.onNext(())
                }
            } catch {
                observer.onError("Failed to subscribe to timeout stream")
            }

            return Disposables.create()
        }.subscribeOn(self.scheduler)
    }
    
    private func createRunningPluginsObservable() -> Observable<PluginInfo> {
        let request = Dronecore_Rpc_Core_ListRunningPluginsRequest()
        let response = try? self.service.listrunningplugins(request)

        return Observable.create { observer in
            for pluginInfo in (response?.pluginInfo)! {
                observer.onNext(PluginInfo(name: pluginInfo.name, address: pluginInfo.address, port: pluginInfo.port))
            }

            observer.onCompleted()
            return Disposables.create()
        }
    }
}
