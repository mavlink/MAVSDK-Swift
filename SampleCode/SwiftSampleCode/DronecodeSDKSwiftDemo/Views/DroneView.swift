//
//  DroneView.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 26.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import MapKit

class DroneView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        
        willSet {

            calloutOffset = CGPoint(x: -5, y: 5)
     
            image = UIImage(named: "annotation-drone")
            
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = "drone"
            detailCalloutAccessoryView = detailLabel
        }
    }
    
}

