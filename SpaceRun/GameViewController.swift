//
//  GameViewController.swift
//  SpaceRun
//
//  Created by Abhiroop on 20/11/2015.
//  Copyright (c) 2015 Abhiroop. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer?
    var starfield : SKEmitterNode!
    
    // function to set the audio file
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
    
    // this method loads the menu scene and plays the background music
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the background music
        var backgroundMusic : AVAudioPlayer = playAudio("backgroundMusic")
        backgroundMusic.prepareToPlay()
        backgroundMusic.play()
        backgroundMusic.numberOfLoops = -1
        
        // loading the Menu Scene
        if let scene = MenuScene(fileNamed:"MenuScene") {
            // Configure the view.
            let skView              = self.view as! SKView
            skView.showsFPS         = false
            skView.showsNodeCount   = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode         = .AspectFill
            
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