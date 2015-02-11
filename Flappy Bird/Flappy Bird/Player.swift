//
//  Player.swift
//  Flappy Bird
//
//  Created by Kevin Ly on 1/15/15.
//  Copyright (c) 2015 Kevin Ly. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKNode {
    let leftWing = SKSpriteNode(imageNamed: "wing.png")
    let rightWing = SKSpriteNode(imageNamed: "wing.png")
    let wingRadian = 1.3
    override init() {
        super.init()
        
        let sprite = SKSpriteNode(imageNamed: "bird.png")
        sprite.setScale(CGFloat(0.17))
        let physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2.0 - 2)
        let sh = SKShapeNode(circleOfRadius: sprite.size.height / 2.0 - 2)
        sh.fillColor = UIColor.blueColor()
        physicsBody.affectedByGravity = true
        self.physicsBody = physicsBody
        self.addChild(sprite)
        
        
        
        leftWing.anchorPoint = CGPoint(x: CGFloat(0.96), y: CGFloat(0.3))
        rightWing.anchorPoint = CGPoint(x: CGFloat(0.96), y: CGFloat(0.3))
        rightWing.xScale = rightWing.xScale * -1
        leftWing.position = CGPoint(x: CGFloat(-50), y: CGFloat(-4))
        rightWing.position = CGPoint(x: CGFloat(50), y: CGFloat(-4))
        leftWing.zRotation = CGFloat(wingRadian)
        rightWing.zRotation = CGFloat(-wingRadian)
        sprite.addChild(leftWing)
        sprite.addChild(rightWing)
}

    func jump() {
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 36))
        runAction(SKAction.playSoundFileNamed("Jump.wav", waitForCompletion: true))

        runAction(SKAction.rotateByAngle(CGFloat(3.14 / 12), duration: NSTimeInterval(0.6)))
        
        let seq1 = SKAction.rotateByAngle(CGFloat(wingRadian), duration: NSTimeInterval(0.3))
        let seq2 = SKAction.rotateByAngle(CGFloat(-wingRadian), duration: NSTimeInterval(0.3))
        
        leftWing.runAction(SKAction.sequence([seq2, seq1]))
        rightWing.runAction(SKAction.sequence([seq1, seq2]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
