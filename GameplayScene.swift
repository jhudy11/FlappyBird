//
//  GameplayScene.swift
//  Flappy Bird
//
//  Created by Joshua Hudson on 5/3/17.
//  Copyright © 2017 ParanoidPenguinProductions. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = Bird()
    
    var pipesHolder = SKNode()
    
    var scoreLabel = SKLabelNode(fontNamed: "04b_19")
    var score = 0
    
    var gameStarted = false
    var isAlive = false
    
    var press = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        initialize()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isAlive {
            moveBackgroundsAndGrounds()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // This is the first touch on the screen
        if gameStarted == false {
            isAlive = true
            gameStarted = true
            press.removeFromParent()
            spawnObstacles()
            
            // Initialize gravity on bird AFTER the first touch
            bird.physicsBody?.affectedByGravity = true
            
            bird.flap()
        }
        
        if isAlive {
            bird.flap()
        }
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Retry" {
                
                // Restart the game
                self.removeAllActions()
                self.removeAllChildren()
                initialize()
                
            }
            
            if atPoint(location).name == "Quit" {
                guard let mainMenu = MainMenuScene(fileNamed: "MainMenuScene") else { return }
                mainMenu.scaleMode = .aspectFill
                
                // Create a transition, play with other types to see which one you prefer
                //self.view?.presentScene(mainMenu, transition: SKTransition.doorway(withDuration: TimeInterval(1)))
                self.view?.presentScene(mainMenu, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(1)))
            }
            
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        // Check to see which physics body is the bird and assign the bird to firstBody
        if contact.bodyA.node?.name == "Bird" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Bird" && secondBody.node?.name == "Score" {
            
            incrementScore()
            
        } else if firstBody.node?.name == "Bird" && secondBody.node?.name == "Pipe" {
            
            if isAlive {
                birdDied()
            }
            
        } else if firstBody.node?.name == "Bird" && secondBody.node?.name == "Ground" {
            
            if isAlive {
                birdDied()
            }
            
        }
        
    }
    
    func initialize() {
        
        gameStarted = false
        isAlive = false
        score = 0
        
        physicsWorld.contactDelegate = self
        
        createInstructions()
        createBird()
        createBackgrounds()
        createGrounds()
        createLabel()
    }
    
    func createInstructions() {
        press = SKSpriteNode(imageNamed: "Press")
        press.anchorPoint =  CGPoint(x: 0.5, y: 0.5)
        press.position = CGPoint(x: 0, y: 0)
        press.setScale(1.8)
        press.zPosition = 10
        self.addChild(press)
    }
    
    func createBird() {
        bird = Bird(imageNamed: "\(GameManager.instance.getBird()) 1")
        bird.initialize()
        bird.position = CGPoint(x: -50, y: 0)
        self.addChild(bird)
    }
    
    func createBackgrounds() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day")
            bg.name = "BG"
            bg.zPosition = 0
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            self.addChild(bg)
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.zPosition = 4
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            // Split image in half and then place at the bottom os the frame
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.affectedByGravity = false
            
            // Locks the ground node in place so that it doesn't move when the bird node collides with it
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
            self.addChild(ground)
        }
    }
    
    func moveBackgroundsAndGrounds() {
        
        enumerateChildNodes(withName: "BG", using: ({
            (node, error) in
            
            node.position.x -= 4.5
            
            // Recycle the backgrounds
            if node.position.x < -(self.frame.width) {
                node.position.x += self.frame.width * 3
            }
            
        }))
        
        enumerateChildNodes(withName: "Ground", using: ({
            (node, error) in
            
            // Ground should move slower to create depth
            node.position.x -= 2.0
            
            // Recycle the grounds
            if node.position.x < -(self.frame.width) {
                node.position.x += self.frame.width * 3
            }
            
        }))
        
    }
    
    func createPipes() {
        
        pipesHolder = SKNode()
        pipesHolder.name = "Holder"
        
        let pipeUp = SKSpriteNode(imageNamed: "Pipe 1")
        let pipeDown = SKSpriteNode(imageNamed: "Pipe 1")
        
        let scoreNode = SKSpriteNode()
        
        scoreNode.name = "Score"
        scoreNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scoreNode.position = CGPoint(x: 0, y: 0)
        scoreNode.size = CGSize(width: 5, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        
        pipeUp.name = "Pipe"
        pipeUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeUp.position = CGPoint(x: 0, y: 630)
        
        // Stretch the down pipeUp to cover screen
        pipeUp.yScale = 1.5
        
        // Rotate the pipe 180 degrees
        pipeUp.zRotation = CGFloat(M_PI)
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeUp.physicsBody?.affectedByGravity = false
        pipeUp.physicsBody?.isDynamic = false
        
        pipeDown.name = "Pipe"
        pipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeDown.position = CGPoint(x: 0, y: -630)
        
        // Stretch the down pipeDown to cover screen
        pipeDown.yScale = 1.5
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeDown.physicsBody?.affectedByGravity = false
        pipeDown.physicsBody?.isDynamic = false
        
        pipesHolder.zPosition = 5
        
        pipesHolder.position.x = self.frame.width + 100
        pipesHolder.position.y = CGFloat.randomBetweenNumbers(firstNumber: -300, secondNumber: 300)
        
        pipesHolder.addChild(pipeUp)
        pipesHolder.addChild(pipeDown)
        pipesHolder.addChild(scoreNode)
        
        self.addChild(pipesHolder)
        
        let destination = self.frame.width * 2
        let move = SKAction.moveTo(x: -destination, duration: TimeInterval(10))
        let remove = SKAction.removeFromParent()
        
        pipesHolder.run(SKAction.sequence([move, remove]), withKey: "Move")
        
    }
    
    func spawnObstacles() {
        let spawn = SKAction.run({ () -> Void in
            self.createPipes()
        })
        
        let delay = SKAction.wait(forDuration: TimeInterval(2))
        let sequence = SKAction.sequence([spawn, delay])
        
        self.run(SKAction.repeatForever(sequence), withKey: "Spawn")
    }
    
    func createLabel() {
        scoreLabel.zPosition = 6
        scoreLabel.position = CGPoint(x: 0, y: 450)
        scoreLabel.fontSize = 120
        scoreLabel.text = "0"
        self.addChild(scoreLabel)
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    func birdDied() {
        
        // Stops the spawning of new pipes
        self.removeAction(forKey: "Spawn")
        
        // Stops the moving of pipes already on screen
        for child in children {
            if child.name == "Holder" {
                child.removeAction(forKey: "Move")
            }
        }
        
        isAlive = false
        
        bird.texture = bird.diedTexture
        
        let highscore = GameManager.instance.getHighscore()
        
        if highscore < score {
            
            // New highscore record
            GameManager.instance.setHighscore(highScore: score)
        }
        
        let retry = SKSpriteNode(imageNamed: "Retry")
        let quit = SKSpriteNode(imageNamed: "Quit")
        
        retry.name = "Retry"
        retry.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        retry.position = CGPoint(x: -150, y: -150)
        retry.zPosition = 7
        retry.setScale(0)
        
        quit.name = "Quit"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        quit.position = CGPoint(x: 150, y: -150)
        quit.zPosition = 7
        quit.setScale(0)
        
        let scaleUp = SKAction.scale(to: 1, duration: TimeInterval(0.5))
        
        retry.run(scaleUp)
        quit.run(scaleUp)
        
        self.addChild(retry)
        self.addChild(quit)
        
    }
    
}
































