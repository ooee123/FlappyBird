//
//  GameOver.swift
//  Flappy Bird
//
//  Created by Classroom Tech User on 2/4/15.
//  Copyright (c) 2015 Kevin Ly. All rights reserved.
//

import UIKit
import SpriteKit

class GameOver: SKScene {
    override func didMoveToView(view: SKView) {
        size = view.frame.size
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Game Over!"
        myLabel.fontSize = 24
        myLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(myLabel)
    }
}
