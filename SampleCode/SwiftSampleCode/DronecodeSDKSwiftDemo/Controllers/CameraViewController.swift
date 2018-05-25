//
//  CameraViewController.swift
//  DronecodeSDKSwiftDemo
//
//

import Foundation

import UIKit
import Dronecode_SDK_Swift

class CameraViewController: UIViewController{
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var video: RTSPPlayer = createRTSPVideo()
    
    //var video:RTSPPlayer? = nil
    
    var lastFrameTime : Float = 0
    var nextFrameTimer : Timer? = nil
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.playVideo()
    }
    
    func createRTSPVideo()-> RTSPPlayer{
        let player :RTSPPlayer = RTSPPlayer(video: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_175k.mov", usesTcp: false)
        player.outputWidth = 426;
        player.outputHeight = 320;
        
        print("video duration: \(String(describing: player.duration))");
        print("video size: \(String(describing: player.sourceWidth)) x \(String(describing: player.sourceHeight))");
        
        return player
    }
    
    func playVideo(){
        
        lastFrameTime = -1;
        
        // seek to 0.0 seconds
        video.seekTime(0)
        
        nextFrameTimer?.invalidate()
        nextFrameTimer = Timer.scheduledTimer(timeInterval: 1.0 / 30, target: self, selector: #selector(displayNextFrame), userInfo: nil, repeats: true)
        
    }
    
    // MARK: - Frames ((A)*(1.0-C)+(B)*C)
    func LERP(valA: Double, valB: Double, valC: Double) -> Double {
        return (valA) * (1.0 - valC) + Double(valB * valC)
    }
    
    @objc func displayNextFrame(_ timer: Timer?) {
        let startTime: TimeInterval = Date.timeIntervalSinceReferenceDate
        if !(video.stepFrame()) {
            timer?.invalidate()
            //playButton.enabled = true
            return
        }
        imageView.image = video.currentImage
        let frameTime: Float = Float(1.0 / (Date.timeIntervalSinceReferenceDate - startTime))
        if lastFrameTime < 0 {
            lastFrameTime = frameTime
        } else {
            lastFrameTime = Float(LERP(valA: Double(frameTime), valB: Double(lastFrameTime), valC: 0.8))
        }
        //label.text = String(format: "%.0f", lastFrameTime)
    }
    
}
