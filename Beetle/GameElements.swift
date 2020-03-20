//
//  GameElements.swift
//  Beetle
//
//  Created by Johanes Riandy on 20/03/20.
//  Copyright © 2020 Johanes Riandy. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory: UInt32 = 0x1 << 0
    static let pillarCategory: UInt32 = 0x1 << 1
    static let flowerCategory: UInt32 = 0x1 << 2
    static let groundCategory: UInt32 = 0x1 << 3
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
extension CGPoint {
    static var upperLeft: CGPoint {
        return CGPoint(x: 0, y: 1)
    }
    
    static var upperCenter: CGPoint {
        return CGPoint(x: 0.5, y: 1)
    }
    
    static var upperRight: CGPoint {
        return CGPoint(x: 1, y: 1)
    }
    
    static var middleLeft: CGPoint {
        return CGPoint(x: 0, y: 0.5)
    }
    
    static var middleCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0.5)
    }
    
    static var middleRight: CGPoint {
        return CGPoint(x: 1, y: 0.5)
    }
    
    static var lowerLeft: CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    static var lowerCenter: CGPoint {
        return CGPoint(x: 0.5, y: 0)
    }
    
    static var lowerRight: CGPoint {
        return CGPoint(x: 1, y: 0)
    }
}

extension SKNode {
    func anchored(value: CGPoint, target: SKNode? = .none) -> CGPoint {
        guard let target = target ?? parent else { return position }
        let targetMin = convert(CGPoint(x: target.frame.minX, y: target.frame.minY), to: self)
        let targetMax = convert(CGPoint(x: target.frame.maxX, y: target.frame.maxY), to: self)
        let xPos = (targetMax.x - targetMin.x) * value.x + targetMin.x
        let yPos = (targetMax.y - targetMin.y) * value.y + targetMin.y
        return CGPoint(x: xPos, y: yPos)
    }
    
    func anchor(local: CGPoint, other: CGPoint, target: SKNode? = .none) -> CGPoint {
        let targetPos = anchored(value: other, target: target)
        let xPos = (frame.maxX - frame.minX) * local.x + frame.minX
        let yPos = (frame.maxY - frame.minY) * local.y + frame.minY
        let offset = CGPoint(x: targetPos.x - xPos, y: targetPos.y - yPos)
        let result = offset + position
        return result
    }
}

extension GameScene {
    func createBird() -> SKSpriteNode {
        // 1
        let bird = SKSpriteNode(texture: SKTextureAtlas(named: "player").textureNamed("bird1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // 2
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        // 3
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    func createRestartButton() {
        restartButton = SKSpriteNode(imageNamed: "restart")
        restartButton.size = CGSize(width: 100, height: 100)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.zPosition = 6
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    
    func createPauseButton() {
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.size = CGSize(width: 40, height: 40)
        pauseButton.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseButton.zPosition = 6
        self.addChild(pauseButton)
    }
    
    func createScoreLabel() {
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 5
        scoreLabel.fontSize = 50
        scoreLabel.fontName = "HelveticaNeue-Bold"
        
        let scoreBackground = SKShapeNode()
        scoreBackground.position = CGPoint(x: 0, y: 0)
        scoreBackground.path = CGPath(roundedRect: CGRect(x: -50, y: -30, width: 100, height: 100), cornerWidth: 50, cornerHeight: 50, transform: nil)
        scoreBackground.strokeColor = .clear
        scoreBackground.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        scoreBackground.zPosition = -1
        scoreLabel.addChild(scoreBackground)
        
        self.addChild(scoreLabel)
    }
    
    func createHighscoreLabel() {
        let highestScore = UserDefaults.standard.object(forKey: "highestScore")
        highscoreLabel.position = highscoreLabel.anchor(local: CGPoint.upperRight, other: CGPoint.upperRight, target: safeArea) - CGPoint(x: 10, y: 0)
        highscoreLabel.text = "Highest Score: \(highestScore ?? 0)"
        highscoreLabel.zPosition = 5
        highscoreLabel.fontSize = 15
        highscoreLabel.fontName = "Helvetica-Bold"
        
        self.addChild(highscoreLabel)
    }
    
    func createLogo() {
        logoImage = SKSpriteNode(imageNamed: "logo")
        logoImage.size = CGSize(width: 272, height: 65)
        logoImage.position = CGPoint(x:self.frame.midX, y: self.frame.midY + 100)
        logoImage.setScale(0.5)
        self.addChild(logoImage)
        logoImage.run(SKAction.scale(by: 1.0, duration: 0.3))
    }
    
    func createTaptoplayLabel() {
        taptoplayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 100)
        taptoplayLabel.text = "Tap anywhere to play"
        taptoplayLabel.fontColor = UIColor(red: 0.247, green: 0.31, blue: 0.569, alpha: 1.0)
        taptoplayLabel.zPosition = 5
        taptoplayLabel.fontSize = 20
        taptoplayLabel.fontName = "HelveticaNeue"
        self.addChild(taptoplayLabel)
    }
}

class SafeAreaNode: SKNode {
    override var frame: CGRect {
        get {
            return _frame
        }
    }
    private var _frame: CGRect = CGRect.zero
    
    func refresh() {
        guard let scene = scene, let view = scene.view else { return }
        let scaleFactor = min(scene.size.width, scene.size.height) / min(view.bounds.width, view.bounds.height)
        let x = view.safeAreaInsets.left * scaleFactor
        let y = view.safeAreaInsets.bottom * scaleFactor
        let width = (view.bounds.size.width - view.safeAreaInsets.right - view.safeAreaInsets.left) * scaleFactor
        let height = (view.bounds.size.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top) * scaleFactor
        let offsetX = scene.size.width * scene.anchorPoint.x
        let offsetY = scene.size.height * scene.anchorPoint.y
        _frame = CGRect(x: x - offsetX, y: y - offsetY, width: width, height: height)
    }
}
