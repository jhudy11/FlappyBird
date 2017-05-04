//
//  GameManager.swift
//  Flappy Bird
//
//  Created by Joshua Hudson on 5/4/17.
//  Copyright © 2017 ParanoidPenguinProductions. All rights reserved.
//

import Foundation

class GameManager {
    
    static let instance = GameManager()
    private init() {}
    
    var birdIndex = Int(0)
    var birds = ["Blue", "Green", "Red"]
    
    func incrementIndex() {
        birdIndex += 1
        
        // Reset the birdIndex when the array limit is reached
        if birdIndex == birds.count {
            birdIndex = 0
        }
    }
    
    func getBird() -> String {
        return birds[birdIndex]
    }
    
    func setHighscore(highScore: Int) {
        //UserDefaults.standard.setValue(highScore, forUndefinedKey: "Highscore")
        UserDefaults.standard.set(highScore, forKey: "Highscore")
    }
    
    func getHighscore() -> Int {
        return UserDefaults.standard.integer(forKey: "Highscore")
    }
    
}



























