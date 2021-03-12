import Foundation
import RxSwift
import GRPC
import NIO

/**
 Access to the connection state and running plugins.
 */
public class Core {
    private let service: Mavsdk_Rpc_Core_CoreServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Core` plugin.

     Normally never created manually, but used from the `Drone` helper class instead.

     - Parameters:
        - address: The address of the `MavsdkServer` instance to connect to
        - port: The port of the `MavsdkServer` instance to connect to
        - scheduler: The scheduler to be used by `Observable`s
     */
    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        let channel = ClientConnection.insecure(group: eventLoopGroup).connect(host: address, port: Int(port))
        let service = Mavsdk_Rpc_Core_CoreServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Core_CoreServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeCoreError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    


    /**
     Connection state type.
     */
    public struct ConnectionState: Equatable {
        public let uuid: UInt64
        public let isConnected: Bool

        

        /**
         Initializes a new `ConnectionState`.

         
         - Parameters:
            
            - uuid:  UUID of the vehicle
            
            - isConnected:  Whether the vehicle got connected or disconnected
            
         
         */
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

    /**
     Plugin info type.
     */
    public struct PluginInfo: Equatable {
        public let name: String
        public let address: String
        public let port: Int32

        

        /**
         Initializes a new `PluginInfo`.

         
         - Parameters:
            
            - name:  Name of the plugin
            
            - address:  Address where the plugin is running
            
            - port:  Port where the plugin is running
            
         
         */
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



    /**
     Subscribe to 'connection state' updates.
     */
    public lazy var connectionState: Observable<ConnectionState> = createConnectionStateObservable()



    private func createConnectionStateObservable() -> Observable<ConnectionState> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Core_SubscribeConnectionStateRequest()

            

            _ = self.service.subscribeConnectionState(request, handler: { (response) in

                
                     
                let connectionState = ConnectionState.translateFromRpc(response.connectionState)
                

                
                observer.onNext(connectionState)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeCoreError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get a list of currently running plugins.

     
     */
    public func listRunningPlugins() -> Single<[PluginInfo]> {
        return Single<[PluginInfo]>.create { single in
            let request = Mavsdk_Rpc_Core_ListRunningPluginsRequest()

            

            do {
                let response = self.service.listRunningPlugins(request)

                

    	    
                    let pluginInfo = try response.response.wait().pluginInfo.map{ PluginInfo.translateFromRpc($0) }
                
                single(.success(pluginInfo))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }
}