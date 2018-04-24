//
//  CoreManager.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 20.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import Dronecode_SDK_Swift

class CoreManager {
    
    // MARK: - Properties
    // Telemetry
    var telemetry = Telemetry(address: "localhost", port: 50051)
    // Action
    let action = Action(address: "localhost", port: 50051)
    let core: Core
    
    
    private static var sharedCoreManager: CoreManager = {
        let coreManager = CoreManager()
        
        // Configuration
        // ...
        
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
        core.connect()
    }
    
}
