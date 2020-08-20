import SpriteKit

public class MainMenuViewController: NSViewController {
    
    public func enterLevel(level: Int) {
        print("Enter level: \(level)")
        if let p = parent as? MainViewController {
            p.addChild(p.gameViewController)
            p.view = p.gameViewController.view as! GameView
            p.gameViewController.enterLevel(level: level)
            removeFromParent()
        }
    }
    
    public override func loadView() {
        view = SKView(frame: .init(x: 0, y: 0, width: 800, height: 600))
    }
    
    public override func viewDidLoad() {
        let v = (view as! SKView)
        v.presentScene(LevelSelectionScene(fileNamed: "LevelSelection"))
        (v.scene as? LevelSelectionScene)?.viewController = self
    }
    
}

