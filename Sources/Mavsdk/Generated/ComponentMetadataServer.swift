import Foundation
import RxSwift
import GRPC
import NIO

/**
 Provide component metadata json definitions, such as parameters.
 */
public class ComponentMetadataServer {
    private let service: Mavsdk_Rpc_ComponentMetadataServer_ComponentMetadataServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `ComponentMetadataServer` plugin.

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
        let service = Mavsdk_Rpc_ComponentMetadataServer_ComponentMetadataServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ComponentMetadataServer_ComponentMetadataServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeComponentMetadataServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    

    /**
     
     */
    public enum MetadataType: Equatable {
        ///  Parameter metadata.
        case parameter
        ///  Event definitions.
        case events
        ///  Actuator definitions.
        case actuators
        case UNRECOGNIZED(Int)

        internal var rpcMetadataType: Mavsdk_Rpc_ComponentMetadataServer_MetadataType {
            switch self {
            case .parameter:
                return .parameter
            case .events:
                return .events
            case .actuators:
                return .actuators
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcMetadataType: Mavsdk_Rpc_ComponentMetadataServer_MetadataType) -> MetadataType {
            switch rpcMetadataType {
            case .parameter:
                return .parameter
            case .events:
                return .events
            case .actuators:
                return .actuators
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     
     */
    public struct Metadata: Equatable {
        public let type: MetadataType
        public let jsonMetadata: String

        

        /**
         Initializes a new `Metadata`.

         
         - Parameters:
            
            - type:  The metadata type
            
            - jsonMetadata:  The JSON metadata
            
         
         */
        public init(type: MetadataType, jsonMetadata: String) {
            self.type = type
            self.jsonMetadata = jsonMetadata
        }

        internal var rpcMetadata: Mavsdk_Rpc_ComponentMetadataServer_Metadata {
            var rpcMetadata = Mavsdk_Rpc_ComponentMetadataServer_Metadata()
            
                
            rpcMetadata.type = type.rpcMetadataType
                
            
            
                
            rpcMetadata.jsonMetadata = jsonMetadata
                
            

            return rpcMetadata
        }

        internal static func translateFromRpc(_ rpcMetadata: Mavsdk_Rpc_ComponentMetadataServer_Metadata) -> Metadata {
            return Metadata(type: MetadataType.translateFromRpc(rpcMetadata.type), jsonMetadata: rpcMetadata.jsonMetadata)
        }

        public static func == (lhs: Metadata, rhs: Metadata) -> Bool {
            return lhs.type == rhs.type
                && lhs.jsonMetadata == rhs.jsonMetadata
        }
    }


    /**
     Provide metadata (can only be called once)

     - Parameter metadata: List of metadata
     
     */
    public func setMetadata(metadata: [Metadata]) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ComponentMetadataServer_SetMetadataRequest()

            
                
            metadata.forEach({ elem in request.metadata.append(elem.rpcMetadata) })
                
            

            do {
                
                let _ = try self.service.setMetadata(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}