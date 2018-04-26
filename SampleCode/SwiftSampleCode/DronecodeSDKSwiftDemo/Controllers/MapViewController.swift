//
//  MapViewController.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 05.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import UIKit
import Dronecode_SDK_Swift
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    private var droneAnnotation: DroneAnnotation!
    private var timer: Timer?
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial location in Zurich
        let initialLocation = CLLocation(latitude: 47.398039859999997, longitude: 8.5455725400000002)
        centerMapOnLocation(location: initialLocation)
        
        
        // init mapview delegate
        mapView.delegate = self
        
        // drone annotation
        mapView.register(DroneView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(DroneView.self))
        droneAnnotation = DroneAnnotation(title: "Drone", coordinate:initialLocation.coordinate)
        mapView.addAnnotation(droneAnnotation)
        
        //timer to get drone state
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector:  #selector(updateDroneInfosDisplayed), userInfo: nil, repeats: true)
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
    
    // MARK: - Helper methods
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - DroneState
    @objc func updateDroneInfosDisplayed(_ _timer: Timer?) {
        droneAnnotation.coordinate = CoreManager.shared().droneState.location2D
        //mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? DroneAnnotation else { return nil }
        
        let identifier = NSStringFromClass(DroneView.self)
        var view: DroneView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? DroneView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = DroneView(annotation: annotation, reuseIdentifier: identifier)
        }
        return view
    }

}

