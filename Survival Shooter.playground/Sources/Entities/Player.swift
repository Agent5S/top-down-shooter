import GameplayKit

public class Player: GKEntity, GKAgentDelegate {
    let renderComponent: RenderComponent
    let physicsComponent: PhysicsComponent
    let inputComponent: InputComponent
    let agent: GKAgent2D
    
    public init(scene: Scene) {
        self.agent = GKAgent2D()
        let sprite = SKSpriteNode(color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), size: CGSize(width: 50, height: 50))
        self.renderComponent = RenderComponent(sprite: sprite)
        self.physicsComponent = PhysicsComponent(sprite: renderComponent)
        self.inputComponent = InputComponent(agent: self.agent, scene: scene)
        super.init()
        
        self.addComponent(self.agent)
        self.addComponent(self.renderComponent)
        self.addComponent(self.physicsComponent)
        self.addComponent(self.inputComponent)
        
        self.renderComponent.node.physicsBody = self.physicsComponent.physicsBody
        self.setUpPhysicsBody()
        self.agent.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpPhysicsBody() {
        self.physicsComponent.physicsBody.categoryBitMask = PhysicsCategory.player.rawValue
        self.physicsComponent.physicsBody.contactTestBitMask = bitmask(.enemy, .worldBounds)
        self.physicsComponent.physicsBody.collisionBitMask = bitmask(.worldBounds)
    }
    
    //MARK: GKAgentDelegate
    public func agentDidUpdate(_ agent: GKAgent) {
        let position = self.agent.position
        self.renderComponent.node.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
        self.renderComponent.node.zRotation = CGFloat(self.agent.rotation)
    }
}

