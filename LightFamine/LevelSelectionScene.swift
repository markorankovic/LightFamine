import SpriteKit

public class LevelSelectionScene: SKScene {
    
    public static var LEVEL_COUNT = 6
    
    var viewController: MainMenuViewController?
        
    func enterLevel(level: Int) {
        viewController?.enterLevel(level: level)
    }
    
    public override func mouseUp(with event: NSEvent) {
        let loc = event.location(in: self)
        let n = nodes(at: loc).filter{ $0.name == "level" }.first
        if let lvlNumber = n?.childNode(withName: "number") as? SKLabelNode {
            enterLevel(level: Int(lvlNumber.text!)!)
        }
    }
    
    public override func keyUp(with event: NSEvent) {
        if event.keyCode == 53 {
            exit(1)
        }
    }
    
}
