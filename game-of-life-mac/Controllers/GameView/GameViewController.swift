//
//  GameViewController.swift
//  game-of-life-mac
//
//  Created by Matheus Silva on 31/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    let scene = GameScene(named: "art.scnassets/main.scn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scene?.setupScene()

        setupViewController()
        setupGestures()
        
    }
    
    func setupViewController() {
        guard let scnView = self.view as? SCNView else { return }
        
        scnView.scene = scene
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = NSColor.black
    }
    
    func setupGestures() {
        guard let scnView = self.view as? SCNView else { return }
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        guard let scnView = self.view as? SCNView else { return }
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            guard let material = result.node.geometry?.firstMaterial else { return }
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
        }
    }
}
