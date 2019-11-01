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
    var map: Map = Map()
    var nextState: [[UnitState]] = [[UnitState]]()
    
    let boxScene = SCNScene(named: "art.scnassets/box.scn")
    let n = 10
    var zPosition = 0
    
    func setupScene() {
        
        guard let boxScene = SCNScene(named: "art.scnassets/box.scn") else { return }
        guard let box = boxScene.rootNode.childNode(withName: "box", recursively: false) else { return }
        guard let voidBox = boxScene.rootNode.childNode(withName: "voidBox", recursively: false) else { return }
        
        
        let base: Unit = Unit(node: box)
        map = Map(unit: base, n: n)
        
        
        //MONTAR A MATRIX && DESENHAR A MATRIX
        for i in 0...n {
            map.appendNewRowInArea2D()
            for j in 0...n {
                let boxVoid: Unit = Unit(node: voidBox)
                boxVoid.node.position = map.getPositionUnit(x: CGFloat(i), y: 0, z: CGFloat(j))
                map.appendInArea2D(unit: boxVoid, x: i)
            }
        }
        
        //Gerar aleatorios iniciais
        for _ in 0...40 {
            self.aleatoryAlive()
        }
        
        // FAZ A FORMA PARA A PROXIMA GERACAO
        self.drawBox(box: box, voidBox: voidBox)
            

        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.zPosition += 1
            self.map.calcSurroundings2D()
            self.calcRules()
        }

        
        
            
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 10, y: 10, z: 40)
    }
    
    func calcRules() {
        for i in 0...n {
            for j in 0...n {
                let box: Unit = map.area2D[i][j]
                if box.state == .alive {
                    if box.lonelyDeath() || box.overpopulationDeath() {
//                        box.node.removeFromParentNode()
                    }
                } else {
                    if box.populationAlive() {
                        guard let boxCopy = box.node.copy() as? SCNNode else { return }
                        boxCopy.position.y = map.getPositionUnitZ(z: CGFloat(zPosition))
                        self.rootNode.addChildNode(boxCopy)
                    }
                }
            }
        }
    }
    
    func createBox(box: SCNNode, in pos: SCNVector3) -> SCNNode {
        guard let boxCopy = box.copy() as? SCNNode else { return SCNNode() }
        boxCopy.position = pos
        return boxCopy
    }
    
    
    func drawBox(box boxFull: SCNNode, voidBox: SCNNode) {
        for i in 0...n {
            for j in 0...n {
                let box: Unit = map.area2D[i][j]
                
                if box.state == .alive {
                    self.rootNode.addChildNode(box.node)
                }
            }
        }
    }
    
    func aleatoryAlive() {
        //Coloca uma box em uma posicao aleatoria
        let radomX = Int.random(in: 0...n)
        let radomY = Int.random(in: 0...n)
        map.changeStateOneUnit(x: radomX, y: radomY)
    }
        
    func setupCamera() {
        
    }
}
