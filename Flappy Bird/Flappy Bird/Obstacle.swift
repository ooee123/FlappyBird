//
//  Obstacle.swift
//  Flappy Bird
//
//  Created by Classroom Tech User on 2/3/15.
//  Copyright (c) 2015 Kevin Ly. All rights reserved.
//

import UIKit
import SpriteKit

class Obstacle: SKNode {
    
   override init()
   {
      super.init()
   }
    
    init(upsideDown: Bool)
    {
        super.init()
        let sprite = SKSpriteNode(imageNamed: "pillar.png")
        
        sprite.setScale(CGFloat(0.4))
        var body : SKPhysicsBody
        var sh : SKShapeNode
        var rect = CGRect(origin: CGPoint(x: sprite.frame.minX, y: sprite.frame.minY), size: CGSize(width: sprite.size.width - 2, height: sprite.size.height))
        rect = sprite.frame
        body = SKPhysicsBody(edgeLoopFromRect: rect)
        sh = SKShapeNode(rect: rect)
        body.affectedByGravity = false
        if upsideDown == true
        {
           //sprite.yScale = sprite.yScale * -1
            //body = SKPhysicsBody(edgeLoopFromRect: rect)
           //sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            //sprite.position = CGPoint(x: sprite.frame.midX, y: sprite.frame.minY)
        }
        else
        {
            body = SKPhysicsBody(edgeLoopFromRect: rect)
            //sprite.anchorPoint = CGPoint(x: 0.5, y: 1)
            //sprite.position = CGPoint(x: sprite.frame.midX, y: sprite.frame.maxY)
        }
        
        
        sh.fillColor = UIColor.blueColor()
        
        self.physicsBody = body
        addChild(sprite)
    }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
