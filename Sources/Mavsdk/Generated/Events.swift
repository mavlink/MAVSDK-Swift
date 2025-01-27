import Foundation
import RxSwift
import GRPC
import NIO

/**
 Get event notifications, such as takeoff, or arming checks
 */
public class Events {
    private let service: Mavsdk_Rpc_Events_EventsServiceClient
    private let scheduler: SchedulerType
    private let clientEventLoopGroup: EventLoopGroup

    /**
     Initializes a new `Events` plugin.

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
        let service = Mavsdk_Rpc_Events_EventsServiceClient(channel: channel)

        self.init(service: service, scheduler: scheduler, eventLoopGroup: eventLoopGroup)
    }

    init(service: Mavsdk_Rpc_Events_EventsServiceClient, scheduler: SchedulerType, eventLoopGroup: EventLoopGroup) {
        self.service = service
        self.scheduler = scheduler
        self.clientEventLoopGroup = eventLoopGroup
    }

    public struct RuntimeEventsError: Error {
        public let description: String

        init(_ description: String) {
            self.description = description
        }
    }

    
    public struct EventsError: Error {
        public let code: Events.EventsResult.Result
        public let description: String
    }
    

    /**
     
     */
    public enum LogLevel: Equatable {
        /// .
        case emergency
        /// .
        case alert
        /// .
        case critical
        /// .
        case error
        /// .
        case warning
        /// .
        case notice
        /// .
        case info
        /// .
        case debug
        case UNRECOGNIZED(Int)

        internal var rpcLogLevel: Mavsdk_Rpc_Events_LogLevel {
            switch self {
            case .emergency:
                return .emergency
            case .alert:
                return .alert
            case .critical:
                return .critical
            case .error:
                return .error
            case .warning:
                return .warning
            case .notice:
                return .notice
            case .info:
                return .info
            case .debug:
                return .debug
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }

        internal static func translateFromRpc(_ rpcLogLevel: Mavsdk_Rpc_Events_LogLevel) -> LogLevel {
            switch rpcLogLevel {
            case .emergency:
                return .emergency
            case .alert:
                return .alert
            case .critical:
                return .critical
            case .error:
                return .error
            case .warning:
                return .warning
            case .notice:
                return .notice
            case .info:
                return .info
            case .debug:
                return .debug
            case .UNRECOGNIZED(let i):
                return .UNRECOGNIZED(i)
            }
        }
    }


    /**
     
     */
    public struct Event: Equatable {
        public let compid: UInt32
        public let message: String
        public let description: String
        public let logLevel: LogLevel
        public let eventNamespace: String
        public let eventName: String

        

        /**
         Initializes a new `Event`.

         
         - Parameters:
            
            - compid:  The source component ID of the event
            
            - message:  Short, single-line message
            
            - description:  Detailed description (optional, might be multiple lines)
            
            - logLevel: 
            
            - eventNamespace:  Namespace, e.g. "px4"
            
            - eventName:  Event name (unique within the namespace)
            
         
         */
        public init(compid: UInt32, message: String, description: String, logLevel: LogLevel, eventNamespace: String, eventName: String) {
            self.compid = compid
            self.message = message
            self.description = description
            self.logLevel = logLevel
            self.eventNamespace = eventNamespace
            self.eventName = eventName
        }

        internal var rpcEvent: Mavsdk_Rpc_Events_Event {
            var rpcEvent = Mavsdk_Rpc_Events_Event()
            
                
            rpcEvent.compid = compid
                
            
            
                
            rpcEvent.message = message
                
            
            
                
            rpcEvent.description = description
                
            
            
                
            rpcEvent.logLevel = logLevel.rpcLogLevel
                
            
            
                
            rpcEvent.eventNamespace = eventNamespace
                
            
            
                
            rpcEvent.eventName = eventName
                
            

            return rpcEvent
        }

        internal static func translateFromRpc(_ rpcEvent: Mavsdk_Rpc_Events_Event) -> Event {
            return Event(compid: rpcEvent.compid, message: rpcEvent.message, description: rpcEvent.description, logLevel: LogLevel.translateFromRpc(rpcEvent.logLevel), eventNamespace: rpcEvent.eventNamespace, eventName: rpcEvent.eventName)
        }

        public static func == (lhs: Event, rhs: Event) -> Bool {
            return lhs.compid == rhs.compid
                && lhs.message == rhs.message
                && lhs.description == rhs.description
                && lhs.logLevel == rhs.logLevel
                && lhs.eventNamespace == rhs.eventNamespace
                && lhs.eventName == rhs.eventName
        }
    }

