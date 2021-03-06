import SpriteKit

@objcMembers
class GameScene_2_0_2_0_0_2_1_0_0_1_x_x: SKScene {
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
        let background = SKSpriteNode(imageNamed: "background-pattern")
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
            let remainingTime = Int(ceil(180 - timePassed))
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
                let item = SKSpriteNode(imageNamed: "1")
                item.position = CGPoint(x: xOffset + (col * 80), y: yOffset + (row * 80))
                addChild(item)
            }
        }
    }

    func createLevel() {
        var itemsToShow = 4 + (level * 4)

        // find all nodes that belong to our scene that are not called "background"
        let items = children.filter { $0.name != "background" }
        
        // shuffle those nodes so they are in a random order
        let shuffled = items.shuffled() as! [SKSpriteNode]

        // loop over them
        for item in shuffled {
            // and hide each one
            item.alpha = 0
        }
        
        // figure out the highest number we're going to show
        let highest = Int.random(in: 5...15)
        var others = [Int]()
    
        // generate lots of numbers lower than that
        for _ in 1 ..< itemsToShow {
            let num = Int.random(in: 0 ..< highest)
            others.append(num)
        }
        
        for (index, number) in others.enumerated() {
            // pull out one of the random balls
            let item = shuffled[index]
            
            // give it the correct texture for its new number
            item.texture = SKTexture(imageNamed: String(number))
            
            // show it immediately
            item.alpha = 1
            
            // but mark it as wrong
            item.name = "wrong"
        }
        
        shuffled.last?.texture = SKTexture(imageNamed: String(highest))
        shuffled.last?.alpha = 1
        shuffled.last?.name = "correct"
    }

    func correctAnswer(node: SKNode) {
        run(SKAction.playSoundFileNamed("correct-1", waitForCompletion: false))
        score += 1

        let correct = SKSpriteNode(imageNamed: "correct")
        correct.position = node.position
        correct.position.y += 40
        correct.zPosition = 10
        addChild(correct)
        
        correct.alpha = 0
        correct.xScale = 2.0
        correct.yScale = 2.0
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.25)
        let scaleIn = SKAction.scale(to: 1, duration: 0.25)
        
        let group = SKAction.group([fadeIn, scaleIn])
        correct.run(group)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            correct.removeFromParent()
            self.level += 1
            self.createLevel()
        }
    }

    func wrongAnswer(node: SKNode) {
        run(SKAction.playSoundFileNamed("wrong-1", waitForCompletion: false))
        score -= 1

        let wrong = SKSpriteNode(imageNamed: "wrong")
        wrong.position = node.position
        wrong.zPosition = 5
        addChild(wrong)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            wrong.removeFromParent()
            self.level -= 1
    
            if self.level == 0 {
                self.level = 1
            }
    
            self.createLevel()
        }
    }
}