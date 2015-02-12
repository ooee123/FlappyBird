//
//  Intro.swift
//  Flappy Bird
//
//  Created by Classroom Tech User on 2/11/15.
//  Copyright (c) 2015 Kevin Ly. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        size = view.frame.size
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Tap to Begin";
        myLabel.fontSize = 24;
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view!.presentScene(Game())
        println("Helllo")
    }
}
