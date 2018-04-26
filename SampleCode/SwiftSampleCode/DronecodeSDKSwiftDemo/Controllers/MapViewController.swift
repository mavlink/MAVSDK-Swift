//
//  MapViewController.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 05.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import UIKit
import Dronecode_SDK_Swift

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IBActions Mission
    @IBAction func sendMissionPressed(_ sender: Any) {
        print("Send Mission Pressed")
        
        self.uploadMission()
    }
    
    @IBAction func startMissionPressed(_ sender: Any) {
        print("Start Mission Pressed")
        
        // /!\ NEED TO ARM BEFORE START THE MISSION
        let armRoutine = CoreManager.shared().action.arm()
            .do(onError: { error in print("Arming failed")},
                onCompleted: { self.startMission() })
        _ = armRoutine.subscribe()
       
    }
    
    @IBAction func pauseMissionPressed(_ sender: Any) {
        print("Pause Mission Pressed")
    }
    
    // MARK: - Missions
    func uploadMission(){
        let missionExample:ExampleMission = ExampleMission()
        let sendMissionRoutine = CoreManager.shared().mission.uploadMission(missionItems: missionExample.missionItems).do(
            onError: { error in print("Mission uploaded failed \(error)") },
            onCompleted: { print("Mission uploaded with success") })
        
        _ = sendMissionRoutine.subscribe()
        
    }
    
    func startMission(){
        let startMissionRoutine = CoreManager.shared().mission.startMission().do(
            onError: { error in print("Mission started failed \(error)") },
            onCompleted: { print("Mission started with success") })
        
        _ = startMissionRoutine.subscribe()
    }
    

}
