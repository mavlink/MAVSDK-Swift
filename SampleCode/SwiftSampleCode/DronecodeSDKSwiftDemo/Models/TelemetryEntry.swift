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
    
    convenience init() {
        self.init(property: "", value: "-")
    }

    init(property: String?, value: String?) {
        self.property = property!
        self.value = value!
    }
}
