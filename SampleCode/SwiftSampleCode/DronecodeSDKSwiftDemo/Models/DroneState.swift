//
//  DroneState.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 26.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import MapKit

class DroneState: NSObject{
    
    var location2D: CLLocationCoordinate2D
    
    override init(){
        self.location2D = CLLocationCoordinate2DMake(0, 0);
    }
}
