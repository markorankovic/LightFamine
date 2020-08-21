import AppKit
import SceneKit

public class GameView: SCNView {
        
    public override func viewDidMoveToWindow() {
        window?.acceptsMouseMovedEvents = true
    }
    
    public override func mouseMoved(with event: NSEvent) {
        (window?.contentViewController as? MainViewController)?.gameViewController.mouseMoved(with: event)
        (window?.contentViewController as? MainViewController)?.mainMenuViewController.mouseMoved(with: event)
    }
    
    public override func mouseExited(with event: NSEvent) {
        (window?.contentViewController as? MainViewController)?.gameViewController.mouseExited(with: event)
    }
    
    public override func keyDown(with event: NSEvent) {
        (window?.contentViewController as? MainViewController)?.gameViewController.keyDown(with: event)
    }
    
    public override func keyUp(with event: NSEvent) {
        (window?.contentViewController as? MainViewController)?.gameViewController.keyUp(with: event)
    }
    
}
