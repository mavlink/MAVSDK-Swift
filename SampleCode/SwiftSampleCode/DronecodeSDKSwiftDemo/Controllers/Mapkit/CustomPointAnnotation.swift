//
//  CustomPointAnnotation.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 31.05.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import UIKit
import MapKit

class CustomPointAnnotation: MKPointAnnotation {

    var labelTitle: String 
    
    init(title: String) {
        self.labelTitle = title
    }
}
