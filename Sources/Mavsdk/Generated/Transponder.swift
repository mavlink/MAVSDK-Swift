import Foundation
import RxSwift
import GRPC
import NIO

/**
 Allow users to get ADS-B information
 and set ADS-B update rates.
 */
public class Transponder {
    private let service: Mavsdk_Rpc_Transponder_TransponderServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Transponder` plugin.

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
        let service = Mavsdk_Rpc_Transponder_TransponderServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Transponder_TransponderServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeTransponderError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct TransponderError: Error {
        public let code: Transponder.TransponderResult.Result
        public let description: String
    }
    

    /**
     ADSB classification for the type of vehicle emitting the transponder signal.
     */
    public enum AdsbEmitterType: Equatable {
        ///  No emitter info..
        case noInfo
        ///  Light emitter..
        case light
        ///  Small emitter..
        case small
        ///  Large emitter..
        case large
        ///  High vortex emitter..
        case highVortexLarge
        ///  Heavy emitter..
        case heavy
        ///  Highly maneuverable emitter..
        case highlyManuv
        ///  Rotorcraft emitter..
        case rotocraft
        ///  Unassigned emitter..
        case unassigned
        ///  Glider emitter..
        case glider
        ///  Lighter air emitter..
        case lighterAir
        ///  Parachute emitter..
        case parachute
        ///  Ultra light emitter..
        case ultraLight
        ///  Unassigned2 emitter..
        case unassigned2
        ///  UAV emitter..
        case uav
        ///  Space emitter..
        case space
        ///  Unassigned3 emitter..
        case unassgined3
        ///  Emergency emitter..
        case emergencySurface
        ///  Service surface emitter..
        case serviceSurface
        ///  Point obstacle emitter..
        case pointObstacle
        case UNRECOGNIZED(Int)

        internal var rpcAdsbEmitterType: Mavsdk_Rpc_Transponder_AdsbEmitterType {
            switch self {
            case .noInfo:
                return .noInfo
            case .light:
                return .light
            case .small:
                return .small
            case .large:
                return .large
            case .highVortexLarge:
                return .highVortexLarge
            case .heavy:
                return .heavy
            case .highlyManuv:
                return .highlyManuv
            case .rotocraft:
                return .rotocraft
            case .unassigned:
                return .unassigned
            case .glider:
                return .glider
            case .lighterAir:
                return .lighterAir
            case .parachute:
                return .parachute
            case .ultraLight:
                return .ultraLight
            case .unassigned2:
                return .unassigned2
            case .uav:
                return .uav
            case .space:
                return .space
            case .unassgined3:
                return .unassgined3
            case .emergencySurface:
                return .emergencySurface
            case .serviceSurface:
                return .serviceSurface
            case .pointObstacle:
                return .pointObstacle
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcAdsbEmitterType: Mavsdk_Rpc_Transponder_AdsbEmitterType) -> AdsbEmitterType {
            switch rpcAdsbEmitterType {
            case .noInfo:
                return .noInfo
            case .light:
                return .light
            case .small:
                return .small
            case .large:
                return .large
            case .highVortexLarge:
                return .highVortexLarge
            case .heavy:
                return .heavy
            case .highlyManuv:
                return .highlyManuv
            case .rotocraft:
                return .rotocraft
            case .unassigned:
                return .unassigned
            case .glider:
                return .glider
            case .lighterAir:
                return .lighterAir
            case .parachute:
                return .parachute
            case .ultraLight:
                return .ultraLight
            case .unassigned2:
                return .unassigned2
            case .uav:
                return .uav
            case .space:
                return .space
            case .unassgined3:
                return .unassgined3
            case .emergencySurface:
                return .emergencySurface
            case .serviceSurface:
                return .serviceSurface
            case .pointObstacle:
                return .pointObstacle
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     ADSB Vehicle type.
     */
    public struct AdsbVehicle: Equatable {
        public let icaoAddress: UInt32
        public let latitudeDeg: Double
        public let longitudeDeg: Double
        public let absoluteAltitudeM: Float
        public let headingDeg: Float
        public let horizontalVelocityMS: Float
        public let verticalVelocityMS: Float
        public let callsign: String
        public let emitterType: AdsbEmitterType
        public let squawk: UInt32
        public let tslcS: UInt32

        

        /**
         Initializes a new `AdsbVehicle`.

         
         - Parameters:
            
            - icaoAddress:  ICAO (International Civil Aviation Organization) unique worldwide identifier
            
            - latitudeDeg:  Latitude in degrees (range: -90 to +90)
            
            - longitudeDeg:  Longitude in degrees (range: -180 to +180).
            
            - absoluteAltitudeM:  Altitude AMSL (above mean sea level) in metres
            
            - headingDeg:  Course over ground, in degrees
            
            - horizontalVelocityMS:  The horizontal velocity in metres/second
            
            - verticalVelocityMS:  The vertical velocity in metres/second. Positive is up.
            
            - callsign:  The callsign
            
            - emitterType:  ADSB emitter type.
            
            - squawk:  Squawk code.
            
            - tslcS:  Time Since Last Communication in seconds.
            
         
         */
        public init(icaoAddress: UInt32, latitudeDeg: Double, longitudeDeg: Double, absoluteAltitudeM: Float, headingDeg: Float, horizontalVelocityMS: Float, verticalVelocityMS: Float, callsign: String, emitterType: AdsbEmitterType, squawk: UInt32, tslcS: UInt32) {
            self.icaoAddress = icaoAddress
            self.latitudeDeg = latitudeDeg
            self.longitudeDeg = longitudeDeg
            self.absoluteAltitudeM = absoluteAltitudeM
            self.headingDeg = headingDeg
            self.horizontalVelocityMS = horizontalVelocityMS
            self.verticalVelocityMS = verticalVelocityMS
            self.callsign = callsign
            self.emitterType = emitterType
            self.squawk = squawk
            self.tslcS = tslcS
        }

        internal var rpcAdsbVehicle: Mavsdk_Rpc_Transponder_AdsbVehicle {
            var rpcAdsbVehicle = Mavsdk_Rpc_Transponder_AdsbVehicle()
            
                
            rpcAdsbVehicle.icaoAddress = icaoAddress
                
            
            
                
            rpcAdsbVehicle.latitudeDeg = latitudeDeg
                
            
            
                
            rpcAdsbVehicle.longitudeDeg = longitudeDeg
                
            
            
                
            rpcAdsbVehicle.absoluteAltitudeM = absoluteAltitudeM
                
            
            
                
            rpcAdsbVehicle.headingDeg = headingDeg
                
            
            
                
            rpcAdsbVehicle.horizontalVelocityMS = horizontalVelocityMS
                
            
            
                
            rpcAdsbVehicle.verticalVelocityMS = verticalVelocityMS
                
            
            
                
            rpcAdsbVehicle.callsign = callsign
                
            
            
                
            rpcAdsbVehicle.emitterType = emitterType.rpcAdsbEmitterType
                
            
            
                
            rpcAdsbVehicle.squawk = squawk
                
            
            
                
            rpcAdsbVehicle.tslcS = tslcS
                
            

            return rpcAdsbVehicle
        }

        internal static func translateFromRpc(_ rpcAdsbVehicle: Mavsdk_Rpc_Transponder_AdsbVehicle) -> AdsbVehicle {
            return AdsbVehicle(icaoAddress: rpcAdsbVehicle.icaoAddress, latitudeDeg: rpcAdsbVehicle.latitudeDeg, longitudeDeg: rpcAdsbVehicle.longitudeDeg, absoluteAltitudeM: rpcAdsbVehicle.absoluteAltitudeM, headingDeg: rpcAdsbVehicle.headingDeg, horizontalVelocityMS: rpcAdsbVehicle.horizontalVelocityMS, verticalVelocityMS: rpcAdsbVehicle.verticalVelocityMS, callsign: rpcAdsbVehicle.callsign, emitterType: AdsbEmitterType.translateFromRpc(rpcAdsbVehicle.emitterType), squawk: rpcAdsbVehicle.squawk, tslcS: rpcAdsbVehicle.tslcS)
        }

        public static func == (lhs: AdsbVehicle, rhs: AdsbVehicle) -> Bool {
            return lhs.icaoAddress == rhs.icaoAddress
                && lhs.latitudeDeg == rhs.latitudeDeg
                && lhs.longitudeDeg == rhs.longitudeDeg
                && lhs.absoluteAltitudeM == rhs.absoluteAltitudeM
                && lhs.headingDeg == rhs.headingDeg
                && lhs.horizontalVelocityMS == rhs.horizontalVelocityMS
                && lhs.verticalVelocityMS == rhs.verticalVelocityMS
                && lhs.callsign == rhs.callsign
                && lhs.emitterType == rhs.emitterType
                && lhs.squawk == rhs.squawk
                && lhs.tslcS == rhs.tslcS
        }
    }

    /**
     Result type.
     */
    public struct TransponderResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for transponder requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Success: the transponder command was accepted by the vehicle.
            case success
            ///  No system connected.
            case noSystem
            ///  Connection error.
            case connectionError
            ///  Vehicle is busy.
            case busy
            ///  Command refused by vehicle.
            case commandDenied
            ///  Request timed out.
            case timeout
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Transponder_TransponderResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .busy:
                    return .busy
                case .commandDenied:
                    return .commandDenied
                case .timeout:
                    return .timeout
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Transponder_TransponderResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .busy:
                    return .busy
                case .commandDenied:
                    return .commandDenied
                case .timeout:
                    return .timeout
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `TransponderResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcTransponderResult: Mavsdk_Rpc_Transponder_TransponderResult {
            var rpcTransponderResult = Mavsdk_Rpc_Transponder_TransponderResult()
            
                
            rpcTransponderResult.result = result.rpcResult
                
            
            
                
            rpcTransponderResult.resultStr = resultStr
                
            

            return rpcTransponderResult
        }

