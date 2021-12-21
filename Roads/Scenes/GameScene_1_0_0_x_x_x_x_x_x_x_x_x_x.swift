import SpriteKit

@objcMembers
class GameScene_1_0_0_x_x_x_x_x_x_x_x_x_x: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "space.jpg")
        background.zPosition = -1
        addChild(background)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }
}