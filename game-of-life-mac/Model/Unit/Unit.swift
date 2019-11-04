//
//  Unit.swift
//  game-of-life-mac
//
//  Created by Matheus Silva on 31/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Cocoa
import SceneKit

class Unit: SCNNode {
    var state: UnitState = .dead
    var surroundings2D: [Unit] = [Unit]()
    var width: CGFloat = CGFloat()
    var height: CGFloat = CGFloat()
    var length: CGFloat = CGFloat()
    var min: SCNVector3 = SCNVector3()
    var max: SCNVector3 = SCNVector3()
    var node: SCNNode = SCNNode()
    
    override init() {
        super.init()
    }
    
    convenience init(node: SCNNode) {
        self.init()
        guard let nodeCopy = node.copy() as? SCNNode else { return }
        self.node = nodeCopy
        self.min = node.boundingBox.min 
        self.max = node.boundingBox.max
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNewPosition(x: Int, y: Int, z: Int, map: Map) {
        self.position = map.getPositionUnit(x: CGFloat(x), y: CGFloat(y), z: CGFloat(z))
    }
    
    func calcWidth() -> CGFloat {
        return CGFloat(max.x - min.x) * 0.314
    }
    
    func calcHeight() -> CGFloat {
        return CGFloat(max.y - min.y) * 0.314
    }
    
    func calcLength() -> CGFloat {
        return CGFloat(max.z - min.z) * 0.314
    }
    
    func changeState() {
        self.state = self.state == .alive ? .dead : .alive
    }
    
    func setSurroundings2D(unit: Unit) {
        self.surroundings2D.append(unit)
    }
    
    func getSurroundings2D() -> [Unit] {
        return self.surroundings2D
    }
    
    func removeSurroundings2D() {
        self.surroundings2D.removeAll()
    }
    
    func howMuchSurroundAlive2D() -> Int {
        var count = 0
        for i in 0 ..< self.getSurroundings2D().count {
            if self.surroundings2D[i].state == .alive {
                count += 1
            }
        }
        return count
    }
    
    ///Qualquer célula viva com menos de dois vizinhos vivos morre de solidão.
    func lonelyDeath() -> Bool {
        if howMuchSurroundAlive2D() < 2 {
            self.state = .dead
            return true
        }
        return false
    }
    
    ///Qualquer célula viva com mais de três vizinhos vivos morre de superpopulação.
    func overpopulationDeath() -> Bool {
        if howMuchSurroundAlive2D() > 3 {
            self.state = .dead
            return true

        }
        return false
    }
    
    ///Qualquer célula morta com exatamente três vizinhos vivos se torna uma célula viva.
    func populationAlive() -> Bool {
        if howMuchSurroundAlive2D() == 3 {
            self.state = .alive
            return true
        }
        return false
    }
    
}
