import SpriteKit

@objcMembers
class GameScene_4_0_2_x_x_x_x_x_x_x_x_x_x: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "night")
        background.zPosition = -2
        addChild(background)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }
}