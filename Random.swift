//
//  Random.swift
//  Flappy Bird
//
//  Created by Joshua Hudson on 5/3/17.
//  Copyright © 2017 ParanoidPenguinProductions. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func randomBetweenNumbers(firstNumber: CGFloat, secondNumber: CGFloat) -> CGFloat {
        
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + firstNumber
    }
    
}
































