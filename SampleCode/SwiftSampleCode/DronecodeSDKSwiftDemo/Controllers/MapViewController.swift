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

class MapViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - Properties
    
    // MARK: IBOutlets -------
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var uploadMissionButton: UIButton!
    @IBOutlet weak var startMissionButton: UIButton!
    
    @IBOutlet weak var createFlightPathButton: UIButton!
    @IBOutlet weak var centerMapOnUsernButton: UIButton!
    
    // MARK: Location -------
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    let regionRadius: CLLocationDistance = 100
    
    // MARK: Misc -------
    
    private var droneAnnotation: DroneAnnotation!
    private var timer: Timer?
    
    // MARK: Mission -------
    
    private let missionExample:ExampleMission = ExampleMission()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set initial location in Zurich
        let initialLocation = CLLocation(latitude: 47.398039859999997, longitude: 8.5455725400000002)
        centerMapOnLocation(location: initialLocation)
        
        // init text for feedback and add round corner and border
        feedbackLabel.text = "Welcome"
        feedbackLabel.layer.cornerRadius   = UI_CORNER_RADIUS_BUTTONS
        feedbackLabel?.layer.masksToBounds = true
        feedbackLabel?.layer.borderColor = UIColor.lightGray.cgColor
        feedbackLabel?.layer.borderWidth = 1.0
        
        // set corners for buttons
        uploadMissionButton.layer.cornerRadius   = UI_CORNER_RADIUS_BUTTONS
        startMissionButton.layer.cornerRadius    = UI_CORNER_RADIUS_BUTTONS
        createFlightPathButton.layer.cornerRadius    = UI_CORNER_RADIUS_BUTTONS
        centerMapOnUsernButton.layer.cornerRadius    = UI_CORNER_RADIUS_BUTTONS
        
        // location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // init mapview delegate
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        // drone annotation
        mapView.register(DroneView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(DroneView.self))
        droneAnnotation = DroneAnnotation(title: "Drone", coordinate:initialLocation.coordinate)
        mapView.addAnnotation(droneAnnotation)
        
        // timer to get drone state
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector:  #selector(updateDroneInfosDisplayed), userInfo: nil, repeats: true)
        
        // display mission trace
        self.createMissionTrace(mapView: mapView, listMissionsItems: missionExample.missionItems)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IBActions Mission
    
    @IBAction func uploadMissionPressed(_ sender: Any) {
        self.displayFeedback(message:"Upload Mission Pressed")
        
        self.uploadMission()
    }
    
    @IBAction func startMissionPressed(_ sender: Any) {
        self.displayFeedback(message:"Start Mission Pressed")
        
        // /!\ NEED TO ARM BEFORE START THE MISSION
        let armRoutine = CoreManager.shared().action.arm()
            .do(onError: { error in self.displayFeedback(message:"Arming failed")},
                onCompleted: { self.startMission() })
        _ = armRoutine.subscribe()
       
    }
    
    // MARK: - Center
    
    @IBAction func centerOnUserPressed(_ sender: Any) {
        let latitude:String = String(format: "%.4f",
                                     currentLocation!.coordinate.latitude)
        let longitude:String = String(format: "%.4f",
                                      currentLocation!.coordinate.longitude)
        self.displayFeedback(message:"User coordinates (\(latitude),\(longitude))")
        
        centerMapOnLocation(location: currentLocation!)
    }
    
    @IBAction func createFlightPathPressed(_ sender: Any) {
        self.displayFeedback(message:"Create new flightpath Pressed")
    }
    
    // MARK: - Missions
    
    func uploadMission(){
        
        let sendMissionRoutine = CoreManager.shared().mission.uploadMission(missionItems: missionExample.missionItems).do(
            onError: { error in self.displayFeedback(message:"Mission uploaded failed \(error)") },
            onCompleted: { self.displayFeedback(message:"Mission uploaded with success") })
        
        _ = sendMissionRoutine.subscribe()
        
    }
    
    func startMission(){
        let startMissionRoutine = CoreManager.shared().mission.startMission().do(
            onError: { error in self.displayFeedback(message: "Mission started failed \(error)") },
            onCompleted: { self.displayFeedback(message:"Mission started with success") })
        
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
        DispatchQueue.main.async {
            // Update the UI
            self.droneAnnotation.coordinate = CoreManager.shared().droneState.location2D
        }
    }
    
    func displayFeedback(message:String){
        print(message)
        feedbackLabel.text = message
    }
    
     // MARK: - Mission trace
    
    func createMissionTrace(mapView: MKMapView, listMissionsItems : Array<MissionItem>) {
        var points = [CLLocationCoordinate2D]()
        
        for missionItem in listMissionsItems {
            points.append(CLLocationCoordinate2DMake(missionItem.latitudeDeg, missionItem.longitudeDeg))
        }
        
        let missionTrace = MKPolyline(coordinates: points, count: listMissionsItems.count)
        mapView.add(missionTrace)
        
        // add start pin
        let point1 = CustomPointAnnotation(title: "START")
        let missionItem1 = listMissionsItems[0]
        point1.coordinate = CLLocationCoordinate2DMake(missionItem1.latitudeDeg, missionItem1.longitudeDeg)
        mapView.addAnnotation(point1)
        
        // add stop pin
        let point2 = CustomPointAnnotation(title: "STOP")
        let missionItem2 = listMissionsItems[listMissionsItems.count - 1]
        point2.coordinate = CLLocationCoordinate2DMake(missionItem2.latitudeDeg, missionItem2.longitudeDeg)
        mapView.addAnnotation(point2)
        
    }
    
    // MARK: - Location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(annotation is CustomPointAnnotation){
            _ = NSStringFromClass(CustomPinAnnotationView.self)
            let  view :CustomPinAnnotationView = CustomPinAnnotationView(annotation: annotation)
             return view
        }else{
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
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let lineRenderer = MKPolylineRenderer(polyline: polyline)
            lineRenderer.strokeColor = .orange
            lineRenderer.lineWidth = 2.0
            return lineRenderer
        }
        fatalError("Fatal error in mapView MKOverlayRenderer")
    }

}

