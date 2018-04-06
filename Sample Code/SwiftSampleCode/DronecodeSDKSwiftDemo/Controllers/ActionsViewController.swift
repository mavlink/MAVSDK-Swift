//
//  ActionsViewController.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Marjory Silvestre on 06.04.18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import UIKit
import DroneCore_Swift

class ActionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func armPressed(_ sender: Any) {
        print("arm")
       //TODO UNCOMMENT when ready
        /*let action = Action()
        let myRoutine = action.arm()
            .do(onError: { error in ActionsViewController.showAlert("Arming failed", self) },
                onCompleted: { ActionsViewController.showAlert(("Arming succeeded",self) })
        myRoutine.subscribe()*/
    }
    
    @IBAction func takeoffPressed(_ sender: Any) {
        print("takeoff")
        //TODO UNCOMMENT when ready
        /*let action = Action()
         let myRoutine = action.takeoff()
         .do(onError: { error in ActionsViewController.showAlert("Takeoff failed", self) },
         onCompleted: { ActionsViewController.showAlert(("Takeoff succeeded",self) })
         myRoutine.subscribe()*/
    }
    
    @IBAction func landPressed(_ sender: Any) {
        print("land")
        //TODO UNCOMMENT when ready
        /*let action = Action()
         let myRoutine = action.land()
         .do(onError: { error in ActionsViewController.showAlert("Land failed", self) },
         onCompleted: { ActionsViewController.showAlert(("Land succeeded",self) })
         myRoutine.subscribe()*/
    }

    class func showAlert(_ message: String?, viewController: UIViewController?) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true) {() -> Void in }
    }

}


