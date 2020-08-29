import SpriteKit
import SceneKit

public class FlipCountdown: SKScene {
        
    public override func didMove(to view: SKView) {
        print("Did move to view")
        size = .init(width: 1920, height: 1080)
        scaleMode = .aspectFit
        for n in children.filter({ $0.name == "counter" }) {
            n.alpha = 0
        }
        backgroundColor = .black
    }
    
    var gameScene: GameScene?
    
    var countdownDone: Bool {
        set {
        }
        get {
            children.filter{ ($0 as? SKLabelNode)?.text == "1" }.first!.isHidden
        }
    }
    
    public override func update(_ currentTime: TimeInterval) {
        gameScene?.screen?.geometry?.materials = []
        let mat = SCNMaterial()
        gameScene?.screen?.geometry?.materials = [mat]
        let tex = view!.texture(from: self)
        mat.diffuse.contents = tex

        if countdownDone {
            gameScene?.screen?.geometry?.materials = []
            view?.presentScene(nil)
            gameScene?.flipTheDarkAndLight()
        }
    }
    
}
