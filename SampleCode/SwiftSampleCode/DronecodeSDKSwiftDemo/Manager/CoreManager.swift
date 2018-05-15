//
//  CoreManager.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 20.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import Dronecode_SDK_Swift
import RxBlocking

class CoreManager {
    
    // MARK: - Properties
    
    // Telemetry
    var telemetry = Telemetry(address: "localhost", port: 50051)
    // Action
    let action = Action(address: "localhost", port: 50051)
    // Mission
    let mission = Mission(address: "localhost", port: 50051)
    
    // Core System
    let core: Core
    
    // Drone state
    let droneState = DroneState()
    
    
    private static var sharedCoreManager: CoreManager = {
        let coreManager = CoreManager()
        
        return coreManager
    }()
    
    
    // Initialization
    
    private init() {
        core = Core()
        

    }
    
    // MARK: - Accessors
    
    class func shared() -> CoreManager {
        return sharedCoreManager
    }
    
    public func start() -> Void{
       _ = core.connect().toBlocking().materialize()
    }
    
}
