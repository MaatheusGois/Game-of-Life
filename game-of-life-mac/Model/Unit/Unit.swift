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
    var surroundings: [[Unit]] = [[Unit]]()
    var width: CGFloat = CGFloat()
    var height: CGFloat = CGFloat()
    var length: CGFloat = CGFloat()
    var min: SCNVector3 = SCNVector3()
    var max: SCNVector3 = SCNVector3()
    var node: SCNNode = SCNNode()
    
    init(node: SCNNode) {
        super.init()
        guard let nodeCopy = node.copy() as? SCNNode else { return }
        self.node = nodeCopy
        self.min = node.boundingBox.min 
        self.max = node.boundingBox.max
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calcWidth() -> CGFloat {
        return CGFloat(max.x - min.x) * 0.1
    }
    
    func calcHeight() -> CGFloat {
        return CGFloat(max.y - min.y) * 0.1
    }
    
    func calcLength() -> CGFloat {
        return CGFloat(max.z - min.z) * 0.1
    }
    
    func changeState() {
        self.state = self.state == .alive ? .dead : .alive
    }
}
