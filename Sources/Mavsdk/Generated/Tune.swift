import Foundation
import RxSwift
import GRPC
import NIO

/**
 Enable creating and sending a tune to be played on the system.
 */
public class Tune {
    private let service: Mavsdk_Rpc_Tune_TuneServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Tune` plugin.

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
        let service = Mavsdk_Rpc_Tune_TuneServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Tune_TuneServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeTuneError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct TuneError: Error {
        public let code: Tune.TuneResult.Result
        public let description: String
    }
    

    /**
     An element of the tune
     */
    public enum SongElement: Equatable {
        ///  After this element, start playing legato.
        case styleLegato
        ///  After this element, start playing normal.
        case styleNormal
        ///  After this element, start playing staccato.
        case styleStaccato
        ///  After this element, set the note duration to 1.
        case duration1
        ///  After this element, set the note duration to 2.
        case duration2
        ///  After this element, set the note duration to 4.
        case duration4
        ///  After this element, set the note duration to 8.
        case duration8
        ///  After this element, set the note duration to 16.
        case duration16
        ///  After this element, set the note duration to 32.
        case duration32
        ///  Play note A.
        case noteA
        ///  Play note B.
        case noteB
        ///  Play note C.
        case noteC
        ///  Play note D.
        case noteD
        ///  Play note E.
        case noteE
        ///  Play note F.
        case noteF
        ///  Play note G.
        case noteG
        ///  Play a rest.
        case notePause
        ///  After this element, sharp the note (half a step up).
        case sharp
        ///  After this element, flat the note (half a step down).
        case flat
        ///  After this element, shift the note 1 octave up.
        case octaveUp
        ///  After this element, shift the note 1 octave down.
        case octaveDown
        case UNRECOGNIZED(Int)

        internal var rpcSongElement: Mavsdk_Rpc_Tune_SongElement {
            switch self {
            case .styleLegato:
                return .styleLegato
            case .styleNormal:
                return .styleNormal
            case .styleStaccato:
                return .styleStaccato
            case .duration1:
                return .duration1
            case .duration2:
                return .duration2
            case .duration4:
                return .duration4
            case .duration8:
                return .duration8
            case .duration16:
                return .duration16
            case .duration32:
                return .duration32
            case .noteA:
                return .noteA
            case .noteB:
                return .noteB
            case .noteC:
                return .noteC
            case .noteD:
                return .noteD
            case .noteE:
                return .noteE
            case .noteF:
                return .noteF
            case .noteG:
                return .noteG
            case .notePause:
                return .notePause
            case .sharp:
                return .sharp
            case .flat:
                return .flat
            case .octaveUp:
                return .octaveUp
            case .octaveDown:
                return .octaveDown
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcSongElement: Mavsdk_Rpc_Tune_SongElement) -> SongElement {
            switch rpcSongElement {
            case .styleLegato:
                return .styleLegato
            case .styleNormal:
                return .styleNormal
            case .styleStaccato:
                return .styleStaccato
            case .duration1:
                return .duration1
            case .duration2:
                return .duration2
            case .duration4:
                return .duration4
            case .duration8:
                return .duration8
            case .duration16:
                return .duration16
            case .duration32:
                return .duration32
            case .noteA:
                return .noteA
            case .noteB:
                return .noteB
            case .noteC:
                return .noteC
            case .noteD:
                return .noteD
            case .noteE:
                return .noteE
            case .noteF:
                return .noteF
            case .noteG:
                return .noteG
            case .notePause:
                return .notePause
            case .sharp:
                return .sharp
            case .flat:
                return .flat
            case .octaveUp:
                return .octaveUp
            case .octaveDown:
                return .octaveDown
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     Tune description, containing song elements and tempo.
     */
    public struct TuneDescription: Equatable {
        public let songElements: [SongElement]
        public let tempo: Int32

        

        /**
         Initializes a new `TuneDescription`.

         
         - Parameters:
            
            - songElements:  The list of song elements (notes, pauses, ...) to be played
            
            - tempo:  The tempo of the song (range: 32 - 255)
            
         
         */
        public init(songElements: [SongElement], tempo: Int32) {
            self.songElements = songElements
            self.tempo = tempo
        }

        internal var rpcTuneDescription: Mavsdk_Rpc_Tune_TuneDescription {
            var rpcTuneDescription = Mavsdk_Rpc_Tune_TuneDescription()
            
                
            rpcTuneDescription.songElements = songElements.map{ $0.rpcSongElement }
                
            
            
                
            rpcTuneDescription.tempo = tempo
                
            

            return rpcTuneDescription
        }

        internal static func translateFromRpc(_ rpcTuneDescription: Mavsdk_Rpc_Tune_TuneDescription) -> TuneDescription {
            return TuneDescription(songElements: rpcTuneDescription.songElements.map{ SongElement.translateFromRpc($0) }, tempo: rpcTuneDescription.tempo)
        }

        public static func == (lhs: TuneDescription, rhs: TuneDescription) -> Bool {
            return lhs.songElements == rhs.songElements
                && lhs.tempo == rhs.tempo
        }
    }

    /**
     
     */
    public struct TuneResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         Possible results returned for tune requests.
         */
        public enum Result: Equatable {
            ///  Unknown result.
            case unknown
            ///  Request succeeded.
            case success
            ///  Invalid tempo (range: 32 - 255).
            case invalidTempo
            ///  Invalid tune: encoded string must be at most 247 chars.
            case tuneTooLong
            ///  Failed to send the request.
            case error
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Tune_TuneResult.Result {
                switch self {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .invalidTempo:
                    return .invalidTempo
                case .tuneTooLong:
                    return .tuneTooLong
                case .error:
                    return .error
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Tune_TuneResult.Result) -> Result {
                switch rpcResult {
                case .unknown:
                    return .unknown
                case .success:
                    return .success
                case .invalidTempo:
                    return .invalidTempo
                case .tuneTooLong:
                    return .tuneTooLong
                case .error:
                    return .error
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `TuneResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcTuneResult: Mavsdk_Rpc_Tune_TuneResult {
            var rpcTuneResult = Mavsdk_Rpc_Tune_TuneResult()
            
                
            rpcTuneResult.result = result.rpcResult
                
            
            
                
            rpcTuneResult.resultStr = resultStr
                
            

            return rpcTuneResult
        }

        internal static func translateFromRpc(_ rpcTuneResult: Mavsdk_Rpc_Tune_TuneResult) -> TuneResult {
            return TuneResult(result: Result.translateFromRpc(rpcTuneResult.result), resultStr: rpcTuneResult.resultStr)
        }

        public static func == (lhs: TuneResult, rhs: TuneResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }


    /**
     Send a tune to be played by the system.

     - Parameter tuneDescription: The tune to be played
     
     */
    public func playTune(tuneDescription: TuneDescription) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Tune_PlayTuneRequest()

            
                
            request.tuneDescription = tuneDescription.rpcTuneDescription
                
            

            do {
                
                let response = self.service.playTune(request)

                let result = try response.response.wait().tuneResult
                if (result.result == Mavsdk_Rpc_Tune_TuneResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TuneError(code: TuneResult.Result.translateFromRpc(result.result), description: result.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}