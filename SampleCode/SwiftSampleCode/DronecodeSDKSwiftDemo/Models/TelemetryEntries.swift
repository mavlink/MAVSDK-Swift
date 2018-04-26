//
//  TelemetryEntries.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 24.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import RxSwift
import MapKit
import Dronecode_SDK_Swift

enum EntryType : Int {
    case connection = 0
    case health
    case altitude
    case latitude_longitude
    case armed
    case groundspeed
    case battery
    case attitude
    case gps
    case in_air
    case entry_type_max
}

class TelemetryEntries {
    
    var entries = [TelemetryEntry]()
    
    init() {
        // Prepare entries array : index EntryType value TelemetryEntry
        if entries.isEmpty {
            entries = [TelemetryEntry](repeating:TelemetryEntry(), count:10)
            do {
                let entry = TelemetryEntry()
                entry.property = "Connection"
                entry.value = "No Connection";
                entries.insert(entry, at: EntryType.connection.rawValue)
            }
            do {
                let entry = TelemetryEntry()
                entry.property = "Health"
                entries.insert(entry, at: EntryType.health.rawValue)
            }
            do {
                let entry = TelemetryEntry()
                entry.property = "Relative, absolute altitude"
                entries.insert(entry, at: EntryType.altitude.rawValue)
            }
            do {
                let entry = TelemetryEntry()
                entry.property = "Latitude, longitude"
                entries.insert(entry, at: EntryType.latitude_longitude.rawValue)
            }
            
            
        }
        
        //Listen Connection
        let coreStatus: Observable<UInt64> = CoreManager.shared().core.getDiscoverObservable()
        _ = coreStatus.subscribe(onNext: { uuid in
            self.onDiscoverObservable(uuid: uuid)
        }, onError: { error in
            print("Error Discover \(error)")
        })
        
        //Listen Timeout
        let coreTimeout: Observable<Void> = CoreManager.shared().core.getTimeoutObservable()
        _ = coreTimeout.subscribe({Void in self.onTimeoutObservable()})
        
    }
    
    // MARK: -
    func onDiscoverObservable(uuid:UInt64)
    {
        //UUID of connected drone 
        print("Drone Connected with UUID : \(uuid)")
        entries[EntryType.connection.rawValue].value = "Drone Connected with UUID : \(uuid)"
        entries[EntryType.connection.rawValue].state = 1
        
        //Listen Health
        let health: Observable<Health> = CoreManager.shared().telemetry.getHealthObservable()
        _ = health.subscribe(onNext: { health in
            //print ("Next health \(health)")
            self.onHealthUpdate(health: health)
        }, onError: { error in
            print("Error Health")
        })
        
        //Listen Position
        let position: Observable<Position> = CoreManager.shared().telemetry.getPositionObservable()
        _ = position.subscribe(onNext: { position in
            //print ("Next Pos \(position)")
            CoreManager.shared().droneState.location2D = CLLocationCoordinate2DMake(position.latitudeDeg,position.longitudeDeg)
            self.onPositionUpdate(position: position)
        }, onError: { error in
            print("Error telemetry")
        })
    }
    
    func onTimeoutObservable()
    {
        entries[EntryType.connection.rawValue].value = "Not Connected"
        entries[EntryType.connection.rawValue].state = 0
    }
    
    func onHealthUpdate(health:Health)
    {
        entries[EntryType.health.rawValue].value = "Calibration \(health.isAccelerometerCalibrationOk ? "Ready" : "Not OK"), GPS \(health.isLocalPositionOk ? "Ready" : "Acquiring")"
    }
    
    func onPositionUpdate(position:Position)
    {
        entries[EntryType.altitude.rawValue].value = "\(position.relativeAltitudeM) m, \(position.absoluteAltitudeM) m"
        
        entries[EntryType.latitude_longitude.rawValue].value = "\(position.latitudeDeg) Deg, \(position.longitudeDeg) Deg"
    }

}
