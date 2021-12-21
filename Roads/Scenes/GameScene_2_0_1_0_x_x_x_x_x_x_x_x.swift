import SpriteKit

@objcMembers
class GameScene_2_0_1_0_x_x_x_x_x_x_x_x: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background-metal")
        background.name = "background"
        background.zPosition = -1
        addChild(background)

        createGrid()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }

    func createGrid() {
        let xOffset = -440
        let yOffset = -320

        for row in 0 ..< 8 {
            for col in 0 ..< 12 {
                let item = SKSpriteNode(imageNamed: "red-light")
                item.position = CGPoint(x: xOffset + (col * 80), y: yOffset + (row * 80))
                addChild(item)
            }
        }
    }
}