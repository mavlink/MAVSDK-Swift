import Foundation
import RxSwift
import SwiftGRPC

public class Core {
    private let service: DronecodeSdk_Rpc_Core_CoreServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = DronecodeSdk_Rpc_Core_CoreServiceServiceClient(address: "\(address):\(port)", secure: false)

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

                let disposable = self.scheduler.schedule(0, action: { _ in
                    var cancel = false

                    
                    while let responseOptional = try? call.receive(), let response = responseOptional, cancel == false {
                        
                            
                        let discover = response.uuid
                            
                        

                        
                        observer.onNext(discover)
                        
                    }
                    

                    return Disposables.create { cancel = true }
                })

                return Disposables.create {
                    disposable.dispose()
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

                let disposable = self.scheduler.schedule(0, action: { _ in
                    var cancel = false

                    
    	        while let responseOptional = try? call.receive(), let _ = responseOptional, cancel == false {
    	            observer.onNext(())
    	        }
                    

                    return Disposables.create { cancel = true }
                })

                return Disposables.create {
                    disposable.dispose()
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
    }
}