import AppKit
import SceneKit

public class GameView: SCNView {
        
    public override func mouseMoved(with event: NSEvent) {
        print(5)
    }
    
    public override func keyDown(with event: NSEvent) {
        (window?.contentViewController as? MainViewController)?.gameViewController.keyDown(with: event)
    }
    
    public override func keyUp(with event: NSEvent) {
        (window?.contentViewController as? MainViewController)?.gameViewController.keyUp(with: event)
    }
    
}
