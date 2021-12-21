import SpriteKit

@objcMembers
class GameScene_3_0_1_0_0_x_x_x_x_x_x_x: SKScene {
    let player = SKSpriteNode(imageNamed: "submarine")
    var touchingScreen = false

    override func didMove(to view: SKView) {
        player.position = CGPoint(x: -400, y: 250)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        addChild(player)

        physicsWorld.gravity = CGVector(dx: 0, dy: -5)

        parallaxScroll(image: "sea", y: 0, z: -3, duration: 10, needsPhysics: false)
        parallaxScroll(image: "sand", y: -340, z: -1, duration: 6, needsPhysics: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
    }

    override func update(_ currentTime: TimeInterval) {
        if touchingScreen {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
        }
    }

    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhysics: Bool) {
        // run this code twice
        for i in 0 ... 1 {
            let node = SKSpriteNode(imageNamed: image)
            
            // position the first node on the left, and the second on the right
            node.position = CGPoint(x: 1023 * CGFloat(i), y: y)
            node.zPosition = z
            addChild(node)
    
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
}