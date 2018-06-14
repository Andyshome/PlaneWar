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
  
    
    //prevent reload the scene then you play again, it works several times , so you could only start this game in name view controller/
    
    var shouldPlay = false
    var playerName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldPlay == true{
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                let scene = Games(size: view.bounds.size,name:playerName)
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                // Present the scene
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
                view.presentScene(scene)
                shouldPlay = false
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.doaSegue), name: NSNotification.Name(rawValue: "doaSegue"), object: nil)
    }
    
    
    //set the exit function
    @objc func doaSegue(){
        performSegue(withIdentifier: "exit", sender: self)
        self.view.removeFromSuperview()
        self.view = nil
    }
    // set up
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
