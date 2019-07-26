import SpriteKit

public class BulletNode: SKSpriteNode {
    init(direction: Float, position: vector_float2) {
        super.init(texture: nil, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), size: CGSize(width: 10, height: 10))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.bullet.rawValue
        self.physicsBody?.contactTestBitMask = bitmask(.enemy, .worldBounds)
        self.physicsBody?.collisionBitMask = 0
        
        let velocity = CGVector(dx: 200 * cos(CGFloat(direction)), dy: 200 * sin(CGFloat(direction)))
        self.physicsBody?.velocity = velocity
        self.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

