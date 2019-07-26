import GameplayKit

public class Enemy: GKEntity, GKAgentDelegate {
    let renderComponent: RenderComponent
    let physicsComponent: PhysicsComponent
    let agent: GKAgent2D
    
    public init(at point: (Int, Int), playerAgent: GKAgent2D) {
        self.agent = GKAgent2D()
        let sprite = SKSpriteNode(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), size: CGSize(width: 25, height: 25))
        self.renderComponent = RenderComponent(sprite: sprite)
        self.physicsComponent = PhysicsComponent(sprite: self.renderComponent)
        super.init()
        
        self.addComponent(self.agent)
        self.addComponent(self.renderComponent)
        self.addComponent(self.physicsComponent)
        
        self.renderComponent.node.physicsBody = physicsComponent.physicsBody
        self.agent.delegate = self
        self.setUpBehavior(playerAgent: playerAgent)
        self.setUpPhysicsBody()
        
        self.renderComponent.node.position = CGPoint(x: point.0, y: point.1)
        self.agent.position = vector2(Float(point.0), Float(point.1))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpBehavior(playerAgent: GKAgent2D) {
        self.agent.maxSpeed = 85
        self.agent.maxAcceleration = 50
        self.agent.radius = 100
        
        self.agent.behavior = GKBehavior()
        self.agent.behavior?.setWeight(1, for: GKGoal(toSeekAgent: playerAgent))
    }
    
    func setUpPhysicsBody() {
        self.physicsComponent.physicsBody.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsComponent.physicsBody.contactTestBitMask = bitmask(.player, .worldBounds, .bullet)
        self.physicsComponent.physicsBody.collisionBitMask = bitmask(.worldBounds)
    }
    
    //MARK: GKAgentDelegate
    public func agentDidUpdate(_ agent: GKAgent) {
        let position = CGPoint(x: CGFloat(self.agent.position.x), y: CGFloat(self.agent.position.y))
        self.renderComponent.node.position = position
        self.renderComponent.node.zRotation = CGFloat(self.agent.rotation)
    }
}

