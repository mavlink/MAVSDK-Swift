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
    
    // MARK: - Properties
    private var telemetry_entries: TelemetryEntries?
    private var timer: Timer?

    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionLabel.text = "Starting system ..."
        
        // Start System
        CoreManager.shared().start()
        
        // Telemetry entries
        telemetry_entries = TelemetryEntries()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(updateView), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /*let position: Observable<Position> = CoreManager.shared().telemetry.getPositionObservable()
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
        })*/
    }
    
    // MARK: - TableView
    @objc func updateView(_ _timer: Timer?) {
        let entry = telemetry_entries?.entries[EntryType.connection.rawValue]
        if entry != nil {
            connectionLabel.text = entry?.value
        } else {
            connectionLabel.text = entry?.value
        }
        telemetryTableView.reloadData()
    }

    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

