//
//  ExampleMission.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 26.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation
import Dronecode_SDK_Swift


class ExampleMission {
    
    var missionItems = [MissionItem]()

    init(){
        
        if missionItems.isEmpty {
            missionItems = [MissionItem]()
            
            do {
                let entry = MissionItem(latitudeDeg: 47.398039859999997, longitudeDeg: 8.5455725400000002, relativeAltitudeM: 10.0, speedMPS: 2.0, isFlyThrough: true, gimbalPitchDeg: -60.0, gimbalYawDeg: -90.0, cameraAction: CameraAction.startPhotoInterval)
                missionItems.append(entry)
            }
            do {
                let entry = MissionItem(latitudeDeg: 47.398039859999997, longitudeDeg: 8.5455725400000002, relativeAltitudeM: 10.0, speedMPS: 2.0, isFlyThrough: true, gimbalPitchDeg: -60.0, gimbalYawDeg: -90.0, cameraAction: CameraAction.startPhotoInterval)
                missionItems.append(entry)
            }
            do {
                let entry = MissionItem(latitudeDeg: 47.398039859999997, longitudeDeg: 8.5455725400000002, relativeAltitudeM: 10.0, speedMPS: 10.0, isFlyThrough: true, gimbalPitchDeg: -60.0, gimbalYawDeg: -90.0, cameraAction: CameraAction.startPhotoInterval)
                missionItems.append(entry)
            }
            do {
                let entry = MissionItem(latitudeDeg: 47.398036222362471, longitudeDeg: 8.5450146439425509, relativeAltitudeM: 10.0, speedMPS: 10.0, isFlyThrough: true, gimbalPitchDeg: -30.0, gimbalYawDeg: 0, cameraAction: CameraAction.stopPhotoInterval)
                missionItems.append(entry)
            }
            do {
                let entry = MissionItem(latitudeDeg: 47.397825620791885, longitudeDeg: 8.5450092830163271, relativeAltitudeM: 10.0, speedMPS: 10.0, isFlyThrough: true, gimbalPitchDeg: -60.0, gimbalYawDeg: -60.0, cameraAction: CameraAction.startVideo)
                missionItems.append(entry)
            }
            do {
                let entry = MissionItem(latitudeDeg: 47.397832880000003, longitudeDeg: 8.5455939999999995, relativeAltitudeM: 10.0, speedMPS: 10.0, isFlyThrough: true, gimbalPitchDeg: 0.0, gimbalYawDeg: 0.0, cameraAction: CameraAction.stopVideo)
                missionItems.append(entry)
            }
        }
        
    }

}
