import Foundation
import RxSwift
import GRPC
import NIO

/**
 API for an onboard image tracking software.
 */
public class TrackingServer {
    private let service: Mavsdk_Rpc_TrackingServer_TrackingServerServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `TrackingServer` plugin.

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
        let service = Mavsdk_Rpc_TrackingServer_TrackingServerServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_TrackingServer_TrackingServerServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeTrackingServerError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct TrackingServerError: Error {
        public let code: TrackingServer.TrackingServerResult.Result
        public let description: String
    }
    

    /**
     Answer to respond to an incoming command
     */
    public enum CommandAnswer: Equatable {
        ///  Command accepted.
        case accepted
        ///  Command temporarily rejected.
        case temporarilyRejected
        ///  Command denied.
        case denied
        ///  Command unsupported.
        case unsupported
        ///  Command failed.
        case failed
        case UNRECOGNIZED(Int)

        internal var rpcCommandAnswer: Mavsdk_Rpc_TrackingServer_CommandAnswer {
            switch self {
            case .accepted:
                return .accepted
            case .temporarilyRejected:
                return .temporarilyRejected
            case .denied:
                return .denied
            case .unsupported:
                return .unsupported
            case .failed:
                return .failed
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcCommandAnswer: Mavsdk_Rpc_TrackingServer_CommandAnswer) -> CommandAnswer {
            switch rpcCommandAnswer {
            case .accepted:
                return .accepted
            case .temporarilyRejected:
                return .temporarilyRejected
            case .denied:
                return .denied
            case .unsupported:
                return .unsupported
            case .failed:
                return .failed
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Point description type
     */
    public struct TrackPoint: Equatable {
        public let pointX: Float
        public let pointY: Float
        public let radius: Float

        

        /**
         Initializes a new `TrackPoint`.

         
         - Parameters:
            
            - pointX:  Point to track x value (normalized 0..1, 0 is left, 1 is right).
            
            - pointY:  Point to track y value (normalized 0..1, 0 is top, 1 is bottom).
            
            - radius:  Point to track y value (normalized 0..1, 0 is top, 1 is bottom).
            
         
         */
        public init(pointX: Float, pointY: Float, radius: Float) {
            self.pointX = pointX
            self.pointY = pointY
            self.radius = radius
        }

        internal var rpcTrackPoint: Mavsdk_Rpc_TrackingServer_TrackPoint {
            var rpcTrackPoint = Mavsdk_Rpc_TrackingServer_TrackPoint()
            
                
            rpcTrackPoint.pointX = pointX
                
            
            
                
            rpcTrackPoint.pointY = pointY
                
            
            
                
            rpcTrackPoint.radius = radius
                
            

            return rpcTrackPoint
        }

        internal static func translateFromRpc(_ rpcTrackPoint: Mavsdk_Rpc_TrackingServer_TrackPoint) -> TrackPoint {
            return TrackPoint(pointX: rpcTrackPoint.pointX, pointY: rpcTrackPoint.pointY, radius: rpcTrackPoint.radius)
        }

        public static func == (lhs: TrackPoint, rhs: TrackPoint) -> Bool {
            return lhs.pointX == rhs.pointX
                && lhs.pointY == rhs.pointY
                && lhs.radius == rhs.radius
        }
    }

    /**
     Rectangle description type
     */
    public struct TrackRectangle: Equatable {
        public let topLeftCornerX: Float
        public let topLeftCornerY: Float
        public let bottomRightCornerX: Float
        public let bottomRightCornerY: Float

        

        /**
         Initializes a new `TrackRectangle`.

         
         - Parameters:
            
            - topLeftCornerX:  Top left corner of rectangle x value (normalized 0..1, 0 is left, 1 is right).
            
            - topLeftCornerY:  Top left corner of rectangle y value (normalized 0..1, 0 is top, 1 is bottom).
            
            - bottomRightCornerX:  Bottom right corner of rectangle x value (normalized 0..1, 0 is left, 1 is right).
            
            - bottomRightCornerY:  Bottom right corner of rectangle y value (normalized 0..1, 0 is top, 1 is bottom).
            
         
         */
        public init(topLeftCornerX: Float, topLeftCornerY: Float, bottomRightCornerX: Float, bottomRightCornerY: Float) {
            self.topLeftCornerX = topLeftCornerX
            self.topLeftCornerY = topLeftCornerY
            self.bottomRightCornerX = bottomRightCornerX
            self.bottomRightCornerY = bottomRightCornerY
        }

        internal var rpcTrackRectangle: Mavsdk_Rpc_TrackingServer_TrackRectangle {
            var rpcTrackRectangle = Mavsdk_Rpc_TrackingServer_TrackRectangle()
            
                
            rpcTrackRectangle.topLeftCornerX = topLeftCornerX
                
            
            
                
            rpcTrackRectangle.topLeftCornerY = topLeftCornerY
                
            
            
                
            rpcTrackRectangle.bottomRightCornerX = bottomRightCornerX
                
            
            
                
            rpcTrackRectangle.bottomRightCornerY = bottomRightCornerY
                
            

            return rpcTrackRectangle
        }

        internal static func translateFromRpc(_ rpcTrackRectangle: Mavsdk_Rpc_TrackingServer_TrackRectangle) -> TrackRectangle {
            return TrackRectangle(topLeftCornerX: rpcTrackRectangle.topLeftCornerX, topLeftCornerY: rpcTrackRectangle.topLeftCornerY, bottomRightCornerX: rpcTrackRectangle.bottomRightCornerX, bottomRightCornerY: rpcTrackRectangle.bottomRightCornerY)
        }

        public static func == (lhs: TrackRectangle, rhs: TrackRectangle) -> Bool {
            return lhs.topLeftCornerX == rhs.topLeftCornerX
                && lhs.topLeftCornerY == rhs.topLeftCornerY
                && lhs.bottomRightCornerX == rhs.bottomRightCornerX
                && lhs.bottomRightCornerY == rhs.bottomRightCornerY
        }
    }

    /**
     Result type
     */
    public struct TrackingServerResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for tracking_server requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  No system is connected.
            case noSystem
            ///  Connection error.
            case connectionError
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_TrackingServer_TrackingServerResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_TrackingServer_TrackingServerResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .noSystem:
                    return .noSystem
                case .connectionError:
                    return .connectionError
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `TrackingServerResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcTrackingServerResult: Mavsdk_Rpc_TrackingServer_TrackingServerResult {
            var rpcTrackingServerResult = Mavsdk_Rpc_TrackingServer_TrackingServerResult()
            
                
            rpcTrackingServerResult.result = result.rpcResult
                
            
            
                
            rpcTrackingServerResult.resultStr = resultStr
                
            

            return rpcTrackingServerResult
        }

        internal static func translateFromRpc(_ rpcTrackingServerResult: Mavsdk_Rpc_TrackingServer_TrackingServerResult) -> TrackingServerResult {
            return TrackingServerResult(result: Result.translateFromRpc(rpcTrackingServerResult.result), resultStr: rpcTrackingServerResult.resultStr)
        }

        public static func == (lhs: TrackingServerResult, rhs: TrackingServerResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Set/update the current point tracking status.

     - Parameter trackedPoint: The tracked point
     
     */
    public func setTrackingPointStatus(trackedPoint: TrackPoint) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TrackingServer_SetTrackingPointStatusRequest()

            
                
            request.trackedPoint = trackedPoint.rpcTrackPoint
                
            

            do {
                
                let _ = try self.service.setTrackingPointStatus(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set/update the current rectangle tracking status.

     - Parameter trackedRectangle: The tracked rectangle
     
     */
    public func setTrackingRectangleStatus(trackedRectangle: TrackRectangle) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TrackingServer_SetTrackingRectangleStatusRequest()

            
                
            request.trackedRectangle = trackedRectangle.rpcTrackRectangle
                
            

            do {
                
                let _ = try self.service.setTrackingRectangleStatus(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Set the current tracking status to off.

     
     */
    public func setTrackingOffStatus() -> Completable {
        return Completable.create { completable in
            let request = Mavsdk_Rpc_TrackingServer_SetTrackingOffStatusRequest()

            

            do {
                
                let _ = try self.service.setTrackingOffStatus(request)
                completable(.completed)
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }


    /**
     Subscribe to incoming tracking point command.
     */
    public lazy var trackingPointCommand: Observable<TrackPoint> = createTrackingPointCommandObservable()



    private func createTrackingPointCommandObservable() -> Observable<TrackPoint> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_TrackingServer_SubscribeTrackingPointCommandRequest()

            

            _ = self.service.subscribeTrackingPointCommand(request, handler: { (response) in

                
                     
                let trackingPointCommand = TrackPoint.translateFromRpc(response.trackPoint)
                

                
                observer.onNext(trackingPointCommand)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTrackingServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to incoming tracking rectangle command.
     */
    public lazy var trackingRectangleCommand: Observable<TrackRectangle> = createTrackingRectangleCommandObservable()



    private func createTrackingRectangleCommandObservable() -> Observable<TrackRectangle> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_TrackingServer_SubscribeTrackingRectangleCommandRequest()

            

            _ = self.service.subscribeTrackingRectangleCommand(request, handler: { (response) in

                
                     
                let trackingRectangleCommand = TrackRectangle.translateFromRpc(response.trackRectangle)
                

                
                observer.onNext(trackingRectangleCommand)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTrackingServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to incoming tracking off command.
     */
    public lazy var trackingOffCommand: Observable<Int32> = createTrackingOffCommandObservable()



    private func createTrackingOffCommandObservable() -> Observable<Int32> {
        return Observable.create { observer in
            let request = Mavsdk_Rpc_TrackingServer_SubscribeTrackingOffCommandRequest()

            

            _ = self.service.subscribeTrackingOffCommand(request, handler: { (response) in

                
                     
                let trackingOffCommand = response.dummy
                    
                

                
                observer.onNext(trackingOffCommand)
                
            })

            return Disposables.create()
        }
        .retryWhen { error in
            error.map {
                guard $0 is RuntimeTrackingServerError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Respond to an incoming tracking point command.

     - Parameter commandAnswer: The ack to answer to the incoming command
     
     */
    public func respondTrackingPointCommand(commandAnswer: CommandAnswer) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TrackingServer_RespondTrackingPointCommandRequest()

            
                
            request.commandAnswer = commandAnswer.rpcCommandAnswer
                
            

            do {
                
                let response = self.service.respondTrackingPointCommand(request)

                let result = try response.response.wait().trackingServerResult
                if (result.result == Mavsdk_Rpc_TrackingServer_TrackingServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TrackingServerError(code: TrackingServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Respond to an incoming tracking rectangle command.

     - Parameter commandAnswer: The ack to answer to the incoming command
     
     */
    public func respondTrackingRectangleCommand(commandAnswer: CommandAnswer) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TrackingServer_RespondTrackingRectangleCommandRequest()

            
                
            request.commandAnswer = commandAnswer.rpcCommandAnswer
                
            

            do {
                
                let response = self.service.respondTrackingRectangleCommand(request)

                let result = try response.response.wait().trackingServerResult
                if (result.result == Mavsdk_Rpc_TrackingServer_TrackingServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TrackingServerError(code: TrackingServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }

    /**
     Respond to an incoming tracking off command.

     - Parameter commandAnswer: The ack to answer to the incoming command
     
     */
    public func respondTrackingOffCommand(commandAnswer: CommandAnswer) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_TrackingServer_RespondTrackingOffCommandRequest()

            
                
            request.commandAnswer = commandAnswer.rpcCommandAnswer
                
            

            do {
                
                let response = self.service.respondTrackingOffCommand(request)

                let result = try response.response.wait().trackingServerResult
                if (result.result == Mavsdk_Rpc_TrackingServer_TrackingServerResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TrackingServerError(code: TrackingServerResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}