//
//  GameScene.swift
//  SpaceRun
//
//  Created by Abhiroop on 20/11/2015.
//  Copyright © 2015 Abhiroop. All rights reserved.
//

// i have used the Hackingwithswift.com tutorials to build this game scene

import GameplayKit
import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var possibleEnemies = ["asteroid-5", "asteroid-2", "asteroid-3"]
    var gameTimer: NSTimer!
    var isDead = false
    
    var objectSpawnRate : Double! = 1.0
    
    var highScore = 0
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var line: SKLabelNode!  // a line to distinguish between gameplay area and user info area
    
    var playButton = SKSpriteNode  ()
    let playButtonTex = SKTexture(imageNamed: "playB")
    
    var pauseButton = SKSpriteNode  ()
    let pauseButtonTex = SKTexture(imageNamed: "pauseB")
    var pauseLabel : SKLabelNode!
    
    var explosionSound  : AVAudioPlayer = GameViewController().playAudio("explosion")
    
    override func didMoveToView(view: SKView) {
        
        // setting the scene
        backgroundColor = UIColor.blackColor()
        
        starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        starfield.position = CGPoint(x: 1024, y: 370)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -0.9
        addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 200, y: size.height/2)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody!.contactTestBitMask = 1
        player.zPosition = -0.9
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: size.width/4 , y: size.height/1.11)
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.fontSize = 70
        addChild(scoreLabel)
        
        pauseLabel = SKLabelNode(fontNamed: "Chalkduster")
        pauseLabel.text = "Game Paused"
        pauseLabel.position = CGPoint(x: size.width/2 , y: size.height/2)
        pauseLabel.fontSize = 80
        addChild(pauseLabel)
        
        line = SKLabelNode(fontNamed: "Chalkduster")
        line.text = "_________________________________________"
        line.position = CGPoint(x: size.width/2.8 , y: size.height/1.17)
        line.fontSize = 60
        addChild(line)
        
        pauseButton = SKSpriteNode(texture: pauseButtonTex)
        pauseButton.position = CGPoint(x: size.width/1.1, y: size.height/1.08)
        addChild(pauseButton)
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: size.width/1.1, y: size.height/1.08)
        addChild(playButton)
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(objectSpawnRate, target: self, selector: Selector("createEnemy:"), userInfo: nil, repeats: true)
        
        // loading back the stored high score if exist
        let highScoreDefault = NSUserDefaults.standardUserDefaults()
        if(highScoreDefault.valueForKey("HighScore") != nil){
            highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger!
        }
    }
    
    // this method is responsible for all the updates in the game
    override func update(currentTime: CFTimeInterval) {
        
        // removing all the objects out of sight
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        // checking if the game is paused
        if(physicsWorld.speed == 0){
            playButton.hidden = false
            pauseLabel.hidden = false
            pauseButton.hidden = true
        }
        else{
            playButton.hidden = true
            pauseLabel.hidden = true
            pauseButton.hidden = false
            
            // add score every frame if still playing
            if !isDead {
                score += 1
                
                // checking for a new high score
                if(score > highScore){
                    highScore = score
                    
                    // saving the new high score
                    let highScoreDefault = NSUserDefaults.standardUserDefaults()
                    highScoreDefault.setValue(highScore, forKey: "HighScore")
                    highScoreDefault.synchronize()
                }
                let scoreDefault = NSUserDefaults.standardUserDefaults()
                scoreDefault.setValue(score, forKey: "Score")
                scoreDefault.synchronize()
            }
            // restart on game over
            else{
                let seconds = 2.0
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                let transition = SKTransition.revealWithDirection(.Left, duration: 0.0)
                let nextScene = GameOverScene1(size:scene!.size)
                nextScene.scaleMode = .AspectFill
                
                // putting a delay of 2 seconds before moving to game over scene
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.scene?.view?.presentScene(nextScene, transition: transition)
                })
                
            }
            
            // increasing the speed of the asteroids generated
            if(objectSpawnRate > 0.5){
                objectSpawnRate = 1.0 - Double(score/100)/10
            }
            // adding a new object
            if(objectSpawnRate == 0.6){
                if(possibleEnemies.count == 3){
                    possibleEnemies.append("asteroid-4")
                }
            }
        }
    }
    
    // this method creates randomly spawning asteroids
    func createEnemy(timer: NSTimer) {
        
        // loading a random enemy from the enemy list
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(possibleEnemies) as! [String]
        let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 590)
        
        let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        sprite.zPosition = -0.5
        
        // adding the asteroid to the scene if the game is not paused
        if(physicsWorld.speed != 0){
            addChild(sprite)
        }
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        // this updates the speed of the asteroids spawned
        timer.fireDate = timer.fireDate.dateByAddingTimeInterval(objectSpawnRate)
    }
    
    // this method is responsible for the movement of the player
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.locationInNode(self)
        
        // clamp the y axis
        if location.y < 50 {
            location.y = 50
        } else if location.y > 610 {
            location.y = 610
        }
        
        // clamp the x axis
        if location.x < 100 {
            location.x = 100
        } else if location.x > 900 {
            location.x = 900
        }
        
        player.position = location
    }
    
    // this method is responsible for play and pause feature of the game
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let location = touches.first?.locationInNode(self){
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode == playButton{
                print("play")
                self.physicsWorld.speed = 1
                playButton.hidden = true
                pauseLabel.hidden = true
                pauseButton.hidden = false
            }
            if touchedNode == pauseButton{
                print("pause")
                self.physicsWorld.speed = 0
                playButton.hidden = false
                pauseLabel.hidden = false
                pauseButton.hidden = true
            }
        }
    }
    
    // this method is responsible for detecting collision
    func didBeginContact(contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion.sks")!
        explosion.position = player.position
        addChild(explosion)
        
        explosionSound.prepareToPlay()
        explosionSound.play()
        explosionSound.numberOfLoops = 0
        
        player.removeFromParent()
        
        isDead = true
    }
}
