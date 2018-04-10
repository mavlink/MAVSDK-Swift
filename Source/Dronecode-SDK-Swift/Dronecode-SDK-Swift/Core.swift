import backend
import Foundation
import gRPC
import RxSwift

public struct PluginInfo: Equatable {
    public var name: String
    public var address: String
    public var port: Int32

    public static func == (lhs: PluginInfo, rhs: PluginInfo) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address && lhs.port == rhs.port
    }
}

public class Core {
    let service: Dronecore_Rpc_Core_CoreServiceService
    let scheduler: SchedulerType

    public convenience init(address: String = "localhost", port: Int32 = 50051) {
        let service = Dronecore_Rpc_Core_CoreServiceServiceClient(address: "\(address):\(port)", secure: false)
        self.init(service: service, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
    }

    init(service: Dronecore_Rpc_Core_CoreServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler

        gRPC.initialize()
    }

    public func connect() {
        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.global(qos: .background).async {
            print("Running backend in background (MAVLink port: 14540)")
            runBackend(14540, { unmanagedSemaphore in let semaphore = Unmanaged<DispatchSemaphore>.fromOpaque(unmanagedSemaphore!).takeRetainedValue(); semaphore.signal() }, Unmanaged.passRetained(semaphore).toOpaque())
        }

        semaphore.wait()
    }

    public func getDiscoverObservable() -> Observable<UInt64> {
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

    public func getTimeoutObservable() -> Observable<Void> {
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

    public func getRunningPluginsObservable() -> Observable<PluginInfo> {
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
