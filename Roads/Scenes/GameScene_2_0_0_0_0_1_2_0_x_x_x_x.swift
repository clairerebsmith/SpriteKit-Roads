import SpriteKit

@objcMembers
class GameScene_2_0_0_0_0_1_2_0_x_x_x_x: SKScene {
    var level = 1

    let scoreLabel = SKLabelNode(fontNamed: "Optima-ExtraBlack")

    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background-leaves")
        background.name = "background"
        background.zPosition = -1
        addChild(background)

        scoreLabel.position = CGPoint(x: -480, y: 330)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 1
        background.addChild(scoreLabel)
        score = 0

        createGrid()
        createLevel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    }

    func createGrid() {
        let xOffset = -440
        let yOffset = -320

        for row in 0 ..< 8 {
            for col in 0 ..< 12 {
                let item = SKSpriteNode(imageNamed: "elephant")
                item.position = CGPoint(x: xOffset + (col * 80), y: yOffset + (row * 80))
                addChild(item)
            }
        }
    }

    func createLevel() {
        var itemsToShow = 5 + (level * 4)

        // find all nodes that belong to our scene that are not called "background"
        let items = children.filter { $0.name != "background" }
        
        // shuffle those nodes so they are in a random order
        let shuffled = items.shuffled() as! [SKSpriteNode]

        // loop over them
        for item in shuffled {
            // and hide each one
            item.alpha = 0
        }
        
        // create and shuffle an array of animals
        let animals = ["elephant", "giraffe", "hippo", "monkey", "panda", "parrot", "penguin", "pig", "rabbit", "snake"]
        var shuffledAnimals = animals.shuffled()
        
        // remove one for the correct answer
        let correct = shuffledAnimals.removeLast()

        var showAnimals = [String]()
        var placingAnimal = 0
        var numUsed = 0
    
        for _ in 1 ..< itemsToShow {
            // mark that we've used this animal
            numUsed += 1
    
            // place it
            showAnimals.append(shuffledAnimals[placingAnimal])
    
            // if we've used this animal twice, go to the next one
            if numUsed == 2 {
                numUsed = 0
                placingAnimal += 1
            }
    
            // if we've gone through all animals, restart
            if placingAnimal == shuffledAnimals.count {
                placingAnimal = 0
            }
        }
        
        for (index, animal) in showAnimals.enumerated() {
            // pull out the matching item
            let item = shuffled[index]
            
            // assign the correct texture
            item.texture = SKTexture(imageNamed: animal)
            
            // show it
            item.alpha = 1
            
            // mark it as wrong
            item.name = "wrong"
        }
        
        shuffled.last?.texture = SKTexture(imageNamed: correct)
        shuffled.last?.alpha = 1
        shuffled.last?.name = "correct"
    }

    func correctAnswer(node: SKNode) {
        score += 1

        let fade = SKAction.fadeOut(withDuration: 0.5)
    
        for child in children {
            guard child.name == "wrong" else { continue }
            child.run(fade)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.level += 1
            self.createLevel()
        }
        
        let scaleUp = SKAction.scale(to: 2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        node.run(sequence)
    }

    func wrongAnswer(node: SKNode) {
        score -= 1

        let wrong = SKSpriteNode(imageNamed: "wrong")
        wrong.position = node.position
        wrong.zPosition = 5
        addChild(wrong)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            wrong.removeFromParent()
            self.level = 1
            self.createLevel()
        }
    }
}