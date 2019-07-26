import SpriteKit
import GameplayKit
import PlaygroundSupport
import simd

/*var v1 = float2(1, 2)
var v2 = float4(1, 2, 3, 4)

var v3 = v2 + v1*/

let viewSize = CGSize(width: 512, height: 512)
let view = SKView(frame: NSRect(origin: CGPoint.zero, size: viewSize))

PlaygroundPage.current.liveView = view 

let scene = TextScene(fileNamed: "IntroScene")

view.presentScene(scene)

