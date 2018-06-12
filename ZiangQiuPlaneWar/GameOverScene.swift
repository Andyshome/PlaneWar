//
//  GameOverScene.swift
//  ZiangQiuPlaneWar
//
//  Created by Qiu Ziang on 2018/6/6.
//  Copyright © 2018年 skylove. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var playerName = ""
    
    init(size: CGSize,score:Int,playerResultName:String) {
        super.init(size: size)
        playerName = playerResultName
        backgroundColor = SKColor.white
        addscoreLb(score: score)
        addTG()
    }
    
    private func addscoreLb(score:Int) {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text =  playerName + ":" + String(score)
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
    }
    
    
    private func addTG() {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Tap to try again"
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        addChild(label)
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let scene = Games(size: self.size,name:playerName)
        self.view?.presentScene(scene, transition:reveal)
    }
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
