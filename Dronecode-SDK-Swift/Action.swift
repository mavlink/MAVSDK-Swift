import Foundation
import SwiftGRPC
import RxSwift

extension String: Error {
}

/**
 The Action class enables simple actions for a drone such as arming, taking off, and landing.
 */
public class Action {
    private let service: DronecodeSdk_Rpc_Action_ActionServiceService
    let scheduler: SchedulerType

    /**
     Helper function to connect `Action` object to the backend.
     
     - Parameter address: Network address of backend (IP or "localhost").
     - Parameter port: Port number of backend.
     */
    public convenience init(address: String, port: Int) {
        let service = DronecodeSdk_Rpc_Action_ActionServiceServiceClient(address: "\(address):\(port)", secure: false)
        let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        self.init(service: service, scheduler: scheduler)
    }
    
    init(service: DronecodeSdk_Rpc_Action_ActionServiceService, scheduler: SchedulerType) {
        self.service = service
        self.scheduler = scheduler
    }
    
    /**
     Send command to *arm* the drone.
     
     - Note: Arming a drone normally causes motors to spin at idle.
             Before arming take all safety precautions and stand clear of the drone!
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func arm() -> Completable {
        return Completable.create { completable in
            let armRequest = DronecodeSdk_Rpc_Action_ArmRequest()
            
            do {
                let armResponse = try self.service.arm(armRequest)
                if (armResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot arm: \(armResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
            }
            .subscribeOn(scheduler)
            .observeOn(MainScheduler.instance)
    }
    
    /**
     Send command to *disarm* the drone.
     
     This will disarm a drone that considers itself landed.
     If flying, the drone should reject the disarm command. Disarming means that all motors will stop.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func disarm() -> Completable {
        return Completable.create { completable in
            let disarmRequest = DronecodeSdk_Rpc_Action_DisarmRequest()
            
            do {
                let disarmResponse = try self.service.disarm(disarmRequest)
                if (disarmResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot disarm: \(disarmResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Send command to *take off and hover*.
     
     This switches the drone into position control mode and commands it to take off and hover at the takeoff altitude (set using `setTakeoffAltitude`).
     
     - Note: The vehicle must be armed before it can take off.

     - Returns: a `Completable` indicating success or an error.
     */
    public func takeoff() -> Completable {
        return Completable.create { completable in
            let takeoffRequest = DronecodeSdk_Rpc_Action_TakeoffRequest()
            
            do {
                let takeoffResponse = try self.service.takeoff(takeoffRequest)
                if (takeoffResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot takeoff: \(takeoffResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Send command to *land* at the current position.
     
     This switches the drone to [Land mode](https://docs.px4.io/en/flight_modes/land.html).
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func land() -> Completable {
        return Completable.create { completable in
            let landRequest = DronecodeSdk_Rpc_Action_LandRequest()
            
            do {
                let landResponse = try self.service.land(landRequest)
                if (landResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot land: \(landResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }

    /**
     Send command to *kill* the drone.
     
     This will disarm a drone irrespective of whether it is landed or flying.
     
     - Note: The drone will fall out of the sky if this command is used while flying.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func kill() -> Completable {
        return Completable.create { completable in
            let killRequest = DronecodeSdk_Rpc_Action_KillRequest()
            
            do {
                let killResponse = try self.service.kill(killRequest)
                if (killResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot kill: \(killResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Send command to *return to the launch* (takeoff) position and *land*.
     
     This switches the drone into [RTL mode](https://docs.px4.io/en/flight_modes/rtl.html) which generally means it will rise up to a certain altitude to clear any obstacles before heading back to the launch (takeoff) position and land there.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func returnToLaunch() -> Completable {
        return Completable.create { completable in
            let rtlRequest = DronecodeSdk_Rpc_Action_ReturnToLaunchRequest()
            
            do {
                let rtlResponse = try self.service.returnToLaunch(rtlRequest)
                if (rtlResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot return to launch: \(rtlResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Send command to transition the drone to fixedwing.
     
     The associated action will only be executed for VTOL vehicles (on other vehicle types the command will fail with an ActionResult). The command will succeed if called when the vehicle is already in fixedwing mode.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func transitionToFixedWing() -> Completable {
        return Completable.create { completable in
            let toFixedWingRequest = DronecodeSdk_Rpc_Action_TransitionToFixedWingRequest()
            
            do {
                let toFixedWingResponse = try self.service.transitionToFixedWing(toFixedWingRequest)
                if (toFixedWingResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot transition to fixed wings: \(toFixedWingResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Send command to transition the drone to multicopter.
     
     The associated action will only be executed for VTOL vehicles (on other vehicle types the command will fail with an ActionResult). The command will succeed if called when the vehicle is already in multicopter mode.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func transitionToMulticopter() -> Completable {
        return Completable.create { completable in
            let toMulticopterRequest = DronecodeSdk_Rpc_Action_TransitionToMulticopterRequest()
            
            do {
                let toMulticopterResponse = try self.service.transitionToMulticopter(toMulticopterRequest)
                if (toMulticopterResponse.actionResult.result == DronecodeSdk_Rpc_Action_ActionResult.Result.success) {
                    completable(.completed)
                } else {
                    completable(.error("Cannot transition to multicopter: \(toMulticopterResponse.actionResult.result)"))
                }
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Get the takeoff altitude.
     
     - Returns: a `Single` containing the altitude relative to ground / takeoff location in meters or an error.
     */
    public func getTakeoffAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let getTakeoffAltitudeRequest = DronecodeSdk_Rpc_Action_GetTakeoffAltitudeRequest()
            
            do {
                let getTakeoffAltitudeResponse = try self.service.getTakeoffAltitude(getTakeoffAltitudeRequest)
                single(.success(getTakeoffAltitudeResponse.altitude))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Set the takeoff altitude.
     
     - Parameter altitude: The altitude relative to ground / takeoff location in meters.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func setTakeoffAltitude(altitude: Float) -> Completable {
        return Completable.create { completable in
            var setTakeoffAltitudeRequest = DronecodeSdk_Rpc_Action_SetTakeoffAltitudeRequest()
            setTakeoffAltitudeRequest.altitude = altitude
            
            do {
                let _ = try self.service.setTakeoffAltitude(setTakeoffAltitudeRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Get the vehicle maximum speed.
     
     - Returns: a `Single` containing the vehicle maximum speed in meters/second or an error.
     */
    public func getMaximumSpeed() -> Single<Float> {
        return Single<Float>.create { single in
            let getMaximumSpeedRequest = DronecodeSdk_Rpc_Action_GetMaximumSpeedRequest()
            
            do {
                let getMaximumSpeedResponse = try self.service.getMaximumSpeed(getMaximumSpeedRequest)
                single(.success(getMaximumSpeedResponse.speed))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
        
    }
    
    /**
     Set vehicle maximum speed.
     
     - Parameter speed: Maximum speed in metres/second.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func setMaximumSpeed(speed: Float) -> Completable {
        return Completable.create { completable in
            var setMaximumSpeedRequest = DronecodeSdk_Rpc_Action_SetMaximumSpeedRequest()
            setMaximumSpeedRequest.speed = speed
            
            do {
                let _ = try self.service.setMaximumSpeed(setMaximumSpeedRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }

            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Get the return to launch minimum return altitude.
     
     - Returns: a `Single` containing the return altitude relative to takeoff location in meters or an error.
     */
    public func getReturnToLaunchAltitude() -> Single<Float> {
        return Single<Float>.create { single in
            let getReturnToLaunchAltitudeRequest = DronecodeSdk_Rpc_Action_GetReturnToLaunchAltitudeRequest()
            
            do {
                let getReturnToLaunchAltitudeResponse = try self.service.getReturnToLaunchAltitude(getReturnToLaunchAltitudeRequest)
                single(.success(getReturnToLaunchAltitudeResponse.relativeAltitudeM))
            } catch {
                single(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
    
    /**
     Set the return to launch minimum return altitude.
     
     - Parameter altitude: Return altitude relative to takeoff location, in meters.
     
     - Returns: a `Completable` indicating success or an error.
     */
    public func setReturnToLaunchAltitude(altitude: Float) -> Completable {
        return Completable.create { completable in
            var setReturnToLaunchRequest = DronecodeSdk_Rpc_Action_SetReturnToLaunchAltitudeRequest()
            setReturnToLaunchRequest.relativeAltitudeM = altitude
            
            do {
                let _ = try self.service.setReturnToLaunchAltitude(setReturnToLaunchRequest)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
        .subscribeOn(scheduler)
        .observeOn(MainScheduler.instance)
    }
}
