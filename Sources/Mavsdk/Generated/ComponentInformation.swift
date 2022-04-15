import Foundation
import RxSwift
import GRPC
import NIO

/**
 Access component information such as parameters.
 */
public class ComponentInformation {
    private let service: Mavsdk_Rpc_ComponentInformation_ComponentInformationServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `ComponentInformation` plugin.

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
        let service = Mavsdk_Rpc_ComponentInformation_ComponentInformationServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_ComponentInformation_ComponentInformationServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeComponentInformationError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct ComponentInformationError: Error {
        public let code: ComponentInformation.ComponentInformationResult.Result
        public let description: String
    }
    


    /**
     Meta information for parameter of type float.
     */
    public struct FloatParam: Equatable {
        public let name: String
        public let shortDescription: String
        public let longDescription: String
        public let unit: String
        public let decimalPlaces: Int32
        public let startValue: Float
        public let defaultValue: Float
        public let minValue: Float
        public let maxValue: Float

        

        /**
         Initializes a new `FloatParam`.

         
         - Parameters:
            
            - name:  Name (max 16 chars)
            
            - shortDescription:  Short description
            
            - longDescription:  Long description
            
            - unit:  Unit
            
            - decimalPlaces:  Decimal places for user to show
            
            - startValue:  Current/starting value
            
            - defaultValue:  Default value
            
            - minValue:  Minimum value
            
            - maxValue:  Maximum value
            
         
         */
        public init(name: String, shortDescription: String, longDescription: String, unit: String, decimalPlaces: Int32, startValue: Float, defaultValue: Float, minValue: Float, maxValue: Float) {
            self.name = name
            self.shortDescription = shortDescription
            self.longDescription = longDescription
            self.unit = unit
            self.decimalPlaces = decimalPlaces
            self.startValue = startValue
            self.defaultValue = defaultValue
            self.minValue = minValue
            self.maxValue = maxValue
        }

        internal var rpcFloatParam: Mavsdk_Rpc_ComponentInformation_FloatParam {
            var rpcFloatParam = Mavsdk_Rpc_ComponentInformation_FloatParam()
            
                
            rpcFloatParam.name = name
                
            
            
                
            rpcFloatParam.shortDescription = shortDescription
                
            
            
                
            rpcFloatParam.longDescription = longDescription
                
            
            
                
            rpcFloatParam.unit = unit
                
            
            
                
            rpcFloatParam.decimalPlaces = decimalPlaces
                
            
            
                
            rpcFloatParam.startValue = startValue
                
            
            
                
            rpcFloatParam.defaultValue = defaultValue
                
            
            
                
            rpcFloatParam.minValue = minValue
                
            
            
                
            rpcFloatParam.maxValue = maxValue
                
            

            return rpcFloatParam
        }

        internal static func translateFromRpc(_ rpcFloatParam: Mavsdk_Rpc_ComponentInformation_FloatParam) -> FloatParam {
            return FloatParam(name: rpcFloatParam.name, shortDescription: rpcFloatParam.shortDescription, longDescription: rpcFloatParam.longDescription, unit: rpcFloatParam.unit, decimalPlaces: rpcFloatParam.decimalPlaces, startValue: rpcFloatParam.startValue, defaultValue: rpcFloatParam.defaultValue, minValue: rpcFloatParam.minValue, maxValue: rpcFloatParam.maxValue)
        }

        public static func == (lhs: FloatParam, rhs: FloatParam) -> Bool {
            return lhs.name == rhs.name
                && lhs.shortDescription == rhs.shortDescription
                && lhs.longDescription == rhs.longDescription
                && lhs.unit == rhs.unit
                && lhs.decimalPlaces == rhs.decimalPlaces
                && lhs.startValue == rhs.startValue
                && lhs.defaultValue == rhs.defaultValue
                && lhs.minValue == rhs.minValue
                && lhs.maxValue == rhs.maxValue
        }
    }

    /**
     A float param that has been updated.
     */
    public struct FloatParamUpdate: Equatable {
        public let name: String
        public let value: Float

        

        /**
         Initializes a new `FloatParamUpdate`.

         
         - Parameters:
            
            - name:  Name of param that changed
            
            - value:  New value of param
            
         
         */
        public init(name: String, value: Float) {
            self.name = name
            self.value = value
        }

        internal var rpcFloatParamUpdate: Mavsdk_Rpc_ComponentInformation_FloatParamUpdate {
            var rpcFloatParamUpdate = Mavsdk_Rpc_ComponentInformation_FloatParamUpdate()
            
                
            rpcFloatParamUpdate.name = name
                
            
            
                
            rpcFloatParamUpdate.value = value
                
            

            return rpcFloatParamUpdate
        }

        internal static func translateFromRpc(_ rpcFloatParamUpdate: Mavsdk_Rpc_ComponentInformation_FloatParamUpdate) -> FloatParamUpdate {
            return FloatParamUpdate(name: rpcFloatParamUpdate.name, value: rpcFloatParamUpdate.value)
        }

        public static func == (lhs: FloatParamUpdate, rhs: FloatParamUpdate) -> Bool {
            return lhs.name == rhs.name
                && lhs.value == rhs.value
        }
    }

    /**
     Result type.
     */
    public struct ComponentInformationResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for param requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  No system is connected.
            case noSystem
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_ComponentInformation_ComponentInformationResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_ComponentInformation_ComponentInformationResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `ComponentInformationResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcComponentInformationResult: Mavsdk_Rpc_ComponentInformation_ComponentInformationResult {
            var rpcComponentInformationResult = Mavsdk_Rpc_ComponentInformation_ComponentInformationResult()
            
                
            rpcComponentInformationResult.result = result.rpcResult
                
            
            
                
            rpcComponentInformationResult.resultStr = resultStr
                
            

            return rpcComponentInformationResult
        }

        internal static func translateFromRpc(_ rpcComponentInformationResult: Mavsdk_Rpc_ComponentInformation_ComponentInformationResult) -> ComponentInformationResult {
            return ComponentInformationResult(result: Result.translateFromRpc(rpcComponentInformationResult.result), resultStr: rpcComponentInformationResult.resultStr)
        }

        public static func == (lhs: ComponentInformationResult, rhs: ComponentInformationResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     List available float params.

     
     */
    public func accessFloatParams() -> Single<[FloatParam]> {
        return Single<[FloatParam]>.create { single in
            let request = Mavsdk_Rpc_ComponentInformation_AccessFloatParamsRequest()

            

            do {
                let response = self.service.accessFloatParams(request)

                
                let result = try response.response.wait().componentInformationResult
                if (result.result != Mavsdk_Rpc_ComponentInformation_ComponentInformationResult.Result.success) {
                    single(.failure(ComponentInformationError(code: ComponentInformationResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let params = try response.response.wait().params.map{ FloatParam.translateFromRpc($0) }
                
                single(.success(params))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to float param changes/updates.
     */
    public lazy var floatParam: Observable<FloatParamUpdate> = createFloatParamObservable()



    private func createFloatParamObservable() -> Observable<FloatParamUpdate> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_ComponentInformation_SubscribeFloatParamRequest()

            

            _ = self.service.subscribeFloatParam(request, handler: { (response) in

                
                     
                let floatParam = FloatParamUpdate.translateFromRpc(response.paramUpdate)
                

                
                observer.onNext(floatParam)
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeComponentInformationError else { throw $0 }
            }
        }
        .share(replay: 1)
    }
}