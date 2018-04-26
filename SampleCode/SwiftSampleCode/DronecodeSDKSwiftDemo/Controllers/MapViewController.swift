//
//  MapViewController.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 05.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IBActions
    @IBAction func sendMissionPressed(_ sender: Any) {
        print("Send Mission Pressed")
    }
    
    @IBAction func startMissionPressed(_ sender: Any) {
        print("Start Mission Pressed")
    }
    
    @IBAction func pauseMissionPressed(_ sender: Any) {
        print("Pause Mission Pressed")
    }

}
