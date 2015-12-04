//
//  MenuScene.swift
//  SpaceRun
//
//  Created by Abhiroop on 20/11/2015.
//  Copyright © 2015 Abhiroop. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var gameLabel : SKLabelNode!
    var playGame : SKLabelNode!
    
    // this method sets the scene displaying all the assets
    override func didMoveToView(view: SKView) {
        
        backgroundColor = UIColor.blackColor()
        
        starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -0.9
        addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 200, y: size.height/2)
        addChild(player)
        
        gameLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameLabel.text = "Space Run"
        gameLabel.position = CGPoint(x: size.width/2 , y: size.height/1.2)
        gameLabel.fontSize = 100
        addChild(gameLabel)
        
        playGame = SKLabelNode(fontNamed: "Chalkduster")
        playGame.text = "Play Game"
        playGame.position = CGPoint(x: size.width/2 , y: size.height/2)
        playGame.fontSize = 60
        addChild(playGame)
    }
    
    // this method changes the scene when play game is touched
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
            if let location = touches.first?.locationInNode(self){
                let touchedNode = nodeAtPoint(location)
                
                // checking the touch for play game
                if touchedNode == playGame{
                    print("touch")
                    let transition = SKTransition.revealWithDirection(.Down, duration: 0.0)
                    let nextScene = GameScene(size:scene!.size)
                    nextScene.scaleMode = .AspectFill
                    scene?.view?.presentScene(nextScene, transition: transition)
            }
        }
    }
}
