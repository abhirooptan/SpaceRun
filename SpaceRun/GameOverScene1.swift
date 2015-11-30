//
//  GameOverScene1.swift
//  SpaceRun
//
//  Created by 20061667 on 30/11/2015.
//  Copyright © 2015 Abhiroop007. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene1: SKScene {
    
    var starfield: SKEmitterNode!
    var hScoreVal   = 0
    var scoreVal    = 0
    
    override func didMoveToView(view: SKView) {
        
        starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -0.9
        
        backgroundColor = SKColor.blackColor()
        
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        if(scoreDefault.valueForKey("Score") != nil){
            scoreVal = scoreDefault.valueForKey("Score") as! NSInteger!
        }
        
        let scoreMessage = "Your Score : \(scoreVal)"
        
        let score = SKLabelNode(fontNamed: "Chalkduster")
        score.text = scoreMessage
        score.fontSize = 40
        score.position = CGPoint(x: size.width/2, y: size.height/2)
        
        
        var hScoreDefault = NSUserDefaults.standardUserDefaults()
        if(hScoreDefault.valueForKey("HighScore") != nil){
            hScoreVal = scoreDefault.valueForKey("HighScore") as! NSInteger!
        }
        
        let hScoreMessage = "High Score : \(hScoreVal)"
        
        let hScore = SKLabelNode(fontNamed: "Chalkduster")
        hScore.text = hScoreMessage
        hScore.fontSize = 80
        hScore.position = CGPoint(x: size.width/2, y: size.height/1.5)
        
        let newHScore = SKLabelNode(fontNamed: "Chalkduster")
        newHScore.text = "Your New"
        newHScore.fontSize = 80
        newHScore.position = CGPoint(x: size.width/2, y: size.height/1.5)
        if(scoreVal >= hScoreVal){
            hScore.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(newHScore)
            addChild(hScore)
        } else{
            addChild(hScore)
            addChild(score)
        }
        
        // 4
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                // 5
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = MenuScene(size:self.scene!.size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
}


