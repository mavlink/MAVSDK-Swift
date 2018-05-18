//
//  CameraViewController.swift
//  DronecodeSDKSwiftDemo
//
//

import Foundation

import UIKit
import Dronecode_SDK_Swift

class CameraViewController: UIViewController, VLCMediaPlayerDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Setup movieView
        self.cameraView.backgroundColor = UIColor.lightGray
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Play RTSP from web (Bunny Movie as sample)
        //TODO modify to use camera rtsp url
        let url = URL(string: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov")
        
        let media = VLCMedia(url: url!)
        mediaPlayer.media = media
        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.cameraView
        
        //TODO modify this
        mediaPlayer.play()
    }
}
