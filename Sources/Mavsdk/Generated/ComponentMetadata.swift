import Foundation
import RxSwift
import GRPC
import NIO

/**
 Access component metadata json definitions, such as parameters.
 */
public class ComponentMetadata {
    private let service: Mavsdk_Rpc_ComponentMetadata_ComponentMetadataServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `ComponentMetadata` plugin.

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
        let service = Mavsdk_Rpc_ComponentMetadata_ComponentMetadataServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ComponentMetadata_ComponentMetadataServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeComponentMetadataError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ComponentMetadataError: Error {
        public let code: ComponentMetadata.ComponentMetadataResult.Result
        public let description: String
    }
    

    /**
     
     */
    public enum MetadataType: Equatable {
        ///  This is set in the subscription callback when all metadata types completed for a given component ID.
        case allCompleted
        ///  Parameter metadata.
        case parameter
        ///  Event definitions.
        case events
        ///  Actuator definitions.
        case actuators
        case UNRECOGNIZED(Int)

        internal var rpcMetadataType: Mavsdk_Rpc_ComponentMetadata_MetadataType {
            switch self {
            case .allCompleted:
                return .allCompleted
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

        internal static func translateFromRpc(_ rpcMetadataType: Mavsdk_Rpc_ComponentMetadata_MetadataType) -> MetadataType {
            switch rpcMetadataType {
            case .allCompleted:
                return .allCompleted
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
     Metadata response
     */
    public struct MetadataData: Equatable {
        public let jsonMetadata: String

        

        /**
         Initializes a new `MetadataData`.

         
         - Parameter jsonMetadata:  The JSON metadata
         
         */
        public init(jsonMetadata: String) {
            self.jsonMetadata = jsonMetadata
        }

        internal var rpcMetadataData: Mavsdk_Rpc_ComponentMetadata_MetadataData {
            var rpcMetadataData = Mavsdk_Rpc_ComponentMetadata_MetadataData()
            
                
            rpcMetadataData.jsonMetadata = jsonMetadata
                
            

            return rpcMetadataData
        }

        internal static func translateFromRpc(_ rpcMetadataData: Mavsdk_Rpc_ComponentMetadata_MetadataData) -> MetadataData {
            return MetadataData(jsonMetadata: rpcMetadataData.jsonMetadata)
        }

        public static func == (lhs: MetadataData, rhs: MetadataData) -> Bool {
            return lhs.jsonMetadata == rhs.jsonMetadata
        }
    }

    /**
     Result type.
     */
    public struct ComponentMetadataResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for GetMetadata
         */
        public enum Result: Equatable {
            /// .
            case success
            /// .
            case notAvailable
            /// .
            case connectionError
            /// .
            case unsupported
            /// .
            case denied
            /// .
            case failed
            /// .
            case timeout
            /// .
            case noSystem
            /// .
            case notRequested
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_ComponentMetadata_ComponentMetadataResult.Result {
                switch self {
                case .success:
                    return .success
                case .notAvailable:
                    return .notAvailable
                case .connectionError:
                    return .connectionError
                case .unsupported:
                    return .unsupported
                case .denied:
                    return .denied
                case .failed:
                    return .failed
                case .timeout:
                    return .timeout
                case .noSystem:
                    return .noSystem
                case .notRequested:
                    return .notRequested
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_ComponentMetadata_ComponentMetadataResult.Result) -> Result {
                switch rpcResult {
                case .success:
                    return .success
                case .notAvailable:
                    return .notAvailable
                case .connectionError:
                    return .connectionError
                case .unsupported:
                    return .unsupported
                case .denied:
                    return .denied
                case .failed:
                    return .failed
                case .timeout:
                    return .timeout
                case .noSystem:
                    return .noSystem
                case .notRequested:
                    return .notRequested
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ComponentMetadataResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcComponentMetadataResult: Mavsdk_Rpc_ComponentMetadata_ComponentMetadataResult {
            var rpcComponentMetadataResult = Mavsdk_Rpc_ComponentMetadata_ComponentMetadataResult()
            
                
            rpcComponentMetadataResult.result = result.rpcResult
                
            
            
                
            rpcComponentMetadataResult.resultStr = resultStr
                
            

            return rpcComponentMetadataResult
        }

        internal static func translateFromRpc(_ rpcComponentMetadataResult: Mavsdk_Rpc_ComponentMetadata_ComponentMetadataResult) -> ComponentMetadataResult {
            return ComponentMetadataResult(result: Result.translateFromRpc(rpcComponentMetadataResult.result), resultStr: rpcComponentMetadataResult.resultStr)
        }

        public static func == (lhs: ComponentMetadataResult, rhs: ComponentMetadataResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }

    /**
     Metadata for a given component and type
     */
    public struct MetadataUpdate: Equatable {
        public let compid: UInt32
        public let type: MetadataType
        public let jsonMetadata: String

        

        /**
         Initializes a new `MetadataUpdate`.

         
         - Parameters:
            
            - compid:  The component ID
            
            - type:  The metadata type
            
            - jsonMetadata:  The JSON metadata
            
         
         */
        public init(compid: UInt32, type: MetadataType, jsonMetadata: String) {
            self.compid = compid
            self.type = type
            self.jsonMetadata = jsonMetadata
        }

        internal var rpcMetadataUpdate: Mavsdk_Rpc_ComponentMetadata_MetadataUpdate {
            var rpcMetadataUpdate = Mavsdk_Rpc_ComponentMetadata_MetadataUpdate()
            
                
            rpcMetadataUpdate.compid = compid
                
            
            
                
            rpcMetadataUpdate.type = type.rpcMetadataType
                
            
            
                
            rpcMetadataUpdate.jsonMetadata = jsonMetadata
                
            

            return rpcMetadataUpdate
        }

        internal static func translateFromRpc(_ rpcMetadataUpdate: Mavsdk_Rpc_ComponentMetadata_MetadataUpdate) -> MetadataUpdate {
            return MetadataUpdate(compid: rpcMetadataUpdate.compid, type: MetadataType.translateFromRpc(rpcMetadataUpdate.type), jsonMetadata: rpcMetadataUpdate.jsonMetadata)
        }

        public static func == (lhs: MetadataUpdate, rhs: MetadataUpdate) -> Bool {
            return lhs.compid == rhs.compid
                && lhs.type == rhs.type
                && lhs.jsonMetadata == rhs.jsonMetadata
        }
    }


    /**
     Request metadata from a specific component. This is used to start requesting metadata from a component.
     The metadata can later be accessed via subscription (see below) or GetMetadata.

     - Parameter compid: The component ID to request
     
     */
    public func requestComponent(compid: UInt32) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_ComponentMetadata_RequestComponentRequest()

            
                
            request.compid = compid
                
            

            do {
                
                let _ = try self.service.requestComponent(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Request metadata from the autopilot component. This is used to start requesting metadata from the autopilot.
     The metadata can later be accessed via subscription (see below) or GetMetadata.

     
     */
    public func requestAutopilotComponent() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_ComponentMetadata_RequestAutopilotComponentRequest()

            

            do {
                
                let _ = try self.service.requestAutopilotComponent(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Register a callback that gets called when metadata is available
     */

    public lazy var metadataAvailable: Observable<MetadataUpdate> = createMetadataAvailableObservable()




    private func createMetadataAvailableObservable() -> Observable<MetadataUpdate> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_ComponentMetadata_SubscribeMetadataAvailableRequest()

            

            let serverStreamingCall = self.service.subscribeMetadataAvailable(request, handler: { (response) in

                
                     
                let metadataAvailable = MetadataUpdate.translateFromRpc(response.data)
                

                
                observer.onNext(metadataAvailable)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeComponentMetadataError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Access metadata. This can be used if you know the metadata is available already, otherwise use
     the subscription to get notified when it becomes available.

     - Parameters:
        - compid: The component ID to request
        - metadataType: The metadata type
     
     */
    public func getMetadata(compid: UInt32, metadataType: MetadataType) -> Single<MetadataData> {
        return Single<MetadataData>.create { single in
            var request = Mavsdk_Rpc_ComponentMetadata_GetMetadataRequest()

            
                
            request.compid = compid
                
            
                
            request.metadataType = metadataType.rpcMetadataType
                
            

            do {
                let response = self.service.getMetadata(request)

                
                let result = try response.response.wait().componentMetadataResult
                if (result.result != Mavsdk_Rpc_ComponentMetadata_ComponentMetadataResult.Result.success) {
                    single(.failure(ComponentMetadataError(code: ComponentMetadataResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let response = try MetadataData.translateFromRpc(response.response.wait().response)
                
                single(.success(response))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}