import Foundation
import RxSwift
import SwiftGRPC

public class Core {
    private let service: Mavsdk_Rpc_Core_CoreServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Core_CoreServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Core_CoreServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeCoreError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    


    public struct ConnectionState: Equatable {
        public let uuid: UInt64
        public let isConnected: Bool

        

        public init(uuid: UInt64, isConnected: Bool) {
            self.uuid = uuid
            self.isConnected = isConnected
        }

        internal var rpcConnectionState: Mavsdk_Rpc_Core_ConnectionState {
            var rpcConnectionState = Mavsdk_Rpc_Core_ConnectionState()
            
                
            rpcConnectionState.uuid = uuid
                
            
            
                
            rpcConnectionState.isConnected = isConnected
                
            

            return rpcConnectionState
        }

        internal static func translateFromRpc(_ rpcConnectionState: Mavsdk_Rpc_Core_ConnectionState) -> ConnectionState {
            return ConnectionState(uuid: rpcConnectionState.uuid, isConnected: rpcConnectionState.isConnected)
        }

        public static func == (lhs: ConnectionState, rhs: ConnectionState) -> Bool {
            return lhs.uuid == rhs.uuid
                && lhs.isConnected == rhs.isConnected
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

        internal var rpcPluginInfo: Mavsdk_Rpc_Core_PluginInfo {
            var rpcPluginInfo = Mavsdk_Rpc_Core_PluginInfo()
            
                
            rpcPluginInfo.name = name
                
            
            
                
            rpcPluginInfo.address = address
                
            
            
                
            rpcPluginInfo.port = port
                
            

            return rpcPluginInfo
        }

        internal static func translateFromRpc(_ rpcPluginInfo: Mavsdk_Rpc_Core_PluginInfo) -> PluginInfo {
            return PluginInfo(name: rpcPluginInfo.name, address: rpcPluginInfo.address, port: rpcPluginInfo.port)
        }

        public static func == (lhs: PluginInfo, rhs: PluginInfo) -> Bool {
            return lhs.name == rhs.name
                && lhs.address == rhs.address
                && lhs.port == rhs.port
        }
    }



    public lazy var connectionState: Observable<ConnectionState> = createConnectionStateObservable()


    private func createConnectionStateObservable() -> Observable<ConnectionState> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Core_SubscribeConnectionStateRequest()

            

            do {
                let call = try self.service.subscribeConnectionState(request, completion: { (callResult) in
                    if callResult.statusCode == .ok || callResult.statusCode == .cancelled {
                        observer.onCompleted()
                    } else {
                        observer.onError(RuntimeCoreError(callResult.statusMessage!))
                    }
                })

                let disposable = self.scheduler.schedule(0, action: { _ in
                    
                    while let response = try? call.receive() {
                        
                            
                        let connectionState = ConnectionState.translateFromRpc(response.connectionState)
                        

                        
                        observer.onNext(connectionState)
                        
                    }
                    

                    return Disposables.create()
                })

                return Disposables.create {
                    call.cancel()
                    disposable.dispose()
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
        .share(replay: 1)
    }

    public func listRunningPlugins() -> Single<[PluginInfo]> {
        return Single<[PluginInfo]>.create { single in
            let request = Mavsdk_Rpc_Core_ListRunningPluginsRequest()

            

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