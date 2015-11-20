//
//  MenuScene.swift
//  SpaceRun
//
//  Created by 20061667 on 20/11/2015.
//  Copyright © 2015 Abhiroop007. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "play")
    
    override func didMoveToView(view: SKView) {
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPointMake(frame.midX, frame.midY)
        self.addChild(playButton)
        
        
        func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
            
            
            if let touch = touches.first as? UITouch {
                let pos = touch.locationInNode(self)
                let node = self.nodeAtPoint(pos)
                
                if node == playButton {
                    //if let sview = view {
                        let scene = GameScene(fileNamed:"GameScene") as GameScene?
                        scene!.scaleMode = SKSceneScaleMode.AspectFill
                        view.presentScene(scene)
                    //}
                }   
            }
        }
    }
}
