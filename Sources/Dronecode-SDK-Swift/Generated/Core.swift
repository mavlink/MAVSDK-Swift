import Foundation
import RxSwift
import SwiftGRPC

public class Core {
    private let service: DronecodeSdk_Rpc_Core_CoreServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Core_CoreServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Core_CoreServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    struct RuntimeCoreError: Error {
        let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    


    public struct PluginInfo: Equatable {
        public let name: String
        public let address: String
        public let port: Int32

        

        public init(name: String, address: String, port: Int32) {
            self.name = name
            self.address = address
            self.port = port
        }

        internal var rpcPluginInfo: DronecodeSdk_Rpc_Core_PluginInfo {
            var rpcPluginInfo = DronecodeSdk_Rpc_Core_PluginInfo()
            
                
            rpcPluginInfo.name = name
                
            
            
                
            rpcPluginInfo.address = address
                
            
            
                
            rpcPluginInfo.port = port
                
            

            return rpcPluginInfo
        }

        internal static func translateFromRpc(_ rpcPluginInfo: DronecodeSdk_Rpc_Core_PluginInfo) -> PluginInfo {
            return PluginInfo(name: rpcPluginInfo.name, address: rpcPluginInfo.address, port: rpcPluginInfo.port)
        }

        public static func == (lhs: PluginInfo, rhs: PluginInfo) -> Bool {
            return lhs.name == rhs.name
                && lhs.address == rhs.address
                && lhs.port == rhs.port
        }
    }


    public lazy var discover: Observable<UInt64> = createDiscoverObservable()

    private func createDiscoverObservable() -> Observable<UInt64> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Core_SubscribeDiscoverRequest()

            

            do {
                let call = try self.service.subscribeDiscover(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCoreError(callResult.statusMessage!))
                    }
                })

                DispatchQueue.init(label: "DronecodeDiscoverReceiver").async {
                    
                    while let responseOptional = try? call.receive(), let response = responseOptional {
                        
                            let discover = response.uuid
                            
                        

                        
                        observer.onNext(discover)
                        
                    }
                    

                    observer.onError(RuntimeCoreError("Broken pipe"))
                }

                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeCoreError else { throw $0 }
            }
        }
        .subscribeOn(scheduler)
    }

    public lazy var timeout: Observable<Void> = createTimeoutObservable()

    private func createTimeoutObservable() -> Observable<Void> {
        return Observable.create { observer in
            let request = DronecodeSdk_Rpc_Core_SubscribeTimeoutRequest()

            

            do {
                let call = try self.service.subscribeTimeout(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCoreError(callResult.statusMessage!))
                    }
                })

                DispatchQueue.init(label: "DronecodeTimeoutReceiver").async {
                    
                    do {
                        while let _ = try call.receive() {
                            observer.onNext(())
                        }
                    } catch {
                        observer.onError(error)
                    }
                    

                    observer.onError(RuntimeCoreError("Broken pipe"))
                }

                return Disposables.create {
                    call.cancel()
                }
            } catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeCoreError else { throw $0 }
            }
        }
        .subscribeOn(scheduler)
    }

    public func listRunningPlugins() -> Single<[PluginInfo]> {
        return Single<[PluginInfo]>.create { single in
            let request = DronecodeSdk_Rpc_Core_ListRunningPluginsRequest()

            

            do {
                let response = try self.service.listRunningPlugins(request)

                

                
                let pluginInfo = response.pluginInfo.map{ PluginInfo.translateFromRpc($0) }
                
                single(.success(pluginInfo))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
    }
}