//
//  Games.swift
//  ZiangQiuPlaneWar
//
//  Created by Qiu Ziang on 2018/6/6.
//  Copyright © 2018年 skylove. All rights reserved.
//

import SpriteKit
import AVFoundation
/*
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}
*/

class Games: SKScene, SKPhysicsContactDelegate {
    // 1
    
    
    var monsterArray : [SKSpriteNode] = [SKSpriteNode]()
    var bulletArray : [SKSpriteNode] = [SKSpriteNode]()
    let player = SKSpriteNode(imageNamed: "Spaceship")
    var monstersDestroyed = 0
    var scorLb:SKLabelNode?
    var nameLb:SKLabelNode?
    var playerName = ""
    var totalMonster = 0
    private var shouldMove = false
    lazy var shootSoundAction = { () -> SKAction in
        let action = SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false)
        return action
    }()
    private func addScoreLb() {
        scorLb = SKLabelNode.init(fontNamed: "Chalkduster")
        scorLb?.text = "0"
        scorLb?.fontSize = 20
        scorLb?.fontColor = .black
        scorLb?.zPosition = 4
        scorLb?.position = .init(x: 50, y: size.height - 80)
        addChild(scorLb!)
    }
    
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
    
    private func addBg() {
        let bgNode = SKSpriteNode.init(imageNamed: "bg_01")
        bgNode.position = .zero
        bgNode.zPosition = 0
        bgNode.anchorPoint = .zero
        bgNode.size = size
        addChild(bgNode)
    }
    
    private func setup() {
        player.size = CGSize(width: 40, height: 40)
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        player.zPosition = 12
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        addBg()
        addScoreLb()
        addName()
        addChild(player)
    }
    
    override init(size : CGSize) {
        super.init(size: size)
        setup()
        addNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    private func addNode(){
        addHero()
        addBg()
        addScoreLb()
        addName()
    }
    
    
    private func addMonster(){
        weak var wkself = self
        let addMonsterAction = SKAction.run {
            wkself?.getMonster()
        }
        let waitAction = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([addMonsterAction,waitAction])
        let repeatAction = SKAction.repeatForever(sequence)
        run(repeatAction)
        
        
    }
    
    private func getMonster(){
        weak var wkself = self
        let minimumDuration:Int = 4
        let maximumDuration:Int = 5
        let duration = Int(arc4random_uniform((UInt32(maximumDuration - minimumDuration)))) + minimumDuration
        let monster = SKSpriteNode.init(imageNamed: "enemy-1")
        let minx:Int = Int(monster.size.width / 2)
        let maxx:Int = Int(size.width - monster.size.width / 2)
        let gapx:Int = maxx - minx
        let xpos:Int = Int(arc4random_uniform(UInt32(gapx))) + minx
        monster.position = .init(x: CGFloat(xpos), y: (size.height + monster.size.height/2))
        addChild(monster)
        totalMonster += 1
        monsterArray.append(monster)
        let move = SKAction.moveTo(y: -monster.size.height/2, duration: TimeInterval(duration))
        let remove = SKAction.run {
            monster.removeFromParent()
            let index = wkself?.monsterArray.index(of:monster)
            if index != nil {
                wkself?.monsterArray.remove(at: index!)
            }
        }
        
        monster.run(SKAction.sequence([move,remove]))
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func shoot() {
        
        
        let bulletNode = SKSpriteNode.init(imageNamed: "bullet-1")
        bulletNode.position = player.position
        addChild(bulletNode)
        bulletArray.append(bulletNode)
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
    
    
    private func addHero(){
        player.position = .init(x: size.width/2, y:player.size.height/2)
        player.name = "player"
        addChild(player)
        weak var wkself = self
        let shootAction = SKAction.run {
            wkself?.shoot()
        }
        let wait = SKAction.wait(forDuration: 0.2)
        let sequenceAction = SKAction.sequence([shootAction,wait])
        let repeatShootAction = SKAction.repeatForever(sequenceAction)
        run(repeatShootAction)
    }
    
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
        guard  x >= player.size.width/2, x <= size.width-hero.size.width/2 else {
            return
        }
        let y = player.position.y - offsety
        guard y >= player.size.height/2, y <= size.height-hero.size.height/2 else {
            return
        }
        player.position = .init(x: x , y: y)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    func addBullet() {
        // 2 - Set up initial location of projectile
        let bullet = SKSpriteNode(imageNamed: "Rectangle")
        bullet.size = CGSize(width: 10, height: 10)
        bullet.position = player.position
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.zPosition = 7
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bulletArray.append(bullet)
        addChild(bullet)
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: player.position.x, y: size.height + bullet.size.width/2), duration: 1)
        let actionMoveDone = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
 
    func addMonster() {
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "enemy-1")
        
        // Determine where to spawn the monster along the Y axis
        let actualX = random(min: -monster.size.width/2, max: size.width + monster.size.width/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true // 2
        monster.zPosition = 13
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        // Add the monster to the scene
        addChild(monster)
        monsterArray.append(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: 0), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        player.position = touchLocation
    }
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        let projectile = SKSpriteNode(imageNamed: "Rectangle")
        projectile.zPosition = 6
        projectile.size = CGSize(width: 10, height: 10)
        projectile.position = player.position
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        // 4 - Bail out if you are shooting down or backwards
        if (offset.y < 0) { return }
        
        // 5 - OK to add now - you've double checked position
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
     
     
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        print("Hit")
        monstersDestroyed += 1
        scorLb?.text = String(monstersDestroyed)
        let position = monsterArray.index(of: monster)
        if position != nil {
            monsterArray.remove(at: position!)
        }
        
        projectile.removeFromParent()
        monster.removeFromParent()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            projectileDidCollideWithMonster(projectile: firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    */
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
        UserDefaults.standard.set(arrayList, forKey: "nomalMode")
        // call the notification center
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nomal"), object: nil)
        // print
        print("success")
    }
    
    override func update(_ currentTime: TimeInterval) {
        for monster in monsterArray {
            if monster.frame.intersects(player.frame){
                gameOver()
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
                }
            }
            
            
            
            
            
        }
        
    }
    
    private func gameOver(){
        saveData(data: playerName+":"+String(monstersDestroyed))
        print("die,die,die")
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: true)
        self.view?.presentScene(gameOverScene, transition: reveal)
        
    }
    
    
    
    
    
    
    
    
}
