import SpriteKit

@objcMembers
class GameScene_2_0_1_0_0_0_0_0_0_0_x_x: SKScene {
    var level = 1

    var startTime = 0.0
    var timeLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")
    var isGameRunning = true

    let scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")

    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background-metal")
        background.name = "background"
        background.zPosition = -1
        addChild(background)

        scoreLabel.position = CGPoint(x: -480, y: 330)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 1
        background.addChild(scoreLabel)
        score = 0

        timeLabel.position = CGPoint(x: 480, y: 330)
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.zPosition = 1
        background.addChild(timeLabel)

        let music = SKAudioNode(fileNamed: "truth-in-the-stones")
        background.addChild(music)

        createGrid()
        createLevel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameRunning else { return }

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        guard let tapped = tappedNodes.first else { return }

        if tapped.name == "correct" {
            correctAnswer(node: tapped)
        } else if tapped.name == "wrong" {
            wrongAnswer(node: tapped)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
        if isGameRunning {
            if startTime == 0 {
                startTime = currentTime
            }

            let timePassed = currentTime - startTime
            let remainingTime = Int(ceil(10 - timePassed))
            timeLabel.text = "TIME: \(remainingTime)"
            timeLabel.alpha = 1
            
            if remainingTime <= 0 {
                isGameRunning = false
        
                let gameOver = SKSpriteNode(imageNamed: "gameOver1")
                gameOver.zPosition = 100
                addChild(gameOver)
            }
        } else {
            timeLabel.alpha = 0
        }
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

    func createLevel() {
        var itemsToShow = 4 + level

        // find all nodes that belong to our scene that are not called "background"
        let items = children.filter { $0.name != "background" }
        
        // shuffle those nodes so they are in a random order
        let shuffled = items.shuffled() as! [SKSpriteNode]

        // loop over them
        for item in shuffled {
            // and hide each one
            item.alpha = 0
        }
        
        shuffled[0].name = "correct"
        shuffled[0].alpha = 1

        let lights = [SKTexture(imageNamed: "green-light"), SKTexture(imageNamed: "red-light")]
        let change = SKAction.animate(with: lights, timePerFrame: 0.2)
        var delay = 2.0
        
        for i in 1 ..< itemsToShow {
            // pull out this item, mark it as wrong, and show it
            let item = shuffled[i]
            item.name = "wrong"
            item.alpha = 1
    
            // create the correct pause for this light
            let ourPause = SKAction.wait(forDuration: delay)
            
            // make a sequence that pauses then animates
            let sequence = SKAction.sequence([ourPause, change])
            item.run(sequence)
            
            // add to the delay so the next light flashes later
            delay += 0.5
        }

        isGameRunning = false

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isGameRunning = true
            self.startTime = 0
        }
    }

    func correctAnswer(node: SKNode) {
        startTime = 0

        run(SKAction.playSoundFileNamed("correct-1", waitForCompletion: false))
        score += 1

        if let sparks = SKEmitterNode(fileNamed: "Sparks") {
            sparks.position = node.position
            addChild(sparks)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                sparks.removeFromParent()
                self.level += 1
                self.createLevel()
            }
        }
    }

    func wrongAnswer(node: SKNode) {
        run(SKAction.playSoundFileNamed("wrong-1", waitForCompletion: false))
        score -= 1

        let wrong = SKSpriteNode(imageNamed: "wrong")
        wrong.position = node.position
        wrong.zPosition = 5
        addChild(wrong)

        let wait = SKAction.wait(forDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait, remove])
        wrong.run(sequence)
    }
}