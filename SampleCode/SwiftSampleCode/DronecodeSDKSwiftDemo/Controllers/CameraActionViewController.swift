//
//  CameraActionViewController.swift
//  DronecodeSDKSwiftDemo
//
//  Created by Sushma Sathyanarayana on 6/21/18.
//  Copyright © 2018 Marjory Silvestre. All rights reserved.
//

import Foundation

import UIKit
import Dronecode_SDK_Swift

class CameraActionViewController: UIViewController {
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init text for feedback and add round corner and border
        feedbackLabel.text = "Welcome"
        feedbackLabel.layer.cornerRadius   = UI_CORNER_RADIUS_BUTTONS
        feedbackLabel?.layer.masksToBounds = true
        feedbackLabel?.layer.borderColor = UIColor.lightGray.cgColor
        feedbackLabel?.layer.borderWidth = 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func capturePicture(_ sender: UIButton) {
        let myRoutine = CoreManager.shared().camera.takePhoto()
            .do(onError: { error in self.feedbackLabel.text = "Photo Capture Failed : \(error.localizedDescription)" },
                onCompleted: { self.feedbackLabel.text = "Photo Capture Success" })
        _ = myRoutine.subscribe()
    }
    
    @IBAction func startVideo(_ sender: UIButton) {
        let myRoutine = CoreManager.shared().camera.startVideo()
            .do(onError: { error in self.feedbackLabel.text = "Start Video Failed : \(error.localizedDescription)" },
                onCompleted: {  self.feedbackLabel.text = "Start Video Success" })
        _ = myRoutine.subscribe()
    }
    
    @IBAction func startPhotoInterval(_ sender: UIButton) {
        let intervalTimeS = 3
        let myRoutine = CoreManager.shared().camera.startPhotoInteval(interval: Float(intervalTimeS))
            .do(onError: { error in self.feedbackLabel.text = "Start Photo Interval Failed : \(error.localizedDescription)" },
                onCompleted: {  self.feedbackLabel.text = "Start Photo Interval Success" })
        _ = myRoutine.subscribe()
    }
    
    class func showAlert(_ message: String?, viewController: UIViewController?) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true) {() -> Void in }
    }
    
}
