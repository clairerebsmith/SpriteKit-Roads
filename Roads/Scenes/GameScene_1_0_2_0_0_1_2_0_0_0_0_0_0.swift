import SpriteKit

@objcMembers
class GameScene_1_0_2_0_0_1_2_0_0_0_0_0_0: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "player-motorbike.png")
    var touchingPlayer = false

    var gameTimer: Timer?
    let music = SKAudioNode(fileNamed: "cyborg-ninja.mp3")

    let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")

    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "road.jpg")
        background.zPosition = -1
        addChild(background)

        scoreLabel.zPosition = 2
        scoreLabel.position.y = 300
        addChild(scoreLabel)
        score = 0

        addChild(music)

        if let particles = SKEmitterNode(fileNamed: "Mud") {
            particles.advanceSimulationTime(10)
            particles.position.x = 512
            addChild(particles)
        }

        player.position.x = -400
        player.zPosition = 1
        addChild(player)

        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.categoryBitMask = 1

        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        physicsWorld.contactDelegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        if tappedNodes.contains(player) {
            touchingPlayer = true
        }        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchingPlayer else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        player.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingPlayer = false
    }

    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -700 {
                node.removeFromParent()
            }
        }

        if touchingPlayer == false {
            if player.parent != nil {
                score += 1
            }
        }

        if player.position.x < -400 {
            player.position.x = -400
        } else if player.position.x > 400 {
            player.position.x = 400
        }
    
        if player.position.y < -300 {
            player.position.y = -300
        } else if player.position.y > 300 {
            player.position.y = 300
        }
    }

    func createEnemy() {
                let sprite = SKSpriteNode(imageNamed: "wall")
        sprite.position = CGPoint(x: 1200, y: Int.random(in: -350...350))
        sprite.name = "enemy"    
        sprite.zPosition = 1
        addChild(sprite)

        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.categoryBitMask = 0
        sprite.physicsBody?.contactTestBitMask = 1

    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }
    }
    
    func playerHit(_ node: SKNode) {
        if let particles = SKEmitterNode(fileNamed: "Explosion.sks") {
            particles.position = player.position
            particles.zPosition = 3
            addChild(particles)
        }

        player.removeFromParent()
        music.removeFromParent()

        let gameOver = SKSpriteNode(imageNamed: "gameOver-1")
        gameOver.zPosition = 10
        addChild(gameOver)

        // wait for two seconds then run some code
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // create a new scene from GameScene.sks
            if let scene = GameScene_1_0_2_0_0_1_2_0_0_0_0_0_x(fileNamed: "GameScene") {
                // make it stretch to fill all available space
                scene.scaleMode = .aspectFill
                
                // present it immediately
                self.view?.presentScene(scene)
            }
        }

        let sound = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
        run(sound)
    }
}