    /**
     
     */
    public struct HealthAndArmingCheckProblem: Equatable {
        public let message: String
        public let description: String
        public let logLevel: LogLevel
        public let healthComponent: String

        

        /**
         Initializes a new `HealthAndArmingCheckProblem`.

         
         - Parameters:
            
            - message:  Short, single-line message
            
            - description:  Detailed description (optional, might be multiple lines)
            
            - logLevel: 
            
            - healthComponent:  Associated health component, e.g. "gps"
            
         
         */
        public init(message: String, description: String, logLevel: LogLevel, healthComponent: String) {
            self.message = message
            self.description = description
            self.logLevel = logLevel
            self.healthComponent = healthComponent
        }

        internal var rpcHealthAndArmingCheckProblem: Mavsdk_Rpc_Events_HealthAndArmingCheckProblem {
            var rpcHealthAndArmingCheckProblem = Mavsdk_Rpc_Events_HealthAndArmingCheckProblem()
            
                
            rpcHealthAndArmingCheckProblem.message = message
                
            
            
                
            rpcHealthAndArmingCheckProblem.description = description
                
            
            
                
            rpcHealthAndArmingCheckProblem.logLevel = logLevel.rpcLogLevel
                
            
            
                
            rpcHealthAndArmingCheckProblem.healthComponent = healthComponent
                
            

            return rpcHealthAndArmingCheckProblem
        }

        internal static func translateFromRpc(_ rpcHealthAndArmingCheckProblem: Mavsdk_Rpc_Events_HealthAndArmingCheckProblem) -> HealthAndArmingCheckProblem {
            return HealthAndArmingCheckProblem(message: rpcHealthAndArmingCheckProblem.message, description: rpcHealthAndArmingCheckProblem.description, logLevel: LogLevel.translateFromRpc(rpcHealthAndArmingCheckProblem.logLevel), healthComponent: rpcHealthAndArmingCheckProblem.healthComponent)
        }

        public static func == (lhs: HealthAndArmingCheckProblem, rhs: HealthAndArmingCheckProblem) -> Bool {
            return lhs.message == rhs.message
                && lhs.description == rhs.description
                && lhs.logLevel == rhs.logLevel
                && lhs.healthComponent == rhs.healthComponent
        }
    }

    /**
     Arming checks for a specific mode
     */
    public struct HealthAndArmingCheckMode: Equatable {
        public let modeName: String
        public let canArmOrRun: Bool
        public let problems: [HealthAndArmingCheckProblem]

        

        /**
         Initializes a new `HealthAndArmingCheckMode`.

         
         - Parameters:
            
            - modeName:  Mode name, e.g. "Position"
            
            - canArmOrRun:  If disarmed: indicates if arming is possible. If armed: indicates if the mode can be selected
            
            - problems:  List of reported problems for the mode
            
         
         */
        public init(modeName: String, canArmOrRun: Bool, problems: [HealthAndArmingCheckProblem]) {
            self.modeName = modeName
            self.canArmOrRun = canArmOrRun
            self.problems = problems
        }

        internal var rpcHealthAndArmingCheckMode: Mavsdk_Rpc_Events_HealthAndArmingCheckMode {
            var rpcHealthAndArmingCheckMode = Mavsdk_Rpc_Events_HealthAndArmingCheckMode()
            
                
            rpcHealthAndArmingCheckMode.modeName = modeName
                
            
            
                
            rpcHealthAndArmingCheckMode.canArmOrRun = canArmOrRun
                
            
            
                
            rpcHealthAndArmingCheckMode.problems = problems.map{ $0.rpcHealthAndArmingCheckProblem }
                
            

            return rpcHealthAndArmingCheckMode
        }

        internal static func translateFromRpc(_ rpcHealthAndArmingCheckMode: Mavsdk_Rpc_Events_HealthAndArmingCheckMode) -> HealthAndArmingCheckMode {
            return HealthAndArmingCheckMode(modeName: rpcHealthAndArmingCheckMode.modeName, canArmOrRun: rpcHealthAndArmingCheckMode.canArmOrRun, problems: rpcHealthAndArmingCheckMode.problems.map{ HealthAndArmingCheckProblem.translateFromRpc($0) })
        }

        public static func == (lhs: HealthAndArmingCheckMode, rhs: HealthAndArmingCheckMode) -> Bool {
            return lhs.modeName == rhs.modeName
                && lhs.canArmOrRun == rhs.canArmOrRun
                && lhs.problems == rhs.problems
        }
    }

    /**
     
     */
    public struct HealthComponentReport: Equatable {
        public let name: String
        public let label: String
        public let isPresent: Bool
        public let hasError: Bool
        public let hasWarning: Bool

        

