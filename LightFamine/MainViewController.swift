import Cocoa
import SpriteKit

public class MainViewController: NSViewController {
    
    let mainMenuViewController = MainMenuViewController()
    let gameViewController = GameViewController()
    
    func addViewControllers() {
        addChild(mainMenuViewController)
        addChild(gameViewController)
    }
    
    public override func loadView() {
        addViewControllers()
        view = mainMenuViewController.view
    }
    
    public override func keyDown(with event: NSEvent) {
        mainMenuViewController.keyDown(with: event)
    }
    
    public override func keyUp(with event: NSEvent) {
        for child in children {
            child.keyUp(with: event)
        }
    }
        
    public override func mouseMoved(with event: NSEvent) {
        for child in children {
            child.mouseMoved(with: event)
        }
    }
        
}
