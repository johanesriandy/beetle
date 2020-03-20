//
//  GameViewController.swift
//  Beetle
//
//  Created by Johanes Riandy on 20/03/20.
//  Copyright © 2020 Johanes Riandy. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            view.ignoresSiblingOrder = false
            view.showsFPS = false
            view.showsNodeCount = false
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
                
            // Present the scene
            view.presentScene(scene)
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let view = self.view as? SKView else { return }
        (view.scene as? GameScene)?.refreshScene()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
