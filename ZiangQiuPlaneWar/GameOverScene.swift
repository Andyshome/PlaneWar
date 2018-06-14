//
//  GameOverScene.swift
//  ZiangQiuPlaneWar
//
//  Created by Qiu Ziang on 2018/6/6.
//  Copyright © 2018年 skylove. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    //get playername
    var playerName = ""
    init(size: CGSize,score:Int,playerResultName:String) {
        super.init(size: size)
        playerName = playerResultName
        backgroundColor = SKColor.white
        addscoreLb(score: score)
        addNameLb()
        addTG()
  
    }
    
   
    //set your score lb
    private func addscoreLb(score:Int) {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = String(score)
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
    }
    
    //set your name lb
    
    private func addNameLb() {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Name:"+playerName
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2+100)
        addChild(label)
    }

    
    
    //set the tip node , you can tap to exit
    
    private func addTG() {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Tap to exit"
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        addChild(label)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "doaSegue"), object: nil)
    }
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
