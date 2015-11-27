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
    var backgroundMusic : AVAudioPlayer?
    var explosionSound  : AVAudioPlayer?
    
    var possibleEnemies = ["asteroid-5", "asteroid-2", "asteroid-3", "asteroid-4"]
    var gameTimer: NSTimer!
    var isDead = false
    
    var objectSpawnRate : Double! = 1.0
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var livesLabel: SKLabelNode!
    var lives: Int = 3 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }
    
    override func didMoveToView(view: SKView) {
        backgroundColor = UIColor.blackColor()
        
        starfield = SKEmitterNode(fileNamed: "Starfield.sks")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 200, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody!.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .Left
        addChild(scoreLabel)
        
        livesLabel = SKLabelNode(fontNamed: "Chalkduster")
        livesLabel.position = CGPoint(x: 360, y: 16)
        livesLabel.horizontalAlignmentMode = .Left
        addChild(livesLabel)
        
        score = 0
        lives = 3
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(objectSpawnRate, target: self, selector: "createEnemy", userInfo: nil, repeats: true)
        
        if (backgroundMusic == nil) {
            print("Creating bacjground music player")
            backgroundMusic = GameViewController().playAudio("background")
        
        }
        
        explosionSound  = GameViewController().playAudio("explosion")
        
        if((backgroundMusic?.playing) == false){
            backgroundMusic?.prepareToPlay()
            backgroundMusic?.play()
            backgroundMusic?.numberOfLoops = -1
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        // add score every frame if still playing
        if !isDead {
            score += 1
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
                self.lives -= 1
            })
            
        }
        
        objectSpawnRate = 1.0 - Double(score/100)/10
    }
    
    func createEnemy() {
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(possibleEnemies) as! [String]
        let randomDistribution = GKRandomDistribution(lowestValue: 150, highestValue: 600)
        
        let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.locationInNode(self)
        
        // clamp the y axis
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        // clamp the x axis
        if location.x < 100 {
            location.x = 100
        } else if location.x > 900 {
            location.x = 900
        }
        
        player.position = location
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion.sks")!
        explosion.position = player.position
        addChild(explosion)
        
        backgroundMusic?.stop()
        
        explosionSound?.prepareToPlay()
        explosionSound?.play()
        explosionSound?.numberOfLoops = 0
        
        player.removeFromParent()
        
        isDead = true
    }
}
