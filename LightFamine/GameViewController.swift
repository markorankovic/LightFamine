//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = GameScene(named: "art.scnassets/scene4.scn")!
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        //scnView.debugOptions = SCNDebugOptions.showPhysicsShapes
    }
        
    override func keyDown(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.keyDown(with: event)
    }
            
}
