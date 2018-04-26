//
//  DroneAnnotation.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 26.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import MapKit

class DroneAnnotation: NSObject, MKAnnotation {

    let title: String?
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    /*func setCoordinate(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }*/

}
