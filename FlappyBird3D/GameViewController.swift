//
//  GameViewController.swift
//  FlappyBird3D
//
//  Created by Никита Комаров on 20.04.2021.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var gameScene: BirdScene?
    var menuScene: MenuScene?
    static var gameOverlay: GameSKOverlay?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
    }
    
    func setupView()
    {
        scnView = (self.view as! SCNView)
    }
    
    func setupScene()
    {
        menuScene = MenuScene(create: true)
        GameViewController.gameOverlay = GameSKOverlay(main: self, size: self.view.frame.size)
        
        if let scene = menuScene, let overlay = GameViewController.gameOverlay
        {
            scnView.scene = scene
            scnView.isPlaying = true
            scnView.delegate = scene
            scnView.overlaySKScene = overlay
            scnView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        }

    }
    
    func checkNodeAtPosition(_ touch: UITouch) -> String?
    {
        if let skOverlay = GameViewController.gameOverlay
        {
            let location = touch.location(in: scnView)
            let node = skOverlay.atPoint(CGPoint(x: location.x, y: self.scnView.frame.size.height - location.y))
            
            if let name = node.name
            {
                return name
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    func changeScene(_ newScene: SCNScene?, newDelegate: SCNSceneRendererDelegate?, completion: (()-> Void)!)
    {
        if let scene = newScene, let skOverlay = GameViewController.gameOverlay, let delegate = newDelegate
        {
            skOverlay.removeAllChildren()
            scnView.scene = scene
            scnView.delegate = delegate
            completion()
        }
    }
    
    func touchesFunction(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = gameScene
        {
            scene.emptyBird.physicsBody?.velocity = SCNVector3(0, 2, 0)
            scene.bird.runAction(scene.rotationSeq)
        }
        
        if let touch = touches.first {
            if let name = checkNodeAtPosition(touch)
            {
                if name == "playButton"
                {
                    gameScene = BirdScene(create: true)
                    changeScene(gameScene, newDelegate: gameScene, completion: {
                        GameViewController.gameOverlay!.addScoreLabel()
                        self.menuScene = nil
                    })
                }
            }
        }
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
