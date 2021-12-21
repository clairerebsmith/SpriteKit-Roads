import SpriteKit

@objcMembers
class GameScene_3_0_1_1_0_2_0_0_0_0_x_x: SKScene, SKPhysicsContactDelegate {
    let player = SKSpriteNode(imageNamed: "submarine")
    let music = SKAudioNode(fileNamed: "salty-ditty.mp3")

    var timer: Timer?

    let scoreLabel = SKLabelNode(fontNamed: "Baskerville-Bold")

    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        player.position = CGPoint(x: -400, y: 250)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.categoryBitMask = 1
        addChild(player)

        scoreLabel.fontColor = UIColor.black.withAlphaComponent(0.5)
        scoreLabel.position.y = 320
        addChild(scoreLabel)
        score = 0

        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(createObstacle), userInfo: nil, repeats: true)
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        physicsWorld.contactDelegate = self

        parallaxScroll(image: "sea", y: 0, z: -3, duration: 10, needsPhysics: false)
        parallaxScroll(image: "sand", y: -340, z: -1, duration: 6, needsPhysics: true)
        addChild(music)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
    }

    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhysics: Bool) {
        // run this code twice
        for i in 0 ... 1 {
            let node = SKSpriteNode(imageNamed: image)
            
            // position the first node on the left, and the second on the right
            node.position = CGPoint(x: 1023 * CGFloat(i), y: y)
            node.zPosition = z
            addChild(node)

            if needsPhysics {
                node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
                node.physicsBody?.isDynamic = false
                node.physicsBody?.contactTestBitMask = 1
                node.name = "obstacle"
            }
    
            // make this node move the width of the screen by whatever duration was passed in
            let move = SKAction.moveBy(x: -1024, y: 0, duration: duration)
            
            // make it jump back to the right edge
            let wrap = SKAction.moveBy(x: 1024, y: 0, duration: 0)
            
            // make these two as a sequence that loops forever
            let sequence = SKAction.sequence([move, wrap])
            let forever = SKAction.repeatForever(sequence)
    
            // run the animations
            node.run(forever)
        }
    }

    func createObstacle() {
        // create and position the sand, choosing either high or low to make the player dodge them
        let options = ["enemy-sand-lo", "enemy-sand-hi"]
        let chosen = Int.random(in: 0...1)
        let obstacle = SKSpriteNode(imageNamed: options[chosen])
        obstacle.zPosition = -2
        obstacle.position.x = 768
        addChild(obstacle)

        obstacle.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size: obstacle.texture!.size())
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.name = "obstacle"

        // decide where to create it
        obstacle.position.y = CGFloat.random(in: -170 ..< 170)

        // make it move across the screen
        let action = SKAction.moveTo(x: -768, duration: 9)
        obstacle.run(action)
        let collision = SKSpriteNode(color: .clear, size: CGSize(width: 20, height: 768))
        collision.physicsBody = SKPhysicsBody(rectangleOf: collision.size)
        collision.physicsBody?.contactTestBitMask = 1
        collision.physicsBody?.isDynamic = false
    
        collision.position.x = obstacle.frame.maxX
        collision.name = "score"
        addChild(collision)
        collision.run(action)
    }

    func playerHit(_ node: SKNode) {
        if node.name == "obstacle" {
            if let explosion = SKEmitterNode(fileNamed: "WaterExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }

            run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
            player.removeFromParent()
            music.removeFromParent()
        } else if node.name == "score" {
            run(SKAction.playSoundFileNamed("score.wav", waitForCompletion: false))
            node.removeFromParent()
            score += 1
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA == player {
            playerHit(nodeB)
        } else if nodeB == player {
            playerHit(nodeA)
        }
    }
}