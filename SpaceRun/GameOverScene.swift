//
//  GameOverScene.swift
//  SpaceRun
//
//  Created by Nakul on 23/11/2015.
//  Copyright © 2015 Abhiroop007. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var starfield: SKEmitterNode!
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        //var gameScene:GameScene
        starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        // 1
        backgroundColor = SKColor.blackColor()
        
        // 2
        
        let message = "Your Score : "
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        //label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/3, y: size.height/2)
        addChild(label)
        
        
        // 4
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                // 5
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
