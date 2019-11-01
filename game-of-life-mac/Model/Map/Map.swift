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
    var area3D:   [[[Unit]]] = [[[Unit]]]()
    var area2D:   [[Unit]] = [[Unit]]()
    var width:  CGFloat = CGFloat()
    var height: CGFloat = CGFloat()
    var length: CGFloat = CGFloat()
    var n:      Int = Int()
    
    init() {}
    
    convenience init(unit: Unit, n: Int) {
        self.init()
        self.n = n
        self.width  = unit.calcWidth()  * CGFloat(n)
        self.height = unit.calcHeight() * CGFloat(n)
        self.length = unit.calcLength() * CGFloat(n)
        self.area2D = [[Unit]](repeating: [Unit](), count: n)
    }
    
    init(area3D: [[[Unit]]], area2D: [[Unit]], width:  CGFloat, height: CGFloat, length: CGFloat, n: Int) {
        self.area3D = area3D
        self.area2D = area2D
        self.width = width
        self.height = height
        self.length = length
        self.n = n
    }
    
    
    
    func getPositionUnit(x: CGFloat, y: CGFloat, z: CGFloat) -> SCNVector3 {
        let xUnit = ((width  / CGFloat(n)) * 0.5) + x * (width  / CGFloat(n))
        let yUnit = ((height / CGFloat(n)) * 0.5) + y * (height / CGFloat(n))
        let zUnit = ((length / CGFloat(n)) * 0.5) + z * (length / CGFloat(n))
        return SCNVector3(x: xUnit, y: yUnit, z: zUnit)
    }
    
    func appendNewRowInArea2D(){
        self.area2D.append([Unit]())
    }
    
    func appendInArea2D(unit: Unit, x: Int) {
        self.area2D[x].append(unit)
    }
    
    func getUnit2D(x: Int, y: Int) -> Unit? {
        //Calcula se esta dentro do range
        if x >= 0 && x < n && y >= 0 && y < n {
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
    
    func calcSurroundings2D() {
        for x in 0...n {
            for y in 0...n {
                setSurroundings2D(x: x, y: y)
            }
        }
    }
    
    func changeStateOneUnit(x: Int, y: Int) {
        if x >= 0 && x < n && y >= 0 && y < n {
            let selectdedBox = self.area2D[x][y]
            if selectdedBox.state == .dead {
                selectdedBox.state = .alive
            } else {
                selectdedBox.state = .dead
            }
        }
    }
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Map(area3D: area3D, area2D: area2D, width: width, height: height, length: length, n: n)
        return copy
    }
}
