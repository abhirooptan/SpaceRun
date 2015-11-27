//
//  GameViewController.swift
//  SpaceRun
//
//  Created by Abhiroop007 on 20/11/2015.
//  Copyright (c) 2015 Abhiroop007. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer?
    var score           : Int = 0
    var lives           : Int = 3
    var objectSpawnRate : Double = 1.0
    
    
    func playAudio(file:NSString)-> AVAudioPlayer {
        
        let soundFileURL = NSBundle.mainBundle().URLForResource(file as String,
            withExtension:"wav")
        
        do{
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL!)
        } catch{
            print("File not found")
        }
        
        return audioPlayer!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = MenuScene(fileNamed:"MenuScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}