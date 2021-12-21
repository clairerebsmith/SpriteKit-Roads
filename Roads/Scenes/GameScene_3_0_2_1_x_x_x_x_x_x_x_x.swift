import SpriteKit

@objcMembers
class GameScene_3_0_2_1_x_x_x_x_x_x_x_x: SKScene {
    let player = SKSpriteNode(imageNamed: "balloon")

    override func didMove(to view: SKView) {
        player.position = CGPoint(x: -400, y: 250)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        addChild(player)

        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }
}