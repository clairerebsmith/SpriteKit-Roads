import SpriteKit

@objcMembers
class GameScene_4_0_1_0_0_0_1_0_1_1_0_x_x: SKScene {
    var cols = [[Item]]()
    let itemSize: CGFloat = 50
    let itemsPerColumn = 12
    let itemsPerRow = 18
    var currentMatches = Set<Item>()

    let scoreLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")

    var score = 0 {
        didSet {
            scoreLabel.text = "SCORE: \(score)"
        }
    }

    let movesLabel = SKLabelNode(fontNamed: "Noteworthy-Bold")
    
    var movesRemaining = 100 {
        didSet {
            movesLabel.text = "MOVES: \(max(0, movesRemaining))"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "clouds")
        background.zPosition = -2
        addChild(background)

        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: frame.maxX - 80, y: frame.maxY - 80)
        addChild(scoreLabel)
        score = 0

        let music = SKAudioNode(fileNamed: "carpe-diem")
        addChild(music)

        movesLabel.horizontalAlignmentMode = .left
        movesLabel.position = CGPoint(x: frame.minX + 80, y: frame.maxY - 80)
        addChild(movesLabel)
        movesRemaining = 100

        for x in 0 ..< itemsPerRow {
            var col = [Item]()
    
            for y in 0 ..< itemsPerColumn {
                let item = createItem(row: y, col: x)
                col.append(item)
            }
    
            cols.append(col)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let tappedItem = item(at: location) else { return }
    
        isUserInteractionEnabled = false
        currentMatches.removeAll()

        run(SKAction.playSoundFileNamed("pop", waitForCompletion: false))
        movesRemaining -= 1

        if tappedItem.name == "multi" {
            triggerSpecialItem(tappedItem)
        }

        match(item: tappedItem)
        removeMatches()
        moveDown()
        adjustScore()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
    }

    func position(for item: Item) -> CGPoint {
        let xOffset: CGFloat = -430
        let yOffset: CGFloat = -300

        let x = xOffset + itemSize * CGFloat(item.col)
        let y = yOffset + itemSize * CGFloat(item.row)
        return CGPoint(x: x, y: y)
    }

    func createItem(row: Int, col: Int, startOffScreen: Bool = false) -> Item {
        let itemImage: String
    
        if startOffScreen && Int.random(in: 0...24) == 0 {
            itemImage = "multi"
        } else {
            let itemImages = ["balloon-black", "balloon-blue", "balloon-green", "balloon-purple", "balloon-red", "balloon-yellow", "balloon-orange"]
            itemImage = itemImages.randomElement()!
        }

        let item = Item(imageNamed: itemImage)
        item.name = itemImage        
        item.row = row
        item.col = col
        
        if startOffScreen {
            // 1: Calculate the position
            let finalPosition = position(for: item)
            
            // move it higher
            item.position = finalPosition
            item.position.y += 600
        
            // create an animation to move it to the final position
            let action = SKAction.move(to: finalPosition, duration: 0.4)
        
            // run the animation then re-enable user interaction when it finishes
            item.run(action) {
                self.isUserInteractionEnabled = true
            }
        } else {
            item.position = position(for: item)
        }

        addChild(item)
        return item
    }

    func item(at point: CGPoint) -> Item? {
        let items = nodes(at: point).compactMap { $0 as? Item }
        return items.first
    }

    func match(item original: Item) {
        var checkItems = [Item?]()

        currentMatches.insert(original)
        let pos = original.position

        checkItems.append(item(at: CGPoint(x: pos.x, y: pos.y - itemSize)))
        checkItems.append(item(at: CGPoint(x: pos.x, y: pos.y + itemSize)))
        checkItems.append(item(at: CGPoint(x: pos.x - itemSize, y: pos.y)))
        checkItems.append(item(at: CGPoint(x: pos.x + itemSize, y: pos.y)))

        for case let check? in checkItems {
            if currentMatches.contains(check) { continue }

            if check.name == original.name {
                match(item: check)
            }
        }
    }

    func removeMatches() {
        let sortedMatches = currentMatches.sorted {
            $0.row > $1.row
        }

        for item in sortedMatches {
            cols[item.col].remove(at: item.row)
            item.removeFromParent()
        }
    }

    func moveDown() {
        // move down any items that need it
        for (columnIndex, col) in cols.enumerated() {
            for (rowIndex, item) in col.enumerated() {
                item.row = rowIndex

                let action = SKAction.move(to: position(for: item), duration: 0.1)
                item.run(action)
            }

            while cols[columnIndex].count < itemsPerColumn {
                let item = createItem(row: cols[columnIndex].count, col: columnIndex, startOffScreen: true)
                cols[columnIndex].append(item)
            }
        }
    }

    func triggerSpecialItem(_ item: Item) {
        run(SKAction.playSoundFileNamed("color-changer", waitForCompletion: false))

        let flash = SKSpriteNode(color: .white, size: frame.size)
        flash.zPosition = 1
        addChild(flash)
        
        flash.run(SKAction.fadeOut(withDuration: 0.2)) {
            flash.removeFromParent()
        }

        var itemImages = ["balloon-black", "balloon-blue", "balloon-green", "balloon-purple", "balloon-red", "balloon-yellow", "balloon-orange"]
        itemImages.shuffle()
        
        let changeFrom = itemImages[0]
        let changeTo = itemImages[1]
        
        let changeToTexture = SKTexture(imageNamed: changeTo)
        
        for col in cols {
            for item in col {
                if item.name == changeFrom {
                    item.name = changeTo
                    item.texture = changeToTexture
                }
            }
        }
    }

    func penalizePlayer() {
        let itemImages = ["balloon-black", "balloon-blue", "balloon-green", "balloon-purple", "balloon-red", "balloon-yellow", "balloon-orange"]

        for col in cols {
            for item in col {
                let changeTo = itemImages.randomElement()!
                item.name = changeTo
                item.texture = SKTexture(imageNamed: changeTo)
            }
        }
    }

    func adjustScore() {
        let newScore = currentMatches.count

        if newScore == 1 {
            penalizePlayer()
        } else if newScore == 2 {
            // no change
        } else {
            // allow up to 16 matches
            let matchCount = min(newScore, 16)
            
            // calculate that as a power of 2
            let scoreToAdd = pow(2, Double(matchCount))
            
            // add it to their score
            score += Int(scoreToAdd)
        }
    }
}