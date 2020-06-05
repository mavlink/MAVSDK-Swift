import Foundation
import RxSwift
import SwiftGRPC

public class Tune {
    private let service: Mavsdk_Rpc_Tune_TuneServiceService
    private let scheduler: SchedulerType

    public convenience init(address: String = "localhost",
                            port: Int32 = 50051,
                            scheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .background)) {
        let service = Mavsdk_Rpc_Tune_TuneServiceServiceClient(address: "\(address):\(port)", secure: false)

        self.init(service: service, scheduler: scheduler)
    }

    init(service: Mavsdk_Rpc_Tune_TuneServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
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
    

    public enum SongElement: Equatable {
        case styleLegato
        case styleNormal
        case styleStaccato
        case duration1
        case duration2
        case duration4
        case duration8
        case duration16
        case duration32
        case noteA
        case noteB
        case noteC
        case noteD
        case noteE
        case noteF
        case noteG
        case notePause
        case sharp
        case flat
        case octaveUp
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


    public struct TuneDescription: Equatable {
        public let songElements: [SongElement]
        public let tempo: Int32

        

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

    public struct TuneResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        public enum Result: Equatable {
            case success
            case invalidTempo
            case tuneTooLong
            case error
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Tune_TuneResult.Result {
                switch self {
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


    public func playTune(description: TuneDescription) -> Completable {
        return Completable.create { completable in
            var request = Mavsdk_Rpc_Tune_PlayTuneRequest()

            
                
            request.description_p = description.rpcTuneDescription
                
            

            do {
                
                let response = try self.service.playTune(request)

                if (response.tuneResult.result == Mavsdk_Rpc_Tune_TuneResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error(TuneError(code: TuneResult.Result.translateFromRpc(response.tuneResult.result), description: response.tuneResult.resultStr)))
                }
                
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
    }
}
