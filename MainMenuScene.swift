//
//  MainMenuScene.swift
//  Flappy Bird
//
//  Created by Joshua Hudson on 5/4/17.
//  Copyright © 2017 ParanoidPenguinProductions. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    var birdButton = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Play" {
                guard let gamePlay = GameplayScene(fileNamed: "GameplayScene") else { return }
                gamePlay.scaleMode = .aspectFill
                
                // Create a transition, play with other types to see which one you prefer
                //self.view?.presentScene(gamePlay, transition: SKTransition.doorway(withDuration: TimeInterval(1)))
                self.view?.presentScene(gamePlay, transition: SKTransition.doorsOpenHorizontal(withDuration: TimeInterval(1)))
            }
            
            if atPoint(location).name == "Highscore" {
                scoreLabel.removeFromParent()
                createLabel()
            }
            
            if atPoint(location).name == "Bird" {
                GameManager.instance.incrementIndex()
                birdButton.removeFromParent()
                createBirdButton()
            }
            
        }
        
    }
    
    func initialize() {
        createBackground()
        createButtons()
        createBirdButton()
    }
    
    func createBackground() {
        let bg = SKSpriteNode(imageNamed: "BG Day")
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = 0
        self.addChild(bg)
    }
    
    func createButtons() {
        let play = SKSpriteNode(imageNamed: "Play")
        let highScore = SKSpriteNode(imageNamed: "Highscore")
        
        play.name = "Play"
        play.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        play.position = CGPoint(x: -180, y: -50)
        play.zPosition = 1
        play.setScale(0.7)
        
        highScore.name = "Highscore"
        highScore.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        highScore.position = CGPoint(x: 180, y: -50)
        highScore.zPosition = 1
        highScore.setScale(0.7)
        
        self.addChild(play)
        self.addChild(highScore)
    }
    
    func createBirdButton() {
        birdButton = SKSpriteNode()
        birdButton.name = "Bird"
        birdButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        birdButton.position = CGPoint(x: 0, y: 200)
        birdButton.setScale(1.3)
        birdButton.zPosition = 3
        
        var birdAnimation = [SKTexture]()
        
        for i in 1..<4 {
            let name = "\(GameManager.instance.getBird()) \(i)"
            birdAnimation.append(SKTexture(imageNamed: name))
        }
        
        let animateBird = SKAction.animate(with: birdAnimation, timePerFrame: 0.1, resize: true, restore: true)
        
        birdButton.run(SKAction.repeatForever(animateBird))
        
        self.addChild(birdButton)
    }
    
    func createLabel() {
        scoreLabel = SKLabelNode(fontNamed: "04b_19")
        scoreLabel.fontSize = 120
        scoreLabel.position = CGPoint(x: 0, y: -400)
        scoreLabel.text = "\(GameManager.instance.getHighscore())"
        self.addChild(scoreLabel)
    }
    
}


































