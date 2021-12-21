import SpriteKit

@objcMembers
class GameScene_2_0_0_0_0_2_1_x_x_x_x_x: SKScene {
    var level = 1

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background-leaves")
        background.name = "background"
        background.zPosition = -1
        addChild(background)

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