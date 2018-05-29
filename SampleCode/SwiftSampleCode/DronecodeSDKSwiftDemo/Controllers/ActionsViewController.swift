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

    override func viewDidLoad() {
        super.viewDidLoad()

        // set corners for buttons
        armButton.layer.cornerRadius        = UI_CORNER_RADIUS_BUTTONS
        takeoffButton.layer.cornerRadius    = UI_CORNER_RADIUS_BUTTONS
        landButton.layer.cornerRadius       = UI_CORNER_RADIUS_BUTTONS
        disarmButton.layer.cornerRadius     = UI_CORNER_RADIUS_BUTTONS
        killButton.layer.cornerRadius       = UI_CORNER_RADIUS_BUTTONS
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func armPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.arm()
            .do(onError: { error in ActionsViewController.showAlert("Arming failed : \(error.localizedDescription)", viewController:self) },
                onCompleted: { ActionsViewController.showAlert("Arming succeeded",viewController:self) })
        _ = myRoutine.subscribe()
        
    }
    
    @IBAction func disarmPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.disarm()
            .do(onError: { error in ActionsViewController.showAlert("Disarming failed : \(error.localizedDescription)", viewController:self) },
                onCompleted: { ActionsViewController.showAlert("Disarming succeeded",viewController:self) })
        _ = myRoutine.subscribe()
        
    }
    
    @IBAction func takeoffPressed(_ sender: Any) {
         let myRoutine = CoreManager.shared().action.takeoff()
         .do(onError: { error in ActionsViewController.showAlert("Takeoff failed", viewController:self) },
         onCompleted: { ActionsViewController.showAlert("Takeoff succeeded",viewController:self) })
         _ = myRoutine.subscribe()
    }
    
    @IBAction func landPressed(_ sender: Any) {
         let myRoutine = CoreManager.shared().action.land()
         .do(onError: { error in ActionsViewController.showAlert("Land failed", viewController:self) },
         onCompleted: { ActionsViewController.showAlert("Land succeeded", viewController:self) })
         _ = myRoutine.subscribe()
    }
    
    @IBAction func killPressed(_ sender: Any) {
        let myRoutine = CoreManager.shared().action.kill()
            .do(onError: { error in ActionsViewController.showAlert("Kill failed", viewController:self) },
                onCompleted: { ActionsViewController.showAlert("Kill succeeded", viewController:self) })
        _ = myRoutine.subscribe()
    }

    class func showAlert(_ message: String?, viewController: UIViewController?) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true) {() -> Void in }
    }

}


