//
//  Info.swift
//  Dronecode-SDK-Swift
//
//  Created by Julian Oes on 23.11.18.
//  Copyright © 2018 Dronecode. All rights reserved.
//

import Foundation
import SwiftGRPC
import RxSwift


/**
 The Info class enables to get the autopilot version.
 */
public class Info {
    private let service: DronecodeSdk_Rpc_Info_InfoServiceService
    let scheduler: SchedulerType
    
    /**
     Helper function to connect `Info` object to the backend.
     
     - Parameter address: Network address of backend (IP or "localhost").
     - Parameter port: Port number of backend.
     */
    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Info_InfoServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        self.init(service: service, scheduler: scheduler)
    }
    
    init(service: DronecodeSdk_Rpc_Info_InfoServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
    /**
     Version type
     */
    public struct Version: Equatable {
        /// Flight software major version
        public let flightSwMajor: Int32
        /// Flight software minor version
        public let flightSwMinor: Int32
        /// Flight software patch version
        public let flightSwPatch: Int32
        /// Flight software major version
        public let flightSwVendorMajor: Int32
        /// Flight software minor version
        public let flightSwVendorMinor: Int32
        /// Flight software patch version
        public let flightSwVendorPatch: Int32
        /// Flight software major version
        public let osSwMajor: Int32
        /// Flight software minor version
        public let osSwMinor: Int32
        /// Flight software patch version
        public let osSwPatch: Int32
    }

    
    /**
     Get the autopilot version.
     
     - Returns: a `Single` containing the version or an error.
     */
    public func getVersion() -> Single<Version> {
        return Single<Version>.create { single in
            let getVersionRequest = DronecodeSdk_Rpc_Info_GetVersionRequest()
            
            do {
                let getVersionResponse = try self.service.getVersion(getVersionRequest)
                let version = Version(flightSwMajor: getVersionResponse.version.flightSwMajor,
                                      flightSwMinor: getVersionResponse.version.flightSwMinor,
                                      flightSwPatch: getVersionResponse.version.flightSwPatch,
                                      flightSwVendorMajor: getVersionResponse.version.flightSwVendorMajor,
                                      flightSwVendorMinor: getVersionResponse.version.flightSwVendorMinor,
                                      flightSwVendorPatch: getVersionResponse.version.flightSwVendorPatch,
                                      osSwMajor: getVersionResponse.version.osSwMajor,
                                      osSwMinor: getVersionResponse.version.osSwMinor,
                                      osSwPatch: getVersionResponse.version.osSwPatch)
                
                single(.success(version))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
            }
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
}
