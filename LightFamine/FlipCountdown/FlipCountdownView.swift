import SpriteKit
import SceneKit

public class FlipCountdownView: SKView {
    
    var gameScene: GameScene?
    
    public func presentScene() {
        let countdownScene = FlipCountdown(fileNamed: "FlipCountdown.sks")
        countdownScene?.gameScene = gameScene
        presentScene(countdownScene)
    }
    
}