        /**
         Initializes a new `HealthComponentReport`.

         
         - Parameters:
            
            - name:  Unique component name, e.g. "gps"
            
            - label:  Human readable label of the component, e.g. "GPS" or "Accelerometer"
            
            - isPresent:  If the component is present
            
            - hasError:  If the component has errors
            
            - hasWarning:  If the component has warnings
            
         
         */
        public init(name: String, label: String, isPresent: Bool, hasError: Bool, hasWarning: Bool) {
            self.name = name
            self.label = label
            self.isPresent = isPresent
            self.hasError = hasError
            self.hasWarning = hasWarning
        }

        internal var rpcHealthComponentReport: Mavsdk_Rpc_Events_HealthComponentReport {
            var rpcHealthComponentReport = Mavsdk_Rpc_Events_HealthComponentReport()
            
                
            rpcHealthComponentReport.name = name
                
            
            
                
            rpcHealthComponentReport.label = label
                
            
            
                
            rpcHealthComponentReport.isPresent = isPresent
                
            
            
                
            rpcHealthComponentReport.hasError_p = hasError
                
            
            
                
            rpcHealthComponentReport.hasWarning_p = hasWarning
                
            

            return rpcHealthComponentReport
        }

        internal static func translateFromRpc(_ rpcHealthComponentReport: Mavsdk_Rpc_Events_HealthComponentReport) -> HealthComponentReport {
            return HealthComponentReport(name: rpcHealthComponentReport.name, label: rpcHealthComponentReport.label, isPresent: rpcHealthComponentReport.isPresent, hasError: rpcHealthComponentReport.hasError_p, hasWarning: rpcHealthComponentReport.hasWarning_p)
        }

        public static func == (lhs: HealthComponentReport, rhs: HealthComponentReport) -> Bool {
            return lhs.name == rhs.name
                && lhs.label == rhs.label
                && lhs.isPresent == rhs.isPresent
                && lhs.hasError == rhs.hasError
                && lhs.hasWarning == rhs.hasWarning
        }
    }

    /**
     
     */
    public struct HealthAndArmingCheckReport: Equatable {
        public let currentModeIntention: HealthAndArmingCheckMode
        public let healthComponents: [HealthComponentReport]
        public let allProblems: [HealthAndArmingCheckProblem]

        

        /**
         Initializes a new `HealthAndArmingCheckReport`.

         
         - Parameters:
            
            - currentModeIntention:  Report for currently intended mode
            
            - healthComponents:  Health components list (e.g. for "gps")
            
            - allProblems:  Complete list of problems
            
         
         */
        public init(currentModeIntention: HealthAndArmingCheckMode, healthComponents: [HealthComponentReport], allProblems: [HealthAndArmingCheckProblem]) {
            self.currentModeIntention = currentModeIntention
            self.healthComponents = healthComponents
            self.allProblems = allProblems
        }

        internal var rpcHealthAndArmingCheckReport: Mavsdk_Rpc_Events_HealthAndArmingCheckReport {
            var rpcHealthAndArmingCheckReport = Mavsdk_Rpc_Events_HealthAndArmingCheckReport()
            
                
            rpcHealthAndArmingCheckReport.currentModeIntention = currentModeIntention.rpcHealthAndArmingCheckMode
                
            
            
                
            rpcHealthAndArmingCheckReport.healthComponents = healthComponents.map{ $0.rpcHealthComponentReport }
                
            
            
                
            rpcHealthAndArmingCheckReport.allProblems = allProblems.map{ $0.rpcHealthAndArmingCheckProblem }
                
            

            return rpcHealthAndArmingCheckReport
        }

        internal static func translateFromRpc(_ rpcHealthAndArmingCheckReport: Mavsdk_Rpc_Events_HealthAndArmingCheckReport) -> HealthAndArmingCheckReport {
            return HealthAndArmingCheckReport(currentModeIntention: HealthAndArmingCheckMode.translateFromRpc(rpcHealthAndArmingCheckReport.currentModeIntention), healthComponents: rpcHealthAndArmingCheckReport.healthComponents.map{ HealthComponentReport.translateFromRpc($0) }, allProblems: rpcHealthAndArmingCheckReport.allProblems.map{ HealthAndArmingCheckProblem.translateFromRpc($0) })
        }

        public static func == (lhs: HealthAndArmingCheckReport, rhs: HealthAndArmingCheckReport) -> Bool {
            return lhs.currentModeIntention == rhs.currentModeIntention
                && lhs.healthComponents == rhs.healthComponents
                && lhs.allProblems == rhs.allProblems
        }
    }

    /**
     Result type.
     */
    public struct EventsResult: Equatable {
        public let result: Result
        public let resultStr: String

        
        

