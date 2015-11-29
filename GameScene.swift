//
//  GameScene.swift
//  SpaceRun
//
//  Created by Abhiroop007 on 20/11/2015.
//  Copyright © 2015 Abhiroop007. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var possibleEnemies = ["asteroid-5", "asteroid-2", "asteroid-3"]
    var gameTimer: NSTimer!
    var isDead = false
    
    var objectSpawnRate : Double! = 1.0
    
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var hscoreLabel : SKLabelNode!
    var highScore: Int = 0 {
        didSet {
            hscoreLabel.text = "High Score: \(highScore)"
        }
    }
    
    var livesLabel: SKLabelNode!
    var lives: Int = 3 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
        }
    }
    
    var gameIsPaused = false
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "playbtn")
    
    var pauseButton = SKSpriteNode()
    let pauseButtonTex = SKTexture(imageNamed: "pausebtn")
    var pauseLabel : SKLabelNode!
    
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
        
        hscoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        hscoreLabel.position = CGPoint(x: 660, y: 16)
        hscoreLabel.horizontalAlignmentMode = .Left
        addChild(hscoreLabel)
        
        pauseButton = SKSpriteNode(texture: pauseButtonTex)
        pauseButton.position = CGPointMake(size.width/2.5, size.height/1.1)
        addChild(pauseButton)
        
        pauseLabel = SKLabelNode(fontNamed: "Chalkduster")
        pauseLabel.text = "Tap To Resume"
        pauseLabel.fontSize = 80
        pauseLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(pauseLabel)
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPointMake(size.width/2, size.height/1.1)
        
        addChild(playButton)
        
        
        score = 0
        lives = 3
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(objectSpawnRate, target: self, selector: Selector("createEnemy:"), userInfo: nil, repeats: true)
        
        // loading the previous high score
        var highScoreDefault = NSUserDefaults.standardUserDefaults()
        if(highScoreDefault.valueForKey("HighScore") != nil){
            highScore = highScoreDefault.valueForKey("HighScore") as! NSInteger!
        }
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        for node in children {
            if ((node.position.x < -200) && node.position.x > 1500) {
                node.removeFromParent()
            }
        }
        
        if(physicsWorld.speed == 0){
            playButton.hidden = false
            pauseLabel.hidden = false
            pauseButton.hidden = true
        }
        else{
            pauseButton.hidden = false
            playButton.hidden = true
            pauseLabel.hidden = true
            
            // add score every frame if still playing
            if !isDead {
                score += 1
                
                if(score > highScore){
                    highScore = score
                    
                    var highScoreDefault = NSUserDefaults.standardUserDefaults()
                    highScoreDefault.setValue(highScore, forKey: "HighScore")
                    //highScoreDefault.setValue(0, forKey: "HighScore")
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
                    self.lives -= 1
                })
                
            }
            
            if(objectSpawnRate>0.5){
                objectSpawnRate = 1.0 - Double(score/100)/10
                print(objectSpawnRate)
            }
        }
    }
    
    func createEnemy(timer: NSTimer) {
        possibleEnemies = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(possibleEnemies) as! [String]
        let randomDistribution = GKRandomDistribution(lowestValue: 150, highestValue: 600)
        
        let sprite = SKSpriteNode(imageNamed: possibleEnemies[0])
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        sprite.zPosition = -0.5
        if(self.physicsWorld.speed != 0){
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let location = touches.first?.locationInNode(self){
            let touchedNode = nodeAtPoint(location)
            
            if touchedNode == playButton{
                print("play")
                gameIsPaused = false
                self.physicsWorld.speed = 1
                pauseButton.hidden = false
                playButton.hidden = true
                pauseLabel.hidden = true
            }
            if touchedNode == pauseButton{
                print("pause")
                gameIsPaused = true
                self.physicsWorld.speed = 0
                pauseButton.hidden = true
                playButton.hidden = false
                pauseLabel.hidden = false
            }
            
            /*if(self.physicsWorld.speed == 0){
                self.physicsWorld.speed = 1
                pauseLabel.removeFromParent()
            }*/
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion.sks")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        
        isDead = true
    }
}
