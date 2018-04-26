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

class TelemetryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

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
        
        //TableView set datasource and delegate
        self.telemetryTableView.delegate = self
        self.telemetryTableView.dataSource = self
        
        // Start System
        CoreManager.shared().start()
        
        // Telemetry entries
        telemetry_entries = TelemetryEntries()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:  #selector(updateView), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    // MARK: - TableView
    @objc func updateView(_ _timer: Timer?) {
        let entry = telemetry_entries?.entries[EntryType.connection.rawValue]
        if entry != nil {
            connectionLabel.text = entry?.state == 1 ? "Connected" : "Disconnected"
        } else {
            connectionLabel.text = "No information about connection"
        }
        telemetryTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return telemetry_entries!.entries.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TelemetryCell", for: indexPath)
        
        let count_entries : Int = (telemetry_entries?.entries.count)!
        if (count_entries > 0) {
            if let entry = telemetry_entries?.entries[indexPath.row] {
                cell.textLabel?.text = entry.value;
                cell.detailTextLabel?.text = entry.property;
            }
        }
        
        return cell
    }

    // MARK: -
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

