import SpriteKit

@objcMembers
class GameScene_4_0_2_0_0_x_x_x_x_x_x_x_x: SKScene {
    var cols = [[Item]]()
    let itemSize: CGFloat = 50
    let itemsPerColumn = 12
    let itemsPerRow = 18
    var currentMatches = Set<Item>()

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "night")
        background.zPosition = -2
        addChild(background)

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
    
        currentMatches.removeAll()
        match(item: tappedItem)
        removeMatches()
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
        let itemImages = ["alien-blue", "alien-gray", "alien-green", "alien-pink", "alien-purple", "alien-yellow"]
        let itemImage = itemImages.randomElement()!

        let item = Item(imageNamed: itemImage)
        item.name = itemImage        
        item.row = row
        item.col = col
        item.position = position(for: item)
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
        for item in currentMatches {
            item.removeFromParent()
        }
    }
}