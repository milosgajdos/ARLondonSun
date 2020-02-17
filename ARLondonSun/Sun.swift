//
//  Sun.swift
//  ARLondonSun
//
//  Created by Milos Gajdos on 17/02/2020.
//  Copyright © 2020 Milos Gajdos. All rights reserved.
//

import Foundation
import SceneKit

class Sun: SCNNode {
    // track the sun spinning
    var spinning: Bool = false
    var radius: CGFloat
    
    init(radius: CGFloat) {
        self.radius = radius

        super.init()
        
        let sphere = SCNSphere(radius: radius)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/sun.jpg")
        sphere.materials = [material]
        
        self.geometry = sphere
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func spin() {
        // create a random number between 1 and 4 and multiply by 90degs in radians
        let randomX = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
        let randomZ = Float((arc4random_uniform(4) + 1)) * (Float.pi/2)
        
        // NOTE: this is how we create animation
        // NOTE: by multiplying the rotation we rotate 5 times more than just simple pi/2
        let spinAction = SCNAction.rotateBy(
            x: CGFloat(randomX * 5),
            y: 0,
            z: CGFloat(randomZ * 5),
            duration: 1.5
        )
        
        // repeate the action forever until stopped
        let repeatAction = SCNAction.repeatForever(spinAction)
        
        // start the action
        runAction(repeatAction)
        
        spinning = true
    }
    
    func stop() {
        // remove all actions
        removeAllActions()
        
        spinning = false
    }
}
