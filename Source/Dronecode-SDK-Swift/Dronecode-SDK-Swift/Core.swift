import backend
import Foundation
import gRPC
import RxSwift

public class Core {
    let service: Dronecore_Rpc_Core_CoreServiceService
    
    public convenience init(address: String, port: Int) {
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
}
