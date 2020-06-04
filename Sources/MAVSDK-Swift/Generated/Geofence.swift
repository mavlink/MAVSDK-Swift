import Foundation
import RxSwift
import SwiftGRPC

public class Geofence {
    private let service: Mavsdk_Rpc_Geofence_GeofenceServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Geofence_GeofenceServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Geofence_GeofenceServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
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
    


    public struct Point: Equatable {
        public let latitudeDeg: Double
        public let longitudeDeg: Double

        

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

    public struct Polygon: Equatable {
        public let points: [Point]
        public let fenceType: FenceType

        
        

        public enum FenceType: Equatable {
            case typeInclusion
            case typeExclusion
            case UNRECOGNIZED(Int)

            internal var rpcFenceType: Mavsdk_Rpc_Geofence_Polygon.FenceType {
                switch self {
                case .typeInclusion:
                    return .typeInclusion
                case .typeExclusion:
                    return .typeExclusion
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcFenceType: Mavsdk_Rpc_Geofence_Polygon.FenceType) -> FenceType {
                switch rpcFenceType {
                case .typeInclusion:
                    return .typeInclusion
                case .typeExclusion:
                    return .typeExclusion
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

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

    public struct GeofenceResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case unknown
            case success
            case error
            case tooManyGeofenceItems
            case busy
            case timeout
            case invalidArgument
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
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

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


    public func uploadGeofence(polygons: [Polygon]) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Geofence_UploadGeofenceRequest()

            
                
            polygons.forEach({ elem in request.polygons.append(elem.rpcPolygon) })
                
            

            do {
                
                let response = try self.service.uploadGeofence(request)

                if (response.geofenceResult.result == Mavsdk_Rpc_Geofence_GeofenceResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(GeofenceError(code: GeofenceResult.Result.translateFromRpc(response.geofenceResult.result), description: response.geofenceResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}