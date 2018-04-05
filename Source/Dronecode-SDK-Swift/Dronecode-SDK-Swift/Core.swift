import backend
import Foundation
import gRPC
import RxSwift

public struct PluginInfo: Equatable {
    var name: String
    var address: String
    var port: Int32

    public static func == (lhs: PluginInfo, rhs: PluginInfo) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address && lhs.port == rhs.port
    }
}

public class Core {
    let service: Dronecore_Rpc_Core_CoreServiceService

    public convenience init(address: String = "localhost", port: Int32 = 50051) {
        let service = Dronecore_Rpc_Core_CoreServiceServiceClient(address: "\(address):\(port)")
        self.init(service: service)
    }

    init(service: Dronecore_Rpc_Core_CoreServiceService = Dronecore_Rpc_Core_CoreServiceServiceClient(address: "localhost:50051", secure: false)) {
        self.service = service
        
        gRPC.initialize()
    }

    public func connect() {
        DispatchQueue.global(qos: .background).async {
            print("Running backend in background (MAVLink port: 14540)")
            runBackend(14540)
        }
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
        }
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
        }
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
