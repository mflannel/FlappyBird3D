//
//  BirdScene.swift
//  FlappyBird3D
//
//  Created by Никита Комаров on 20.04.2021.
//

import SceneKit

class BirdScene: SCNScene {
    convenience init(create: Bool) {
        self.init()
        setupScenery()
        setupCamera()
        print("Bird Scene")
    }
        func setupCamera()
        {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.camera!.usesOrthographicProjection = false
            cameraNode.position = SCNVector3(0, 0, 0)
            cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -3)
            rootNode.addChildNode(cameraNode)
        }
    func setupScenery()
    {
        let groundGeom = SCNBox(width: 4, height: 0.5, length: 0.4, chamferRadius: 0)
        let groundNode = SCNNode(geometry: groundGeom)
        rootNode.addChildNode(groundNode)
        groundNode.position.y = -1.63
    }
}
