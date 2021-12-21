import SpriteKit

@objcMembers
class GameScene_4_0_1_0_x_x_x_x_x_x_x_x_x: SKScene {
    var cols = [[Item]]()
    let itemSize: CGFloat = 50
    let itemsPerColumn = 12
    let itemsPerRow = 18

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "clouds")
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
        let itemImages = ["balloon-black", "balloon-blue", "balloon-green", "balloon-purple", "balloon-red", "balloon-yellow", "balloon-orange"]
        let itemImage = itemImages.randomElement()!

        let item = Item(imageNamed: itemImage)
        item.name = itemImage        
        item.row = row
        item.col = col
        item.position = position(for: item)
        addChild(item)
        return item
    }
}