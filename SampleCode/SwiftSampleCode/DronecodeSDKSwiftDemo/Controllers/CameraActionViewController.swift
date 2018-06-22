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
    @IBOutlet weak var videoLabel: UIButton!
    @IBOutlet weak var photoIntervalLabel: UIButton!
    
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
    
    @IBAction func videoAction(_ sender: UIButton) {
        if(videoLabel.titleLabel?.text == "Start Video") {
            let myRoutine = CoreManager.shared().camera.startVideo()
                .do(onError: { error in self.feedbackLabel.text = "Start Video Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Start Video Success"
                        self.videoLabel.setTitle("Stop Video", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
            
        else {
            let myRoutine = CoreManager.shared().camera.stopVideo()
                .do(onError: { error in self.feedbackLabel.text = "Stop Video Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Stop Video Success"
                        self.videoLabel.setTitle("Start Video", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
        
    }
    
    @IBAction func photoIntervalAction(_ sender: UIButton) {
        let intervalTimeS = 3
        if(photoIntervalLabel.titleLabel?.text == "Start Photo Interval") {
            let myRoutine = CoreManager.shared().camera.startPhotoInteval(interval: Float(intervalTimeS))
                .do(onError: { error in self.feedbackLabel.text = "Start Photo Interval Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Start Photo Interval Success"
                        self.photoIntervalLabel.setTitle("Stop Photo Interval", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
        else {
            let myRoutine = CoreManager.shared().camera.stopPhotoInterval()
                .do(onError: { error in self.feedbackLabel.text = "Stop Photo Interval Failed : \(error.localizedDescription)" },
                    onCompleted: {
                        self.feedbackLabel.text = "Stop Photo Interval Success"
                        self.photoIntervalLabel.setTitle("Start Photo Interval", for: .normal)
                })
            _ = myRoutine.subscribe()
        }
        
    }
    
    @IBAction func setPhotoMode(_ sender: UIButton) {
        let myRoutine = CoreManager.shared().camera.setMode(mode: CameraMode.photo)
            .do(onError: { error in self.feedbackLabel.text = "Set Photo Mode Failed : \(error.localizedDescription)" },
                onCompleted: {  self.feedbackLabel.text = "Set Photo Mode Success" })
        _ = myRoutine.subscribe()
    }
    
    @IBAction func setVideoMode(_ sender: UIButton) {
        let myRoutine = CoreManager.shared().camera.setMode(mode: CameraMode.video)
            .do(onError: { error in self.feedbackLabel.text = "Set Video Mode Failed : \(error.localizedDescription)" },
                onCompleted: {  self.feedbackLabel.text = "Set Video Mode Success" })
        _ = myRoutine.subscribe()
    }
    
    class func showAlert(_ message: String?, viewController: UIViewController?) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true) {() -> Void in }
    }
    
}
