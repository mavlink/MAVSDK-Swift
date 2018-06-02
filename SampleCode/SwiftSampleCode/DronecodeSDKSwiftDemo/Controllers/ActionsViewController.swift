//
//  ActionsViewController.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 06.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import UIKit
import Dronecode_SDK_Swift

let UI_CORNER_RADIUS_BUTTONS = CGFloat(8.0)

class ActionsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var armButton: UIButton!
    @IBOutlet weak var takeoffButton: UIButton!
    @IBOutlet weak var landButton: UIButton!
    @IBOutlet weak var disarmButton: UIButton!
    @IBOutlet weak var killButton: UIButton!
    @IBOutlet weak var returnToLaunchButton: UIButton!
    @IBOutlet weak var transitionToFixedWingButton: UIButton!
    @IBOutlet weak var transitionToMulticopterButton: UIButton!
    @IBOutlet weak var getTakeoffAltitudeButton: UIButton!
    @IBOutlet weak var getMaxSpeedButton: UIButton!
    
    @IBOutlet weak var feedbackLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // init text for feedback and add round corner and border
        feedbackLabel.text = "Welcome"
        feedbackLabel.layer.cornerRadius   = UI_CORNER_RADIUS_BUTTONS
        feedbackLabel?.layer.masksToBounds = true
        feedbackLabel?.layer.borderColor = UIColor.lightGray.cgColor
        feedbackLabel?.layer.borderWidth = 1.0
        
        // set corners for buttons
        armButton.layer.cornerRadius        = UI_CORNER_RADIUS_BUTTONS
        takeoffButton.layer.cornerRadius    = UI_CORNER_RADIUS_BUTTONS
        landButton.layer.cornerRadius       = UI_CORNER_RADIUS_BUTTONS
        disarmButton.layer.cornerRadius     = UI_CORNER_RADIUS_BUTTONS
        killButton.layer.cornerRadius       = UI_CORNER_RADIUS_BUTTONS
        returnToLaunchButton.layer.cornerRadius             = UI_CORNER_RADIUS_BUTTONS
        transitionToFixedWingButton.layer.cornerRadius      = UI_CORNER_RADIUS_BUTTONS
        transitionToMulticopterButton.layer.cornerRadius    = UI_CORNER_RADIUS_BUTTONS
        getTakeoffAltitudeButton.layer.cornerRadius      = UI_CORNER_RADIUS_BUTTONS
        getMaxSpeedButton.layer.cornerRadius    = UI_CORNER_RADIUS_BUTTONS
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func armPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.arm()
            .do(onError: { error in  self.feedbackLabel.text = "Arming failed : \(error.localizedDescription)" },
                onCompleted: {  self.feedbackLabel.text = "Arming succeeded"})
        _ = myRoutine.subscribe()
        
    }
    
    @IBAction func disarmPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.disarm()
            .do(onError: { error in self.feedbackLabel.text = "Disarming failed : \(error.localizedDescription)"  },
                onCompleted: { self.feedbackLabel.text = "Disarming succeeded" })
        _ = myRoutine.subscribe()
        
    }
    
    @IBAction func takeoffPressed(_ sender: Any) {
         let myRoutine = CoreManager.shared().action.takeoff()
         .do(onError: { error in self.feedbackLabel.text = "Takeoff failed" },
         onCompleted: { self.feedbackLabel.text = "Takeoff succeeded" })
         _ = myRoutine.subscribe()
    }
    
    @IBAction func landPressed(_ sender: Any) {
         let myRoutine = CoreManager.shared().action.land()
         .do(onError: { error in self.feedbackLabel.text = "Land failed" },
         onCompleted: { self.feedbackLabel.text = "Land succeeded" })
         _ = myRoutine.subscribe()
    }
    
    @IBAction func killPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.kill()
            .do(onError: { error in self.feedbackLabel.text = "Kill failed"},
                onCompleted: { self.feedbackLabel.text = "Kill succeeded" })
        _ = myRoutine.subscribe()
    }
    
    @IBAction func returnToLaunchPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.returnToLaunch()
            .do(onError: { error in self.feedbackLabel.text = "Return to launch failed" },
                onCompleted: { self.feedbackLabel.text = "Return to launch succeeded"})
        _ = myRoutine.subscribe()
    }
    
    @IBAction func transitionToFixedWingPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.transitionToFixedWing()
            .do(onError: { error in self.feedbackLabel.text = "transitionToFixedWing failed"},
                onCompleted: { self.feedbackLabel.text = "transitionToFixedWing succeeded"})
        _ = myRoutine.subscribe()
    }
    
    @IBAction func transitionToMulticopterPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.transitionToMulticopter()
            .do(onError: { error in self.feedbackLabel.text = "transitionToMulticopter failed"},
                onCompleted: { self.feedbackLabel.text = "transitionToMulticopter succeeded"})
        _ = myRoutine.subscribe()
    }
    
    @IBAction func getTakeoffAltitudePressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.getTakeoffAltitude()
        _ = myRoutine.subscribe{ event in
            switch event {
            case .success(let altitude):
                self.feedbackLabel.text = "Takeoff altitude : \(altitude)"
                break
            case .error(let error):
                self.feedbackLabel.text = "failure: getTakeoffAltitude() \(error)"
            }
        }
    }
    
    @IBAction func getMaximumSpeedPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.getMaximumSpeed()
        _ = myRoutine.subscribe{ event in
            switch event {
            case .success(let maxSpeed):
                self.feedbackLabel.text = "Maximum speed : \(maxSpeed)"
                break
            case .error(let error):
                self.feedbackLabel.text = "failure: getMaximumSpeed() \(error)"
            }
        }
    }

    class func showAlert(_ message: String?, viewController: UIViewController?) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true) {() -> Void in }
    }

}


