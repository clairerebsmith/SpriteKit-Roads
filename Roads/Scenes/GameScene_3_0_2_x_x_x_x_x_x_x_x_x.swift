import SpriteKit

@objcMembers
class GameScene_3_0_2_x_x_x_x_x_x_x_x_x: SKScene {
    let player = SKSpriteNode(imageNamed: "balloon")

    override func didMove(to view: SKView) {
        player.position = CGPoint(x: -400, y: 250)
        addChild(player)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }
}