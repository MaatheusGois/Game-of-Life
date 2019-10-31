//
//  GameScene.swift
//  game-of-life-mac
//
//  Created by Matheus Silva on 31/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Cocoa
import SceneKit

public class GameScene: SCNScene {
    
    func setupScene() {
        
        guard let boxScene = SCNScene(named: "art.scnassets/box.scn") else { return }
        guard let box = boxScene.rootNode.childNode(withName: "box", recursively: false) else { return }
        
//        self.rootNode.addChildNode(box)
        
        let min = box.boundingBox.min
        let max = box.boundingBox.max
        let w = CGFloat(max.x - min.x)
        let h = CGFloat(max.y - min.y)
        let l = CGFloat(max.z - min.z)

        
        let box2 = createBox(box: box, in: SCNVector3(x: w * 0.1 , y: 0, z: l * 0.1))
        
        let box3: Unit = Unit(node: box)
        let map: Map = Map(unit: box3, n: 3)
        
        box3.node.position = map.getPositionUnit(x: 0, y: 0, z: 0)
        
        let box4: Unit = Unit(node: box)
        box4.node.position = map.getPositionUnit(x: 1, y: 1, z: 0)
        
        self.rootNode.addChildNode(box3.node)
        self.rootNode.addChildNode(box4.node)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)
        
        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .omni
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        self.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        self.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
//        let ship = self.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
    }
    
    func createBox(box: SCNNode, in pos: SCNVector3) -> SCNNode {
        guard let boxCopy = box.copy() as? SCNNode else { return SCNNode() }
        boxCopy.position = pos
        return boxCopy
    }
    
    
    func setupCamera() {
        
    }
}
