//
//  BirdScene.swift
//  FlappyBird3D
//
//  Created by Никита Комаров on 20.04.2021.
//

import SceneKit

class BirdScene: SCNScene, SCNSceneRendererDelegate {
    
    let emptyGrass = SCNNode()
    let emptyGrass2 = SCNNode()
    
    var runningUpdate = true
    var timeLast: Double?
    let speedConstant = -0.7
    
    
    convenience init(create: Bool) {
        self.init()
        setupScenery()
        setupCamera()
        
        let propsScene = SCNScene(named: "art.scnassets/Props.dae")!
        emptyGrass.scale = SCNVector3(easyScale: 0.15)
        emptyGrass.position = SCNVector3(0, -1.3, 0)
        
        emptyGrass2.scale = SCNVector3(easyScale: 0.15)
        emptyGrass2.position = SCNVector3(4.45, -1.3, 0)
        
        let grass = propsScene.rootNode.childNode(withName: "Ground", recursively: true)!
        grass.position = SCNVector3(-5.0, 0, 0)
        
        let grass2 = grass.clone()
        grass.position = SCNVector3(-5.0, 0, 0)
        
        emptyGrass.addChildNode(grass)
        emptyGrass2.addChildNode(grass2)
        
        rootNode.addChildNode(emptyGrass)
        rootNode.addChildNode(emptyGrass2)
    }
        func setupCamera()
        {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.camera!.usesOrthographicProjection = false
            cameraNode.position = SCNVector3(0, 0, 0)
            cameraNode.pivot = SCNMatrix4MakeTranslation(0, 0, -3)
            rootNode.addChildNode(cameraNode)
            
            let lightOne = SCNLight()
            lightOne.type = .spot
            lightOne.spotOuterAngle = 90
            lightOne.attenuationStartDistance = 0.0
            lightOne.attenuationFalloffExponent = 2
            lightOne.attenuationEndDistance = 30.0
            
            let lightNodeSpot = SCNNode()
            lightNodeSpot.light = lightOne
            lightNodeSpot.position = SCNVector3(0, 10, 1)
            rootNode.addChildNode(lightNodeSpot)
            
            let lightNodeFront = SCNNode()
            lightNodeFront.light = lightOne
            lightNodeFront.position = SCNVector3(0, 1, 15)
            rootNode.addChildNode(lightNodeFront)
            
            let emptyAtCenter = SCNNode()
            emptyAtCenter.position = SCNVector3Zero
            rootNode.addChildNode(emptyAtCenter)
            
            lightNodeSpot.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
            lightNodeFront.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
            cameraNode.constraints = [SCNLookAtConstraint(target: emptyAtCenter)]
            
            let ambientLight = SCNNode()
            ambientLight.light = SCNLight()
            ambientLight.light!.type = .ambient
            ambientLight.light!.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            rootNode.addChildNode(ambientLight)
            
        }
    
    
    func setupScenery()
    {
        let groundGeom = SCNBox(width: 4, height: 0.5, length: 0.4, chamferRadius: 0)
        groundGeom.firstMaterial?.diffuse.contents = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        groundGeom.firstMaterial?.specular.contents = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        groundGeom.firstMaterial?.emission.contents = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
        
        let groundNode = SCNNode(geometry: groundGeom)
        let emptyGround = SCNNode()
        emptyGround.addChildNode(groundNode)
        emptyGround.position.y = -1.63
        rootNode.addChildNode(emptyGround)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let deltaTime: Double
        
        if runningUpdate {
            if let lt = timeLast {
                deltaTime = time - lt
            } else {
                deltaTime = 0
            }
        } else {
            deltaTime = 0
        }
        timeLast = time
    }
    
    func moveGrass(node: SCNNode, deltaTime: Double)
}



extension SCNVector3
{
    init (easyScale: Float)
    {
        self.init()
        self.x = easyScale
        self.y = easyScale
        self.z = easyScale
    }
}
