import SpriteKit

public class FlipCountdown: SKScene {
    
    public override func didMove(to view: SKView) {
        for n in children.filter({ $0.name == "counter" }) {
            n.alpha = 0
        }
    }
    
}
