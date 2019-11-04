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
    
    let boxScene: SCNScene? = SCNScene(named: "art.scnassets/box.scn")
    let sizeMap: Int = 10
    var zPosition: Int = 0
    var timeByGeneration: Double = 0.5
    var timer: Timer?
    var state: GameState = .stoped
    
    public func setupScene() {
        
        self.setupBox()
        self.setupMap()
    
        self.map.build2D()
        self.map.generateAleatory2D(by: 1000)
        
        self.map.draw(scene: self)
    }
    
    public func start() {
        if self.state == .stoped {
            self.loop()
            self.state = .started
        }
    }
    
    public func stop() {
        if self.state == .started {
            self.removeLoop()
            self.state = .stoped
        }
    }
    
    public func restart() {
        self.cleanAll()
        self.state = .stoped
        self.removeLoop()
        
        self.map.clean()
        self.map.build2D()
        self.map.generateAleatory2D(by: 1000)
        self.map.draw(scene: self)
    }
    
    public func changeTimeByGeneration(time: Double) {
        if self.state == .started {
            self.removeLoop()
            self.timeByGeneration = time
            self.loop()
        }
    }
    
    @objc public func nextGeneration() {
        self.map.zPosition += 1
        self.map.calcSurroundings2D()
        self.map.calcRules2D(scene: self)
    }
    
    private func setupBox() {
        guard let boxScene = SCNScene(named: "art.scnassets/box.scn") else { return }
        if let box = boxScene.rootNode.childNode(withName: "box", recursively: false) {
            self.box = box
        }
    }
    
    private func setupMap() {
        let base: Unit = Unit(node: box)
        self.map = Map(unit: base, size: sizeMap)
    }
    
    private func setupCamera() {
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.zFar = 1000
        self.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 10, y: 10, z: 40)
    }
    
    private func loop() {
        timer = Timer(timeInterval: timeByGeneration, target: self, selector: #selector(nextGeneration), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func removeLoop() {
        self.timer?.invalidate()
    }
    
    private func cleanAll() {
        self.rootNode.enumerateChildNodes { (node, stop) in
            if let name = node.name {
                if name == "box" {
                    node.removeFromParentNode()
                }
            }
            
        }
    }

}
