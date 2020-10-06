//
//  ArPlayerNode.swift
//  Ryukito_AR
//
//  Created by kouki on 2020/09/28.
//  Copyright © 2020 又吉琉稀斗. All rights reserved.
//

import Foundation
import SceneKit

class ArPlayerNode: ArSuperNode {
    var playerObj: SCNGeometry
    var playerNode: SCNNode

    init (playerObj: SCNGeometry) {
        self.playerObj = playerObj
        self.playerNode = SCNNode(geometry: playerObj)
    }
    
    var playerPosition: SCNVector3 {
        get {
            return self.playerNode.position
        }
        set (position) {
            self.playerNode.position = position
        }
    }
}
