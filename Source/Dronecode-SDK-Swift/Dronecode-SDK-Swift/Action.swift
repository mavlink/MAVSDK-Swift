//
//  Action.swift
//  DroneCore-Swift
//
//  Created by Jones on 12.03.18.
//  Copyright © 2018 Dronecode. All rights reserved.
//

import backend
import Foundation
import gRPC
import RxSwift

public class Action {
    let service = Dronecore_Rpc_Action_ActionServiceServiceClient(address: "localhost:50051", secure: false)
    
    public init() {
        DispatchQueue.global(qos: .background).async {
            print("Running backend in background (MAVLink port: 14540)")
            runBackend(14540)
        }
        
        gRPC.initialize()
    }

    public func arm() -> Completable {
        return Completable.create { completable in
            let armRequest = Dronecore_Rpc_Action_ArmRequest()
            
            do {
                let armResponse = try self.service.arm(armRequest)
                if (armResponse.actionResult.result == Dronecore_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                    return Disposables.create {}
                } else {
                    completable(.error("Cannot arm: \(armResponse.actionResult.result)" as! Error))
                    return Disposables.create {}
                }
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }
    }
    
    public func takeoff() -> Completable {
        return Completable.create { completable in
            let takeoffRequest = Dronecore_Rpc_Action_TakeoffRequest()
            
            do {
                let takeoffResponse = try self.service.takeoff(takeoffRequest)
                if (takeoffResponse.actionResult.result == Dronecore_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                    return Disposables.create {}
                } else {
                    completable(.error("Cannot takeoff: \(takeoffResponse.actionResult.result)" as! Error))
                    return Disposables.create {}
                }
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }
    }
    
    public func land() -> Completable {
        return Completable.create { completable in
            let landRequest = Dronecore_Rpc_Action_LandRequest()
            
            do {
                let landResponse = try self.service.land(landRequest)
                if (landResponse.actionResult.result == Dronecore_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                    return Disposables.create {}
                } else {
                    completable(.error("Cannot land: \(landResponse.actionResult.result)" as! Error))
                    return Disposables.create {}
                }
            } catch {
                completable(.error(error))
                return Disposables.create {}
            }
        }
    }
}
