import Foundation
import RxSwift
import GRPC
import NIO

/**
 Access to the connection state and core configurations
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
        public let isConnected: Bool

        

        /**
         Initializes a new `ConnectionState`.

         
         - Parameter isConnected:  Whether the vehicle got connected or disconnected
         
         */
        public init(isConnected: Bool) {
            self.isConnected = isConnected
        }

        internal var rpcConnectionState: Mavsdk_Rpc_Core_ConnectionState {
            var rpcConnectionState = Mavsdk_Rpc_Core_ConnectionState()
            
                
            rpcConnectionState.isConnected = isConnected
                
            

            return rpcConnectionState
        }

        internal static func translateFromRpc(_ rpcConnectionState: Mavsdk_Rpc_Core_ConnectionState) -> ConnectionState {
            return ConnectionState(isConnected: rpcConnectionState.isConnected)
        }

        public static func == (lhs: ConnectionState, rhs: ConnectionState) -> Bool {
            return lhs.isConnected == rhs.isConnected
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
     Set timeout of MAVLink transfers.

     The default timeout used is generally (0.5 seconds) seconds.
     If MAVSDK is used on the same host this timeout can be reduced, while
     if MAVSDK has to communicate over links with high latency it might
     need to be increased to prevent timeouts.

     - Parameter timeoutS: Timeout in seconds
     
     */
    public func setMavlinkTimeout(timeoutS: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Core_SetMavlinkTimeoutRequest()

            
                
            request.timeoutS = timeoutS
                
            

            do {
                
                let _ = try self.service.setMavlinkTimeout(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}