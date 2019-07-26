import GameplayKit
import SpriteKit

public class RenderComponent: GKComponent {
    let node: SKSpriteNode
    
    public init(sprite: SKSpriteNode) {
        self.node = sprite
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didAddToEntity() {
        self.node.entity = self.entity
    }
    
    public override func willRemoveFromEntity() {
        self.node.entity = nil
    }
}

