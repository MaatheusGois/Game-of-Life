//
//  Map.swift
//  game-of-life-mac
//
//  Created by Matheus Silva on 31/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import SceneKit

class Map {
    var area3D: [[[Unit]]] = [[[Unit]]]()
    var area2D: [[Unit]] = [[Unit]]()
    var width:  CGFloat = CGFloat()
    var height: CGFloat = CGFloat()
    var length: CGFloat = CGFloat()
    var size:   Int = Int()
    var base:   Unit = Unit()
    
    var zPosition = 0 //REMAKE
    
    init() {}
    
    convenience init(unit: Unit, size: Int) {
        self.init()
        self.size = size
        self.base = unit
        
        self.width  = unit.calcWidth()  * CGFloat(size)
        self.height = unit.calcHeight() * CGFloat(size)
        self.length = unit.calcLength() * CGFloat(size)
        self.area2D = [[Unit]](repeating: [Unit](), count: size)
    }
    
    init(area3D: [[[Unit]]], area2D: [[Unit]], width:  CGFloat, height: CGFloat, length: CGFloat, n: Int) {
        self.area3D = area3D
        self.area2D = area2D
        self.width = width
        self.height = height
        self.length = length
        self.size = n
    }
    
    func build2D() {
        for i in 0..<size {
            self.appendNewRowInArea2D()
            for j in 0..<size {
                let unitBox: Unit = Unit(node: base.node)
                unitBox.node.position = self.getPositionUnit(x: CGFloat(i), y: 0, z: CGFloat(j))
                self.appendInArea2D(unit: unitBox, x: i)
            }
        }
    }
    
    func getPositionUnit(x: CGFloat, y: CGFloat, z: CGFloat) -> SCNVector3 {
        let xUnit = ((width  / CGFloat(size)) * 0.5) + x * (width  / CGFloat(size))
        let yUnit = ((height / CGFloat(size)) * 0.5) + y * (height / CGFloat(size))
        let zUnit = ((length / CGFloat(size)) * 0.5) + z * (length / CGFloat(size))
        return SCNVector3(x: xUnit, y: yUnit, z: zUnit)
    }
    
    func getPositionUnitZ(z: CGFloat) -> CGFloat {
        let zUnit = ((length / CGFloat(size)) * 0.5) + z * (length / CGFloat(size))
        return zUnit
    }
    
    func appendNewRowInArea2D(){
        self.area2D.append([Unit]())
    }
    
    func appendInArea2D(unit: Unit, x: Int) {
        self.area2D[x].append(unit)
    }
    
    func getUnit2D(x: Int, y: Int) -> Unit? {
        //Calcula se esta dentro do range
        if x >= 0 && x < size && y >= 0 && y < size {
            return self.area2D[x][y]
        } else {
            return nil
        }
    }
    
    func getUnitState2D(x: Int, y: Int) -> UnitState {
        return self.area2D[x][y].state
    }
    
    func setSurroundings2D(x: Int, y: Int) {
        guard let unit = self.getUnit2D(x: x, y: y) else { return }
        unit.removeSurroundings2D()
        for i in -1...1 {
            for j in -1...1 {
                if i != 0 || j != 0 {
                    if let unitS = self.getUnit2D(x: x + i , y: y + j) {
                        unit.setSurroundings2D(unit: unitS)
                    } else {
                        unit.setSurroundings2D(unit: Unit())
                    }
                }
            }
        }
    }
    
    func draw(scene: SCNScene) {
        func initialDraw() {
            for i in 0..<size {
                for j in 0..<size {
                    let box: Unit = self.area2D[i][j]
                    if box.state == .alive {
                        scene.rootNode.addChildNode(box.node)
                    }
                }
            }
        }
    }
    
    func generateAleatory2D(by i: Int) {
        for _ in 0..<i {
            //Coloca uma box em uma posicao aleatoria
            let radomX = Int.random(in: 0..<size)
            let radomY = Int.random(in: 0..<size)
            self.changeStateOneUnit(x: radomX, y: radomY)
        }
    }
    
    func calcSurroundings2D() {
        for x in 0...size {
            for y in 0...size {
                setSurroundings2D(x: x, y: y)
            }
        }
    }
    
    func changeStateOneUnit(x: Int, y: Int) {
        if x >= 0 && x < size && y >= 0 && y < size {
            let selectdedBox = self.area2D[x][y]
            if selectdedBox.state == .dead {
                selectdedBox.state = .alive
            } else {
                selectdedBox.state = .dead
            }
        }
    }
    
    func calcRules2D(scene: SCNScene) {
        for i in 0..<size {
            for j in 0..<size {
                let box: Unit = self.area2D[i][j]
                if box.state == .alive {
                    if box.lonelyDeath() || box.overpopulationDeath() {
                        //                        box.node.removeFromParentNode()
                    }
                } else {
                    if box.populationAlive() {
                        guard let boxCopy = box.node.copy() as? SCNNode else { return }
                        boxCopy.position.y = self.getPositionUnitZ(z: CGFloat(zPosition))
                        scene.rootNode.addChildNode(boxCopy)
                    }
                }
            }
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Map(area3D: area3D, area2D: area2D, width: width, height: height, length: length, n: size)
        return copy
    }
}
