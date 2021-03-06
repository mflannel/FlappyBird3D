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
    
    var emptyPipe1 = SCNNode()
    var emptyPipe2 = SCNNode()
    var emptyPipe3 = SCNNode()
    var emptyPipe4 = SCNNode()
    
    let emptyBird = SCNNode()
    var bird = SCNNode()
    
    var rotationSeq = SCNAction()
    
    enum ColliderCategory: Int
    {
        case Bird = 1
        case Pipe
        case Ground
    }
    
    
    convenience init(create: Bool) {
        self.init()
        
        let rotationAction1 = SCNAction.rotate(toAxisAngle: SCNVector4(1, 0, 0, 0.78), duration: 0.1)
        let rotationAction2 = SCNAction.rotate(toAxisAngle: SCNVector4(1, 0, 0, -1.57), duration: 1)
        rotationAction2.timingMode = .easeOut
        
        rotationSeq = SCNAction.sequence([rotationAction1, rotationAction2])
        
        setupScenery()
        setupCamera()
        
        physicsWorld.gravity = SCNVector3(0, -5.0, 0)
        
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
        
        let bottomPipe = propsScene.rootNode.childNode(withName: "Pipe", recursively: true)!
        let topPipe = bottomPipe.clone()
        
        topPipe.rotation = SCNVector4(0, 0, 1, Double.pi)
        topPipe.position = SCNVector3(0, 13, 0)
        
        let emptyPipe = SCNNode()
        emptyPipe.addChildNode(topPipe)
        emptyPipe.addChildNode(bottomPipe)
        emptyPipe.scale = SCNVector3(easyScale: 0.15)
        emptyPipe.physicsBody = SCNPhysicsBody.kinematic()
        emptyPipe.physicsBody!.categoryBitMask = ColliderCategory.Pipe.rawValue
        
        if #available(iOS 9.0, *)
        {
            emptyPipe.physicsBody!.contactTestBitMask = ColliderCategory.Bird.rawValue
        } else {
            emptyPipe.physicsBody!.collisionBitMask = ColliderCategory.Bird.rawValue
        }
        
        emptyPipe1 = emptyPipe.clone()
        emptyPipe1.position = SCNVector3(2, randomHeight(), 0)
        emptyPipe1.physicsBody = emptyPipe.physicsBody?.copy() as? SCNPhysicsBody
        
        emptyPipe2 = emptyPipe.clone()
        emptyPipe2.position = SCNVector3(3, randomHeight(), 0)
        emptyPipe2.physicsBody = emptyPipe.physicsBody?.copy() as? SCNPhysicsBody
        
        emptyPipe3 = emptyPipe.clone()
        emptyPipe3.position = SCNVector3(4, randomHeight(), 0)
        emptyPipe3.physicsBody = emptyPipe.physicsBody?.copy() as? SCNPhysicsBody
        
        emptyPipe4 = emptyPipe.clone()
        emptyPipe4.position = SCNVector3(5, randomHeight(), 0)
        emptyPipe4.physicsBody = emptyPipe.physicsBody?.copy() as? SCNPhysicsBody
        
        rootNode.addChildNode(emptyPipe1)
        rootNode.addChildNode(emptyPipe2)
        rootNode.addChildNode(emptyPipe3)
        rootNode.addChildNode(emptyPipe4)
        
        let birdScene = SCNScene(named: "art.scnassets/FlappyBird.dae")!
        bird = birdScene.rootNode.childNode(withName: "Bird", recursively: true)!
        emptyBird.addChildNode(bird)
        emptyBird.scale = SCNVector3(easyScale: 0.08)
        emptyBird.rotation = SCNVector4(0, 1, 0, -1.57)
        emptyBird.position = SCNVector3(-0.3, 0, 0)
        
        let birdGeo = SCNSphere(radius: 0.05)
        
        emptyBird.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: birdGeo, options: nil))
        emptyBird.physicsBody!.mass = 5
        emptyBird.physicsBody!.velocityFactor = SCNVector3(1, 1, 0)
        emptyBird.physicsBody!.angularVelocityFactor = SCNVector3Zero
        emptyBird.physicsBody!.categoryBitMask = ColliderCategory.Bird.rawValue
        
        if #available(iOS 9.0, *)
        {
            emptyBird.physicsBody!.contactTestBitMask = ColliderCategory.Ground.rawValue |
                ColliderCategory.Pipe.rawValue
        } else {
            emptyBird.physicsBody!.collisionBitMask = ColliderCategory.Ground.rawValue |
                ColliderCategory.Pipe.rawValue
        }
        
        rootNode.addChildNode(emptyBird)
        
        
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
        
        let collideGround = SCNNode(geometry: groundGeom)
        collideGround.opacity = 0
        collideGround.physicsBody = SCNPhysicsBody.kinematic()
        collideGround.physicsBody!.mass = 1000
        
        collideGround.physicsBody!.categoryBitMask = ColliderCategory.Ground.rawValue
        
        if #available(iOS 9.0, *)
        {
            collideGround.physicsBody!.contactTestBitMask = ColliderCategory.Bird.rawValue
        } else {
            collideGround.physicsBody!.collisionBitMask = ColliderCategory.Bird.rawValue
            
        }
        collideGround.position.y = -1.36
        rootNode.addChildNode(collideGround)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let deltaTime: Double
        
        if runningUpdate == true {
            if let lt = timeLast {
                deltaTime = time - lt
            } else {
                deltaTime = 0
            }
        } else {
            deltaTime = 0
        }
        timeLast = time
        
        moveGrass(node: emptyGrass, deltaTime: deltaTime)
        moveGrass(node: emptyGrass2, deltaTime: deltaTime)
        movePipe(node: emptyPipe1, deltaTime: deltaTime)
        movePipe(node: emptyPipe2, deltaTime: deltaTime)
        movePipe(node: emptyPipe3, deltaTime: deltaTime)
        movePipe(node: emptyPipe4, deltaTime: deltaTime)
        
    }
    
    func moveGrass(node: SCNNode, deltaTime: Double)
    {
        node.position.x += Float(deltaTime * speedConstant)
        if node.position.x <= -4.45
        {
            node.position.x = 4.45
        }
    }
    
    func movePipe(node: SCNNode, deltaTime: Double)
    {
        node.position.x += Float(deltaTime * speedConstant)
        if node.position.x <= -2
        {
            node.position.x = 2
            node.position.y = randomHeight()
        }
    }
    
    func randomHeight() -> Float
    {
        var newHeight = Float(arc4random_uniform(13))
        newHeight /= -10.0
        
        return newHeight
    }
    
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
