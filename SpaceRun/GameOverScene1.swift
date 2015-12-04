//
//  GameOverScene1.swift
//  SpaceRun
//
//  Created by Abhiroop on 30/11/2015.
//  Copyright © 2015 Abhiroop. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene1: SKScene {
    
    var starfield: SKEmitterNode!
    var hScoreVal   = 0
    var scoreVal    = 0
    
    // this method sets the scene displaying all the assets
    override func didMoveToView(view: SKView) {
        
        starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -0.9
        
        backgroundColor = SKColor.blackColor()
        
        // bringing in the score data
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        if(scoreDefault.valueForKey("Score") != nil){
            scoreVal = scoreDefault.valueForKey("Score") as! NSInteger!
        }
        
        // setting the score
        let scoreMessage = "Your Score : \(scoreVal)"
        let score = SKLabelNode(fontNamed: "Chalkduster")
        score.text = scoreMessage
        score.fontSize = 40
        score.position = CGPoint(x: size.width/2, y: size.height/2)
        
        // bringing in HighScore data
        var hScoreDefault = NSUserDefaults.standardUserDefaults()
        if(hScoreDefault.valueForKey("HighScore") != nil){
            hScoreVal = scoreDefault.valueForKey("HighScore") as! NSInteger!
        }
        
        // setting the highScore
        let hScoreMessage = "High Score : \(hScoreVal)"
        let hScore = SKLabelNode(fontNamed: "Chalkduster")
        hScore.text = hScoreMessage
        hScore.fontSize = 80
        hScore.position = CGPoint(x: size.width/2, y: size.height/1.5)
        
        // setting the new HighScore
        let newHScore = SKLabelNode(fontNamed: "Chalkduster")
        newHScore.text = "Your New"
        newHScore.fontSize = 80
        newHScore.position = CGPoint(x: size.width/2, y: size.height/1.5)
        
        // checking for a new HighScore and displaying accordingly
        if(scoreVal >= hScoreVal){
            hScore.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(newHScore)
            addChild(hScore)
        } else{
            addChild(hScore)
            addChild(score)
        }
        
        // changing the scene back to menu
        runAction(SKAction.sequence([
            // putting a delay to transit to menu scene
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = MenuScene(size:self.scene!.size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
}


