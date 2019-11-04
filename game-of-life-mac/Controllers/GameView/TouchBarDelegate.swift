//
//  TouchBarDelegate.swift
//  game-of-life-mac
//
//  Created by Matheus Silva on 04/11/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation
import SceneKit
import QuartzCore

@available(OSX 10.12.1, *)
extension GameViewController: NSTouchBarDelegate {
    
    
    @IBAction func playButton(_ sender: Any) {
//        print("Here")
        scene?.start()
    }
    @IBAction func stopButton(_sender: Any) {
        scene?.stop()
    }
    @IBAction func sliderValueChanged(_ sender: NSSliderTouchBarItem) {
        let currentValue = sender.doubleValue / 100
        scene?.changeTimeByGeneration(time: 1 - currentValue)
    }
    
    @IBAction func restartButton(_sender: Any) {
        scene?.restart()
    }
}
