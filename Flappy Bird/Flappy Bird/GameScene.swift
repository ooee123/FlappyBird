//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Kevin Ly on 1/15/15.
//  Copyright (c) 2015 Kevin Ly. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let PLAYER_CATEGORY : UInt32 = 0x1
    let OBSTACLE_CATEGORY : UInt32 = 0x2
    let EDGE_CATEGORY : UInt32 = 0x4
    
    var started = false
    let sprite = Player()
    let motion = CMMotionManager()
    var tiles : [SKSpriteNode] = []
    
    override func didMoveToView(view: SKView) {
        //let background = SKSpriteNode(imageNamed: "background.png")
        //background.runAction(SKAction()
        /* Setup your scene here */
        //size = CGSize(width: view.frame.size.width, height: view.frame.size.height - 280)
        size = view.frame.size
        //size = CGSize(width: 500, height: 200)
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Tap to Begin";
        myLabel.fontSize = 24;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)

        let body = SKPhysicsBody(edgeLoopFromRect: self.frame)
        //let body = SKPhysicsBody()
        self.physicsBody = body
        
        sprite.physicsBody?.categoryBitMask = PLAYER_CATEGORY
        
        sprite.physicsBody?.collisionBitMask = EDGE_CATEGORY | OBSTACLE_CATEGORY
        sprite.physicsBody?.contactTestBitMask = EDGE_CATEGORY | OBSTACLE_CATEGORY
        body.categoryBitMask = EDGE_CATEGORY
        physicsWorld.contactDelegate = self
        
        var o = Obstacle()
        //o.setHeight(100)
        o.position = CGPoint(x: self.frame.midX, y: self.frame.minY)
        self.addChild(o)
    }
    
    func skRand(lowerBound low: CGFloat, upperBound high: CGFloat) -> CGFloat {
        return CGFloat( Double(arc4random()) / Double(UINT32_MAX)) * (high - low) + low
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if (!started)
        {
            self.removeAllChildren()
            //self.view!.backgroundColor = UIColor(red: CGFloat(1), green: CGFloat(1), blue: CGFloat(1), alpha: CGFloat(1))
            let velo = -50
            let gameLeft = SKSpriteNode(imageNamed: "gameLeft.jpg")
            gameLeft.anchorPoint = CGPoint(x: 0, y: 0.5)
            gameLeft.position = CGPoint(x: 0, y: self.frame.midY)
            gameLeft.physicsBody = SKPhysicsBody()
            gameLeft.physicsBody?.affectedByGravity = false
            gameLeft.physicsBody?.velocity = CGVector(dx: velo, dy: 0)
            //gameLeft.position = CGPoint(x: 0 + gameLeft.size.width / 2, y: self.frame.midY)
            //gameLeft.runAction(SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10)))
            addChild(gameLeft)
            tiles.append(gameLeft)
            
            let gameMid = SKSpriteNode(imageNamed: "gameMid.jpg")
            gameMid.anchorPoint = CGPoint(x: 0, y: 0.5)
            gameMid.position = CGPoint(x: 0 + gameLeft.size.width, y: self.frame.midY)
            gameMid.physicsBody = SKPhysicsBody()
            gameMid.physicsBody?.affectedByGravity = false
            gameMid.physicsBody?.velocity = CGVector(dx: velo, dy: 0)
            //gameMid.position = CGPoint(x: 0 + gameLeft.size.width + gameMid.size.width / 2, y: self.frame.midY)
            //gameMid.runAction(SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10)))
            addChild(gameMid)
            tiles.append(gameMid)
            
            let gameRight = SKSpriteNode(imageNamed: "gameRight.jpg")
            gameRight.anchorPoint = CGPoint(x: 0, y: 0.5)
            gameRight.physicsBody = SKPhysicsBody()
            gameRight.physicsBody?.affectedByGravity = false
            gameRight.physicsBody?.velocity = CGVector(dx: velo, dy: 0)
            //gameRight.position = CGPoint(x: 0 + gameLeft.size.width + gameMid.size.width + gameRight.size.width / 2, y: self.frame.midY)
            gameRight.position = CGPoint(x: 0 + gameLeft.size.width + gameMid.size.width, y: self.frame.midY)
            //gameRight.runAction(SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10)))
            addChild(gameRight)
            tiles.append(gameRight)
            
            println("Left Width \(gameLeft.size.width) and frame.midX \(gameLeft.frame.midX)");
            
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
            
            let touch = touches.anyObject() as UITouch?
            
            if let touch = touch?
            {
                sprite.position = touch.locationInNode(self)
                self.addChild(sprite)
                started = true
            }
        }
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
        let seq = SKAction.sequence([SKAction.moveBy(CGVector(dx: -self.frame.size.width, dy: 0), duration: NSTimeInterval(10)), SKAction.removeFromParent()])
        pillar.runAction(seq)
        addChild(pillar)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        /*
        if let data = motion.accelerometerData?
        {/Users/classroomtech/Flappy Bird/Flappy Bird/C11AY.png
            physicsWorld.gravity = CGVector(dx: data.acceleration.x * 20 , dy: data.acceleration.y * 20)
        }
        */
        for tile in tiles
        {
            //tile.position.x -= 1
            //if tile.position.x + tile.size.width / 2 < 0
            if CGRectGetMaxX(tile.frame) <= 0
            {
                tile.position = CGPoint(x: self.frame.maxX, y: self.frame.midY)
            }
        }
        
    }
    
    override func didSimulatePhysics() {
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        physicsWorld.speed = 0.0
        removeAllActions()
        self.view?.presentScene(GameOver())
    }
}
