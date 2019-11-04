//
//  GameScene.swift
//  game-of-life-mac
//
//  Created by Matheus Silva on 31/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Cocoa
import SceneKit
import AVFoundation

public class GameScene: SCNScene {
    private(set) var map: Map = Map()
    private(set) var nextState: [[UnitState]] = [[UnitState]]()
    private(set) var box: SCNNode = SCNNode()
    
    let boxScene = SCNScene(named: "art.scnassets/box.scn")
    let sizeMap = 100
    var zPosition = 0
    var timeByGeneration = 0.5
    
    func setupScene() {
        
        self.setupBox()
        self.setupMap()
    
        self.map.build2D()
        self.map.generateAleatory2D(by: 1000)
        
        self.map.draw(scene: self)
        self.loop(time: timeByGeneration)
    }
    
    func setupBox() {
        guard let boxScene = SCNScene(named: "art.scnassets/box.scn") else { return }
        if let box = boxScene.rootNode.childNode(withName: "box", recursively: false) {
            self.box = box
        }
    }
    
    func setupMap() {
        let base: Unit = Unit(node: box)
        map = Map(unit: base, size: sizeMap)
    }
    
    func build2D(size: Int) {
        for i in 0..<size {
            map.appendNewRowInArea2D()
            for j in 0..<size {
                let unitBox: Unit = Unit(node: box)
                unitBox.node.position = map.getPositionUnit(x: CGFloat(i), y: 0, z: CGFloat(j))
                map.appendInArea2D(unit: unitBox, x: i)
            }
        }
    }
        
    func setupCamera() {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 1000
        self.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 10, y: 10, z: 40)
    }
    
    func loop(time: Double) {
        Timer.scheduledTimer(withTimeInterval: time, repeats: true) { timer in
            self.map.zPosition += 1
            self.map.calcSurroundings2D()
            self.map.calcRules2D(scene: self)
        }
    }
}
