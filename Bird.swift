//
//  Bird.swift
//  Flappy Bird
//
//  Created by Joshua Hudson on 5/3/17.
//  Copyright © 2017 ParanoidPenguinProductions. All rights reserved.
//

import SpriteKit

struct ColliderType {
    static let Bird: UInt32 = 1
    static let Ground: UInt32 = 2
    static let Pipes: UInt32 = 3
    static let Score: UInt32 = 4
}

class Bird: SKSpriteNode {
    
    var birdAnimation = [SKTexture]()
    var birdAnimationAction = SKAction()
    
    var diedTexture = SKTexture()
    
    func initialize () {
        
        for i in 2..<4 {
            let name = "\(GameManager.instance.getBird()) \(i)"
            birdAnimation.append(SKTexture(imageNamed: name))
        }
        
        birdAnimationAction = SKAction.animate(with: birdAnimation, timePerFrame: 0.08, resize: true, restore: true)
        
        diedTexture = SKTexture(imageNamed: "\(GameManager.instance.getBird()) 4")
        
        self.name = "Bird"
        self.zPosition = 3
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = ColliderType.Bird
        
        // Bird should collide with both the ground and the pipes
        self.physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Pipes
        
        // We want to know when the bird collides with all of the other objects
        self.physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Pipes | ColliderType.Score
    }
    
    func flap() {
        // Make the physics body stop before applying the force again to remove compounding forces with additional taps
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        // Push the bird up when tapped
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
        
        self.run(birdAnimationAction)
    }
    
}






