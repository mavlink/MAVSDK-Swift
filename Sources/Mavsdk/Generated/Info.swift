import Foundation
import RxSwift
import GRPC
import NIO

/**
 Provide information about the hardware and/or software of a system.
 */
public class Info {
    private let service: Mavsdk_Rpc_Info_InfoServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Info` plugin.

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
        let service = Mavsdk_Rpc_Info_InfoServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Info_InfoServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
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
    


    /**
     System flight information.
     */
    public struct FlightInfo: Equatable {
        public let timeBootMs: UInt32
        public let flightUid: UInt64

        

        /**
         Initializes a new `FlightInfo`.

         
         - Parameters:
            
            - timeBootMs:  Time since system boot
            
            - flightUid:  Flight counter. Starts from zero, is incremented at every disarm and is never reset (even after reboot)
            
         
         */
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

    /**
     System identification.
     */
    public struct Identification: Equatable {
        public let hardwareUid: String
        public let legacyUid: UInt64

        

        /**
         Initializes a new `Identification`.

         
         - Parameters:
            
            - hardwareUid:  UID of the hardware. This refers to uid2 of MAVLink. If the system does not support uid2 yet, this is all zeros.
            
            - legacyUid:  Legacy UID of the hardware, referred to as uid in MAVLink (formerly exposed during system discovery as UUID).
            
         
         */
        public init(hardwareUid: String, legacyUid: UInt64) {
            self.hardwareUid = hardwareUid
            self.legacyUid = legacyUid
        }

        internal var rpcIdentification: Mavsdk_Rpc_Info_Identification {
            var rpcIdentification = Mavsdk_Rpc_Info_Identification()
            
                
            rpcIdentification.hardwareUid = hardwareUid
                
            
            
                
            rpcIdentification.legacyUid = legacyUid
                
            

            return rpcIdentification
        }

        internal static func translateFromRpc(_ rpcIdentification: Mavsdk_Rpc_Info_Identification) -> Identification {
            return Identification(hardwareUid: rpcIdentification.hardwareUid, legacyUid: rpcIdentification.legacyUid)
        }

        public static func == (lhs: Identification, rhs: Identification) -> Bool {
            return lhs.hardwareUid == rhs.hardwareUid
                && lhs.legacyUid == rhs.legacyUid
        }
    }

    /**
     System product information.
     */
    public struct Product: Equatable {
        public let vendorID: Int32
        public let vendorName: String
        public let productID: Int32
        public let productName: String

        

        /**
         Initializes a new `Product`.

         
         - Parameters:
            
            - vendorID:  ID of the board vendor
            
            - vendorName:  Name of the vendor
            
            - productID:  ID of the product
            
            - productName:  Name of the product
            
         
         */
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

    /**
     System version information.
     */
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

        

        /**
         Initializes a new `Version`.

         
         - Parameters:
            
            - flightSwMajor:  Flight software major version
            
            - flightSwMinor:  Flight software minor version
            
            - flightSwPatch:  Flight software patch version
            
            - flightSwVendorMajor:  Flight software vendor major version
            
            - flightSwVendorMinor:  Flight software vendor minor version
            
            - flightSwVendorPatch:  Flight software vendor patch version
            
            - osSwMajor:  Operating system software major version
            
            - osSwMinor:  Operating system software minor version
            
            - osSwPatch:  Operating system software patch version
            
            - flightSwGitHash:  Flight software git hash
            
            - osSwGitHash:  Operating system software git hash
            
         
         */
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

    /**
     Result type.
     */
    public struct InfoResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for info requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  Information has not been received yet.
            case informationNotReceivedYet
            ///  No system is connected.
            case noSystem
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Info_InfoResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .informationNotReceivedYet:
                    return .informationNotReceivedYet
                case .noSystem:
                    return .noSystem
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
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `InfoResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
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


    /**
     Get flight information of the system.

     
     */
    public func getFlightInformation() -> Single<FlightInfo> {
        return Single<FlightInfo>.create { single in
            let request = Mavsdk_Rpc_Info_GetFlightInformationRequest()

            

            do {
                let response = self.service.getFlightInformation(request)

                
                let result = try response.response.wait().infoResult
                if (result.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let flightInfo = try FlightInfo.translateFromRpc(response.response.wait().flightInfo)
                
                single(.success(flightInfo))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the identification of the system.

     
     */
    public func getIdentification() -> Single<Identification> {
        return Single<Identification>.create { single in
            let request = Mavsdk_Rpc_Info_GetIdentificationRequest()

            

            do {
                let response = self.service.getIdentification(request)

                
                let result = try response.response.wait().infoResult
                if (result.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let identification = try Identification.translateFromRpc(response.response.wait().identification)
                
                single(.success(identification))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get product information of the system.

     
     */
    public func getProduct() -> Single<Product> {
        return Single<Product>.create { single in
            let request = Mavsdk_Rpc_Info_GetProductRequest()

            

            do {
                let response = self.service.getProduct(request)

                
                let result = try response.response.wait().infoResult
                if (result.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let product = try Product.translateFromRpc(response.response.wait().product)
                
                single(.success(product))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the version information of the system.

     
     */
    public func getVersion() -> Single<Version> {
        return Single<Version>.create { single in
            let request = Mavsdk_Rpc_Info_GetVersionRequest()

            

            do {
                let response = self.service.getVersion(request)

                
                let result = try response.response.wait().infoResult
                if (result.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let version = try Version.translateFromRpc(response.response.wait().version)
                
                single(.success(version))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Get the speed factor of a simulation (with lockstep a simulation can run faster or slower than realtime).

     
     */
    public func getSpeedFactor() -> Single<Double> {
        return Single<Double>.create { single in
            let request = Mavsdk_Rpc_Info_GetSpeedFactorRequest()

            

            do {
                let response = self.service.getSpeedFactor(request)

                
                let result = try response.response.wait().infoResult
                if (result.result != Mavsdk_Rpc_Info_InfoResult.Result.success) {
                    single(.error(InfoError(code: InfoResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    let speedFactor = try response.response.wait().speedFactor
                
                single(.success(speedFactor))
            } catch {
                single(.error(error))
            }

            return Disposables.create()
        }
    }
}