import SpriteKit

public class MainMenuViewController: NSViewController {
    public func enterLevel(level: Int) {
        print("Enter level: \(level)")
        let vController = (parent as? MainViewController)
        vController!.view = vController!.gameViewController.view
        vController!.gameViewController.enterLevel(level: level)
        removeFromParent()
    }
    
    public override func loadView() {
        view = SKView()
    }
    public override func viewDidLoad() {
        let v = (view as! SKView)
        v.presentScene(LevelSelectionScene(fileNamed: "LevelSelection"))
        (v.scene as? LevelSelectionScene)?.viewController = self
    }
}
