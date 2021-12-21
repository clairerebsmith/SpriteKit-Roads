import SpriteKit
import CoreMotion

@objcMembers
class GameScene_1_0_0_0_0_0_x_x_x_x_x_x_x: SKScene {
    let player = SKSpriteNode(imageNamed: "player-rocket.png")
    let motionManager = CMMotionManager()

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "space.jpg")
        background.zPosition = -1
        addChild(background)

        if let particles = SKEmitterNode(fileNamed: "SpaceDust") {
            particles.advanceSimulationTime(10)
            particles.position.x = 512
            addChild(particles)
        }

        player.position.x = -400
        player.zPosition = 1
        addChild(player)

        motionManager.startAccelerometerUpdates()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            let changeX = CGFloat(accelerometerData.acceleration.y) * 100
            let changeY = CGFloat(accelerometerData.acceleration.x) * 100
            player.position.x -= changeX
            player.position.y += changeY
        }
    }
}