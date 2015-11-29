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
    var highScore = 0
    var scoreVal = 0
    
    
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
        var scoreDefault = NSUserDefaults.standardUserDefaults()
        if(scoreDefault.valueForKey("Score") != nil){
            scoreVal = scoreDefault.valueForKey("Score") as! NSInteger!
        }
        
        let scoreMessage = "Your Score : \(scoreVal)"
        
        // 3
        let score = SKLabelNode(fontNamed: "Chalkduster")
        score.text = scoreMessage
        score.fontSize = 40
        score.position = CGPoint(x: size.width/2, y: size.height/2)
        
        
        
        var highScoreDefault = NSUserDefaults.standardUserDefaults()
        if(highScoreDefault.valueForKey("HighScore") != nil){
            highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger!
        }
        
        let hScoreMessage = "High Score : \(highScore)"
        
        // 3
        let hScore = SKLabelNode(fontNamed: "Chalkduster")
        hScore.text = hScoreMessage
        hScore.fontSize = 80
        hScore.position = CGPoint(x: size.width/2, y: size.height/1.5)
        //addChild(hScore)
        
        
        let newHighScore = SKLabelNode(fontNamed: "Chalkduster")
        newHighScore.text = "Your New"
        newHighScore.fontSize = 80
        newHighScore.position = CGPoint(x: size.width/2, y: size.height/1.5)
        if(scoreVal >= highScore){
            hScore.position = CGPoint(x: size.width/2, y: size.height/2)
            addChild(newHighScore)
            addChild(hScore)
        }
        else{
            addChild(hScore)
            addChild(score)
        }
        
        
        // 4
        runAction(SKAction.sequence([
            SKAction.waitForDuration(5.0),
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
