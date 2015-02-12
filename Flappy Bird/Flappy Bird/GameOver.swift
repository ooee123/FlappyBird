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
    
    var score = 0
    var highScores : [Int] = []
    
    override func didMoveToView(view: SKView) {
        size = view.frame.size
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Game Over!"
        myLabel.fontSize = 24
        myLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(myLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
        scoreLabel.text = "Your Score: \(score)"
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 30)
        addChild(scoreLabel)
        
        /*
        let hiScore1 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
        hiScore1.text = "#1: \(highScores[0])"
        hiScore1.fontSize = 16
        hiScore1.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 50)
        let hiScore2 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
        hiScore2.text = "#2: \(highScores[1])"
        hiScore2.fontSize = 16
        hiScore2.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 70)
        let hiScore3 = SKLabelNode(fontNamed: "AppleSDGothicNeo-Bold")
        hiScore3.text = "#3: \(highScores[2])"
        hiScore3.fontSize = 16
        hiScore3.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame) - 90)
        
        addChild(hiScore1)
        addChild(hiScore2)
        addChild(hiScore3)
*/
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view?.presentScene(Game())
        
    }
}