        /**
         
         */
        public enum Result: Equatable {
            /// .
            case success
            /// .
            case notAvailable
            /// .
            case connectionError
            /// .
            case unsupported
            /// .
            case denied
            /// .
            case failed
            /// .
            case timeout
            /// .
            case noSystem
            case UNRECOGNIZED(Int)

            internal var rpcResult: Mavsdk_Rpc_Events_EventsResult.Result {
                switch self {
                case .success:
                    return .success
                case .notAvailable:
                    return .notAvailable
                case .connectionError:
                    return .connectionError
                case .unsupported:
                    return .unsupported
                case .denied:
                    return .denied
                case .failed:
                    return .failed
                case .timeout:
                    return .timeout
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }

            internal static func translateFromRpc(_ rpcResult: Mavsdk_Rpc_Events_EventsResult.Result) -> Result {
                switch rpcResult {
                case .success:
                    return .success
                case .notAvailable:
                    return .notAvailable
                case .connectionError:
                    return .connectionError
                case .unsupported:
                    return .unsupported
                case .denied:
                    return .denied
                case .failed:
                    return .failed
                case .timeout:
                    return .timeout
                case .noSystem:
                    return .noSystem
                case .UNRECOGNIZED(let i):
                    return .UNRECOGNIZED(i)
                }
            }
        }
        

        /**
         Initializes a new `EventsResult`.

         
         - Parameters:
            
            - result:  Result enum value
            
            - resultStr:  Human-readable English string describing the result
            
         
         */
        public init(result: Result, resultStr: String) {
            self.result = result
            self.resultStr = resultStr
        }

        internal var rpcEventsResult: Mavsdk_Rpc_Events_EventsResult {
            var rpcEventsResult = Mavsdk_Rpc_Events_EventsResult()
            
                
            rpcEventsResult.result = result.rpcResult
                
            
            
                
            rpcEventsResult.resultStr = resultStr
                
            

            return rpcEventsResult
        }

        internal static func translateFromRpc(_ rpcEventsResult: Mavsdk_Rpc_Events_EventsResult) -> EventsResult {
            return EventsResult(result: Result.translateFromRpc(rpcEventsResult.result), resultStr: rpcEventsResult.resultStr)
        }

        public static func == (lhs: EventsResult, rhs: EventsResult) -> Bool {
            return lhs.result == rhs.result
                && lhs.resultStr == rhs.resultStr
        }
    }



    /**
     Subscribe to event updates.
     */

    public lazy var events: Observable<Event> = createEventsObservable()




    private func createEventsObservable() -> Observable<Event> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Events_SubscribeEventsRequest()

            

            let serverStreamingCall = self.service.subscribeEvents(request, handler: { (response) in

                
                     
                let events = Event.translateFromRpc(response.event)
                

                
                observer.onNext(events)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeEventsError else { throw $0 }
            }
        }
        .share(replay: 1)
    }


    /**
     Subscribe to arming check updates.
     */

    public lazy var healthAndArmingChecks: Observable<HealthAndArmingCheckReport> = createHealthAndArmingChecksObservable()




    private func createHealthAndArmingChecksObservable() -> Observable<HealthAndArmingCheckReport> {
        return Observable.create { [unowned self] observer in
            let request = Mavsdk_Rpc_Events_SubscribeHealthAndArmingChecksRequest()

            

            let serverStreamingCall = self.service.subscribeHealthAndArmingChecks(request, handler: { (response) in

                
                     
                let healthAndArmingChecks = HealthAndArmingCheckReport.translateFromRpc(response.report)
                

                
                observer.onNext(healthAndArmingChecks)
                
            })

            return Disposables.create {
                serverStreamingCall.cancel(promise: nil)
            }
        }
        .retry { error in
            error.map {
                guard $0 is RuntimeEventsError else { throw $0 }
            }
        }
        .share(replay: 1)
    }

    /**
     Get the latest report.

     
     */
    public func getHealthAndArmingChecksReport() -> Single<HealthAndArmingCheckReport> {
        return Single<HealthAndArmingCheckReport>.create { single in
            let request = Mavsdk_Rpc_Events_GetHealthAndArmingChecksReportRequest()

            

            do {
                let response = self.service.getHealthAndArmingChecksReport(request)

                
                let result = try response.response.wait().eventsResult
                if (result.result != Mavsdk_Rpc_Events_EventsResult.Result.success) {
                    single(.failure(EventsError(code: EventsResult.Result.translateFromRpc(result.result), description: result.resultStr)))

                    return Disposables.create()
                }
                

    	    
                    let report = try HealthAndArmingCheckReport.translateFromRpc(response.response.wait().report)
                
                single(.success(report))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}