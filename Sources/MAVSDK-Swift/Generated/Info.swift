import Foundation
import RxSwift
import SwiftGRPC

public class Info {
    private let service: Mavsdk_Rpc_Info_InfoServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Info_InfoServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Info_InfoServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }

    public struct RuntimeInfoError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct InfoError: Error {
        public let code: Info.InfoResult.Result
        public let description: String
    }
    


    public struct FlightInfo: Equatable {
        public let timeBootMs: UInt32
        public let flightUid: UInt64

        

        public init(timeBootMs: UInt32, flightUid: UInt64) {
            self.timeBootMs = timeBootMs
            self.flightUid = flightUid
        }

        internal var rpcFlightInfo: Mavsdk_Rpc_Info_FlightInfo {
            var rpcFlightInfo = Mavsdk_Rpc_Info_FlightInfo()
            
                
            rpcFlightInfo.timeBootMs = timeBootMs
                
            
            
                
            rpcFlightInfo.flightUid = flightUid
                
            

            return rpcFlightInfo
        }

        internal static func translateFromRpc(_ rpcFlightInfo: Mavsdk_Rpc_Info_FlightInfo) -> FlightInfo {
            return FlightInfo(timeBootMs: rpcFlightInfo.timeBootMs, flightUid: rpcFlightInfo.flightUid)
        }

        public static func == (lhs: FlightInfo, rhs: FlightInfo) -> Bool {
            return lhs.timeBootMs == rhs.timeBootMs
                && lhs.flightUid == rhs.flightUid
        }
    }

    public struct Identification: Equatable {
        public let hardwareUid: String

        

        public init(hardwareUid: String) {
            self.hardwareUid = hardwareUid
        }

        internal var rpcIdentification: Mavsdk_Rpc_Info_Identification {
            var rpcIdentification = Mavsdk_Rpc_Info_Identification()
            
                
            rpcIdentification.hardwareUid = hardwareUid
                
            

            return rpcIdentification
        }

        internal static func translateFromRpc(_ rpcIdentification: Mavsdk_Rpc_Info_Identification) -> Identification {
            return Identification(hardwareUid: rpcIdentification.hardwareUid)
        }

        public static func == (lhs: Identification, rhs: Identification) -> Bool {
            return lhs.hardwareUid == rhs.hardwareUid
        }
    }

    public struct Product: Equatable {
        public let vendorID: Int32
        public let vendorName: String
        public let productID: Int32
        public let productName: String

        

        public init(vendorID: Int32, vendorName: String, productID: Int32, productName: String) {
            self.vendorID = vendorID
            self.vendorName = vendorName
            self.productID = productID
            self.productName = productName
        }

        internal var rpcProduct: Mavsdk_Rpc_Info_Product {
            var rpcProduct = Mavsdk_Rpc_Info_Product()
            
                
            rpcProduct.vendorID = vendorID
                
            
            
                
            rpcProduct.vendorName = vendorName
                
            
            
                
            rpcProduct.productID = productID
                
            
            
                
            rpcProduct.productName = productName
                
            

            return rpcProduct
        }

        internal static func translateFromRpc(_ rpcProduct: Mavsdk_Rpc_Info_Product) -> Product {
            return Product(vendorID: rpcProduct.vendorID, vendorName: rpcProduct.vendorName, productID: rpcProduct.productID, productName: rpcProduct.productName)
        }

        public static func == (lhs: Product, rhs: Product) -> Bool {
            return lhs.vendorID == rhs.vendorID
                && lhs.vendorName == rhs.vendorName
                && lhs.productID == rhs.productID
                && lhs.productName == rhs.productName
        }
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
        public let flightSwGitHash: String
        public let osSwGitHash: String

        

        public init(flightSwMajor: Int32, flightSwMinor: Int32, flightSwPatch: Int32, flightSwVendorMajor: Int32, flightSwVendorMinor: Int32, flightSwVendorPatch: Int32, osSwMajor: Int32, osSwMinor: Int32, osSwPatch: Int32, flightSwGitHash: String, osSwGitHash: String) {
            self.flightSwMajor = flightSwMajor
            self.flightSwMinor = flightSwMinor
            self.flightSwPatch = flightSwPatch
            self.flightSwVendorMajor = flightSwVendorMajor
            self.flightSwVendorMinor = flightSwVendorMinor
            self.flightSwVendorPatch = flightSwVendorPatch
            self.osSwMajor = osSwMajor
            self.osSwMinor = osSwMinor
            self.osSwPatch = osSwPatch
            self.flightSwGitHash = flightSwGitHash
            self.osSwGitHash = osSwGitHash
        }

        internal var rpcVersion: Mavsdk_Rpc_Info_Version {
            var rpcVersion = Mavsdk_Rpc_Info_Version()
            
                
            rpcVersion.flightSwMajor = flightSwMajor
                
            
            
                
            rpcVersion.flightSwMinor = flightSwMinor
                
            
            
                
            rpcVersion.flightSwPatch = flightSwPatch
                
            
            
                
            rpcVersion.flightSwVendorMajor = flightSwVendorMajor
                
            
            
                
            rpcVersion.flightSwVendorMinor = flightSwVendorMinor
                
            
            
                
            rpcVersion.flightSwVendorPatch = flightSwVendorPatch
                
            
            
                
            rpcVersion.osSwMajor = osSwMajor
                
            
            
                
            rpcVersion.osSwMinor = osSwMinor
                
            
            
                
            rpcVersion.osSwPatch = osSwPatch
                
            
            
                
            rpcVersion.flightSwGitHash = flightSwGitHash
                
            
            
                
            rpcVersion.osSwGitHash = osSwGitHash
                
            

            return rpcVersion
        }

        internal static func translateFromRpc(_ rpcVersion: Mavsdk_Rpc_Info_Version) -> Version {
            return Version(flightSwMajor: rpcVersion.flightSwMajor, flightSwMinor: rpcVersion.flightSwMinor, flightSwPatch: rpcVersion.flightSwPatch, flightSwVendorMajor: rpcVersion.flightSwVendorMajor, flightSwVendorMinor: rpcVersion.flightSwVendorMinor, flightSwVendorPatch: rpcVersion.flightSwVendorPatch, osSwMajor: rpcVersion.osSwMajor, osSwMinor: rpcVersion.osSwMinor, osSwPatch: rpcVersion.osSwPatch, flightSwGitHash: rpcVersion.flightSwGitHash, osSwGitHash: rpcVersion.osSwGitHash)
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
                && lhs.flightSwGitHash == rhs.flightSwGitHash
                && lhs.osSwGitHash == rhs.osSwGitHash
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

            internal var rpcResult: Mavsdk_Rpc_Info_InfoResult.Result {
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

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Info_InfoResult.Result) -> Result {
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

        internal var rpcInfoResult: Mavsdk_Rpc_Info_InfoResult {
            var rpcInfoResult = Mavsdk_Rpc_Info_InfoResult()
            
                
            rpcInfoResult.result = result.rpcResult
                
            
            
                
            rpcInfoResult.resultStr = resultStr
                
            

            return rpcInfoResult
        }

        internal static func translateFromRpc(_ rpcInfoResult: Mavsdk_Rpc_Info_InfoResult) -> InfoResult {
            return InfoResult(result: Result.translateFromRpc(rpcInfoResult.result), resultStr: rpcInfoResult.resultStr)
        }

        public static func == (lhs: InfoResult, rhs: InfoResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    public func getFlightInformation() -> Single<FlightInfo> {
        return Single<FlightInfo>.create { single in
            let request = Mavsdk_Rpc_Info_GetFlightInformationRequest()

            

            do {
                let response = try self.service.getFlightInformation(request)

                
                if (response.infoResult.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(response.infoResult.result), description: response.infoResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let flightInfo = FlightInfo.translateFromRpc(response.flightInfo)
                
                single(.success(flightInfo))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getIdentification() -> Single<Identification> {
        return Single<Identification>.create { single in
            let request = Mavsdk_Rpc_Info_GetIdentificationRequest()

            

            do {
                let response = try self.service.getIdentification(request)

                
                if (response.infoResult.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(response.infoResult.result), description: response.infoResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let identification = Identification.translateFromRpc(response.identification)
                
                single(.success(identification))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getProduct() -> Single<Product> {
        return Single<Product>.create { single in
            let request = Mavsdk_Rpc_Info_GetProductRequest()

            

            do {
                let response = try self.service.getProduct(request)

                
                if (response.infoResult.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(response.infoResult.result), description: response.infoResult.resultStr)))

                    return Disposables.create()
                }
                

                
                    let product = Product.translateFromRpc(response.product)
                
                single(.success(product))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    public func getVersion() -> Single<Version> {
        return Single<Version>.create { single in
            let request = Mavsdk_Rpc_Info_GetVersionRequest()

            

            do {
                let response = try self.service.getVersion(request)

                
                if (response.infoResult.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
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
    }
}