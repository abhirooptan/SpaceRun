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
        
        var background = SKSpriteNode(imageNamed: "background2")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = .zero
        addChild(background)
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPointMake(frame.midX, frame.midY)
        self.addChild(playButton)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
            if let location = touches.first?.locationInNode(self){
                let touchedNode = nodeAtPoint(location)
    
                if touchedNode == playButton{
                    print("touch")
                    let transition = SKTransition.revealWithDirection(.Down, duration: 1.0)
                    let nextScene = GameScene(size:scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
}
