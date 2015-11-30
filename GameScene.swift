//
//  GameScene.swift
//  SpaceRun
//
//  Created by Abhiroop007 on 20/11/2015.
//  Copyright © 2015 Abhiroop007. All rights reserved.
//

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
    
    var playButton = SKSpriteNode  ()
    let playButtonTex = SKTexture(imageNamed: "playB")
    
    var pauseButton = SKSpriteNode  ()
    let pauseButtonTex = SKTexture(imageNamed: "pauseB")
    var pauseLabel : SKLabelNode!
    
    var explosionSound  : AVAudioPlayer = GameViewController().playAudio("explosion")
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        
        starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        starfield.position = CGPoint(x: 1024, y: 280)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        addChild(starfield)
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 200, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody!.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: size.width/2.8 , y: size.height/1.11)
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.fontSize = 60
        addChild(scoreLabel)
        
        pauseLabel = SKLabelNode(fontNamed: "Chalkduster")
        pauseLabel.text = "Game Paused"
        pauseLabel.position = CGPoint(x: size.width/2 , y: size.height/2)
        pauseLabel.fontSize = 80
        addChild(pauseLabel)
        
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
        
        var highScoreDefault = NSUserDefaults.standardUserDefaults()
        if(highScoreDefault.valueForKey("HighScore") != nil){
            highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger!
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
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
                
                if(score > highScore){
                    highScore = score
                    
                    var highScoreDefault = NSUserDefaults.standardUserDefaults()
                    highScoreDefault.setValue(highScore, forKey: "HighScore")
                    highScoreDefault.synchronize()
                }
                var scoreDefault = NSUserDefaults.standardUserDefaults()
                scoreDefault.setValue(score, forKey: "Score")
                scoreDefault.synchronize()
            }
                // restart on game over
            else{
                let seconds = 2.0
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                let transition = SKTransition.revealWithDirection(.Right, duration: 0.0)
                let nextScene = GameOverScene(size: self.size, won: true)
                nextScene.scaleMode = .AspectFill
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.scene?.view?.presentScene(nextScene, transition: transition)
                })
                
            }
            
            if(objectSpawnRate > 0.5){
                objectSpawnRate = 1.0 - Double(score/100)/10
            }
        }
        
    }
    
    func createEnemy(timer: NSTimer) {
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(possibleEnemies) as! [String]
        let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 600)
        
        let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        sprite.zPosition = -0.5
        if(physicsWorld.speed != 0){
            addChild(sprite)
        }
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
        
        timer.fireDate = timer.fireDate.dateByAddingTimeInterval(objectSpawnRate)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.locationInNode(self)
        
        // clamp the y axis
        if location.y < 50 {
            location.y = 50
        } else if location.y > 650 {
            location.y = 650
        }
        
        // clamp the x axis
        if location.x < 100 {
            location.x = 100
        } else if location.x > 900 {
            location.x = 900
        }
        
        player.position = location
    }
    
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
