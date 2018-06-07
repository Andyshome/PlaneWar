//
//  GameViewController.swift
//  ZiangQiuPlaneWar
//
//  Created by Qiu Ziang on 2018/6/6.
//  Copyright © 2018年 skylove. All rights reserved.
//
import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    
    var playerName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = Games(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            // Present the scene
            scene.playerName = playerName
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
