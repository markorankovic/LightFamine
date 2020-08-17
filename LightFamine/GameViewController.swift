//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController, SCNSceneRendererDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            ((self.view as? SCNView)?.scene as? GameScene)?.update(time)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        let scene = GameScene(named: "art.scnassets/scene7.scn")!
        
        // set the scene to the view
        scnView.scene = scene
                
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //scnView.showsStatistics = true
        
        //scnView.debugOptions = SCNDebugOptions.showPhysicsShapes
        
        scnView.delegate = self
    }
        
    override func keyDown(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.keyUp(with: event)
    }
    
}
