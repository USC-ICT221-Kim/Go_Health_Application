//
//  ViewController.swift
//  Go_Health_Application
//
//  Created by Donghyun kim on 1/10/19.
//  Copyright © 2019 Donghyun kim. All rights reserved.
//

import UIKit
import AVKit
import Firebase

class ViewController: UIViewController {

    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
//    var ref:FIRDatabaseReference!
    
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up video on BG
        setUpVideo()
        
    }
    
    func setUpElements(){
        
        Utilities.styleFilledButton(singUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    
    func setUpVideo(){
     
        // Get bundle
        let bundlePath = Bundle.main.path(forResource: "Bmainpage", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        // Create URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        // Create video player item
        let item = AVPlayerItem(url: url)
        
        // Create player
        videoPlayer = AVPlayer(playerItem: item)
        // Create player Layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
//         Adjust size and frame
        
        // Todo: Player the video again whenever it reaches the end
        videoPlayerLayer?.frame = CGRect(x:
            -self.view.frame.size.width*1.5, y: 0, width:
            self.view.frame.size.width*4, height:
            self.view.frame.size.height)
//        videoPlayerLayer?.frame = CGRect(x: 0, y: 0, width:
//            self.view.frame.size.width, height:
//            self.view.frame.size.width)
        
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Displayer and player it
        videoPlayer?.playImmediately(atRate: 1)
    }

}

