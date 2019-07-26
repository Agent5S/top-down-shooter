import SpriteKit

public class TextScene: SKScene {
    public override func keyDown(with event: NSEvent) {
        if event.keyCode == 49 {
            if let scene = Scene(fileNamed: "GameScene") {
                self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1))
            }
        }
    }
}

