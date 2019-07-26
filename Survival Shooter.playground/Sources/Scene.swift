import SpriteKit
import GameplayKit

public class Scene: SKScene, SKPhysicsContactDelegate {
    let levelFrame = CGRect(x: -512, y: -512, width: 1024, height: 1024)
    let horizontalDistribution = GKRandomDistribution(lowestValue: -487, highestValue: 487)
    let verticalDistribution = GKRandomDistribution(lowestValue: -487, highestValue: 487)
    let agentComponentSystem = GKComponentSystem(componentClass: GKAgent2D.self)
    let inputComponentSystem = GKComponentSystem(componentClass: InputComponent.self)
    
    var player: Player!
    var previousTime: TimeInterval = 0
    var pressedKeys = Set<UInt16>()
    var entities = Set<GKEntity>()
    
    var elapsedTime: TimeInterval = 0 {
        didSet {
            if self.elapsedTime > 5 {
                self.elapsedTime = 0
                
                self.generateEnemy()
            }
        }
    }
    
    override public func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.addCameraConstraints(view: view)
        self.createBounds()
        
        self.player = Player(scene: self)
        self.addEntity(entity: self.player)
    }
    
    override public func keyDown(with event: NSEvent) {
        self.pressedKeys.insert(event.keyCode)
        self.player.inputComponent.pressed(key: event.keyCode)
    }
    
    override public func keyUp(with event: NSEvent) {
        self.pressedKeys.remove(event.keyCode)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        //Calculate dt
        if self.previousTime == 0 { self.previousTime = currentTime }
        let deltaTime = currentTime - self.previousTime
        self.previousTime = currentTime
        
        //Update elapsed time for enemy generation
        self.elapsedTime += deltaTime
        
        self.inputComponentSystem.update(deltaTime: deltaTime)
        self.agentComponentSystem.update(deltaTime: deltaTime)
        
        if let camera = self.childNode(withName: "Camera") as? SKCameraNode {
            camera.position = self.player.renderComponent.node.position
        }
    }
    
    override public func didFinishUpdate() {
        self.agentComponentSystem.components.map { return $0 as? GKAgent2D }.forEach {
            if let node = $0?.entity?.component(ofType: RenderComponent.self)?.node {
                $0?.position = vector2(Float(node.position.x), Float(node.position.y))
            }
        }
    }
    
    func addCameraConstraints(view: SKView) {
        guard let camera = self.childNode(withName: "Camera") as? SKCameraNode else {
            return
        }
        
        let maxHorizontal = (self.levelFrame.width / 2) - (view.frame.width / 2)
        let maxVertical = (self.levelFrame.height / 2) - (view.frame.height / 2)
        
        let horizontalRange = SKRange(lowerLimit: -maxHorizontal, upperLimit: maxHorizontal)
        let verticalRange = SKRange(lowerLimit: -maxVertical, upperLimit: maxVertical)
        
        let constraint = SKConstraint.positionX(horizontalRange, y: verticalRange)
        camera.constraints = [constraint]
    }
    
    func createBounds() {
        guard let bounds = self.childNode(withName: "Bounds") else {
            return
        }
        
        bounds.physicsBody = SKPhysicsBody(edgeLoopFrom: self.levelFrame)
        bounds.physicsBody?.isDynamic = false
        bounds.physicsBody?.categoryBitMask = PhysicsCategory.worldBounds.rawValue
        bounds.physicsBody?.collisionBitMask = UInt32.max
        bounds.physicsBody?.contactTestBitMask = UInt32.max
    }
    
    func generateEnemy() {
        let position = (self.horizontalDistribution.nextInt(), self.verticalDistribution.nextInt())
        let enemy = Enemy(at: position, playerAgent: self.player.agent)
        self.addEntity(entity: enemy)
    }
    
    func addEntity(entity: GKEntity) {
        self.entities.insert(entity)
        
        if let renderComponent = entity.component(ofType: RenderComponent.self) {
            self.addChild(renderComponent.node)
        }
        
        if let agent = entity.component(ofType: GKAgent2D.self) {
            self.agentComponentSystem.addComponent(agent)
        }
        
        if let inputComponent = entity.component(ofType: InputComponent.self) {
            self.inputComponentSystem.addComponent(inputComponent)
        }
    }
    
    func removeEntity(entity: GKEntity) {
        if let renderComponent = entity.component(ofType: RenderComponent.self) {
            renderComponent.node.removeFromParent()
        }
        
        if let agent = entity.component(ofType: GKAgent2D.self) {
            self.agentComponentSystem.removeComponent(agent)
        }
        
        if let inputComponent = entity.component(ofType: InputComponent.self) {
            self.inputComponentSystem.removeComponent(inputComponent)
        }
        
        self.entities.remove(entity)
    }
    
    //MARK: SKPhysicsContactDelegate
    public func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask | bodyB.categoryBitMask) == bitmask(.enemy, .bullet) {
            let bullet = bodyA.node is BulletNode ? bodyA.node : bodyB.node
            let enemy = bodyA.node?.entity is Enemy ? bodyA.node!.entity! : bodyB.node!.entity!
            bullet?.removeFromParent()
            self.removeEntity(entity: enemy)
            bullet?.removeFromParent()
        }
        
        if (bodyA.categoryBitMask | bodyB.categoryBitMask) == bitmask(.enemy, .player) {
            if let scene = TextScene(fileNamed: "GameOver") {
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
        }
    }
    
    public func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask | bodyB.categoryBitMask) == bitmask(.worldBounds, .bullet) {
            let bullet = bodyA.node is BulletNode ? bodyA.node : bodyB.node
            bullet?.removeFromParent()
        }
    }
}

