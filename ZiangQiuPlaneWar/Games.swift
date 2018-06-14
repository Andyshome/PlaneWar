//
//  Games.swift
//  ZiangQiuPlaneWar
//
//  Created by Qiu Ziang on 2018/6/6.
//  Copyright © 2018年 skylove. All rights reserved.
//

import SpriteKit
import AVFoundation

class Games: SKScene, SKPhysicsContactDelegate {
    // set up array of these nodes
    var monsterArray : [SKSpriteNode] = [SKSpriteNode]()
    var bulletArray : [SKSpriteNode] = [SKSpriteNode]()
    //create a player
    let player = SKSpriteNode.init(imageNamed: "Spaceship")
    //create general node and score variable
    var score = 0
    var scorLb:SKLabelNode?
    var nameLb:SKLabelNode?
    var playerName = ""
    var totalMonster = 0
    var supplyNode = SKSpriteNode.init(imageNamed: "supply")
    var boss = SKSpriteNode.init(imageNamed: "boss")
    //set the boss hp
    var bossHp = 10
    // determine the plane could move or not
    private var shouldMove = false
    // play sound
    lazy var shootSoundAction = { () -> SKAction in
        let action = SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false)
        return action
    }()

    //add scorelb node
    private func addScoreLb() {
        scorLb = SKLabelNode.init(fontNamed: "Chalkduster")
        scorLb?.text = "0"
        scorLb?.fontSize = 20
        scorLb?.fontColor = .black
        scorLb?.zPosition = 4
        scorLb?.position = .init(x: 50, y: size.height - 80)
        addChild(scorLb!)
    }
    // add name node
    private func addName() {
        nameLb = SKLabelNode.init(fontNamed: "Helvetica")
        nameLb?.text = playerName
        nameLb?.zPosition = 14
        nameLb?.fontSize = 24
        nameLb?.fontColor = .black
        nameLb?.zPosition = 2
        nameLb?.position = .init(x: 50, y: size.height - 40)
        addChild(nameLb!)
    }
    //ad background node
    private func addBg() {
        let bgNode = SKSpriteNode.init(imageNamed: "bg_01")
        bgNode.position = .zero
        bgNode.zPosition = 0
        bgNode.anchorPoint = .zero
        bgNode.size = size
        addChild(bgNode)
    }
    //set up basic things when the game starts
     init(size : CGSize,name:String) {
        super.init(size: size)
        playerName = name
        addNode()
    }
    //default
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //add node function
    
    private func addNode(){
        addHero()
        addBg()
        addScoreLb()
        addName()
        addMonster()
    }
    
    
    

    
    
    
    // add monster forever
    private func addMonster(){
        weak var wkself = self
        let addMonsterAction = SKAction.run {
            wkself?.getMonster()
        }
        let waitAction = SKAction.wait(forDuration: 0.2)
        let sequence = SKAction.sequence([addMonsterAction,waitAction])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction)
        
        
    }
    // get monster to the add monster function to add
    private func getMonster(){
        addSupply()
        addBoss()
        // set different speeed for different monster
        weak var wkself = self
        let minimumDuration:Int = 4
        let maximumDuration:Int = 5
        // random get a  duration
        let duration = Int(arc4random_uniform((UInt32(maximumDuration - minimumDuration)))) + minimumDuration
        // set up a monster
        let monster = SKSpriteNode.init(imageNamed: "enemy-1")
        // before background
        monster.zPosition = 13
        // set x
        let minx:Int = Int(monster.size.width / 2)
        let maxx:Int = Int(size.width - monster.size.width / 2)
        let gapx:Int = maxx - minx
        let xpos:Int = Int(arc4random_uniform(UInt32(gapx))) + minx
        monster.position = .init(x: CGFloat(xpos), y: (size.height + monster.size.height/2))
        addChild(monster)
        // find out how much total monster we set up
        totalMonster += 1
        // add this data to monster array
        monsterArray.append(monster)
        let move = SKAction.moveTo(y: -monster.size.height/2, duration: TimeInterval(duration))
        let remove = SKAction.run {
            monster.removeFromParent()
            let index = wkself?.monsterArray.index(of:monster)
            if index != nil {
                wkself?.monsterArray.remove(at: index!)
            }
        }
        //run the monster
        
        monster.run(SKAction.sequence([move,remove]))
    }
    // add supply if you need
    private func addSupply(){
        //random chance to add a supply
        if arc4random_uniform(100) < 98 {
            return
        }
        // prevent there are two bossese in this screne
        if supplyNode.parent != nil {
            return
        }
        // set the place of the supply
        let supplyx = CGFloat(arc4random_uniform(UInt32(size.width - supplyNode.size.width))) + supplyNode.size.width/2
        supplyNode.zPosition = 14
        supplyNode.removeAllActions()
        supplyNode.position = .init(x: supplyx, y: size.height + size.height + supplyNode.size.height/2)
        addChild(supplyNode)
        // run it
        let move = SKAction.moveTo(y: -supplyNode.size.height/2, duration: TimeInterval(5))
        supplyNode.run(move, completion: {
            self.supplyNode.removeFromParent()
        })
    }
    
    
    // shoot function
    
    private func shoot() {
        
        // get a bullet node
        let bulletNode = SKSpriteNode.init(imageNamed: "bullet-1")
        bulletNode.position = player.position
        addChild(bulletNode)
        bulletArray.append(bulletNode)
        // prevent it behind the background
        bulletNode.zPosition = 14
        let distence = size.height - bulletNode.position.y
        let speed = size.height
        let duration = distence / speed
        let move = SKAction.moveTo(y: size.height, duration: TimeInterval(duration))
        weak var wkbullet = bulletNode
        weak var wkself = self
        let group = SKAction.group([move,shootSoundAction])
        bulletNode.run(group,completion:{
            wkbullet?.removeFromParent()
            let index = wkself?.bulletArray.index(of: wkbullet!)
            if index != nil {
                wkself?.bulletArray.remove(at: index!)
            }
        })
    }
    // add a player node in this game.
    private func addHero(){
        player.size = .init(width: 40, height: 40)
        player.position = .init(x: size.width/2, y:player.size.height/2)
        player.name = "Spaceship"
        addChild(player)
        player.zPosition = 12
        weak var wkself = self
        let shootAction = SKAction.run {
            wkself?.shoot()
        }
        let wait = SKAction.wait(forDuration: 0.2)
        let sequenceAction = SKAction.sequence([shootAction,wait])
        let repeatShootAction = SKAction.repeatForever(sequenceAction)
        run(repeatShootAction)
    }
    
    
    //add boss in this game, score smaller than 50 boss would not come, there would not be 2 boss at same time
    private func addBoss(){
        if score < 50 {
            return
        }
        if arc4random_uniform(100) < 50 {
            return
        }
        if boss.parent != nil {
            return
        }
        boss.size = .init(width:200,height:400)
        bossHp = 10
        let bossx = CGFloat(arc4random_uniform(UInt32(size.width - boss.size.width))) + boss.size.width/2
        boss.removeAllActions()
        boss.position = .init(x: bossx, y: size.height + size.height + boss.size.height/2)
        boss.zPosition = 12
        addChild(boss)
        let move = SKAction.moveTo(y: -boss.size.height/2, duration: TimeInterval(6.5))
        boss.run(move, completion: {
            self.boss.removeFromParent()
        })
    }
    
    
    
    
    
    // touch first place to control the game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        var frm = player.frame
        frm = .init(x: frm.origin.x, y: frm.origin.y, width: frm.size.width + 100, height: frm.size.height + 100)
        if !frm.contains(location) {
            shouldMove = false
        }else{
            shouldMove = true
        }
    }
    
    //plane follow your finger's position
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  shouldMove else {
            return
        }
        let touch = touches.first!
        let previousPosition = touch.previousLocation(in: view)
        let currentPosition = touch.location(in: view)
        let offsetx = currentPosition.x - previousPosition.x
        let offsety = currentPosition.y - previousPosition.y
        let x = player.position.x + offsetx
        guard  x >= player.size.width/2, x <= size.width - player.size.width/2 else {
            return
        }
        let y = player.position.y - offsety
        guard y >= player.size.height/2, y <= size.height - player.size.height/2 else {
            return
        }
        player.position = .init(x: x , y: y)
    }
    
    

    func saveData(data:String) {
        // load the data before
        guard let arrayListObject = UserDefaults.standard.object(forKey: "nomalMode") else {
            print("error")
            return
        }
        // get the array
        guard var arrayList = arrayListObject as? Array<String> else {
            return
        }
        // append the data
        arrayList.append(data)
        // save the data to user defaults
        print(arrayList)
        UserDefaults.standard.set(arrayList, forKey: "nomalMode")
        // call the notification center
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nomal"), object: nil)
        // print
        print("success")
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        
        
        
        // if bullet hit small plane, it dies
        //if monster hit you, you die
        
        for monster in monsterArray {
            if monster.frame.intersects(player.frame){
                gameOver(resultScore: score)
            }
            for bullet in bulletArray {
                if bullet.intersects(monster){
                    bullet.removeFromParent()
                    monster.removeFromParent()
                    let bulletIndex = bulletArray.index(of:bullet)
                    if bulletIndex != nil {
                        bulletArray.remove(at: bulletIndex!)
                    }
                    let monsterIndex = monsterArray.index(of:monster)
                    if monsterIndex != nil {
                        monsterArray.remove(at: monsterIndex!)
                    }
                    score += 1
                    scorLb?.text = String(score)
                }
            }
            
            
            
            
            
        }
        //if boss hit you , you loss
        if boss.parent != nil {
            if boss.frame.intersects(player.frame){
                gameOver(resultScore: score)
            }
        }
        
        
        
        
        
        //get supply
        if supplyNode.parent != nil {
            if supplyNode.frame.intersects(player.frame){
                //remove it
                supplyNode.removeFromParent()
                if boss.parent != nil {
                    boss.removeFromParent()
                    score += 20
                    scorLb?.text = String(score)
                }
                // kill all the node
                if monsterArray.count > 0 {
                    monsterArray.forEach{
                        score += 1
                        scorLb?.text = String(score)
                        $0.removeFromParent()
                    }
                    monsterArray.removeAll()
                }
            }
        }
        
        //set up the bullet in this array
        for bullet in bulletArray {
            // if they touch boss loss hp
            if bullet.frame.intersects(boss.frame){
                if bossHp == 0 {
                    boss.removeAllActions()
                    boss.removeFromParent()
                    bullet.removeFromParent()
                    // 20 score for one boss
                    score += 20
                    scorLb?.text = String(score)
                    bossHp = 10
                } else {
                    bossHp -= 1
                    bullet.removeFromParent()
                }
                
                let index = bulletArray.index(of:bullet)
                if index != nil {
                    bulletArray.remove(at: index!)
                }
            }
        }
        
        
        
        
        
    }
    // game over function
    
    private func gameOver(resultScore:Int){
        saveData(data: String(score) + ":" + playerName)
        print("die,die,die")
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameOverScene(size: self.size,score:resultScore,playerResultName:playerName)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            // Present the scene
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.presentScene(scene)
        }
        // remove sound
        for bullet in bulletArray {
            bullet.removeAllActions()
        }
            //remove action
        bulletArray.removeAll()
        // remove player
        player.removeAllActions()
        //pause the scene
        self.scene?.isPaused = true
    }
    
    
    
    
    
    
    
    
}
