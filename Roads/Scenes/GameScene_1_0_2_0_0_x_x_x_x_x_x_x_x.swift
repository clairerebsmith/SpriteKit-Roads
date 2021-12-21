import SpriteKit

@objcMembers
class GameScene_1_0_2_0_0_x_x_x_x_x_x_x_x: SKScene {
    let player = SKSpriteNode(imageNamed: "player-motorbike.png")

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "road.jpg")
        background.zPosition = -1
        addChild(background)

        if let particles = SKEmitterNode(fileNamed: "Mud") {
            particles.advanceSimulationTime(10)
            particles.position.x = 512
            addChild(particles)
        }

        player.position.x = -400
        player.zPosition = 1
        addChild(player)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }
}