        internal static func translateFromRpc(_ rpcTransponderResult: Mavsdk_Rpc_Transponder_TransponderResult) -> TransponderResult {
            return TransponderResult(result: Result.translateFromRpc(rpcTransponderResult.result), resultStr: rpcTransponderResult.resultStr)
        }

        public static func == (lhs: TransponderResult, rhs: TransponderResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }



    /**
     Subscribe to 'transponder' updates.
     */
    public lazy var transponder: Observable<AdsbVehicle> = createTransponderObservable()



    private func createTransponderObservable() -> Observable<AdsbVehicle> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_Transponder_SubscribeTransponderRequest()

            

            _ = self.service.subscribeTransponder(request, handler: { (response) in

                
                     
                let transponder = AdsbVehicle.translateFromRpc(response.transponder)
                

                
                observer.onNext(transponder)
                
            })

            return Disposables.create()
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeTransponderError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Set rate to 'transponder' updates.

     - Parameter rateHz: The requested rate (in Hertz)
     
     */
    public func setRateTransponder(rateHz: Double) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Transponder_SetRateTransponderRequest()

            
                
            request.rateHz = rateHz
                
            

            do {
                
                let response = self.service.setRateTransponder(request)

                let result = try response.response.wait().transponderResult
                if (result.result == Mavsdk_Rpc_Transponder_TransponderResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TransponderError(code: TransponderResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}