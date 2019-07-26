import GameplayKit
import SpriteKit

public class InputComponent: GKComponent {
    let agent: GKAgent2D
    let scene: Scene
    
    public init(agent: GKAgent2D, scene: Scene) {
        self.agent = agent
        self.scene = scene
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func update(deltaTime seconds: TimeInterval) {
        var rotate = false
        var directions: (Float, Float) = (0, 0)
        if self.scene.pressedKeys.contains(123) != self.scene.pressedKeys.contains(124) {
            directions.0 = self.scene.pressedKeys.contains(123) ? -1 : 1
            self.agent.position.x += 80 * directions.0 * Float(seconds)
            rotate = true
        }
        if self.scene.pressedKeys.contains(125) != self.scene.pressedKeys.contains(126) {
            directions.1 = self.scene.pressedKeys.contains(125) ? -1 : 1
            self.agent.position.y += 80 * directions.1 * Float(seconds)
            rotate = true
        }
        if rotate {
            self.agent.rotation = atan2(directions.1, directions.0)
        }
    }
    
    public func pressed(key: UInt16) {
        switch key {
        case 6, 49:
            scene.addChild(BulletNode(direction: self.agent.rotation, position: self.agent.position))
        case 7:
            //TODO: Handle x pressed
            break
        default:
            break
        }
    }
}

