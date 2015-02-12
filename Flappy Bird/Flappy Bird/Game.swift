//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Kevin Ly on 1/15/15.
//  Copyright (c) 2015 Kevin Ly. All rights reserved.
//

import SpriteKit
import CoreMotion

class Game: SKScene, SKPhysicsContactDelegate, UIApplicationDelegate {
    
    let PLAYER_CATEGORY : UInt32 = 0x1
    let OBSTACLE_CATEGORY : UInt32 = 0x2
    let EDGE_CATEGORY : UInt32 = 0x4
    
    let sprite = Player()
    let motion = CMMotionManager()
    var tiles : [SKSpriteNode] = []
    var pillars : [Obstacle] = []
    var score : Int = 0
        {
        didSet {
            scoreLabel.text = "Score: \(score / 2)"
        }
    }
    let scoreLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
    
    func applicationDidEnterBackground(application: UIApplication) {
        physicsWorld.speed = 0
        self.removeAllActions()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        physicsWorld.speed = 1
        let spawnPillar = SKAction.sequence([
            SKAction.runBlock {
                let height = Int(self.frame.size.height)
                var offset = Int(self.skRand(lowerBound: 0, upperBound: 200))
                let gap = Int(self.skRand(lowerBound: 120, upperBound: 170))
                self.addPillar(false, height: offset, gap: gap)
                self.addPillar(true, height: offset, gap: gap)
            },
            SKAction.waitForDuration(3.3, withRange: 0.6)])
        runAction(SKAction.repeatActionForever(spawnPillar))
        for node in children
        {
            if let n = node as? Obstacle
            {
                let seq = SKAction.sequence([SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10))])
                n.runAction(seq)
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        size = view.frame.size
        
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 14;
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame) - 40)
        scoreLabel.zPosition = 10
        
        let body = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = body
        
        sprite.physicsBody?.categoryBitMask = PLAYER_CATEGORY
        sprite.physicsBody?.collisionBitMask = EDGE_CATEGORY | OBSTACLE_CATEGORY
        sprite.physicsBody?.contactTestBitMask = EDGE_CATEGORY | OBSTACLE_CATEGORY
        body.categoryBitMask = EDGE_CATEGORY
        physicsWorld.contactDelegate = self
        
        let velo = -50
        let gameLeft = SKSpriteNode(imageNamed: "gameLeft.png")
        gameLeft.anchorPoint = CGPoint(x: 0, y: 0.5)
        gameLeft.position = CGPoint(x: 0, y: self.frame.midY)
        gameLeft.physicsBody = SKPhysicsBody()
        gameLeft.physicsBody?.affectedByGravity = false
        gameLeft.physicsBody?.velocity = CGVector(dx: velo, dy: 0)
        //gameLeft.position = CGPoint(x: 0 + gameLeft.size.width / 2, y: self.frame.midY)
        //gameLeft.runAction(SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10)))
        addChild(gameLeft)
        tiles.append(gameLeft)
        
        let gameMid = SKSpriteNode(imageNamed: "gameMid.png")
        gameMid.anchorPoint = CGPoint(x: 0, y: 0.5)
        gameMid.position = CGPoint(x: 0 + gameLeft.size.width, y: self.frame.midY)
        gameMid.physicsBody = SKPhysicsBody()
        gameMid.physicsBody?.affectedByGravity = false
        gameMid.physicsBody?.velocity = CGVector(dx: velo, dy: 0)
        //gameMid.position = CGPoint(x: gameLeft.size.width, y: self.frame.midY)
        //gameMid.runAction(SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10)))
        addChild(gameMid)
        tiles.append(gameMid)
        
        let gameRight = SKSpriteNode(imageNamed: "gameRight.png")
        gameRight.anchorPoint = CGPoint(x: 0, y: 0.5)
        gameRight.physicsBody = SKPhysicsBody()
        gameRight.physicsBody?.affectedByGravity = false
        gameRight.physicsBody?.velocity = CGVector(dx: velo, dy: 0)
        //gameRight.position = CGPoint(x: gameLeft.size.width + gameMid.size.width, y: self.frame.midY)
        gameRight.position = CGPoint(x: 0 + gameLeft.size.width + gameMid.size.width, y: self.frame.midY)
        //gameRight.runAction(SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10)))
        addChild(gameRight)
        tiles.append(gameRight)
        
        let spawnPillar = SKAction.sequence([
            SKAction.runBlock {
                let height = Int(self.frame.size.height)
                var offset = Int(self.skRand(lowerBound: 0, upperBound: 200))
                let gap = Int(self.skRand(lowerBound: 120, upperBound: 170))
                self.addPillar(false, height: offset, gap: gap)
                self.addPillar(true, height: offset, gap: gap)
            },
            SKAction.waitForDuration(3.3, withRange: 0.6)])
        runAction(SKAction.repeatActionForever(spawnPillar))
        
        sprite.position = CGPoint(x: CGRectGetMinX(self.frame) + 40, y: CGRectGetMidY(self.frame) + 50)
        self.addChild(sprite)
        self.addChild(scoreLabel)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
    }
    
    func skRand(lowerBound low: CGFloat, upperBound high: CGFloat) -> CGFloat {
        return CGFloat( Double(arc4random()) / Double(UINT32_MAX)) * (high - low) + low
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        sprite.jump();
        
    }
    
    func addPillar(upsideDown: Bool, height: Int, gap: Int)
    {
        let pillar = Obstacle(upsideDown: upsideDown)
        pillar.physicsBody?.categoryBitMask = OBSTACLE_CATEGORY
        var position = self.frame.minY + CGFloat(height) + pillar.frame.size.height
        position = self.frame.minY + CGFloat(height / 2) - CGFloat(gap / 2)
        if (upsideDown == true)
        {
            position = self.frame.maxY - CGFloat(height) - pillar.frame.size.height
            position = self.frame.minY + CGFloat(height / 2) + CGFloat(gap / 2) + 240
        }
        pillar.position = CGPoint(x: self.frame.maxX - pillar.frame.size.width - 10, y: position)
        let seq = SKAction.sequence([SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10))])
        pillar.runAction(seq)
        addChild(pillar)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        /*
        if let data = motion.accelerometerData?
        {
        physicsWorld.gravity = CGVector(dx: data.acceleration.x * 20 , dy: data.acceleration.y * 20)
        }
        */
        for tile in tiles
        {
            //tile.position.x -= 1
            if CGRectGetMaxX(tile.frame) <= 0
            {
                tile.position = CGPoint(x: self.frame.maxX, y: self.frame.midY)
            }
        }
        for node in children
        {
            if let n = node as? Obstacle
            {
                if (n.position.x <= 0)
                {
                    score = score + 1
                    n.removeFromParent()
                }
            }
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        physicsWorld.speed = 0.0
        removeAllActions()
        let s = GameOver()
        s.score = score / 2

        
        
        self.view?.presentScene(s)
    }
}
