import Foundation
import RxSwift
import GRPC
import NIO

/**
 Enable setting a geofence.
 */
public class Geofence {
    private let service: Mavsdk_Rpc_Geofence_GeofenceServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Geofence` plugin.

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
        let service = Mavsdk_Rpc_Geofence_GeofenceServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Geofence_GeofenceServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeGeofenceError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct GeofenceError: Error {
        public let code: Geofence.GeofenceResult.Result
        public let description: String
    }
    


    /**
     Point type.
     */
    public struct Point: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double

        

        /**
         Initializes a new `Point`.

         
         - Parameters:
            
            - latitudeDeg:  Latitude in degrees (range: -90 to +90)
            
            - longitudeDeg:  Longitude in degrees (range: -180 to +180)
            
         
         */
        public init(latitudeDeg: Double, longitudeDeg: Double) {
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
        }

        internal var rpcPoint: Mavsdk_Rpc_Geofence_Point {
            var rpcPoint = Mavsdk_Rpc_Geofence_Point()
            
                
            rpcPoint.latitudeDeg = latitudeDeg
                
            
            
                
            rpcPoint.longitudeDeg = longitudeDeg
                
            

            return rpcPoint
        }

        internal static func translateFromRpc(_ rpcPoint: Mavsdk_Rpc_Geofence_Point) -> Point {
            return Point(latitudeDeg: rpcPoint.latitudeDeg, longitudeDeg: rpcPoint.longitudeDeg)
        }

        public static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
        }
    }

    /**
     Polygon type.
     */
    public struct Polygon: Equatable {
        public let points: [Point]
        public let fenceType: FenceType

        
        

        /**
         Geofence polygon types.
         */
        public enum FenceType: Equatable {
            ///  Type representing an inclusion fence.
            case inclusion
            ///  Type representing an exclusion fence.
            case exclusion
            case UNRECOGNIZED(Int)

            internal var rpcFenceType: Mavsdk_Rpc_Geofence_Polygon.FenceType {
                switch self {
                case .inclusion:
                    return .inclusion
                case .exclusion:
                    return .exclusion
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcFenceType: Mavsdk_Rpc_Geofence_Polygon.FenceType) -> FenceType {
                switch rpcFenceType {
                case .inclusion:
                    return .inclusion
                case .exclusion:
                    return .exclusion
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `Polygon`.

         
         - Parameters:
            
            - points:  Points defining the polygon
            
            - fenceType:  Fence type
            
         
         */
        public init(points: [Point], fenceType: FenceType) {
            self.points = points
            self.fenceType = fenceType
        }

        internal var rpcPolygon: Mavsdk_Rpc_Geofence_Polygon {
            var rpcPolygon = Mavsdk_Rpc_Geofence_Polygon()
            
                
            rpcPolygon.points = points.map{ $0.rpcPoint }
                
            
            
                
            rpcPolygon.fenceType = fenceType.rpcFenceType
                
            

            return rpcPolygon
        }

        internal static func translateFromRpc(_ rpcPolygon: Mavsdk_Rpc_Geofence_Polygon) -> Polygon {
            return Polygon(points: rpcPolygon.points.map{ Point.translateFromRpc($0) }, fenceType: FenceType.translateFromRpc(rpcPolygon.fenceType))
        }

        public static func == (lhs: Polygon, rhs: Polygon) -> Bool {
            return lhs.points == rhs.points
                && lhs.fenceType == rhs.fenceType
        }
    }

    /**
     Result type.
     */
    public struct GeofenceResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for geofence requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  Error.
            case error
            ///  Too many Polygon objects in the geofence.
            case tooManyGeofenceItems
            ///  Vehicle is busy.
            case busy
            ///  Request timed out.
            case timeout
            ///  Invalid argument.
            case invalidArgument
            ///  No system connected.
            case noSystem
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Geofence_GeofenceResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .error:
                    return .error
                case .tooManyGeofenceItems:
                    return .tooManyGeofenceItems
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .invalidArgument:
                    return .invalidArgument
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Geofence_GeofenceResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .error:
                    return .error
                case .tooManyGeofenceItems:
                    return .tooManyGeofenceItems
                case .busy:
                    return .busy
                case .timeout:
                    return .timeout
                case .invalidArgument:
                    return .invalidArgument
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `GeofenceResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcGeofenceResult: Mavsdk_Rpc_Geofence_GeofenceResult {
            var rpcGeofenceResult = Mavsdk_Rpc_Geofence_GeofenceResult()
            
                
            rpcGeofenceResult.result = result.rpcResult
                
            
            
                
            rpcGeofenceResult.resultStr = resultStr
                
            

            return rpcGeofenceResult
        }

        internal static func translateFromRpc(_ rpcGeofenceResult: Mavsdk_Rpc_Geofence_GeofenceResult) -> GeofenceResult {
            return GeofenceResult(result: Result.translateFromRpc(rpcGeofenceResult.result), resultStr: rpcGeofenceResult.resultStr)
        }

        public static func == (lhs: GeofenceResult, rhs: GeofenceResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Upload a geofence.

     Polygons are uploaded to a drone. Once uploaded, the geofence will remain
     on the drone even if a connection is lost.

     - Parameter polygons: Polygon(s) representing the geofence(s)
     
     */
    public func uploadGeofence(polygons: [Polygon]) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Geofence_UploadGeofenceRequest()

            
                
            polygons.forEach({ elem in request.polygons.append(elem.rpcPolygon) })
                
            

            do {
                
                let response = self.service.uploadGeofence(request)

                let result = try response.response.wait().geofenceResult
                if (result.result == Mavsdk_Rpc_Geofence_GeofenceResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GeofenceError(code: GeofenceResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}