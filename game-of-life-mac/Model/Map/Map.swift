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
    var area:   [[[Unit]]] = [[[Unit]]]()
    var width:  CGFloat = CGFloat()
    var height: CGFloat = CGFloat()
    var length: CGFloat = CGFloat()
    var n:      Int = Int()
    
    init(unit: Unit, n: Int) {
        self.n = n
        self.width  = unit.calcWidth()  * CGFloat(n)
        self.height = unit.calcHeight() * CGFloat(n)
        self.length = unit.calcLength() * CGFloat(n)
    }
    
    func getPositionUnit(x: CGFloat, y: CGFloat, z: CGFloat) -> SCNVector3 {
        let xUnit = ((width  / CGFloat(n)) * 0.5) + x * (width  / CGFloat(n))
        let yUnit = ((height / CGFloat(n)) * 0.5) + y * (height / CGFloat(n))
        let zUnit = ((length / CGFloat(n)) * 0.5) + z * (length / CGFloat(n))
        return SCNVector3(x: xUnit, y: yUnit, z: zUnit)
    }
}
