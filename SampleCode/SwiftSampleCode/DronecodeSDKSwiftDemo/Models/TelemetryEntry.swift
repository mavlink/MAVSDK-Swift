//
//  TelemetryEntry.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 24.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation


class TelemetryEntry {
    
    var property: String = ""
    var value: String = ""
    var state : Int = 0
    
    convenience init() {
        self.init(property: "", value: "-", state: 0)
    }

    init(property: String?, value: String?, state: Int?) {
        self.property = property!
        self.value = value!
        self.state = state!
    }
}
