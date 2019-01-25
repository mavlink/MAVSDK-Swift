import Foundation
import RxSwift
import SwiftGRPC

public class Info {
    private let service: DronecodeSdk_Rpc_Info_InfoServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Info_InfoServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: DronecodeSdk_Rpc_Info_InfoServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    struct RuntimeInfoError: Error {
        let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    struct InfoError: Error {
        let code: Info.InfoResult.Result
        let description: String
    }
    


    public struct Version: Equatable {
        public let flightSwMajor: Int32
        public let flightSwMinor: Int32
        public let flightSwPatch: Int32
        public let flightSwVendorMajor: Int32
        public let flightSwVendorMinor: Int32
        public let flightSwVendorPatch: Int32
        public let osSwMajor: Int32
        public let osSwMinor: Int32
        public let osSwPatch: Int32

        

        public init(flightSwMajor: Int32, flightSwMinor: Int32, flightSwPatch: Int32, flightSwVendorMajor: Int32, flightSwVendorMinor: Int32, flightSwVendorPatch: Int32, osSwMajor: Int32, osSwMinor: Int32, osSwPatch: Int32) {
            self.flightSwMajor = flightSwMajor
            self.flightSwMinor = flightSwMinor
            self.flightSwPatch = flightSwPatch
            self.flightSwVendorMajor = flightSwVendorMajor
            self.flightSwVendorMinor = flightSwVendorMinor
            self.flightSwVendorPatch = flightSwVendorPatch
            self.osSwMajor = osSwMajor
            self.osSwMinor = osSwMinor
            self.osSwPatch = osSwPatch
        }

        internal var rpcVersion: DronecodeSdk_Rpc_Info_Version {
            var rpcVersion = DronecodeSdk_Rpc_Info_Version()
            
                
            rpcVersion.flightSwMajor = flightSwMajor
                
            
            
                
            rpcVersion.flightSwMinor = flightSwMinor
                
            
            
                
            rpcVersion.flightSwPatch = flightSwPatch
                
            
            
                
            rpcVersion.flightSwVendorMajor = flightSwVendorMajor
                
            
            
                
            rpcVersion.flightSwVendorMinor = flightSwVendorMinor
                
            
            
                
            rpcVersion.flightSwVendorPatch = flightSwVendorPatch
                
            
            
                
            rpcVersion.osSwMajor = osSwMajor
                
            
            
                
            rpcVersion.osSwMinor = osSwMinor
                
            
            
                
            rpcVersion.osSwPatch = osSwPatch
                
            

            return rpcVersion
        }

        internal static func translateFromRpc(_ rpcVersion: DronecodeSdk_Rpc_Info_Version) -> Version {
            return Version(flightSwMajor: rpcVersion.flightSwMajor, flightSwMinor: rpcVersion.flightSwMinor, flightSwPatch: rpcVersion.flightSwPatch, flightSwVendorMajor: rpcVersion.flightSwVendorMajor, flightSwVendorMinor: rpcVersion.flightSwVendorMinor, flightSwVendorPatch: rpcVersion.flightSwVendorPatch, osSwMajor: rpcVersion.osSwMajor, osSwMinor: rpcVersion.osSwMinor, osSwPatch: rpcVersion.osSwPatch)
        }

        public static func == (lhs: Version, rhs: Version) -> Bool {
            return lhs.flightSwMajor == rhs.flightSwMajor
                && lhs.flightSwMinor == rhs.flightSwMinor
                && lhs.flightSwPatch == rhs.flightSwPatch
                && lhs.flightSwVendorMajor == rhs.flightSwVendorMajor
                && lhs.flightSwVendorMinor == rhs.flightSwVendorMinor
                && lhs.flightSwVendorPatch == rhs.flightSwVendorPatch
                && lhs.osSwMajor == rhs.osSwMajor
                && lhs.osSwMinor == rhs.osSwMinor
                && lhs.osSwPatch == rhs.osSwPatch
        }
    }

    public struct InfoResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case informationNotReceivedYet
            case UNRECOGNIZED(Int)

            internal var rpcResult: DronecodeSdk_Rpc_Info_InfoResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .informationNotReceivedYet:
                    return .informationNotReceivedYet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: DronecodeSdk_Rpc_Info_InfoResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .informationNotReceivedYet:
                    return .informationNotReceivedYet
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcInfoResult: DronecodeSdk_Rpc_Info_InfoResult {
            var rpcInfoResult = DronecodeSdk_Rpc_Info_InfoResult()
            
                
            rpcInfoResult.result = result.rpcResult
                
            
            
                
            rpcInfoResult.resultStr = resultStr
                
            

            return rpcInfoResult
        }

        internal static func translateFromRpc(_ rpcInfoResult: DronecodeSdk_Rpc_Info_InfoResult) -> InfoResult {
            return InfoResult(result: Result.translateFromRpc(rpcInfoResult.result), resultStr: rpcInfoResult.resultStr)
        }

        public static func == (lhs: InfoResult, rhs: InfoResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func getVersion() -> Single<Version> {
        return Single<Version>.create { single in
            let request = DronecodeSdk_Rpc_Info_GetVersionRequest()

            

            do {
                let response = try self.service.getVersion(request)

                
                if (response.infoResult.result != DronecodeSdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(response.infoResult.result), description: response.infoResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let version = Version.translateFromRpc(response.version)
                
                single(.success(version))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
    }
}