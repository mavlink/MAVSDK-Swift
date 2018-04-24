//
//  TelemetryEntries.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 24.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import RxSwift

enum EntryType : Int {
    case altitude = 0
    case latitude_longitude
    case groundspeed
    case battery
    case attitude
    case gps
    case in_air
    case armed
    case health
    case connection
    case entry_type_max
}

class TelemetryEntries {
    
    var entries = [TelemetryEntry]()
    
    init() {
        // Prepare entries array : index EntryType value TelemetryEntry
        if entries.isEmpty {
            entries = [TelemetryEntry](repeating:TelemetryEntry(), count:10)
            entries.reserveCapacity(10)
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
            do {
                let entry = TelemetryEntry()
                entry.property = "Health"
                print("value health \(EntryType.health.rawValue)")
                entries.insert(entry, at: EntryType.health.rawValue)
            }
            do {
                let entry = TelemetryEntry()
                entry.property = "Connection"
                entry.value = "No Connection";
                entries.insert(entry, at: EntryType.connection.rawValue)
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
    
    func onDiscoverObservable(uuid:UInt64)
    {
        //UUID of connected drone 
        print("Drone Connected with UUID : \(uuid)")
        entries[EntryType.connection.rawValue].value = "Drone Connected with UUID : \(uuid)"
    }
    
    func onTimeoutObservable()
    {
        //UUID of connected drone
        print("Timeout Core")
        entries[EntryType.connection.rawValue].value = "Not Connected"
    }

}
