//
//  ViewController.swift
//  ARLondonSun
//
//  Created by Milos Gajdos on 17/02/2020.
//  Copyright © 2020 Milos Gajdos. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    // we make sun an optional as an empty scene should not contain one
    var sun: Sun?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // place features points on the detected surface
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // at the bottom of the screen
        sceneView.showsStatistics = true
        
        // automatically add lighting to the scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // NOTE: this is a 2D location on the screen -- we will need to convert it to 3D
            let touchLocation = touch.location(in: sceneView)
            // find 3D location int the the real world -- not the AR scene
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            // we will pick the first results and unwrap it
            if let hitResult = results.first {
                if let node = sun {
                    // if the sun is spinning, stop it
                    // otherwise start spinning it
                    node.spinning ? node.stop() : node.spin()
                } else {
                    // create new sun
                    sun = Sun(radius: 0.1)
                    // ADD the sun to the scene
                    place(sun: sun!, location: hitResult)
                }
            }
        }
    }

    func place(sun node: Sun, location: ARHitTestResult) {
        // if we dont add sun.boundingSphere.radius to z coordinate
        // we will get the sun's other half hidden underneath the scene plane
        // whilst we want it ALL on top of the scene plane
        // we essentially move the sun anchor UP i.e. along the z axis
        node.position = SCNVector3(
            x: location.worldTransform.columns.3.x,
            y: location.worldTransform.columns.3.y,
            z: location.worldTransform.columns.3.z
        )
        
        // ad the node to the scene
        sceneView.scene.rootNode.addChildNode(node)
    }

    @IBAction func removeSunTapped(_ sender: UIBarButtonItem) {
        // remove the sun from the scene when tapping the trash button
        sun?.removeFromParentNode()
        // mark the sun node as nil
        sun = nil
    }
}
