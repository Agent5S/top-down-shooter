import GameplayKit
import SpriteKit

public class PhysicsComponent: GKComponent {
    var physicsBody: SKPhysicsBody
    
    public init(sprite: RenderComponent) {
        self.physicsBody = SKPhysicsBody(rectangleOf: sprite.node.size)
        self.physicsBody.affectedByGravity = false
        self.physicsBody.isDynamic = true
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

