//
//  GameSKOverlay.swift
//  FlappyBird3D
//
//  Created by Никита Комаров on 23.04.2021.
//

import UIKit
import SpriteKit

class GameSKOverlay: SKScene
{
    var playButtonNode = SKSpriteNode()
    var titleGame = SKSpriteNode()
    
    var scoreLabel = SKLabelNode(fontNamed: "Arial")
    var scoreNumber = 0
    
    var mainView: GameViewController?
    
    convenience init(main: GameViewController, size: CGSize) {
        self.init(sceneSize: size)
        mainView = main
    }
    
    convenience init(sceneSize: CGSize)
    {
        self.init(size: sceneSize)
        
        
        let playTexture = SKTexture(image: UIImage(named: "Play")!)
        playButtonNode = SKSpriteNode(texture: playTexture)
        playButtonNode.size = CGSize(width: 100, height: 100)
        playButtonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playButtonNode.position = CGPoint(x: self.size.width / 2, y: (self.size.height) - 400)
        playButtonNode.name = "playButton"
        
        self.addChild(playButtonNode)
        
        let titleTexture = SKTexture(image: UIImage(named: "Title")!)
        titleGame = SKSpriteNode(texture: titleTexture)
        titleGame.size = CGSize(width: 150, height: 150)
        titleGame.position = CGPoint(x: self.size.width / 2, y: (self.size.height) - 100)
        
        self.addChild(titleGame)
        
        scoreLabel.text = "0"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.fontSize = 64
        scoreLabel.position = CGPoint(x: self.size.width / 7, y: self.size.height - 75)
        
    }
    
    func addScoreLabel()
    {
        scoreNumber = 0
        scoreLabel.text = String(scoreNumber)
        
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let main = mainView {
            main.touchesFunction(touches, with: event)
        }
    }
}
