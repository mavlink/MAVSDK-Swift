//
//  TelemetryViewController.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 05.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import UIKit
import Dronecode_SDK_Swift
import RxSwift

class TelemetryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var telemetryTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionLabel.text = "Starting system ..."
        
        // Start System
        CoreManager.shared().start()
        
        let coreStatus: Observable<UInt64> = CoreManager.shared().core.getDiscoverObservable()
        _ = coreStatus.subscribe(onNext: { uuid in
            //UUID du drone connected
            print("Drone Discovered with UUID : \(uuid)")
            
                DispatchQueue.main.async { // Correct
                    self.connectionLabel.text = "Drone Discovered with UUID : \(uuid)"
                }
            
            
            }, onError: { error in
            print("Error Discover \(error)")
        })
       /* let coreTimeout: Observable<UInt64> = core.getTimeoutObservable()
        _ = coreStatus.subscribe({  in
            <#code#>
        })*/
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        sleep(5)
        
        let position: Observable<Position> = CoreManager.shared().telemetry.getPositionObservable()
        _ = position.subscribe(onNext: { position in
            //print ("next pos \(position)")
        }, onError: { error in
            print("error telemetry")
        })
        
        let health: Observable<Health> = CoreManager.shared().telemetry.getHealthObservable()
        _ = health.subscribe(onNext: { health in
            print ("next health \(health)")
        }, onError: { error in
            print("error health")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

